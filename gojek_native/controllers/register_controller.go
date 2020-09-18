package controllers

//import (
//	"fmt"
//	"net/http"
//)

//func Index1(w http.ResponseWriter, r *http.Request) {
//	fmt.Fprintf(w, "hello\n")
//}

import (
	"database/sql"
	"encoding/json"
	"errors"
	"io/ioutil"
	"math/rand"
	"net/http"
	"strconv"

	"github.com/zulkiflisaid/coba/configs"
	"github.com/zulkiflisaid/coba/models"
	"github.com/zulkiflisaid/coba/responses"
	"github.com/zulkiflisaid/coba/structs"
	"github.com/zulkiflisaid/coba/utils"
	"gopkg.in/go-playground/validator.v9"
)

// Register is ...
func Register(w http.ResponseWriter, r *http.Request) {

	body, err := ioutil.ReadAll(r.Body)
	if err != nil {
		responses.ERROR(w, http.StatusBadRequest, err)
		return
	}
	m := structs.UserRegister{}
	err = json.Unmarshal(body, &m)
	if err != nil {
		responses.ERROR(w, http.StatusBadRequest, err)
		return
	}
	//pinregister := rand.Intn(999999-100000) + 100000
	db := configs.Conn()

	//filter register by
	var tblRegister string
	if m.Usertype == "customer" {
		tblRegister = "customers"
	} else if m.Usertype == "motor" || m.Usertype == "car4" || m.Usertype == "car6" {
		tblRegister = "drivers"
	} else if m.Usertype == "resto" {
		tblRegister = "restaurants"
	} else if m.Usertype == "cook" {
		tblRegister = "cooks"
	} else if m.Usertype == "shop" {
		tblRegister = "shops"
	} else {
		responses.ERROR(w, http.StatusBadRequest, errors.New("Akses pengguna tidak dikenali sistem"))
		return
	}

	m.PrepareUserRegister()
	validate = validator.New()
	err = validate.Struct(m)
	if err != nil {
		responses.ERROR_validation(w, http.StatusUnprocessableEntity, err)
		return
	}
	password, err := utils.Hash(m.Password)
	if err != nil {
		responses.ERROR(w, http.StatusUnprocessableEntity, err)
		return
	}
	var insForm sql.Result
	if tblRegister == "drivers" {
		insForm, err = db.Exec("INSERT INTO "+tblRegister+"(name,email,phone_number,phone_id,password,pin_register,gcm,category_driver) VALUES (?,?,?,?,?,?,?,?)",
			m.Name,
			m.Email,
			m.PhoneNumber,
			m.PhoneID,
			password,
			m.PinRegister,
			m.Gcm,
			m.Usertype,
		)
	} else {
		insForm, err = db.Exec("INSERT INTO "+tblRegister+"(name,email,phone_number,phone_id,password,pin_register,gcm) VALUES (?,?,?,?,?,?,?)",
			m.Name,
			m.Email,
			m.PhoneNumber,
			m.PhoneID,
			password,
			m.PinRegister,
			m.Gcm,
		)
	}

	defer db.Close()
	if err != nil {
		responses.ERROR_mysql(w, http.StatusUnprocessableEntity, err)
		return
	}
	//id, err := insForm.LastInsertId()
	RowsAff, err := insForm.RowsAffected()
	if err != nil {
		responses.ERROR_mysql(w, http.StatusUnprocessableEntity, err)
		return
	}
	//fmt.Println(int(id))
	//fmt.Println(int(RowsAff))
	if RowsAff == 1 {
		//err := SendGcmRegister(db, pin_register, m.PhoneID, m.PhoneNumber, m.Name)
		//if err != nil {
		//	responses.JSON(w, http.StatusOK, json.RawMessage(`{"status": true}`))
		//	return
		//}

		responses.JSON(w, http.StatusOK, json.RawMessage(`{"status": true}`))
		return
	}

	responses.ERROR(w, http.StatusBadRequest, errors.New("Terjadi kesalahaan"))
	return
}

// SendGcmRegister is ...
func SendGcmRegister(Pin, PhoneID, PhoneNumber string) error {
	//kirim gcm new register

	gcmServer, err := models.ModelGcmServer()
	if err != nil {
		return err
	}

	gcmData := structs.GcmData{
		ID:                Pin,
		Body:              "Ada Pelanggan baru",
		Title:             "Ada Pelanggan baru",
		Message:           "Ada Pelanggan baru",
		NewRegister:       "baru",
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

// ValidasiRegister is ...
func ValidasiRegister(w http.ResponseWriter, r *http.Request) {
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
	defer db.Close()
	if err != nil {
		responses.ERROR(w, http.StatusUnprocessableEntity, err)
		return
	}

	for selDB.Next() {
		var status uint64
		err = selDB.Scan(&status)
		if err != nil {
			responses.ERROR(w, http.StatusUnprocessableEntity, err)
			return
		}
		responses.ERROR(w, http.StatusBadRequest, errors.New("Nomor HP telah digunakan"))
		return

	}
	pinregister := rand.Intn(999999-100000) + 100000
	var Pin = strconv.Itoa(pinregister)
	if status == 4 {

		var PhoneNumber = strconv.FormatUint(validasiPinRegister.PhoneNumber, 10)
		err = SendGcmRegister(Pin, validasiPinRegister.PhoneID, PhoneNumber)
		if err != nil {
			responses.ERROR(w, http.StatusBadRequest, errors.New("Gagal validasi silahkan ulangi"))
			return
		}
	}

	responses.JSON(w, http.StatusOK, json.RawMessage(`{"status": true,"pin": "`+Pin+`"}`))
	return
}
