package tran

//import (
//	"fmt"
//	"net/http"
//)

//func Index1(w http.ResponseWriter, r *http.Request) {
//	fmt.Fprintf(w, "hello\n")
//}

import (
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"strconv"
	"time"

	//_ "github.com/go-sql-driver/mysql"
	"github.com/zulkiflisaid/coba/auth"
	"github.com/zulkiflisaid/coba/configs"
	"github.com/zulkiflisaid/coba/responses"
	"github.com/zulkiflisaid/coba/structs"
	"github.com/zulkiflisaid/coba/utils"
	"gopkg.in/go-playground/validator.v9"
)

//AddTopup is
func AddTopup(w http.ResponseWriter, r *http.Request) {

	akses, err := auth.ExtractTokenKat(r)
	if err != nil {

		responses.ERROR(w, http.StatusUnauthorized, errors.New("Unauthorized"))
		return
	}
	tokenID, err := auth.ExtractTokenID(r)
	if err != nil {

		responses.ERROR(w, http.StatusUnauthorized, errors.New("Unauthorized"))
		return
	}

	//r.Body = http.MaxBytesReader(w, r.Body, 500*1024) // 500*1024=500kb     2*10241024=2Mb
	body, err := ioutil.ReadAll(r.Body)
	if err != nil {
		responses.ERROR(w, http.StatusBadRequest, err)
		return
	}

	m := structs.TopUps{}
	err = json.Unmarshal(body, &m)
	if err != nil {
		responses.ERROR_unmarshal(w, http.StatusBadRequest, err)
		return
	}

	if m.UserKat != akses {

		responses.ERROR(w, http.StatusUnauthorized, errors.New("Unauthorized"))
		return
	}
	if m.UserID != tokenID {
		responses.ERROR(w, http.StatusUnauthorized, errors.New("Unauthorizedq"))
		return
	}

	//random uiid
	uuid4Angka, err := utils.RandomUIID(8, 2)
	if err != nil {
		responses.ERROR(w, http.StatusBadRequest, err)
		return
	}
	NextRandom := utils.NextRandom()

	m.ID = 1
	m.KdTransfer = uuid4Angka + NextRandom
	m.Verifikasi = 1
	m.Banks.ID = 1
	m.Banks.NoRek = "no_rek"
	m.Banks.NmPendek = "nm_pendek"
	m.Banks.NmPanjang = "nm_panjang"
	m.Banks.Pemilik = "pemilik"
	m.Banks.Base46Img = "YQ=="
	validate := validator.New()
	err = validate.Struct(m)
	if err != nil {
		responses.ERROR_validation(w, http.StatusUnprocessableEntity, err)
		return
	}

	//pathImage := "upload/topup/"
	//ImgBukti, err := utils.UploadImageBase64ByFormat(pathImage, uuid+"-"+NextRandom, "data:image/png;base64,"+m.Base46Img)
	//if err != nil {
	//	responses.ERROR(w, http.StatusUnprocessableEntity, err)
	//	return
	//}
	log.Println(m.KdTransfer)
	db := configs.Conn()
	insForm, err := db.Exec("INSERT INTO topups(user_category,code_transfer,user_id,bank_id,amount, is_verification) VALUES (?,?,?,?,?,?)",
		m.UserKat,
		m.KdTransfer,
		m.UserID,
		m.BankID,
		m.Jumlah,
		0)
	defer db.Close()
	if err != nil {
		//if _, ok := err.(*validator.InvalidValidationError); ok {
		//	fmt.Println(err)
		//	return
		//}
		responses.ERROR_mysql(w, http.StatusUnprocessableEntity, err)
		return
	}

	RowsAff, err := insForm.RowsAffected()
	if err != nil {
		responses.ERROR_mysql(w, http.StatusBadRequest, err)
		return
	}
	if RowsAff == 1 {
		responses.JSON(w, http.StatusOK, json.RawMessage(`{"status": true}`))
		return
	}

	responses.ERROR(w, http.StatusBadRequest, errors.New("Bad Request"))
	return

}

