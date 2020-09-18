package tran

import (
	"encoding/json"
	"errors"
	"fmt"
	"io/ioutil"
	"log"
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

type distanceDuration struct {
	Text  string `json:"text"`
	Value int64  `json:"value"`
}
type legs struct {
	Distance *distanceDuration `json:"distance"`
	Duration *distanceDuration `json:"duration"`
	//End_address string            `json:"end_address"`
}
type routes struct {
	//Bounds            interface{} `json:"bounds"`
	//Copyrights        string      `json:"copyrights"`
	Legs []legs `json:"legs"`
	//Overview_polyline interface{} `json:"overview_polyline"`
	//Summary           string      `json:"summary"`
	//Warnings          interface{} `json:"warnings"`
	//Waypoint_order    interface{} `json:"waypoint_order"`
}

type responGoogle struct {
	//Geocoded_waypoints interface{} `json:"geocoded_waypoints"`
	Routes []routes `json:"routes"`
	Status string   `json:"status"`
}

type postPrice struct {
	CategoryDriver  string `json:"category_driver" validate:"required,max=5"`
	OriginLat       string `json:"origin_lat" validate:"required,latitude"`
	OriginLong      string `json:"origin_long" validate:"required,longitude"`
	DestinationLat  string `json:"destination_lat" validate:"required,latitude"`
	DestinationLong string `json:"destination_long" validate:"required,longitude"`
}

type responPrices struct {
	DistanceText     string `json:"distance_text"`
	DistanceValue    string `json:"distance_value"`
	DurationText     string `json:"duration_text"`
	DurationValue    string `json:"duration_value"`
	Polyline         string `json:"polyline"`
	Charge           string `json:"charge"`
	CategoryDriver   string `json:"category_driver"`
	PayCategories    string `json:"pay_categories"`
	PointTransaction string `json:"point_transaction"`
	TotalPrices      string `json:"total_prices"`
	Status           string `json:"status"`
}

// GetPriceRute is  ....
func GetPriceRute(w http.ResponseWriter, r *http.Request) {

	//tokenID, err := auth.ExtractTokenID(r)
	//	if err != nil {
	//	responses.ERROR(w, http.StatusUnauthorized, errors.New("Unauthorized"))
	//	return
	//}
	akses, err := auth.ExtractTokenKat(r)
	if err != nil || akses != "customers" {
		responses.ERROR(w, http.StatusUnauthorized, errors.New("Unauthorized"))
		return
	}

	body, err := ioutil.ReadAll(r.Body)
	if err != nil {
		responses.ERROR(w, http.StatusBadRequest, err)
		return
	}
	post := postPrice{}

	err = json.Unmarshal(body, &post)
	if err != nil {
		responses.ERROR_unmarshal(w, http.StatusBadRequest, err)
		return
	}
	validate := validator.New()
	err = validate.Struct(post)
	if err != nil {
		responses.ERROR_validation(w, http.StatusUnprocessableEntity, err)
		return
	}

	url := "https://maps.googleapis.com/maps/api/directions/json?mode=driving&key=" + configs.KeyAPIMap() + "&origin=" + post.OriginLat + "," + post.OriginLong + "&destination=" + post.DestinationLat + "," + post.DestinationLong + ""
	//fmt.Println(url)
	//req, err := http.NewRequest("GET", url, nil)
	req, err := utils.GetURL(url)
	if err != nil {
		responses.ERROR(w, http.StatusUnprocessableEntity, err)
		return
	}
	req.Header.Add("cache-control", "no-cache")
	//fmt.Println(req.StatusCode)
	if req.StatusCode != 200 {
		responses.ERROR(w, http.StatusBadRequest, errors.New("StatusBadRequest"))
		return
	}

	//req.Header.Add("Content-Type:", "application/json")
	//req.Header.Add("cache-control", "no-cache")
	//res, err := http.DefaultClient.Do(req.Request)
	//if err != nil {
	//	responses.ERROR(w, http.StatusUnprocessableEntity, err)
	//	return
	//}
	defer req.Body.Close()
	bodyRute, err := ioutil.ReadAll(req.Body)
	if err != nil {
		responses.ERROR(w, http.StatusUnprocessableEntity, err)
		return
	}
	fmt.Println(string(bodyRute))
	var maps responGoogle
	err = json.Unmarshal([]byte(bodyRute), &maps)
	if err != nil {
		responses.ERROR(w, http.StatusUnprocessableEntity, err)
		return
	}
	//fmt.Println(maps.Status)
	if maps.Status != "OK" {
		responses.ERROR(w, http.StatusBadRequest, errors.New("REQUEST_DENIED"))
		return
	}

	db := configs.Conn()
	selDB, err := db.Query("SELECT  *  FROM driver_prices WHERE id=? limit 1", post.CategoryDriver)
	defer db.Close()
	if err != nil {
		responses.ERROR_mysql(w, http.StatusUnprocessableEntity, err)
		return
	}
	var id uint64
	var categoryDriver, posProvinsi, posKab, posKec, posLurahDesa, radiusZonaSpecial, radiusZonaCommon, maxZonOrder string
	var minMeter, charge, priceCash, priceDeposit, pricePerKm, priceLoopingKm, basicKm, distanceLloopingKm, pointTransaction uint64
	var status *uint
	var createdAt, updatedAt string
	//m := structs.DriverPrices{}
	for selDB.Next() {

		err = selDB.Scan(&id, &categoryDriver, &posProvinsi, &posKab, &posKec, &posLurahDesa,
			&radiusZonaSpecial, &radiusZonaCommon, &maxZonOrder,
			&minMeter, &charge, &priceCash, &priceDeposit, &pricePerKm, &priceLoopingKm, &basicKm,
			&distanceLloopingKm, &pointTransaction, &status,
			&createdAt, &updatedAt)
		if err != nil {
			responses.ERROR_mysql(w, http.StatusUnprocessableEntity, err)
			return
		}
		/*m.ID = id
		m.CategoryDriver = categoryDriver
		m.PosProvinsi = posProvinsi
		m.PosKab = posKab
		m.PosKec = posKec
		m.PosLurahDesa = posLurahDesa
		m.RadiusZonaSpecial = radiusZonaSpecial
		m.RradiusZonaCommon = radiusZonaCommon
		m.MaxZonaOrder = maxZonOrder
		m.MinMeter = minMeter
		m.Charge = charge
		m.PriceCash = priceCash
		m.PriceDeposit = priceDeposit
		m.PpricePeRKm = pricePerKm
		m.PriceLoopingKm = priceLoopingKm
		m.BasicKm = basicKm
		m.DistanceLoopingKm = distanceLloopingKm
		m.PointTransaction = pointTransaction
		m.Status = status
		m.CreatedAt = createdAt
		m.UpdatedAt = updatedAt*/

		if categoryDriver != "" {

		}

	}

	//fmt.Println(post.CategoryDriver)

	f := map[string]interface{}{
		"distance_text":     maps.Routes[0].Legs[0].Distance.Text,
		"distance_value":    maps.Routes[0].Legs[0].Distance.Value,
		"duration_text":     maps.Routes[0].Legs[0].Duration.Text,
		"duration_value":    maps.Routes[0].Legs[0].Duration.Value,
		"polyline":          "Wednesday",
		"charge":            charge,
		"category_driver":   post.CategoryDriver,
		"pay_categories":    "Wednesday",
		"point_transaction": "Wednesday",
		"total_prices":      "Wednesday",
		"status":            "Wednesday",
	}
	//w.Header().Set("Location", fmt.Sprintf("%s%s/%d", r.Host, r.RequestURI, 1))
	//responses.JSON(w, http.StatusCreated, f)

	responses.JSON(w, http.StatusOK, f)
	return

}

// NewOrderGojek is  ....
func NewOrderGojek(w http.ResponseWriter, r *http.Request) {

	akses, err := auth.ExtractTokenKat(r)
	if err != nil || akses != "customers" {
		responses.ERROR(w, http.StatusUnauthorized, errors.New("Unauthorized"))
		return
	}

	tokenID, err := auth.ExtractTokenID(r)
	if err != nil {
		responses.ERROR(w, http.StatusUnauthorized, errors.New("Unauthorized"))
		return
	}

	body, err := ioutil.ReadAll(r.Body)
	if err != nil {
		responses.ERROR(w, http.StatusBadRequest, err)
		return
	}

	m := structs.TranOjeks{}
	err = json.Unmarshal(body, &m)
	if err != nil {
		responses.ERROR(w, http.StatusBadRequest, err)
		return
	}
	m.PrepareTranOjeks()

	//random uuid kita ambil cuman 4 angka
	uuid4Angka, err := utils.RandomUIID(8, 2)
	if err != nil {
		responses.ERROR(w, http.StatusBadRequest, err)
		return
	}
	log.Println(uuid4Angka)

	//ramdom angka 10 digit
	NextRandom := utils.NextRandom()
	log.Println(NextRandom)

	m.ID = 1
	m.KdTransaksi = uuid4Angka + NextRandom
	m.StatusOrder = 0 //status_order 0 artinya orderan di batalkan oleh driver
	m.StatusDriver = 0
	m.DriverID = 0
	if m.PayCategory == "tunai" || m.PayCategory == "saldo" {

	} else {
		responses.ERROR(w, http.StatusBadRequest, errors.New("Metode pembayaran harus saldo atau tunai"))
		return
	}
	if m.CategoryDriver == "ojek" || m.CategoryDriver == "car4" || m.CategoryDriver == "car6" {

	} else {
		responses.ERROR(w, http.StatusBadRequest, errors.New("Kategori Driver harus motor atau Mobil"))
		return
	}

	//log.Println(m.ID)
	validate := validator.New()
	err = validate.Struct(m)
	if err != nil {
		responses.ERROR(w, http.StatusUnprocessableEntity, err)
		return
	}
	if tokenID != m.UserID {
		responses.ERROR(w, http.StatusUnauthorized, errors.New("Unauthorized"))
		return
	}

	//ambil harga driver
	//========================

	//bandingkan harga datang dengan harga asli dari database
	//kemduian atur ulang point transaksi dan chager dan total prices
	//========================

	//cek saldo jika dibayar pakai saldo
	//========================

	db := configs.Conn()
	insForm, err := db.Exec("INSERT INTO tran_ojeks("+
		"customer_id,code_trans, category_driver, pay_category, charge, point_transaction, status_driver, "+
		"total_prices, driver_id, duration_value, 	distance_value, status_order, "+
		"pickup_lat,pickup_long,desti_lat,desti_long, "+
		"distance_text, duration_text,  pickup_address, pickup_place, pickup_desc, "+
		"desti_address, desti_place, polyline "+
		") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
		m.UserID,
		m.KdTransaksi,
		m.CategoryDriver,
		m.PayCategory,
		m.Charge,
		m.PointTransaction,
		m.StatusDriver,
		m.TotalPrices,
		m.DriverID,
		m.DurationValue,
		m.DistanceValue,
		m.StatusOrder,
		m.JemputLat,
		m.JemputLong,
		m.TujuanLat,
		m.TujuanLong,
		m.DistanceText,
		m.DurationText,
		m.JemputAlamat,
		m.JemputJudul,
		m.JemputKet,
		m.TujuanAlamat,
		m.TujuanJudul,
		m.Polyline,
	)
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
	lastInsertID, err := insForm.LastInsertId()
	if err != nil {
		responses.ERROR(w, http.StatusBadRequest, err)
		return
	}

	if RowsAff == 1 {

		//select data gcm message masing-masing driver berdasarkan radius user dengan driver
		//dan berdasarkan saldo driver jika bayar tunai dan sementara tidak mengantar

		selGCMDriver, err := db.Query("SELECT gcm FROM drivers where radius_pickup>=((2 * asin(sqrt(pow(SIN((RADIANS(?)-RADIANS(latitude)) / 2), 2) + cos(RADIANS(latitude)) * cos(RADIANS(?)) * pow(SIN((RADIANS(?)-RADIANS(longitude)) / 2), 2)))) * 6371000)"+
			"AND active_driving=? AND category_driver=?  limit 5", m.JemputLat, m.JemputLat, m.JemputLong, 0, "motor")
		if err != nil {
			responses.JSON(w, http.StatusOK, json.RawMessage(`{"status": true,"order":"`+m.KdTransaksi+`","id":`+strconv.FormatInt(lastInsertID, 10)+`}`))
			return
		}

		//var gcmDrivers [5]string
		gcmDrivers := []string{"", "", "", "", ""}
		sum := 0
		for selGCMDriver.Next() {
			var gcm string
			err := selGCMDriver.Scan(&gcm)
			if err != nil {
				responses.JSON(w, http.StatusOK, json.RawMessage(`{"status": true,"order":"`+m.KdTransaksi+`","id":`+strconv.FormatInt(lastInsertID, 10)+`}`))
				return
			}
			gcmDrivers[sum] = gcm
			sum++
		}
		gcmDrivers = gcmDrivers[:sum]
		//	log.Println(gcmDrivers)
		JSONOrder, err := json.Marshal(m)
		if err != nil {
			responses.JSON(w, http.StatusOK, json.RawMessage(`{"status": true,"order":"`+m.KdTransaksi+`","id":`+strconv.FormatInt(lastInsertID, 10)+`}`))
			return
		}

		gcmData := structs.GcmData{
			ID:      strconv.FormatInt(lastInsertID, 10),
			Body:    "body",
			Title:   "title",
			Message: "message",
			Timing:  time.Now().String(),
			//Order:         strconv.FormatInt(lastInsertID, 10),
			Order:         m.KdTransaksi,
			CategoryOrder: "ojek_motor",
			//JSONCustomer:  string(JSONCustomer),
			JSONOrder:         string(JSONOrder),
			ClickActionstring: "FLUTTER_NOTIFICATION_CLICK",
		}
		gcmFormat := structs.GcmFormat{
			RegistrationIds: gcmDrivers,
			TimeToLive:      60,
			Priority:        "high",
			Data:            gcmData,
		}

		resBody, err := utils.PostURLF(configs.URLGcm(), gcmFormat)
		if err != nil {
			responses.JSON(w, http.StatusOK, json.RawMessage(`{"status": true,"order":"`+m.KdTransaksi+`","id":`+strconv.FormatInt(lastInsertID, 10)+`}`))
			return
		}

		fmt.Println(resBody)
		responses.JSON(w, http.StatusOK, json.RawMessage(`{"status": true,"order":"`+m.KdTransaksi+`","id":`+strconv.FormatInt(lastInsertID, 10)+`}`))
		return
	}

	responses.ERROR(w, http.StatusBadRequest, errors.New("Bad Request"))
	return
}

// CancelOrderGojek is  ....
func CancelOrderGojek(w http.ResponseWriter, r *http.Request) {
	akses, err := auth.ExtractTokenKat(r)
	if err != nil {
		responses.ERROR(w, http.StatusUnauthorized, errors.New("Unauthorized"))
		return
	}
	tokenID, err := auth.ExtractTokenID(r)
	if err != nil {
		responses.ERROR(w, http.StatusUnauthorized, errors.New("Unauthorized1"))
		return
	}

	kolomPengguna := ""
	if akses == "drivers" {
		kolomPengguna = " driver_id=? "
	} else if akses == "customers" {
		kolomPengguna = " customer_id=?  "
	} else {
		responses.ERROR(w, http.StatusUnauthorized, errors.New("Unauthorized"))
		return
	}

	Query := r.URL.Query()

	id, err := strconv.Atoi(Query.Get("id"))
	if err != nil || id < 1 {
		responses.ERROR(w, http.StatusBadRequest, err)
		return
	}

	cancelID, err := strconv.Atoi(Query.Get("cancelid"))
	if err != nil {
		responses.ERROR(w, http.StatusBadRequest, err)
		return
	}
	codetran := Query.Get("codetran")

	m := structs.CancelTranOjeks{
		ID:          uint64(id),
		UserID:      tokenID,
		DriverID:    tokenID,
		CancelID:    uint32(cancelID),
		KdTransaksi: codetran,
		UserKat:     akses,
	}

	m.PrepareCancelTranOjeks()

	//log.Println(cancelID)
	//log.Println(id)
	//log.Println(codetran)

	//log.Println(akses)
	//log.Println(tokenID)
	//log.Println(kolomPengguna)

	validate := validator.New()
	err = validate.Struct(m)
	if err != nil {
		responses.ERROR_validation(w, http.StatusUnprocessableEntity, err)
		return
	}

	currentTime := time.Now()
	//status_order 88 artinya orderan di batalkan oleh driver
	db := configs.Conn()
	updateForm, err := db.Exec("UPDATE tran_ojeks SET status_order=?, cancel_id=?,  updated_at=? WHERE  id=? AND  code_trans=? AND status_order<>99 AND  "+kolomPengguna,
		88,
		cancelID,
		currentTime.Format("2006.01.02 15:04:05"),
		id,
		codetran,
		tokenID)
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
		responses.JSON(w, http.StatusOK, json.RawMessage(`{"status": true}`))
		return
	}

}

