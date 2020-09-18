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
	"io/ioutil"
	"net/http"
	"strconv"
	"time"

	_ "github.com/go-sql-driver/mysql"
	"github.com/zulkiflisaid/coba/configs"
	"github.com/zulkiflisaid/coba/responses"
	"github.com/zulkiflisaid/coba/structs"
	"gopkg.in/go-playground/validator.v9"
)

func AddGcm(w http.ResponseWriter, r *http.Request) {

	body, err := ioutil.ReadAll(r.Body)
	if err != nil {
		responses.ERROR(w, http.StatusBadRequest, err)
		return
	}

	m := structs.Gcms{}
	err = json.Unmarshal(body, &m)
	if err != nil {
		responses.ERROR(w, http.StatusBadRequest, err)
		return
	}
	m.PrepareGcm()
	m.ID = 1
	//log.Println(m.ID)
	validate = validator.New()
	err = validate.Struct(m)
	if err != nil {
		responses.ERROR(w, http.StatusUnprocessableEntity, err)
		return
	}
	db := configs.Conn()
	insForm, err := db.Exec("INSERT INTO gcms(gcm,key_server) VALUES (?,?)", m.Gcm, m.KeyServer)
	defer db.Close()
	if err != nil {
		responses.ERROR(w, http.StatusUnprocessableEntity, err)
		return
	}

	RowsAff, err := insForm.RowsAffected()
	if err != nil {
		responses.ERROR(w, http.StatusBadRequest, err)
		return
	}
	if RowsAff == 1 {
		responses.JSON(w, http.StatusOK, json.RawMessage(`{"status": true}`))
		return
	}

	responses.ERROR(w, http.StatusBadRequest, errors.New("Bad Request"))
	return

}

func UpdateGcm(w http.ResponseWriter, r *http.Request) {

	body, err := ioutil.ReadAll(r.Body)
	if err != nil {
		responses.ERROR(w, http.StatusBadRequest, err)
		return
	}

	m := structs.Gcms{}
	err = json.Unmarshal(body, &m)
	if err != nil {
		responses.ERROR(w, http.StatusBadRequest, err)
		return
	}

	m.PrepareGcm()
	//log.Println(m.ID)
	validate = validator.New()
	err = validate.Struct(m)
	if err != nil {
		responses.ERROR(w, http.StatusUnprocessableEntity, err)
		return
	}
	currentTime := time.Now()
	db := configs.Conn()
	updateForm, err := db.Exec("UPDATE gcms SET  gcm=?, key_serve=?, updated_at=? WHERE id=?",
		m.Gcm,
		m.KeyServer,
		currentTime.Format("2006.01.02 15:04:05"),
		m.ID)
	defer db.Close()
	if err != nil {
		responses.ERROR(w, http.StatusUnprocessableEntity, err)
		return
	}

	RowsAff, err := updateForm.RowsAffected()
	if err != nil {
		responses.ERROR(w, http.StatusBadRequest, err)
		return
	}
	//log.Println(RowsAff)
	if RowsAff == 1 {
		responses.JSON(w, http.StatusOK, json.RawMessage(`{"status": true}`))
		return
	} else {
		selDB, err := db.Query("SELECT id FROM gcms WHERE id=?", m.ID)
		if err != nil {
			responses.ERROR(w, http.StatusBadRequest, err)
			return
		}
		emp := structs.CategoryFoods{}
		emp.ID = 0
		for selDB.Next() {
			var id uint64
			err = selDB.Scan(&id)
			if err != nil {
				responses.ERROR(w, http.StatusBadRequest, err)
				return
			} else {
				emp.ID = id
			}
		}
		if emp.ID == 0 {
			responses.ERROR(w, http.StatusBadRequest, errors.New("Bad Request"))
			return
		}
		responses.JSON(w, http.StatusOK, json.RawMessage(`{"status": true}`))
		return
	}

	responses.ERROR(w, http.StatusBadRequest, errors.New("Bad Request"))
	return

}