//AddBuktiTopup is
func AddBuktiTopup(w http.ResponseWriter, r *http.Request) {
	akses, err := auth.ExtractTokenKat(r)
	if err != nil {
		responses.ERROR(w, http.StatusUnauthorized, errors.New("Unauthorized"))
		return
	}
	tokenID, err := auth.ExtractTokenID(r)
	if err != nil {
		responses.ERROR(w, http.StatusUnauthorized, errors.New("Unauthorized"))
		return
	}

	r.Body = http.MaxBytesReader(w, r.Body, 500*1024) // 500*1024=500kb     2*10241024=2Mb
	body, err := ioutil.ReadAll(r.Body)
	if err != nil {
		responses.ERROR(w, http.StatusBadRequest, err)
		return
	}

	m := structs.TopUps{}
	err = json.Unmarshal(body, &m)
	if err != nil {
		responses.ERROR_unmarshal(w, http.StatusBadRequest, err)
		return
	}

	if m.UserKat != akses {
		responses.ERROR(w, http.StatusUnauthorized, errors.New("Unauthorized"))
		return
	}
	if m.UserID != tokenID {
		responses.ERROR(w, http.StatusUnauthorized, errors.New("Unauthorized"))
		return
	}

	//random uiid
	uuid16Angka, err := utils.RandomUIID(8, 2)
	if err != nil {
		responses.ERROR(w, http.StatusBadRequest, err)
		return
	}

	NextRandom := utils.NextRandom()
	//m.PrepareTopUp()

	m.Verifikasi = 1
	m.Banks.ID = 1
	m.Banks.NoRek = "no_rek"
	m.Banks.NmPendek = "nm_pendek"
	m.Banks.NmPanjang = "nm_panjang"
	m.Banks.Pemilik = "pemilik"
	m.Banks.Base46Img = "YQ=="
	validate := validator.New()
	err = validate.Struct(m)
	if err != nil {
		responses.ERROR_validation(w, http.StatusUnprocessableEntity, err)
		return
	}

	errs := validate.Var(m.Base46Img, "required,base64")
	if errs != nil {
		responses.ERROR_validation(w, http.StatusUnprocessableEntity, err)
		return
	}

	pathImage := "upload/topup/"
	ImgBukti, err := utils.UploadImageBase64ByFormat(pathImage, uuid16Angka+"-"+NextRandom, "data:image/png;base64,"+m.Base46Img)
	if err != nil {
		responses.ERROR(w, http.StatusUnprocessableEntity, err)
		return
	}
	log.Println(m.KdTransfer)
	db := configs.Conn()
	currentTime := time.Now()
	updateForm, err := db.Exec("UPDATE topups SET   img_struck=?, updated_at=? WHERE user_category=? AND code_transfer=? AND user_id=? AND bank_id=? AND amount=?  AND  is_verification=? AND id=?",

		pathImage+ImgBukti,
		currentTime.Format("2006.01.02 15:04:05"),
		m.UserKat,
		m.KdTransfer,
		m.UserID,
		m.BankID,
		m.Jumlah,
		0,
		m.ID)
	defer db.Close()
	if err != nil {
		if _, ok := err.(*validator.InvalidValidationError); ok {
			fmt.Println(err)
			return
		}
		responses.ERROR_mysql(w, http.StatusUnprocessableEntity, err)
		return
	}

	RowsAff, err := updateForm.RowsAffected()
	if err != nil {
		responses.ERROR_mysql(w, http.StatusBadRequest, err)
		return
	}
	if RowsAff == 1 {
		//buat notifikasi gcm ke admin
		//agar segera di cek jumlah topup
		responses.JSON(w, http.StatusOK, json.RawMessage(`{"status": true}`))
		return
	}
	responses.ERROR(w, http.StatusBadRequest, errors.New("Bad Request"))
	return
}

