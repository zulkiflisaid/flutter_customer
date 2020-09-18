package controllers

import (
	"encoding/json"
	"errors"
	"io/ioutil"
	"math/rand"
	"net/http"
	"strconv"
	"time"

	"github.com/zulkiflisaid/coba/auth"
	"github.com/zulkiflisaid/coba/configs"
	"github.com/zulkiflisaid/coba/models"
	"github.com/zulkiflisaid/coba/responses"
	"github.com/zulkiflisaid/coba/structs"
	"github.com/zulkiflisaid/coba/utils"
	"gopkg.in/go-playground/validator.v9"

	//_ "github.com/go-sql-driver/mysql"
	"golang.org/x/crypto/bcrypt"
)

var validate *validator.Validate

// VerifyPassword is ...
func VerifyPassword(hashedPassword, password string) error {
	return bcrypt.CompareHashAndPassword([]byte(hashedPassword), []byte(password))
}

// Login is ...
func Login(w http.ResponseWriter, r *http.Request) {
	
	body, err := ioutil.ReadAll(r.Body)
	if err != nil {
		responses.ERROR(w, http.StatusBadRequest, err)
		return
	}

	userLogin := structs.UserLogin{}
	err = json.Unmarshal(body, &userLogin)
	if err != nil {
		responses.ERROR_unmarshal(w, http.StatusBadRequest, err)
		return
	}

	var tblLogin string
	if userLogin.Usertype == "customer" {
		tblLogin = "customers"
	} else if userLogin.Usertype == "driver" {
		tblLogin = "drivers"
	} else if userLogin.Usertype == "resto" {
		tblLogin = "restaurants"
	} else if userLogin.Usertype == "cook" {
		tblLogin = "cooks"
	} else if userLogin.Usertype == "shop" {
		tblLogin = "shops"
	} else if userLogin.Usertype == "admin" {
		tblLogin = "admins"
	} else {
		responses.ERROR(w, http.StatusBadRequest, errors.New("Bad Request"))
		return
	}

	//log.Println(string(body))
	userLogin.PrepareUserLogin()
	validate = validator.New()
	err = validate.Struct(userLogin)
	if err != nil {
		responses.ERROR_validation(w, http.StatusBadRequest, err)
		return
	}

	tokenRespon, err := SignIn(userLogin.PhoneNumber, userLogin.PhoneID, userLogin.Password, tblLogin, userLogin.Gcm)
	if err != nil {
		responses.ERROR(w, http.StatusBadRequest, err)
		return
	}
	byteArray, err := json.Marshal(tokenRespon)
	if err != nil {
		responses.ERROR(w, http.StatusBadRequest, err)
	}

	responses.JSON(w, http.StatusOK, json.RawMessage(string(byteArray)))
}

// SignIn is ...
func SignIn(phoneNumber uint64, PhoneID, password, tblLogin, userGCM string) (structs.TokenRespon, error) {

	var err error

	userLogin := structs.UserLogin{}
	userLogin.Status = -1
	tokenRespon := structs.TokenRespon{
		Status: false,
		Token:  "",
	}
	db := configs.Conn()
	selDB, err := db.Query("SELECT  id,  email,phone_id,  phone_number, name, balance,counter_reputation,divide_reputation, trip,point, url_avatar,password,  status FROM "+tblLogin+" WHERE phone_number=? AND phone_id=? limit 1", phoneNumber, PhoneID)

	if err != nil {
		defer db.Close()
		return tokenRespon, err
	}
	var email, pass, phone_id, name, lastname, avatar string
	var id, phone_number uint64
	var status, point, divide_reputation, balance, trip int
	var counter_reputation float32
	for selDB.Next() {

		status = 0
		email = ""
		err = selDB.Scan(&id, &email, &phone_id, &phone_number, &name, &balance, &counter_reputation, &divide_reputation, &trip, &point, &avatar, &pass, &status)
		if err != nil {
			return tokenRespon, err
		}

		userLogin.ID = id
		userLogin.Password = pass
		userLogin.Usertype = tblLogin
		userLogin.Status = status
        
		tokenRespon.ID = id
		tokenRespon.PhoneID = phone_id
		tokenRespon.PhoneNumber = phone_number
		tokenRespon.Email = email
		tokenRespon.FirstName = name
		tokenRespon.Lastname = lastname
		tokenRespon.Point = point
		tokenRespon.Balance = balance
		tokenRespon.Avatar = avatar
		tokenRespon.CounterReputation = counter_reputation
		tokenRespon.DivideReputation = divide_reputation

	}

	if email == "" {
		return tokenRespon, errors.New("Usename dan Password tidak ditemukan")
	}
	if userLogin.Status == -1 {
		return tokenRespon, errors.New("Nomor HP belum terdaftar")
	}
	//if userLogin.Status == 0 {
	//	return tokenRespon, errors.New("Nomor HP belum divalidasi")
	//}
	if userLogin.Status == 2 {
		return tokenRespon, errors.New("Akun anda sedang diblok oleh sistem")
	}
	if userLogin.Status == 3 {
		return tokenRespon, errors.New("Akun anda belum dovalidasi oleh sistem")
	}

	err = VerifyPassword(userLogin.Password, password)
	if err != nil && err == bcrypt.ErrMismatchedHashAndPassword {
		return tokenRespon, err
	}

	//update gcm users
	currentTime := time.Now()
	updateForm, err := db.Exec("UPDATE  "+tblLogin+" SET gcm=?,  updated_at=? WHERE id=?",
		userGCM,
		currentTime.Format("2006.01.02 15:04:05"),
		userLogin.ID)
	defer db.Close()
	if err != nil {
		return tokenRespon, err
	}

	RowsAff, err := updateForm.RowsAffected()
	if err != nil {
		return tokenRespon, err
	}
	//log.Println(currentTime.Format("2006.01.02 15:04:05") + "1")
	if (RowsAff == 1) || (RowsAff == 0) {
		var token string
		token, err = auth.CreateToken(userLogin.ID, tblLogin, userGCM)
		if err != nil {
			return tokenRespon, err
		}

		tokenRespon.Status = true
		tokenRespon.Token = token

		return tokenRespon, nil
		//return auth.CreateToken(userLogin.ID)

	}
	//log.Println(currentTime.Format("2006.01.02 15:04:05"))
	//return tokenRespon, nil
	return tokenRespon, errors.New("Usename dan Password tidak ditemukan")

}

