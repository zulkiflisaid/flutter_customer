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

	_ "github.com/go-sql-driver/mysql"
	"github.com/zulkiflisaid/coba/configs"
	"github.com/zulkiflisaid/coba/responses"
	"github.com/zulkiflisaid/coba/structs"
	"github.com/zulkiflisaid/coba/utils"
	"gopkg.in/go-playground/validator.v9"
)

func AddCook(w http.ResponseWriter, r *http.Request) {

	body, err := ioutil.ReadAll(r.Body)
	if err != nil {
		responses.ERROR(w, http.StatusBadRequest, err)
		return
	}

	m := structs.Cooks{}
	err = json.Unmarshal(body, &m)
	if err != nil {
		responses.ERROR_unmarshal(w, http.StatusBadRequest, err)
		return
	}
	m.ID = 1
	m.PrepareCook()
	//log.Println(m)
	validate = validator.New()
	err = validate.Struct(m)
	if err != nil {
		responses.ERROR_validation(w, http.StatusUnprocessableEntity, err)
		return
	}

	NextRandom := utils.NextRandom()
	pathImage := "img/cook/"
	UrlLogo, err := utils.UploadImageBase64ByFormat(pathImage, NextRandom, "data:image/png;base64,"+m.Base46Img)
	if err != nil {
		responses.ERROR(w, http.StatusUnprocessableEntity, err)
		return
	}

	db := configs.Conn()
	sql_insert := "INSERT INTO cooks(" +
		"nm_cook ,alamat_cook ,ket_cook ," +
		"min_hrg ,counter_reputation, " +
		"divide_reputation,kat_onkir ,posisi_lat ,posisi_long, " +
		"url_img " +
		")VALUES (?,?,?,?,?,?,?,?,?,?)"
	insForm, err := db.Exec(sql_insert,
		m.NmCook,
		m.AlamatCook,
		m.KetCook,
		m.MinHrg,
		m.CounterReputation,
		m.DivideReputation,
		m.KatOnkir,
		m.PosisLat,
		m.PosisiLong,
		configs.ConfigURL()+pathImage+UrlLogo)
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

func UpdateCook(w http.ResponseWriter, r *http.Request) {

	body, err := ioutil.ReadAll(r.Body)
	if err != nil {
		responses.ERROR(w, http.StatusBadRequest, err)
		return
	}

	m := structs.Cooks{}
	err = json.Unmarshal(body, &m)
	if err != nil {
		responses.ERROR(w, http.StatusBadRequest, err)
		return
	}

	m.PrepareCook()
	//log.Println(m.ID)
	validate = validator.New()
	err = validate.Struct(m)
	if err != nil {
		responses.ERROR_validation(w, http.StatusUnprocessableEntity, err)
		return
	}

	NextRandom := utils.NextRandom()
	pathImage := "img/cook/"
	UrlLogo, err := utils.UploadImageBase64ByFormat(pathImage, NextRandom, "data:image/png;base64,"+m.Base46Img)
	if err != nil {
		responses.ERROR(w, http.StatusUnprocessableEntity, err)
		return
	}

	currentTime := time.Now()
	db := configs.Conn()
	updateForm, err := db.Exec("UPDATE cooks SET "+
		"nm_cook=? ,alamat_cook=? ,ket_cook=? ,"+
		"min_hrg=? ,counter_reputation=?, "+
		"divide_reputation=?,kat_onkir=? ,posisi_lat=? ,posisi_long=?, "+
		"url_img=?,"+
		"updated_at=? WHERE id=?",
		m.NmCook,
		m.AlamatCook,
		m.KetCook,
		m.MinHrg,
		m.CounterReputation,
		m.DivideReputation,
		m.KatOnkir,
		m.PosisLat,
		m.PosisiLong,
		configs.ConfigURL()+pathImage+UrlLogo,
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
	} else {
		selDB, err := db.Query("SELECT id FROM cooks WHERE id=?", m.ID)
		if err != nil {
			responses.ERROR_mysql(w, http.StatusBadRequest, err)
			return
		}
		emp := structs.Cooks{}
		emp.ID = 0
		for selDB.Next() {
			var id uint64
			err = selDB.Scan(&id)
			if err != nil {
				responses.ERROR_mysql(w, http.StatusBadRequest, err)
				return
			} else {
				emp.ID = id
			}
		}
		if emp.ID == 0 {
			responses.ERROR(w, http.StatusBadRequest, errors.New("Data tidak ditemukan"))
			return
		}
		responses.JSON(w, http.StatusOK, json.RawMessage(`{"status": true}`))
		return
	}

	responses.ERROR(w, http.StatusBadRequest, errors.New("Bad Request"))
	return

}

func DeleteCook(w http.ResponseWriter, r *http.Request) {
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
	delForm, err := db.Exec("DELETE FROM cooks WHERE id=?", id)
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

func GetCookById(w http.ResponseWriter, r *http.Request) {

	id, err := strconv.Atoi(r.URL.Query().Get("id"))
	if err != nil || id < 1 {
		responses.ERROR(w, http.StatusBadRequest, errors.New("Parameter id not found"))
		return
	}
	validate = validator.New()
	errs := validate.Var(id, "required,numeric")
	if errs != nil {
		responses.ERROR_validation(w, http.StatusUnprocessableEntity, err)
		return
	}
	db := configs.Conn()
	selDB, err := db.Query("SELECT  id,  nm_cook, status, created_at,  updated_at  FROM cooks WHERE id=? limit 1", id)
	defer db.Close()
	if err != nil {
		responses.ERROR_mysql(w, http.StatusUnprocessableEntity, err)
		return
	}

	m := structs.Cooks{}
	for selDB.Next() {

		var id uint64
		var nm_cook string
		//alamat_cook, ket_cook, min_hrg, counter_reputation, divide_reputation string
		//	var kat_onkir, posisi_lat, posisi_long, buka_senin, tutup_senin, url_img string
		var status int
		var created_at, updated_at string

		err = selDB.Scan(&id, &nm_cook,
			&status,
			&created_at, &updated_at)
		if err != nil {
			responses.ERROR_mysql(w, http.StatusUnprocessableEntity, err)
			return
		} else {
			m.ID = id
			m.NmCook = nm_cook
			m.Status = status
			m.CreatedAt = created_at
			m.UpdatedAt = updated_at

		}
		if nm_cook != "" {
			responses.JSON(w, http.StatusOK, m)
			return
		}

	}
	responses.ERROR(w, http.StatusBadRequest, errors.New("Bad Request"))
	return

}

func GetAllCook(w http.ResponseWriter, r *http.Request) {
	var offset, count uint64
	offset = 0
	count = 0
	cooks := []structs.Cooks{}

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
	selDB, err := db.Query("SELECT  id,  nm_cook, status, created_at,  updated_at  FROM cooks LIMIT  ?, ?", offset, p.Limit)
	if err != nil {
		responses.ERROR_mysql(w, http.StatusUnprocessableEntity, err)
		return
	}

	for selDB.Next() {
		var id uint64
		var nm_cook string
		//, alamat_cook, ket_cook, min_hrg, counter_reputation, divide_reputation string
		//var kat_onkir, posisi_lat, posisi_long, buka_senin, tutup_senin, url_img string
		var status int
		var created_at, updated_at string
		err = selDB.Scan(&id, &nm_cook,
			&status,
			&created_at, &updated_at)
		if err != nil {
			responses.ERROR_mysql(w, http.StatusUnprocessableEntity, err)
			return
		} else {
			m := structs.Cooks{
				ID:        id,
				NmCook:    nm_cook,
				Status:    status,
				CreatedAt: created_at,
				UpdatedAt: updated_at,
			}
			cooks = append(cooks, m)
		}
	}

	//defer selDB.Close()
	selCountDB, err := db.Query("SELECT count(*) as count_data FROM cooks")
	if err != nil {
		responses.ERROR_mysql(w, http.StatusUnprocessableEntity, err)
		return
	}

	var count_data uint64
	for selCountDB.Next() {
		err = selCountDB.Scan(&count_data)
		if err != nil {
			responses.ERROR_mysql(w, http.StatusUnprocessableEntity, err)
			return
		} else {
			count = count_data
		}
	}
	defer db.Close()
	responPaging := structs.DataPaging{
		Data:   cooks,
		Count:  count,
		Paging: p,
	}
	responses.JSON(w, http.StatusOK, responPaging)
	return
}