//ImgTopUp is
func ImgTopUp(w http.ResponseWriter, r *http.Request) {

	kdtransfer := r.URL.Query().Get("kd")
	id, err := strconv.Atoi(r.URL.Query().Get("id"))
	if err != nil || id < 1 {
		fmt.Println("1")
		ErrorImage(w, r)
		//fmt.Fprintf(w, "%s", "Not Found")
		return
	}
	validate := validator.New()
	err = validate.Var(kdtransfer, "required,len=13")
	if err != nil {
		fmt.Println("2")
		ErrorImage(w, r)
		return
	}
	err = validate.Var(id, "required,numeric")
	if err != nil {
		fmt.Println("3")
		ErrorImage(w, r)
		return
	}

	tokenID, err := auth.ExtractTokenID(r)
	if err != nil {
		fmt.Println("5")
		ErrorImage(w, r)
		return
	}
	akses, err := auth.ExtractTokenKat(r)
	if err != nil {
		fmt.Println("6")
		ErrorImage(w, r)
		return
	}

	db := configs.Conn()
	selDB, err := db.Query("SELECT user_category, user_id, img_struck FROM topups WHERE id=?  AND code_transfer=? limit 1", id, kdtransfer)
	defer db.Close()
	if err != nil {
		fmt.Println("7")
		ErrorImage(w, r)
		return
	}
	var userID uint64
	var userKat, imgBukti string
	for selDB.Next() {

		err = selDB.Scan(&userKat, &userID, &imgBukti)
		if err != nil {
			fmt.Println("8")
			ErrorImage(w, r)
			return
		}
	}

	if userKat != akses {
		fmt.Println("09")
		ErrorImage(w, r)
		return
	}

	if userID != tokenID {
		fmt.Println("11")
		ErrorImage(w, r)
		return
	}

	if imgBukti == "" {
		fmt.Println("33")
		ErrorImage(w, r)
		return
	}

	existingImageFile, err := os.Open(imgBukti)
	if err != nil {
		fmt.Println("33")
		ErrorImage(w, r)
		return
	}
	defer existingImageFile.Close()
	//w.Header().Set("Content-Type", "image/png")
	w.Header().Set("Content-Type", "image/jpeg")
	io.Copy(w, existingImageFile)
	// _, err = io.Copy(w, existingImageFile)
	// if err != nil {
	//   fmt.Println("33")
	//ErrorImage(w, r)
	//	return
	//}

	return
	/*b := make([]byte, 8)
	_, err := rand.Read(b)
	if err != nil {
		fmt.Println("Error: ", err)
		return
	}

	uuid := fmt.Sprintf("%X-%X-%X", b[0:4], b[4:6], b[6:])
	fmt.Println(uuid)


		//////////////////////////////////////
		aaaaaa, err := os.Open("img/shop/195316711.jpeg")

		if err != nil {
			// Handle error
		}

		defer aaaaaa.Close()
		imageData1, imageType1, err := image.Decode(aaaaaa)
		if err != nil {
			// Handle error
		}
		fmt.Println(imageData1)
		fmt.Println(imageType1)

		buffer1 := new(bytes.Buffer)
		if err := jpeg.Encode(buffer1, imageData1, nil); err != nil {
			log.Println("unable to encode image.")
		}

		w.Header().Set("Content-Type", "image/jpeg")
		w.Header().Set("Content-Length", strconv.Itoa(len(buffer1.Bytes())))
		if _, err := w.Write(buffer1.Bytes()); err != nil {
			log.Println("unable to write image.")
		}
		return


			///////////////////////////////

				reqImg, err := client.Get("https://i.stack.imgur.com/wQ0qQ.png?s=32")
				if err != nil {
					//fmt.Fprintf(reqImg, "Error %d", err)
					return
				}
				buffer := make([]byte, reqImg.ContentLength)
				io.ReadFull(reqImg.Body, buffer)
				w.Header().Set("Content-Length", fmt.Sprint(reqImg.ContentLength))
				w.Header().Set("Content-Type", reqImg.Header.Get("Content-Type"))
				w.Write(buffer)
				r.Body.Close()
				return*/

	/////////////////////////////

}