// AcceptOrderGojek is  ....
func AcceptOrderGojek(w http.ResponseWriter, r *http.Request) {
	akses, err := auth.ExtractTokenKat(r)
	if err != nil || akses != "drivers" {
		responses.ERROR(w, http.StatusUnauthorized, errors.New("Unauthorized"))
		return
	}
	tokenID, err := auth.ExtractTokenID(r)
	if err != nil {
		responses.ERROR(w, http.StatusUnauthorized, errors.New("Unauthorized"))
		return
	}

	//log.Println(r.URL.Query().Get("id"))
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
	//status_order 1 artinya orderan diterima oleh driver
	currentTime := time.Now()
	db := configs.Conn()
	updateForm, err := db.Exec("UPDATE tran_ojeks SET status_order=?, driver_id=? updated_at=? WHERE  id=? AND status_order==0   AND driver_id=? ",
		1,
		tokenID,
		currentTime.Format("2006.01.02 15:04:05"),
		id,
		0)
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
		//select data gcm message masing-masing driver berdasarkan radius user dan driver
		//dan berdasarkan saldo driver dan sementara tidak mengantar

		selGCMDriver, err := db.Query("SELECT gcm FROM drivers where id=?")
		if err != nil {
			responses.JSON(w, http.StatusOK, json.RawMessage(`{"status": true}`))
			return
		}

		//var gcmDrivers [5]string

		for selGCMDriver.Next() {
			var gcm string
			err := selGCMDriver.Scan(&gcm)
			if err != nil {
				responses.JSON(w, http.StatusOK, json.RawMessage(`{"status": true}`))
				return
			}
		}

		gcmData := structs.GcmData{
			Body:            "body",
			Title:           "title",
			Message:         "message",
			Timing:          time.Now().String(),
			Order:           strconv.Itoa(id),
			CategoryOrder:   "ojek_motor",
			CategoryMessage: "accept_order",
			//JSONDriver:  string(JSONDriver),
			//JSONCustomer:  string(JSONCustomer),
			//JSONOrder: string(JSONOrder),
			ClickActionstring: "FLUTTER_NOTIFICATION_CLICK",
		}
		gcmFormat := structs.GcmFormat{
			To:         "gcmDrivers",
			TimeToLive: 30,
			Priority:   "high",
			Data:       gcmData,
		}

		resBody, err := utils.PostURLF(configs.URLGcm(), gcmFormat)
		if err != nil {
			responses.JSON(w, http.StatusOK, json.RawMessage(`{"status": true}`))
			return
		}

		//	fmt.Println(resBody)
		responses.JSON(w, http.StatusOK, json.RawMessage(resBody))
		return
	}

	responses.JSON(w, http.StatusBadRequest, json.RawMessage(`{"status": false}`))
	return
}