func DeleteGcm(w http.ResponseWriter, r *http.Request) {
	id, err := strconv.Atoi(r.URL.Query().Get("id"))
	if err != nil || id < 1 {
		responses.ERROR(w, http.StatusBadRequest, err)
		return
	}
	validate = validator.New()
	errs := validate.Var(id, "required,numeric")
	if errs != nil {
		responses.ERROR(w, http.StatusUnprocessableEntity, err)
		return
	}
	db := configs.Conn()
	delForm, err := db.Exec("DELETE FROM gcms WHERE id=?", id)
	defer db.Close()
	if err != nil {
		responses.ERROR(w, http.StatusUnprocessableEntity, err)
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

func GetGcmById(w http.ResponseWriter, r *http.Request) {

	/*www, err := auth.ExtractTokenKat(r)
	if err != nil {
		responses.ERROR(w, http.StatusUnauthorized, errors.New("Unauthorized"))
		return
	}*/

	id, err := strconv.Atoi(r.URL.Query().Get("id"))
	if err != nil || id < 1 {
		responses.ERROR(w, http.StatusBadRequest, err)
		return
	}
	validate = validator.New()
	errs := validate.Var(id, "required,numeric")
	if errs != nil {
		responses.ERROR(w, http.StatusUnprocessableEntity, err)
		return
	}
	db := configs.Conn()
	selDB, err := db.Query("SELECT  *  FROM gcms WHERE id=? limit 1", id)
	defer db.Close()
	if err != nil {
		responses.ERROR(w, http.StatusUnprocessableEntity, err)
		return
	}

	m := structs.Gcms{}
	for selDB.Next() {

		var id uint64
		var gcm, key_server string
		var created_at, updated_at string
		err = selDB.Scan(&id, &gcm, &key_server, &created_at, &updated_at)
		if err != nil {
			responses.ERROR(w, http.StatusUnprocessableEntity, err)
			return
		} else {
			m.ID = id
			m.Gcm = gcm
			m.KeyServer = key_server
			m.CreatedAt = created_at
			m.UpdatedAt = updated_at

		}
		if gcm != "" {
			responses.JSON(w, http.StatusOK, gcm)
			return
		}

	}
	responses.ERROR(w, http.StatusBadRequest, errors.New("Bad Request"))
	return

}

func GetAllGcm(w http.ResponseWriter, r *http.Request) {
	var offset, count uint64
	offset = 0
	count = 0
	gcms := []structs.Gcms{}

	page, err := strconv.ParseUint(r.URL.Query().Get("page"), 10, 64)
	if err != nil || page < 1 {
		responses.ERROR(w, http.StatusBadRequest, err)
		return
	}
	limit, err := strconv.ParseUint(r.URL.Query().Get("limit"), 10, 64)
	if err != nil || limit < 1 {
		responses.ERROR(w, http.StatusBadRequest, err)
		return
	}

	p := structs.Paging{
		Page:  page,
		Limit: limit,
	}
	validate = validator.New()
	err = validate.Struct(p)
	if err != nil {
		responses.ERROR(w, http.StatusUnprocessableEntity, err)
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
	selDB, err := db.Query("SELECT  *  FROM gcms LIMIT  ?, ?", offset, p.Limit)
	if err != nil {
		responses.ERROR(w, http.StatusUnprocessableEntity, err)
		return
	}

	for selDB.Next() {
		var id uint64
		var gcm, key_server string
		var created_at, updated_at string
		err = selDB.Scan(&id, &gcm, &key_server, &created_at, &updated_at)
		if err != nil {
			responses.ERROR(w, http.StatusUnprocessableEntity, err)
			return
		} else {
			m := structs.Gcms{id, gcm, key_server, created_at, updated_at}
			gcms = append(gcms, m)
		}
	}

	//defer selDB.Close()
	selCountDB, err := db.Query("SELECT count(*) as count_data FROM gcms")
	if err != nil {
		responses.ERROR(w, http.StatusUnprocessableEntity, err)
		return
	}

	var count_data uint64
	for selCountDB.Next() {
		err = selCountDB.Scan(&count_data)
		if err != nil {
			responses.ERROR(w, http.StatusUnprocessableEntity, err)
			return
		} else {
			count = count_data
		}
	}
	defer db.Close()
	responPaging := structs.DataPaging{
		Data:   gcms,
		Count:  count,
		Paging: p,
	}
	responses.JSON(w, http.StatusOK, responPaging)
	return
}