//ErrorImage is
func ErrorImage(w http.ResponseWriter, r *http.Request) {
	aaaa, err := os.Open("upload/topup/no.png")
	if err != nil {
		w.Header().Set("Content-Type", "image/png")
		return
	}

	defer aaaa.Close()
	w.Header().Set("Content-Type", "image/png") // <-- set the content-type header
	io.Copy(w, aaaa)

	return
}

//DeleteTopUp is
func DeleteTopUp(w http.ResponseWriter, r *http.Request) {
	akses, err := auth.ExtractTokenKat(r)
	if err != nil {
		responses.ERROR(w, http.StatusUnauthorized, errors.New("Unauthorized"))
		return
	}
	if akses != "admins" {
		responses.ERROR(w, http.StatusUnauthorized, errors.New("Unauthorized"))
		return
	}
	id, err := strconv.Atoi(r.URL.Query().Get("id"))
	if err != nil || id < 1 {
		responses.ERROR(w, http.StatusBadRequest, err)
		return
	}
	validate := validator.New()
	errs := validate.Var(id, "required,numeric")
	if errs != nil {
		responses.ERROR_validation(w, http.StatusUnprocessableEntity, err)
		return
	}
	db := configs.Conn()
	delForm, err := db.Exec("DELETE FROM topups WHERE id=?", id)
	defer db.Close()
	if err != nil {
		responses.ERROR_mysql(w, http.StatusUnprocessableEntity, err)
		return
	}

	RowsAff, err := delForm.RowsAffected()
	if RowsAff == 1 {
		responses.JSON(w, http.StatusOK, json.RawMessage(`{"status": true}`))
		return
	}
	responses.ERROR(w, http.StatusBadRequest, errors.New("Bad Request"))
	return

}

