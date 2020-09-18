package structs

import (
	"html"
	"strings"
)

//##############################################
//########## tran
//##############################################

// TopUps is ...
type TopUps struct {
	ID         uint64 `json:"id,omitempty" validate:"required,numeric"`
	KdTransfer string `json:"code_transfer,omitempty" validate:"required,len=13"`
	UserKat    string `json:"user_category,omitempty" validate:"required,max=20"`
	UserID     uint64 `json:"user_id" validate:"required,numeric"`
	BankID     uint32 `json:"bank_id" validate:"required,numeric"`
	Jumlah     uint32 `json:"amount" validate:"gte=20000,lte=500000"`
	//IsBukti    string `json:"is_bukti,omitempty" validate:"required"`
	Verifikasi uint8  `json:"is_verification,omitempty" validate:"required"`
	ImgBukti   string `json:"img_struck,omitempty" `
	Base46Img  string `json:"base46_img,omitempty" `
	CreatedAt  string `json:"created_at"`
	UpdatedAt  string `json:"updated_at"`
	Banks      Banks  `json:"banks,omitempty" validate:"omitempty"`
}

// TranOjeks is ...
type TranOjeks struct {
	ID               uint64  `json:"id,omitempty" validate:"required,numeric"`
	UserID           uint64  `json:"customer_id" validate:"required,numeric"`
	DriverID         uint64  `json:"driver_id" validate:"gte=0"`
	KdTransaksi      string  `json:"code_trans,omitempty" validate:"required,len=13"`
	CategoryDriver   string  `json:"category_driver,omitempty" validate:"required,max=50"`
	PayCategory      string  `json:"pay_category" validate:"required,max=10"`
	Charge           uint32  `json:"charge" validate:"gte=0,lte=50000"`
	PointTransaction uint32  `json:"point_transaction" validate:"gte=0,lte=1000"`
	StatusDriver     uint32  `json:"status_driver" validate:"gte=0,lte=10"`
	TotalPrices      uint32  `json:"total_prices" validate:"gte=1000,lte=500000"`
	DurationValue    uint32  `json:"duration_value" validate:"gte=0,lte=100000"`
	DistanceValue    uint32  `json:"distance_value" validate:"gte=0,lte=100000"`
	StatusOrder      uint32  `json:"status_order,omitempty" validate:"gte=0,lte=10"`
	JemputLat        float64 `json:"pickup_lat" validate:"required,latitude"`
	JemputLong       float64 `json:"pickup_long" validate:"required,longitude"`
	TujuanLat        float64 `json:"desti_lat" validate:"required,latitude"`
	TujuanLong       float64 `json:"desti_long" validate:"required,longitude"`
	TujuanAlamat     string  `json:"desti_address,omitempty" validate:"required,max=255"`
	TujuanJudul      string  `json:"desti_place,omitempty" validate:"required,max=255"`
	DistanceText     string  `json:"distance_text,omitempty" validate:"required,max=10"`
	DurationText     string  `json:"duration_text,omitempty" validate:"required,max=10"`
	JemputAlamat     string  `json:"pickup_address,omitempty" validate:"required,max=255"`
	JemputJudul      string  `json:"pickup_place,omitempty" validate:"required,max=255"`
	JemputKet        string  `json:"pickup_desc,omitempty" validate:"max=255"`
	Polyline         string  `json:"polyline,omitempty" validate:"required"`
	CreatedAt        string  `json:"created_at"`
	AcceptAt         string  `json:"accept_at"`
	FinishAt         string  `json:"finish_at"`
	UpdatedAt        string  `json:"updated_at"`
	//Banks            Banks  `json:"banks,omitempty" validate:"omitempty"`
	//JSOUser JSOUsers `json:"customer,omitempty" validate:"omitempty"`
}

// CancelTranOjeks is ...
type CancelTranOjeks struct {
	ID          uint64 `json:"id" validate:"required,numeric"`
	UserID      uint64 `json:"customer_id" validate:"required,numeric"`
	DriverID    uint64 `json:"driver_id" validate:"required,numeric"`
	CancelID    uint32 `json:"cancel_id" validate:"gte=0"`
	KdTransaksi string `json:"code_trans" validate:"required,len=13"`
	UserKat     string `json:"usertype" validate:"required,max=25"`
}

// ChatImgs is ...
type ChatImgs struct {
	ImageName string `json:"image" validate:"required,min=27,max=39"`
	Base46Img string `json:"base46_img" validate:"required,base64"`
}

// PrepareTranOjeks is ...
//prepaeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
func (u *TranOjeks) PrepareTranOjeks() {
	//u.ID = u.ID
	u.TujuanAlamat = html.EscapeString(strings.TrimSpace(u.TujuanAlamat))
	u.TujuanJudul = html.EscapeString(strings.TrimSpace(u.TujuanJudul))
	u.JemputAlamat = html.EscapeString(strings.TrimSpace(u.JemputAlamat))
	u.JemputJudul = html.EscapeString(strings.TrimSpace(u.JemputJudul))
	u.JemputKet = html.EscapeString(strings.TrimSpace(u.JemputKet))
	u.Polyline = html.EscapeString(strings.TrimSpace(u.Polyline))
	u.DistanceText = html.EscapeString(strings.TrimSpace(u.DistanceText))
	u.DurationText = html.EscapeString(strings.TrimSpace(u.DurationText))
}

// PrepareCancelTranOjeks is ...
func (u *CancelTranOjeks) PrepareCancelTranOjeks() {
	//u.ID = u.ID
	u.UserKat = html.EscapeString(strings.TrimSpace(u.UserKat))
	u.KdTransaksi = html.EscapeString(strings.TrimSpace(u.KdTransaksi))

}
