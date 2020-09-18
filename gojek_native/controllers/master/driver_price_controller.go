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
	"gopkg.in/go-playground/validator.v9"
)

func AddDriverPrice(w http.ResponseWriter, r *http.Request) {

	body, err := ioutil.ReadAll(r.Body)
	if err != nil {
		responses.ERROR(w, http.StatusBadRequest, err)
		return
	}

	m := structs.DriverPrices{}
	err = json.Unmarshal(body, &m)
	if err != nil {
		responses.ERROR_unmarshal(w, http.StatusBadRequest, err)
		return
	}
	m.ID = 1
	m.PrepareDriverPrice()
	//log.Println(m)
	validate = validator.New()
	err = validate.Struct(m)
	if err != nil {
		responses.ERROR_validation(w, http.StatusUnprocessableEntity, err)
		return
	}

	db := configs.Conn()
	sql_insert := "INSERT INTO driver_prices(category_driver, pos_provinsi," +
		"pos_kab , 	pos_kec, 	pos_lurah_desa , 	radius_zona_special, 	radius_zona_common ," +
		"max_zona_order, 	min_meter, charge, 	price_cash ," +
		"price_deposit, 	price_per_km, 	price_looping_km," +
		"basic_km, 	distance_looping_km , 	point_transaction , status" +
		" ) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
	insForm, err := db.Exec(sql_insert,
		m.CategoryDriver,
		m.PosProvinsi,
		m.PosKab,
		m.PosKec,
		m.PosLurahDesa,
		m.RadiusZonaSpecial,
		m.RradiusZonaCommon,
		m.MaxZonaOrder,
		m.MinMeter,
		m.Charge,
		m.PriceCash,
		m.PriceDeposit,
		m.PpricePeRKm,
		m.PriceLoopingKm,
		m.BasicKm,
		m.DistanceLoopingKm,
		m.PointTransaction,
		m.Status)
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

func UpdateDriverPrice(w http.ResponseWriter, r *http.Request) {

	body, err := ioutil.ReadAll(r.Body)
	if err != nil {
		responses.ERROR(w, http.StatusBadRequest, err)
		return
	}

	m := structs.DriverPrices{}
	err = json.Unmarshal(body, &m)
	if err != nil {
		responses.ERROR(w, http.StatusBadRequest, err)
		return
	}

	m.PrepareDriverPrice()
	//log.Println(m.ID)
	validate = validator.New()
	err = validate.Struct(m)
	if err != nil {
		responses.ERROR_validation(w, http.StatusUnprocessableEntity, err)
		return
	}

	currentTime := time.Now()
	db := configs.Conn()
	updateForm, err := db.Exec("UPDATE driver_prices SET "+
		"category_driver=?, pos_provinsi=?,"+
		"pos_kab=? , 	pos_kec=?, 	pos_lurah_desa=? , 	radius_zona_special=?, 	radius_zona_common=? ,"+
		"max_zona_order=?, 	min_meter=?, charge=?, 	price_cash=? ,"+
		"price_deposit=?, 	price_per_km=?, 	price_looping_km=?,"+
		"basic_km=?, 	distance_looping_km=? , point_transaction=? , status=?,"+
		"updated_at=? WHERE id=?",
		m.CategoryDriver,
		m.PosProvinsi,
		m.PosKab,
		m.PosKec,
		m.PosLurahDesa,
		m.RadiusZonaSpecial,
		m.RradiusZonaCommon,
		m.MaxZonaOrder,
		m.MinMeter,
		m.Charge,
		m.PriceCash,
		m.PriceDeposit,
		m.PpricePeRKm,
		m.PriceLoopingKm,
		m.BasicKm,
		m.DistanceLoopingKm,
		m.PointTransaction,
		m.Status,
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
		selDB, err := db.Query("SELECT id FROM driver_prices WHERE id=?", m.ID)
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
			responses.ERROR(w, http.StatusBadRequest, errors.New("Bad Request"))
			return
		}
		responses.JSON(w, http.StatusOK, json.RawMessage(`{"status": true}`))
		return
	}

	responses.ERROR(w, http.StatusBadRequest, errors.New("Bad Request"))
	return

}