//GetTopUpByID is
func GetTopUpByID(w http.ResponseWriter, r *http.Request) {
	tokenID, err := auth.ExtractTokenID(r)
	if err != nil {
		responses.ERROR(w, http.StatusUnauthorized, errors.New("Unauthorized"))
		return
	}
	akses, err := auth.ExtractTokenKat(r)
	if err != nil {
		responses.ERROR(w, http.StatusUnauthorized, errors.New("Unauthorized"))
		return
	}
	id, err := strconv.Atoi(r.URL.Query().Get("id"))
	if err != nil || id < 1 {
		responses.ERROR(w, http.StatusBadRequest, errors.New("Parameter id not found"))
		return
	}

	validate := validator.New()
	err = validate.Var(id, "required,numeric")
	if err != nil {
		responses.ERROR_validation(w, http.StatusUnprocessableEntity, err)
		return
	}

	db := configs.Conn()
	selDB, err := db.Query("SELECT "+
		"a.id, 	a.kd_transfer, 	a.user_kat, a.user_id, a.bank_id, a.jumlah,  "+
		"a.is_bukti, a.is_verification, a.img_bukti, a.created_at, a.updated_at,  "+
		"b.no_rek, b.nm_pendek, b.nm_panjang, b.pemilik, b.url_logo,  "+
		"b.created_at, b.updated_at   "+
		"FROM topups a JOIN banks b ON  a.bank_id=b.id WHERE a.id=? limit 1", id)
	//selDB, err := db.Query("SELECT  *  FROM topups WHERE id=? limit 1", id)
	defer db.Close()
	if err != nil {
		responses.ERROR_mysql(w, http.StatusUnprocessableEntity, err)
		return
	}

	m := structs.TopUps{}
	for selDB.Next() {
		var verifikasi uint8
		var id, userID uint64
		var bankID, jumlah uint32

		var kdTransfer, userKat, imgBukti string
		var createdAt, updatedAt string

		var noRek, nmPendek, nmPanjang, pemilik, urlLogo string
		var bCreatedAt, bUpdatedAt string

		err = selDB.Scan(
			&id, &kdTransfer, &userKat, &userID, &bankID, &jumlah, &verifikasi, &imgBukti, &createdAt, &updatedAt,
			&noRek, &nmPendek, &nmPanjang, &pemilik, &urlLogo, &bCreatedAt, &bUpdatedAt)
		if err != nil {
			responses.ERROR_mysql(w, http.StatusUnprocessableEntity, err)
			return
		}

		m.ID = id
		m.KdTransfer = kdTransfer
		m.UserKat = userKat
		m.UserID = userID
		m.BankID = bankID
		m.Jumlah = jumlah

		m.Verifikasi = verifikasi
		m.ImgBukti = configs.ConfigURL() + imgBukti
		m.CreatedAt = createdAt
		m.UpdatedAt = updatedAt
		m.Banks = structs.Banks{
			NoRek:     noRek,
			NmPendek:  nmPendek,
			NmPanjang: nmPanjang,
			Pemilik:   pemilik,
			UrlLogo:   urlLogo,
			CreatedAt: bCreatedAt,
			UpdatedAt: bUpdatedAt,
		}

	}
	if m.KdTransfer != "" {
		if akses == "admins" {
			responses.JSON(w, http.StatusOK, m)
			return
		} else if m.UserID == tokenID && m.UserKat == akses {
			responses.JSON(w, http.StatusOK, m)
			return
		}

	}
	responses.ERROR(w, http.StatusBadRequest, errors.New("Bad Request"))
	return

}

