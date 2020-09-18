package master

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
	"io/ioutil"
	"net/http"
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

// AddBank is ...
func AddBank(w http.ResponseWriter, r *http.Request) {

	akses, err := auth.ExtractTokenKat(r)
	if err != nil {
		responses.ERROR(w, http.StatusUnauthorized, errors.New("Unauthorized"))
		return
	}
	if akses != "admins" {
		responses.ERROR(w, http.StatusUnauthorized, errors.New("Unauthorized"))
		return
	}
	r.Body = http.MaxBytesReader(w, r.Body, 500*1024) // 500*1024=500kb     2*10241024=2Mb
	body, err := ioutil.ReadAll(r.Body)
	if err != nil {
		responses.ERROR(w, http.StatusBadRequest, err)
		return
	}

	m := structs.Banks{}
	err = json.Unmarshal(body, &m)
	if err != nil {
		responses.ERROR_unmarshal(w, http.StatusBadRequest, err)
		return
	}
	m.ID = 1
	m.PrepareBank()
	//log.Println(m)
	validate = validator.New()
	err = validate.Struct(m)
	if err != nil {
		responses.ERROR_validation(w, http.StatusUnprocessableEntity, err)
		return
	}

	/*//deklarasi file
	fmt.Println("File Upload Endpoint Hit")

	// Parse our multipart form, 10 << 20 specifies a maximum
	// upload of 10 MB files.
	//r.ParseMultipartForm(100)
	// FormFile returns the first file for the given key `myFile`
	// it also returns the FileHeader so we can get the Filename,
	// the Header and the size of the file
	//r.Body = http.MaxBytesReader(w, r.Body, 500*1024) // 500*1024=500kb     2*10241024=2Mb
	file, handler, err := r.FormFile("file")
	if err != nil {
		responses.ERROR(w, http.StatusBadRequest, err)
		return
	}
	defer file.Close()

	if handler.Size > 500*1024 {
		responses.ERROR(w, http.StatusUnprocessableEntity, errors.New("File terlalu besar maksimal 500KB"))
		return
	}
	//fmt.Printf("Uploaded File: %+v\n", handler.Filename)
	//fmt.Printf("File Size: %+v\n", handler.Size)
	//fmt.Printf("MIME Header: %+v\n", handler.Header)

	// Create a temporary file within our temp-images directory that follows
	// a particular naming pattern
	tempFile, err := ioutil.TempFile("upload/bank", "bank-*.png")
	if err != nil {
		fmt.Println(err)
	}
	defer tempFile.Close()
	//tempFile.
	//fmt.Println("Temp file name:", tempFile.Name())
	// read all of the contents of our uploaded file into a
	// byte array
	fileBytes, err := ioutil.ReadAll(file)
	if err != nil {
		fmt.Println(err)
	}
	// write this byte array to our temporary file
	//tempFile.Write(fileBytes)
	*/

	NextRandom := utils.NextRandom()
	pathImage := "img/bank/"
	URLLogo, err := utils.UploadImageBase64ByFormat(pathImage, NextRandom, "data:image/png;base64,"+m.Base46Img)
	if err != nil {
		responses.ERROR(w, http.StatusUnprocessableEntity, err)
		return
	}

	//UrlLogo = NextRandom + ".png"
	//err = utils.UploadImageBase64(pathImage+UrlLogo, m.ImgLogo)
	//if err != nil {
	//	responses.ERROR(w, http.StatusUnprocessableEntity, err)
	//	return
	//}

	db := configs.Conn()
	insForm, err := db.Exec("INSERT INTO banks(no_rek,nm_pendek,nm_panjang,pemilik,url_logo) VALUES (?,?,?,?,?)",
		m.NoRek,
		m.NmPendek,
		m.NmPanjang,
		m.Pemilik,
		configs.ConfigURL()+pathImage+URLLogo)
	defer db.Close()
	if err != nil {
		if _, ok := err.(*validator.InvalidValidationError); ok {
			fmt.Println(err)
			return
		}
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

// UpdateBank is ...
func UpdateBank(w http.ResponseWriter, r *http.Request) {
	akses, err := auth.ExtractTokenKat(r)
	if err != nil {
		responses.ERROR(w, http.StatusUnauthorized, errors.New("Unauthorized"))
		return
	}
	if akses != "admins" {
		responses.ERROR(w, http.StatusUnauthorized, errors.New("Unauthorized"))
		return
	}
	body, err := ioutil.ReadAll(r.Body)
	if err != nil {
		responses.ERROR(w, http.StatusBadRequest, err)
		return
	}

	m := structs.Banks{}
	err = json.Unmarshal(body, &m)
	if err != nil {
		responses.ERROR(w, http.StatusBadRequest, err)
		return
	}

	m.PrepareBank()
	//log.Println(m.ID)
	validate = validator.New()
	err = validate.Struct(m)
	if err != nil {
		responses.ERROR_validation(w, http.StatusUnprocessableEntity, err)
		return
	}

	NextRandom := utils.NextRandom()
	pathImage := "img/bank/"
	URLLogo, err := utils.UploadImageBase64ByFormat(pathImage, NextRandom, "data:image/png;base64,"+m.Base46Img)
	if err != nil {
		responses.ERROR(w, http.StatusUnprocessableEntity, err)
		return
	}

	currentTime := time.Now()
	db := configs.Conn()
	updateForm, err := db.Exec("UPDATE banks SET no_rek=?,nm_pendek=?,nm_panjang=?,pemilik=?,url_logo=?, updated_at=? WHERE id=?",
		m.NoRek,
		m.NmPendek,
		m.NmPanjang,
		m.Pemilik,
		configs.ConfigURL()+pathImage+URLLogo,
		currentTime.Format("2006.01.02 15:04:05"),
		m.ID)
	defer db.Close()
	if err != nil {
		responses.ERROR_mysql(w, http.StatusUnprocessableEntity, err)
		return
	}

	RowsAff, err := updateForm.RowsAffected()
	if err != nil {
		responses.ERROR_mysql(w, http.StatusBadRequest, err)
		return
	}
	//log.Println(RowsAff)
	if RowsAff == 1 {
		responses.JSON(w, http.StatusOK, json.RawMessage(`{"status": true}`))
		return
	}
	selDB, err := db.Query("SELECT id FROM banks WHERE id=?", m.ID)
	if err != nil {
		responses.ERROR_mysql(w, http.StatusBadRequest, err)
		return
	}
	emp := structs.Banks{}
	emp.ID = 0
	for selDB.Next() {
		var id uint64
		err = selDB.Scan(&id)
		if err != nil {
			responses.ERROR_mysql(w, http.StatusBadRequest, err)
			return
		}
		emp.ID = id

	}
	if emp.ID == 0 {
		responses.ERROR(w, http.StatusBadRequest, errors.New("Data tidak ditemukan"))
		return
	}
	responses.JSON(w, http.StatusOK, json.RawMessage(`{"status": true}`))
	return

	//responses.ERROR(w, http.StatusBadRequest, errors.New("Bad Request"))
	//return

}

// DeleteBank is ...
func DeleteBank(w http.ResponseWriter, r *http.Request) {
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
	validate = validator.New()
	errs := validate.Var(id, "required,numeric")
	if errs != nil {
		responses.ERROR_validation(w, http.StatusUnprocessableEntity, err)
		return
	}
	db := configs.Conn()
	delForm, err := db.Exec("DELETE FROM banks WHERE id=?", id)
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

// GetBankByID is ...
func GetBankByID(w http.ResponseWriter, r *http.Request) {

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
		responses.ERROR(w, http.StatusBadRequest, errors.New("Parameter id not found"))
		return
	}
	validate = validator.New()
	err = validate.Var(id, "required,numeric")
	if err != nil {
		responses.ERROR_validation(w, http.StatusUnprocessableEntity, err)
		return
	}
	db := configs.Conn()
	selDB, err := db.Query("SELECT  *  FROM banks WHERE id=? limit 1", id)
	defer db.Close()
	if err != nil {
		responses.ERROR_mysql(w, http.StatusUnprocessableEntity, err)
		return
	}

	m := structs.Banks{}
	for selDB.Next() {

		var id uint64
		var noRek, nmPendek, nmPanjang, pemilik, urlLogo string
		var createdAt, updatedAt string

		err = selDB.Scan(&id, &noRek, &nmPendek, &nmPanjang, &pemilik, &urlLogo, &createdAt, &updatedAt)
		if err != nil {
			responses.ERROR_mysql(w, http.StatusUnprocessableEntity, err)
			return
		}
		m.ID = id
		m.NoRek = noRek
		m.NmPendek = nmPendek
		m.NmPanjang = nmPanjang
		m.Pemilik = pemilik
		m.UrlLogo = urlLogo
		m.CreatedAt = createdAt
		m.UpdatedAt = updatedAt

		if noRek != "" {
			responses.JSON(w, http.StatusOK, m)
			return
		}
	}
	responses.ERROR(w, http.StatusBadRequest, errors.New("Bad Request"))
	return

}

// GetAllBank is ...
func GetAllBank(w http.ResponseWriter, r *http.Request) {
	//akses, err := auth.ExtractTokenKat(r)
	//if err != nil || akses != "admins" {
	//	responses.ERROR(w, http.StatusUnauthorized, errors.New("Unauthorized"))
	//	return
	//}
	//if akses != "admins" {
	//	responses.ERROR(w, http.StatusUnauthorized, errors.New("Unauthorized"))
	//	return
	//}
	var offset, count uint64
	offset = 0
	count = 0
	banks := []structs.Banks{}

	page, err := strconv.ParseUint(r.URL.Query().Get("page"), 10, 64)
	if err != nil || page < 1 {
		responses.ERROR(w, http.StatusBadRequest, errors.New("Parameter page not found"))
		return
	}
	limit, err := strconv.ParseUint(r.URL.Query().Get("limit"), 10, 64)
	if err != nil || limit < 1 {
		responses.ERROR(w, http.StatusBadRequest, errors.New("Parameter limit not found"))
		return
	}

	p := structs.Paging{
		Page:  page,
		Limit: limit,
	}
	validate = validator.New()
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

	db := configs.Conn()
	selDB, err := db.Query("SELECT  *  FROM banks LIMIT  ?, ?", offset, p.Limit)
	if err != nil {
		responses.ERROR_mysql(w, http.StatusUnprocessableEntity, err)
		return
	}

	for selDB.Next() {
		var id ,status uint64
		var noRek, nmPendek, nmPanjang, pemilik, urlLogo string
		var createdAt, updatedAt string

		err = selDB.Scan(&id, &noRek, &nmPendek, &nmPanjang, &pemilik, &urlLogo, &status, &createdAt, &updatedAt)
		if err != nil {
			responses.ERROR_mysql(w, http.StatusUnprocessableEntity, err)
			return
		}
		m := structs.Banks{
		     ID:     id,
			NoRek:     noRek,
			NmPendek:  nmPendek,
			NmPanjang: nmPanjang,
			Pemilik:   pemilik,
			UrlLogo:   urlLogo,
			CreatedAt: createdAt,
			UpdatedAt: updatedAt,
		}
		banks = append(banks, m)

	}

	//defer selDB.Close()
	selCountDB, err := db.Query("SELECT count(*) as count_data FROM banks")
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
		Data:   banks,
		Count:  count,
		Paging: p,
	}
	responses.JSON(w, http.StatusOK, responPaging)
	return
}