// SendGcmReset is ...
func SendGcmReset(Pin string, PhoneID string, PhoneNumber string) error {
	//kirim gcm new register

	gcmServer, err := models.ModelGcmServer()
	if err != nil {
		return err
	}

	gcmData := structs.GcmData{
		ID:                Pin,
		Body:              "Ada Reset",
		Title:             "Ada Reset",
		Message:           "Ada Reset",
		NewRegister:       "reset",
		PhoneNumber:       PhoneID + PhoneNumber,
		Pin:               Pin,
		Name:              "name",
		ClickActionstring: "FLUTTER_NOTIFICATION_CLICK",
	}
	gcmFormat := structs.GcmFormat{
		To:       gcmServer.Gcm,
		Priority: "high",
		Data:     gcmData,
	}

	byteArray, err := json.Marshal(gcmFormat)
	if err != nil {
		return err
	}
	//fmt.Println(string(gcmServer.Gcm))
	//fmt.Println(string(byteArray))

	//url := "https://fcm.googleapis.com/fcm/send"
	//fmt.Println(url)
	//req, err := http.NewRequest("POST", "https://fcm.googleapis.com/fcm/send", bytes.NewBuffer(byteArray))
	req, err := utils.PostURL(configs.URLGcm(), byteArray)
	if err != nil {
		return err
	}
	//fmt.Println(req.StatusCode)
	if req.StatusCode != 200 {
		return errors.New("Gagal validasi silahkan ulangi")
	}
	//req.Close = true
	//fmt.Println(req.Body)
	//	req.Header.Set("Authorization", "key="+configs.KeyGcmServer())
	//req.Header.Set("Content-Type", "application/json")
	//req.Header.Set("Authorization", "key="+gcmServer.Key)
	//req.Header.Set("Content-Type", "application/json")

	//client := &http.Client{}
	//resp, err := client.Do(req.Request)
	//if err != nil {
	//	return err
	//}
	//defer req.Body.Close()

	return err
}