//GetAllTopUp is
func GetAllTopUp(w http.ResponseWriter, r *http.Request) {
	tokenID, err := auth.ExtractTokenID(r)
	if err != nil {
		responses.ERROR(w, http.StatusUnauthorized, errors.New("Unauthorized"))
		return
	}
	//fmt.Println(tokenID)
	akses, err := auth.ExtractTokenKat(r)
	if err != nil {
		responses.ERROR(w, http.StatusUnauthorized, errors.New("Unauthorized"))
		return
	}
	//fmt.Println(akses)
	var offset, count uint64
	offset = 0
	count = 0
	topups := []structs.TopUps{}

	page, err := strconv.ParseUint(r.URL.Query().Get("page"), 10, 64)
	if err != nil || page < 1 {
		responses.ERROR(w, http.StatusBadRequest, errors.New("Parameter page tidak ditemukan"))
		return
	}
	limit, err := strconv.ParseUint(r.URL.Query().Get("limit"), 10, 64)
	if err != nil || limit < 1 {
		responses.ERROR(w, http.StatusBadRequest, errors.New("Parameter limit tidak ditemukan"))
		return
	}

	byverification, err := strconv.ParseInt(r.URL.Query().Get("verification"), 10, 64)
	if err != nil {
		responses.ERROR(w, http.StatusBadRequest, errors.New("Parameter verification tidak ditemukan"))
		return
	}

	strucks, ok := r.URL.Query()["struck"]
	if !ok || len(strucks[0]) < 1 {
		responses.ERROR(w, http.StatusBadRequest, errors.New("Parameter filter gambar tidak ditemukan"))
		return
	}
	sql_struck := ""
	if strucks[0] == "yes" {
		sql_struck = " img_struck<>? AND"
	} else if strucks[0] == "no" {
		sql_struck = " img_struck=? AND"
	} else {
		responses.ERROR(w, http.StatusBadRequest, errors.New("Parameter filter gambar tidak ditemukan"))
		return
	}

	p := structs.Paging{
		Page:  page,
		Limit: limit,
	}
	validate := validator.New()
	err = validate.Struct(p)
	if err != nil {
		responses.ERROR_validation(w, http.StatusUnprocessableEntity, err)
		return
	}

	if p.Limit < 10 {
		p.Limit = 10
	}
	if p.Page < 2 {
		offset = 0
	} else {
		offset = (p.Page - 1) * p.Limit
	}

	query := "SELECT " +
		"a.id, 	a.code_transfer,  a.user_category, a.user_id, a.bank_id, a.amount,  " +
		"a.is_verification, a.img_struck, a.created_at, a.updated_at,  " +
		"b.no_rek, b.nm_short, b.nm_long, b.owner, b.url_logo,  " +
		"b.created_at, b.updated_at   " +
		"FROM topups a JOIN banks b ON  a.bank_id=b.id "
	db := configs.Conn()
	selDB, err := db.Query(query+"WHERE "+sql_struck+" is_verification=?  LIMIT  ?, ?", "", byverification, offset, p.Limit)
	if akses != "admins" {
		selDB, err = db.Query(query+" WHERE "+sql_struck+"  is_verification=? AND user_category=? AND user_id=?  LIMIT  ?, ?", "", byverification, akses, tokenID, offset, p.Limit)
	}
	if err != nil {
		responses.ERROR_mysql(w, http.StatusUnprocessableEntity, err)
		return
	}

	for selDB.Next() {
		var is_verification uint8
		var id, userID uint64
		var bankID, amount uint32
		var kdTransfer, userKat, imgStruck string
		var createdAt, updatedAt string

		var noRek, nmPendek, nmPanjang, pemilik, urlLogo string
		var bCreatedAt, bUpdatedAt string
		err = selDB.Scan(
			&id, &kdTransfer, &userKat, &userID, &bankID, &amount, &is_verification, &imgStruck, &createdAt, &updatedAt,
			&noRek, &nmPendek, &nmPanjang, &pemilik, &urlLogo, &bCreatedAt, &bUpdatedAt)
		if err != nil {
			responses.ERROR_mysql(w, http.StatusUnprocessableEntity, err)
			return
		}

		m := structs.TopUps{
			ID:         id,
			KdTransfer: kdTransfer,
			UserKat:    userKat,
			UserID:     userID,
			BankID:     bankID,
			Jumlah:     amount,

			Verifikasi: is_verification,
			ImgBukti:   configs.ConfigURL() + imgStruck,
			CreatedAt:  createdAt,
			UpdatedAt:  updatedAt,
			Banks: structs.Banks{
				NoRek:     noRek,
				NmPendek:  nmPendek,
				NmPanjang: nmPanjang,
				Pemilik:   pemilik,
				UrlLogo:   urlLogo,
				CreatedAt: bCreatedAt,
				UpdatedAt: bUpdatedAt,
			},
		}
		topups = append(topups, m)

	}

	selCountDB, err := db.Query("SELECT count(*) as count_data FROM topups WHERE  "+sql_struck+"  is_verification=? ", "", byverification)
	if akses != "admins" {
		selCountDB, err = db.Query("SELECT count(*) as count_data FROM topups WHERE  "+sql_struck+"  is_verification=? AND user_category=? AND user_id=?", "", byverification, akses, tokenID)
	}
	if err != nil {
		responses.ERROR_mysql(w, http.StatusUnprocessableEntity, err)
		return
	}

	for selCountDB.Next() {
		err = selCountDB.Scan(&count)
		if err != nil {
			responses.ERROR_mysql(w, http.StatusUnprocessableEntity, err)
			return
		}
	}
	defer db.Close()
	responPaging := structs.DataPaging{
		Data:   topups,
		Count:  count,
		Paging: p,
	}

	responses.JSON(w, http.StatusOK, responPaging)
	return

	//responses.ERROR(w, http.StatusUnauthorized, errors.New("Unauthorized"))
	//return

}
