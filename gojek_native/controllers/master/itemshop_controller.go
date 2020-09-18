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
	"github.com/zulkiflisaid/coba/auth"
	"github.com/zulkiflisaid/coba/configs"
	"github.com/zulkiflisaid/coba/responses"
	"github.com/zulkiflisaid/coba/structs"
	"github.com/zulkiflisaid/coba/utils"
	"gopkg.in/go-playground/validator.v9"
)

func AddItemShop(w http.ResponseWriter, r *http.Request) {

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

	m := structs.ItemShops{}
	err = json.Unmarshal(body, &m)
	if err != nil {
		responses.ERROR_unmarshal(w, http.StatusBadRequest, err)
		return
	}
	m.ID = 1
	m.PrepareItemShop()
	//log.Println(m)
	validate = validator.New()
	err = validate.Struct(m)
	if err != nil {
		responses.ERROR_validation(w, http.StatusUnprocessableEntity, err)
		return
	}

	NextRandom := utils.NextRandom()
	pathImage := "img/food/"
	UrlImg, err := utils.UploadImageBase64ByFormat(pathImage, NextRandom, "data:image/png;base64,"+m.Base46Img)
	if err != nil {
		responses.ERROR(w, http.StatusUnprocessableEntity, err)
		return
	}

	db := configs.Conn()
	insForm, err := db.Exec("INSERT INTO itemshops(shop_id,kategory_id,nm_shop,ket_shop,hrg,url_img) VALUES (?,?,?,?,?,?)",
		m.ShopId,
		m.KategoriId,
		m.NmShop,
		m.KetShop,
		m.Hrg,
		configs.ConfigURL()+pathImage+UrlImg)
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

func UpdateItemShop(w http.ResponseWriter, r *http.Request) {
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

	m := structs.ItemShops{}
	err = json.Unmarshal(body, &m)
	if err != nil {
		responses.ERROR(w, http.StatusBadRequest, err)
		return
	}

	m.PrepareItemShop()
	//log.Println(m.ID)
	validate = validator.New()
	err = validate.Struct(m)
	if err != nil {
		responses.ERROR_validation(w, http.StatusUnprocessableEntity, err)
		return
	}

	NextRandom := utils.NextRandom()
	pathImage := "img/food/"
	UrlImg, err := utils.UploadImageBase64ByFormat(pathImage, NextRandom, "data:image/png;base64,"+m.Base46Img)
	if err != nil {
		responses.ERROR(w, http.StatusUnprocessableEntity, err)
		return
	}

	currentTime := time.Now()
	db := configs.Conn()
	updateForm, err := db.Exec("UPDATE itemshops SET shop_id=?,kategory_id=?,nm_shop=?,ket_shop=?,url_img=?, hrg=?, updated_at=? WHERE id=?",
		m.ShopId,
		m.KategoriId,
		m.NmShop,
		m.KetShop,
		m.Hrg,
		configs.ConfigURL()+pathImage+UrlImg,
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
		selDB, err := db.Query("SELECT id FROM itemshops WHERE id=?", m.ID)
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

func DeleteItemShop(w http.ResponseWriter, r *http.Request) {
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
	delForm, err := db.Exec("DELETE FROM itemshops WHERE id=?", id)
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

func GetItemShopById(w http.ResponseWriter, r *http.Request) {

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
	errs := validate.Var(id, "required,numeric")
	if errs != nil {
		responses.ERROR_validation(w, http.StatusUnprocessableEntity, err)
		return
	}
	db := configs.Conn()
	selDB, err := db.Query("SELECT  *  FROM itemshops WHERE id=? limit 1", id)
	defer db.Close()
	if err != nil {
		responses.ERROR_mysql(w, http.StatusUnprocessableEntity, err)
		return
	}

	m := structs.ItemShops{}
	for selDB.Next() {

		var id, shop_id, kategory_id, hrg, laku uint64
		var nm_shop, ket_shop, url_img string
		var created_at, updated_at string
		err = selDB.Scan(&id, &shop_id, &kategory_id, &nm_shop, &ket_shop, &url_img, &hrg, &laku, &created_at, &updated_at)
		if err != nil {
			responses.ERROR_mysql(w, http.StatusUnprocessableEntity, err)
			return
		} else {
			m.ID = id
			m.ShopId = shop_id
			m.KategoriId = kategory_id
			m.NmShop = nm_shop
			m.KetShop = ket_shop
			m.UrlImg = url_img
			m.Hrg = hrg
			m.Laku = laku
			m.CreatedAt = created_at
			m.UpdatedAt = updated_at

		}
		if nm_shop != "" {
			responses.JSON(w, http.StatusOK, m)
			return
		}
	}
	responses.ERROR(w, http.StatusBadRequest, errors.New("Bad Request"))
	return

}

func GetAllItemShop(w http.ResponseWriter, r *http.Request) {
	akses, err := auth.ExtractTokenKat(r)
	if err != nil {
		responses.ERROR(w, http.StatusUnauthorized, errors.New("Unauthorized"))
		return
	}
	if akses != "admins" {
		responses.ERROR(w, http.StatusUnauthorized, errors.New("Unauthorized"))
		return
	}
	var offset, count uint64
	offset = 0
	count = 0
	itemshops := []structs.ItemShops{}

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
	selDB, err := db.Query("SELECT  *  FROM itemshops LIMIT  ?, ?", offset, p.Limit)
	if err != nil {
		responses.ERROR_mysql(w, http.StatusUnprocessableEntity, err)
		return
	}

	for selDB.Next() {
		var id, shop_id, kategory_id, hrg, laku uint64
		var nm_shop, ket_shop, url_img string
		var created_at, updated_at string

		err = selDB.Scan(&id, &shop_id, &kategory_id, &nm_shop, &ket_shop, &url_img, &hrg, &laku, &created_at, &updated_at)
		if err != nil {
			responses.ERROR_mysql(w, http.StatusUnprocessableEntity, err)
			return
		} else {
			m := structs.ItemShops{
				ID:         id,
				ShopId:     shop_id,
				KategoriId: kategory_id,
				NmShop:     nm_shop,
				KetShop:    ket_shop,
				UrlImg:     url_img,
				Hrg:        hrg,
				Laku:       laku,
				CreatedAt:  created_at,
				UpdatedAt:  updated_at,
			}
			itemshops = append(itemshops, m)
		}
	}

	//defer selDB.Close()
	selCountDB, err := db.Query("SELECT count(*) as count_data FROM itemshops")
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
		Data:   itemshops,
		Count:  count,
		Paging: p,
	}
	responses.JSON(w, http.StatusOK, responPaging)
	return
}