func DeleteDriverPrice(w http.ResponseWriter, r *http.Request) {
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
	delForm, err := db.Exec("DELETE FROM driver_prices WHERE id=?", id)
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

func GetDriverPriceById(w http.ResponseWriter, r *http.Request) {

	/*www, err := auth.ExtractTokenKat(r)
	if err != nil {
		responses.ERROR(w, http.StatusUnauthorized, errors.New("Unauthorized"))
		return
	}*/

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
	selDB, err := db.Query("SELECT  *  FROM driver_prices WHERE id=? limit 1", id)
	defer db.Close()
	if err != nil {
		responses.ERROR_mysql(w, http.StatusUnprocessableEntity, err)
		return
	}

	m := structs.DriverPrices{}
	for selDB.Next() {

		var id uint64
		var category_driver, pos_provinsi, pos_kab, pos_kec, pos_lurah_desa, radius_zona_special, radius_zona_common, max_zona_order string
		var min_meter, charge, price_cash, price_deposit, price_per_km, price_looping_km, basic_km, distance_looping_km, point_transaction *uint64
		var status *uint
		var created_at, updated_at string

		err = selDB.Scan(&id, &category_driver, &pos_provinsi, &pos_kab, &pos_kec, &pos_lurah_desa,
			&radius_zona_special, &radius_zona_common, &max_zona_order,
			&min_meter, &charge, &price_cash, &price_deposit, &price_per_km, &price_looping_km, &basic_km,
			&distance_looping_km, &point_transaction, &status,
			&created_at, &updated_at)
		if err != nil {
			responses.ERROR_mysql(w, http.StatusUnprocessableEntity, err)
			return
		} else {
			m.ID = id
			m.CategoryDriver = category_driver
			m.PosProvinsi = pos_provinsi
			m.PosKab = pos_kab
			m.PosKec = pos_kec
			m.PosLurahDesa = pos_lurah_desa
			m.RadiusZonaSpecial = radius_zona_special
			m.RradiusZonaCommon = radius_zona_common
			m.MaxZonaOrder = max_zona_order
			m.MinMeter = min_meter
			m.Charge = charge
			m.PriceCash = price_cash
			m.PriceDeposit = price_deposit
			m.PpricePeRKm = price_per_km
			m.PriceLoopingKm = price_looping_km
			m.BasicKm = basic_km
			m.DistanceLoopingKm = distance_looping_km
			m.PointTransaction = point_transaction
			m.Status = status
			m.CreatedAt = created_at
			m.UpdatedAt = updated_at

		}
		if category_driver != "" {
			responses.JSON(w, http.StatusOK, m)
			return
		}

	}
	responses.ERROR(w, http.StatusBadRequest, errors.New("Bad Request"))
	return

}

func GetAllDriverPrice(w http.ResponseWriter, r *http.Request) {

	var offset, count uint64
	offset = 0
	count = 0
	driveprices := []structs.DriverPrices{}

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
	SELECT := "id, category_driver, pos_provinsi, pos_kab, pos_kec, pos_lurah_desa," +
		"radius_zona_special, radius_zona_common, max_zona_order," +
		"min_meter, charge, price_cash, price_deposit, price_per_km, price_looping_km, basic_km," +
		"distance_looping_km, point_transaction, status," +
		"created_at, updated_at "
	selDB, err := db.Query("SELECT  "+SELECT+" FROM driver_prices LIMIT  ?, ?", offset, p.Limit)
	if err != nil {
		responses.ERROR_mysql(w, http.StatusUnprocessableEntity, err)
		return
	}

	for selDB.Next() {
		var id uint64
		var category_driver, pos_provinsi, pos_kab, pos_kec, pos_lurah_desa, radius_zona_special, radius_zona_common, max_zona_order string
		var min_meter, charge, price_cash, price_deposit, price_per_km, price_looping_km, basic_km, distance_looping_km, point_transaction *uint64
		var status *uint
		var created_at, updated_at string
		err = selDB.Scan(&id, &category_driver, &pos_provinsi, &pos_kab, &pos_kec, &pos_lurah_desa,
			&radius_zona_special, &radius_zona_common, &max_zona_order,
			&min_meter, &charge, &price_cash, &price_deposit, &price_per_km, &price_looping_km, &basic_km,
			&distance_looping_km, &point_transaction, &status,
			&created_at, &updated_at)
		if err != nil {
			responses.ERROR_mysql(w, http.StatusUnprocessableEntity, err)
			return
		} else {
			m := structs.DriverPrices{
				ID:                id,
				CategoryDriver:    category_driver,
				PosProvinsi:       pos_provinsi,
				PosKab:            pos_kab,
				PosKec:            pos_kec,
				PosLurahDesa:      pos_lurah_desa,
				RadiusZonaSpecial: radius_zona_special,
				RradiusZonaCommon: radius_zona_common,
				MaxZonaOrder:      max_zona_order,
				MinMeter:          min_meter,
				Charge:            charge,
				PriceCash:         price_cash,
				PriceDeposit:      price_deposit,
				PpricePeRKm:       price_per_km,
				PriceLoopingKm:    price_looping_km,
				BasicKm:           basic_km,
				DistanceLoopingKm: distance_looping_km,
				PointTransaction:  point_transaction,
				Status:            status,
				CreatedAt:         created_at,
				UpdatedAt:         updated_at,
			}
			driveprices = append(driveprices, m)
		}
	}

	//defer selDB.Close()
	selCountDB, err := db.Query("SELECT count(*) as count_data FROM driver_prices")
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
		Data:   driveprices,
		Count:  count,
		Paging: p,
	}
	responses.JSON(w, http.StatusOK, responPaging)
	return
}