// ValidasiReset is ...
func ValidasiReset(w http.ResponseWriter, r *http.Request) {
	body, err := ioutil.ReadAll(r.Body)
	if err != nil {
		responses.ERROR(w, http.StatusBadRequest, err)
		return
	}

	validasiPinRegister := structs.ValidasiPinRegister{}
	err = json.Unmarshal(body, &validasiPinRegister)
	if err != nil {
		responses.ERROR(w, http.StatusBadRequest, err)
		return
	}

	validate = validator.New()
	err = validate.Struct(validasiPinRegister)
	if err != nil {
		responses.ERROR(w, http.StatusBadRequest, err)
		return
	}

	tblRegister := ""
	status := 4
	if validasiPinRegister.TypeUser == "customer" {
		tblRegister = "customers"

	} else if validasiPinRegister.TypeUser == "driver" {
		tblRegister = "drivers"
	} else if validasiPinRegister.TypeUser == "resto" {
		tblRegister = "restaurants"
	} else if validasiPinRegister.TypeUser == "cook" {
		tblRegister = "cooks"
	} else if validasiPinRegister.TypeUser == "shop" {
		tblRegister = "shops"
	} else {
		responses.ERROR(w, http.StatusBadRequest, errors.New("Sistem tidak menemukan pengguna"))
		return
	}

	db := configs.Conn()
	selDB, err := db.Query("SELECT status  FROM "+tblRegister+" WHERE  phone_id=?  AND phone_number=?    limit 1",
		validasiPinRegister.PhoneID,
		validasiPinRegister.PhoneNumber)

	if err != nil {
		responses.ERROR(w, http.StatusUnprocessableEntity, err)
		return
	}

	for selDB.Next() {

		err = selDB.Scan(&status)
		if err != nil {
			responses.ERROR(w, http.StatusUnprocessableEntity, err)
			return
		}
		if status == 2 {
			responses.ERROR(w, http.StatusBadRequest, errors.New("Akun telah diblok oleh sistem"))
			return
		} else if status == 0 || status == 1 {
			var PhoneNumber = strconv.FormatUint(validasiPinRegister.PhoneNumber, 10)
			pinregister := rand.Intn(999999-100000) + 100000
			var Pin = strconv.Itoa(pinregister)
			currentTime := time.Now()
			updateForm, err := db.Exec("UPDATE "+tblRegister+" SET  pin_reset=?, updated_at=? WHERE   phone_id=?  AND phone_number=?  ",
				pinregister,
				currentTime.Format("2006.01.02 15:04:05"),
				validasiPinRegister.PhoneID,
				validasiPinRegister.PhoneNumber)
			defer db.Close()
			if err != nil {
				responses.ERROR(w, http.StatusBadRequest, err)
				return
			}
			RowsAff, err := updateForm.RowsAffected()
			if err != nil {
				responses.ERROR(w, http.StatusBadRequest, err)
				return
			}
			if RowsAff == 1 {
				err = SendGcmReset(Pin, validasiPinRegister.PhoneID, PhoneNumber)
				if err != nil {
					responses.ERROR(w, http.StatusBadRequest, errors.New("Gagal validasi silahkan ulangi"))
					return
				}
				responses.JSON(w, http.StatusOK, json.RawMessage(`{"status": true}`))
				return
			}
		}
	}
	if status == 4 {
		responses.ERROR(w, http.StatusBadRequest, errors.New("Nomor HP tidak terdaftar"))
		return
	}
	responses.ERROR(w, http.StatusBadRequest, errors.New("Gagal validasi silahkan ulangi"))
	return
}

// ResetPassword is ...
func ResetPassword(w http.ResponseWriter, r *http.Request) {
	body, err := ioutil.ReadAll(r.Body)
	if err != nil {
		responses.ERROR(w, http.StatusBadRequest, err)
		return
	}

	UserReset := structs.UserReset{}
	err = json.Unmarshal(body, &UserReset)
	if err != nil {
		responses.ERROR(w, http.StatusBadRequest, err)
		return
	}

	validate = validator.New()
	err = validate.Struct(UserReset)
	if err != nil {
		responses.ERROR(w, http.StatusBadRequest, err)
		return
	}

	tblRegister := ""
	status := 4
	var pin_reset uint64 
	 pin_reset=1
	if UserReset.TypeUser == "customer" {
		tblRegister = "customers"

	} else if UserReset.TypeUser == "driver" {
		tblRegister = "drivers"
	} else if UserReset.TypeUser == "resto" {
		tblRegister = "restaurants"
	} else if UserReset.TypeUser == "cook" {
		tblRegister = "cooks"
	} else if UserReset.TypeUser == "shop" {
		tblRegister = "shops"
	} else {
		responses.ERROR(w, http.StatusBadRequest, errors.New("Sistem tidak menemukan pengguna"))
		return
	}

	db := configs.Conn()
	selDB, err := db.Query("SELECT status,pin_reset  FROM "+tblRegister+" WHERE  phone_id=?  AND phone_number=?   limit 1",
		UserReset.PhoneID,
		UserReset.PhoneNumber )
	//defer db.Close()
	if err != nil {
		responses.ERROR(w, http.StatusBadRequest, err)
		return
	}

	for selDB.Next() {

		err = selDB.Scan(&status,&pin_reset)
		if err != nil {
			responses.ERROR(w, http.StatusBadRequest, err)
			return
		}
		if status == 2 {
			responses.ERROR(w, http.StatusBadRequest, errors.New("Akun diblok oleh sistem"))
			return
		}else if UserReset.Pin != pin_reset {
			responses.ERROR(w, http.StatusBadRequest, errors.New("Kode Verifikasi tidak valid"))
			return
		} else if status == 0 || status == 1 {
			password, err := utils.Hash(UserReset.Password)
			if err != nil {
				responses.ERROR(w, http.StatusBadRequest, err)
				return
			}
			currentTime := time.Now()
			updateForm, err := db.Exec("UPDATE "+tblRegister+" SET  password=?, updated_at=? WHERE   phone_id=?  AND phone_number=? AND pin_reset=?",
				password,
				currentTime.Format("2006.01.02 15:04:05"),
				UserReset.PhoneID,
				UserReset.PhoneNumber,
				UserReset.Pin)
			defer db.Close()
			if err != nil {
				responses.ERROR(w, http.StatusBadRequest, err)
				return
			}

			RowsAff, err := updateForm.RowsAffected()
			if err != nil {
				responses.ERROR(w, http.StatusBadRequest, err)
				return
			}
			if RowsAff == 1 {
				responses.JSON(w, http.StatusOK, json.RawMessage(`{"status": true}`))
				return
			}

		}
	}
	responses.ERROR(w, http.StatusBadRequest, errors.New("Gagal mengganti Kata sandi"))
	return
}