// FinishOrderGojek is  ....
func FinishOrderGojek(w http.ResponseWriter, r *http.Request) {
	akses, err := auth.ExtractTokenKat(r)
	if err != nil || akses != "drivers" {
		responses.ERROR(w, http.StatusUnauthorized, errors.New("Unauthorized"))
		return
	}
	tokenID, err := auth.ExtractTokenID(r)
	if err != nil {
		responses.ERROR(w, http.StatusUnauthorized, errors.New("Unauthorized"))
		return
	}

	//log.Println(r.URL.Query().Get("id"))
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
	//status_order 99 artinya orderan selesai oleh driver
	currentTime := time.Now()
	db := configs.Conn()
	updateForm, err := db.Exec("UPDATE tran_ojeks SET status_order=?,  updated_at=? WHERE  id=? AND status_order==2   AND driver_id=? ",
		99,
		currentTime.Format("2006.01.02 15:04:05"),
		id,
		tokenID)
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

	responses.JSON(w, http.StatusBadRequest, json.RawMessage(`{"status": false}`))
	return
}

// GetOrderOjekByID is  ....
func GetOrderOjekByID(w http.ResponseWriter, r *http.Request) {

}

// GetOrderOjekAll is  ....
func GetOrderOjekAll(w http.ResponseWriter, r *http.Request) {

}
