package structs

import (
	"html"
	"strings"
)

// JSOUsers is ...
type JSOUsers struct {
	ID                string  `json:"id,omitempty"`
	Name              string  `json:"name" validate:"required,max=50"`
	Email             string  `json:"email" validate:"required,email"`
	PhoneNumber       uint64  `json:"phone_number" validate:"required,numeric"`
	PhoneID           string  `json:"phone_id" validate:"required,min=2,max=3"`
	CounterReputation float64 `json:"counter_reputation" validate:"required"`
	DivideReputation  uint32  `json:"divide_reputation" validate:"gte=0,lte=5000000"`
	Trip              uint32  `json:"trip" validate:"gte=0,lte=5000000"`
	Gcm               string  `json:"gcm" validate:"required,max=255"`
	URLAvatar         string  `json:"url_avatar" validate:"required,max=255"`
}

// GcmData is ...
type GcmData struct {
	ID          string `json:"id,omitempty"`
	Body        string `json:"body,omitempty"`
	Title       string `json:"title,omitempty"`
	Message     string `json:"message,omitempty"`
	NewRegister string `json:"new_register,omitempty"`
	PhoneNumber string `json:"phone_number,omitempty"`
	Pin         string `json:"pin,omitempty"`
	Name        string `json:"name,omitempty"`

	//untuk order ojek
	Timing          string   `json:"timing,omitempty"`
	Order           string   `json:"order,omitempty"`
	CategoryOrder   string   `json:"category_order,omitempty"`
	CategoryMessage string   `json:"category_message,omitempty"`
	JSONOrder       string   `json:"json_order,omitempty"`
	JSONCustomer    JSOUsers `json:"json_customer,omitempty"`
	JSONDriver      JSOUsers `json:"json_driver,omitempty"`

	//DataJSON      TranOjeks `json:"data_json,omitempty"`
	//DataJSON          string `json:"data_json,omitempty"`
	ClickActionstring string `json:"click_actionstring,omitempty"`
}

// GcmFormat is ...
type GcmFormat struct {
	To              string   `json:"to,omitempty"`
	RegistrationIds []string `json:"registration_ids,omitempty"`
	TimeToLive      uint     `json:"time_to_live,omitempty"`
	Priority        string   `json:"priority,omitempty"`
	Data            GcmData  `json:"data,omitempty"`
}

// GcmServer is ...
type GcmServer struct {
	ID  uint64 `json:"id,omitempty" validate:"omitempty"`
	Gcm string `json:"gcm,omitempty" validate:"required,max=255"`
	Key string `json:"key_server,omitempty" validate:"required,max=255"`
}

// UserLogin is ...
type UserLogin struct {
	ID uint64 `json:"id,omitempty" validate:"omitempty"`
	//	Email    string `json:"email" validate:"required,email,max=255"`
	PhoneNumber uint64 `json:"phone_number" validate:"required,numeric"`
	PhoneID     string `json:"phone_id" validate:"required,min=2,max=3"`
	Password    string `json:"password" validate:"required,max=255"`
	Usertype    string `json:"usertype" validate:"required,max=255"`
	Gcm         string `json:"gcm" validate:"required,max=255"`
	Status      int    `json:"status,omitempty" `
}

// UserReset is ...
type UserReset struct {
	PhoneNumber uint64 `json:"phone_number" validate:"required,numeric"`
	PhoneID     string `json:"phone_id" validate:"required,min=2,max=3"`
	Password    string `json:"password" validate:"required,min=6,max=50"`
	Pin         uint64 `json:"pin"  validate:"required,numeric"`
	TypeUser    string `json:"typeuser" validate:"required,max=16"`
}

// UserRegister is ...
type UserRegister struct {
	ID          uint64 `json:"id,omitempty" validate:"omitempty"`
	Name        string `json:"name" validate:"required,max=50"`
	Email       string `json:"email" validate:"required,email"`
	PhoneNumber uint64 `json:"phone_number" validate:"required,numeric"`
	PhoneID     string `json:"phone_id" validate:"required,min=2,max=3"`
	Password    string `json:"password" validate:"required,min=6,max=50"`
	PinRegister uint64 `json:"pin_register" validate:"omitempty"`
	Gcm         string `json:"gcm" validate:"required,max=255"`
	Usertype    string `json:"usertype" validate:"required,max=50"`
}

// ValidasiPinRegister is ...
type ValidasiPinRegister struct {
	//Pin          uint64 `json:"pin_register,omitempty" validate:"required,numeric"`
	PhoneNumber uint64 `json:"phone_number" validate:"required,numeric"`
	PhoneID     string `json:"phone_id" validate:"required,min=2,max=3"`
	TypeUser    string `json:"typeuser" validate:"required,max=15"`
}

// TokenRespon is ...
type TokenRespon struct {
	ID             uint64     `json:"id"`
	Status            bool    `json:"status"`
	Token             string  `json:"token"`
	PhoneNumber       uint64  `json:"phone_number"`
	PhoneID           string  `json:"phone_id"`
	Email             string  `json:"email"`
	FirstName         string  `json:"firstname"`
	Lastname          string  `json:"lastname"`
	Point             int     `json:"point"`
	Balance           int     `json:"balance"`
	Trip              int     `json:"trip"`
	Avatar            string  `json:"avatar"`
	CounterReputation float32 `json:"counter_reputation"`
	DivideReputation  int     `json:"divide_reputation"`
}

// Paging is ...
type Paging struct {
	Page  uint64 `json:"page" validate:"required,numeric"`
	Limit uint64 `json:"limit" validate:"required,numeric"`
}

// DataPaging is ...
type DataPaging struct {
	Data   interface{} `json:"data"`
	Count  uint64      `json:"count"`
	Paging Paging      `json:"paging"`
}

//Employee ...##############################################
//########## master
//##############################################
// Employee is ...
type Employee struct {
	ID   uint64
	Name string `validate:"required,max=20"`
	City string `validate:"required,max=5"`
	//City string `validate:"required,gte=2,lte=4"`
}
// Inboxs is ...
type Promotions struct {
	ID        uint64 `json:"id,omitempty" validate:"required,numeric"`
	Title     string `json:"title" validate:"required"`
	Message   string `json:"message" validate:"required"`
	Tag       string `json:"tag" validate:"required"`
Image       string `json:"image" validate:"required"`
ActionClick       string `json:"action_click" validate:"required"`
	CreatedAt string ` json:"created_at"`
	UpdatedAt string ` json:"updated_at"`
}
// Inboxs is ...
type Inboxs struct {
	ID        uint64 `json:"id,omitempty" validate:"required,numeric"`
	Title     string `json:"title" validate:"required"`
	Message   string `json:"message" validate:"required"`
	Tag       string `json:"tag" validate:"required"`
	CreatedAt string ` json:"created_at"`
	UpdatedAt string ` json:"updated_at"`
}

// CategoryFoods is ...
type CategoryFoods struct {
	ID           uint64 `json:"id,omitempty" validate:"required,numeric"`
	CategoryFood string `json:"category_food" validate:"required,max=50"`
	CreatedAt    string ` json:"created_at"`
	UpdatedAt    string ` json:"updated_at"`
}

// CategoryCooks is ...
type CategoryCooks struct {
	ID           uint64 `json:"id,omitempty" validate:"required,numeric"`
	CategoryCook string `json:"category_cook" validate:"required,max=50"`
	CreatedAt    string ` json:"created_at"`
	UpdatedAt    string ` json:"updated_at"`
}

// CategoryShops is ...
type CategoryShops struct {
	ID           uint64 `json:"id,omitempty" validate:"required,numeric"`
	CategoryShop string `json:"category_shop" validate:"required,max=50"`
	CreatedAt    string ` json:"created_at"`
	UpdatedAt    string ` json:"updated_at"`
}

// Banks is ...
type Banks struct {
	ID        uint64 `json:"id,omitempty" validate:"required,numeric"`
	NoRek     string `json:"no_rek" validate:"required,max=50"`
	NmPendek  string `json:"nm_short" validate:"required,max=50"`
	NmPanjang string `json:"nm_long" validate:"required,max=50"`
	Pemilik   string `json:"owner" validate:"required,max=50"`
	UrlLogo   string `json:"url_logo,omitempty" validate:"max=50"`
	Base46Img string `json:"base46_img,omitempty" validate:"required,base64"`
	CreatedAt string `json:"created_at"`
	UpdatedAt string `json:"updated_at"`
}

// ItemFoods is ...
// Employee is ...
type ItemFoods struct {
	ID         uint64 `json:"id,omitempty" validate:"required,numeric"`
	RestoId    uint64 `json:"resto_id" validate:"required,numeric"`
	KategoriId uint64 `json:"kategory_id" validate:"required,numeric"`
	NmMenu     string `json:"nm_menu" validate:"required,max=255"`
	KetMenu    string `json:"ket_menu" validate:"required,max=255"`
	Hrg        uint64 `json:"hrg" validate:"gte=0,lte=500000"`
	Laku       uint64 `json:"laku" validate:"omitempty"`
	UrlImg     string `json:"url_img,omitempty" validate:"max=50"`
	Base46Img  string `json:"base46_img,omitempty" validate:"required,base64"`
	CreatedAt  string ` json:"created_at"`
	UpdatedAt  string ` json:"updated_at"`
}

// ItemCooks is ...
// Employee is ...
type ItemCooks struct {
	ID         uint64 `json:"id,omitempty" validate:"required,numeric"`
	CookId     uint64 `json:"cook_id" validate:"required,numeric"`
	KategoriId uint64 `json:"kategory_id" validate:"required,numeric"`
	NmCook     string `json:"nm_cook" validate:"required,max=255"`
	KetCook    string `json:"ket_cook" validate:"required,max=255"`
	Hrg        uint64 `json:"hrg" validate:"gte=0,lte=500000"`
	Laku       uint64 `json:"laku" validate:"omitempty"`
	UrlImg     string `json:"url_img,omitempty" validate:"max=50"`
	Base46Img  string `json:"base46_img,omitempty" validate:"required,base64"`
	CreatedAt  string ` json:"created_at"`
	UpdatedAt  string ` json:"updated_at"`
}

// ItemShops is ...
type ItemShops struct {
	ID         uint64 `json:"id,omitempty" validate:"required,numeric"`
	ShopId     uint64 `json:"shop_id" validate:"required,numeric"`
	KategoriId uint64 `json:"kategory_id" validate:"required,numeric"`
	NmShop     string `json:"nm_shop" validate:"required,max=255"`
	KetShop    string `json:"ket_shop" validate:"required,max=255"`
	Hrg        uint64 `json:"hrg" validate:"gte=0,lte=500000"`
	Laku       uint64 `json:"laku" validate:"omitempty"`
	UrlImg     string `json:"url_img,omitempty" validate:"max=50"`
	Base46Img  string `json:"base46_img,omitempty" validate:"required,base64"`
	CreatedAt  string ` json:"created_at"`
	UpdatedAt  string ` json:"updated_at"`
}

// DriverPrices is ...
type DriverPrices struct {
	ID                uint64  `json:"id,omitempty" validate:"required,numeric"`
	CategoryDriver    string  `json:"category_driver" validate:"required,max=50"`
	PosProvinsi       string  `json:"pos_provinsi,omitempty" validate:"required,max=50"`
	PosKab            string  `json:"pos_kab,omitempty" validate:"required,max=50"`
	PosKec            string  `json:"pos_kec,omitempty" validate:"required,max=50"`
	PosLurahDesa      string  `json:"pos_lurah_desa,omitempty" validate:"required,max=50"`
	RadiusZonaSpecial string  `json:"radius_zona_special,omitempty" validate:"required,max=50"`
	RradiusZonaCommon string  `json:"radius_zona_common,omitempty" validate:"required,max=50"`
	MaxZonaOrder      string  `json:"max_zona_order,omitempty" validate:"required,max=50"`
	MinMeter          *uint64 `json:"min_meter" validate:"required,numeric"`
	Charge            *uint64 `json:"charge" validate:"required,numeric"`
	PriceCash         *uint64 `json:"price_cash" validate:"required,numeric"`
	PriceDeposit      *uint64 `json:"price_deposit" validate:"required,numeric"`
	PpricePeRKm       *uint64 `json:"price_per_km" validate:"required,numeric"`
	PriceLoopingKm    *uint64 `json:"price_looping_km" validate:"required,numeric"`
	BasicKm           *uint64 `json:"basic_km" validate:"required,numeric"`
	DistanceLoopingKm *uint64 `json:"distance_looping_km" validate:"required,numeric"`
	PointTransaction  *uint64 `json:"point_transaction" validate:"required,numeric"`
	Status            *uint   `json:"status" validate:"required,numeric"`
	CreatedAt         string  ` json:"created_at"`
	UpdatedAt         string  ` json:"updated_at"`
}

// Admins is ...
type Admins struct {
	ID          uint64 `json:"id,omitempty" validate:"omitempty"`
	Name        string `json:"name" validate:"required,max=50"`
	Email       string `json:"email" validate:"required,email"`
	PhoneNumber uint64 `json:"phone_number" validate:"required,numeric"`
	PhoneID     string `json:"phone_id" validate:"required,min=2,max=3"`
	Password    string `json:"password,omitempty" validate:"required,min=6,max=50"`
	Gcm         string `json:"gcm" validate:"omitempty"`
	UrlAvatar   string `json:"url_avatar" validate:"omitempty"`
	CreatedAt   string ` json:"created_at"`
	UpdatedAt   string ` json:"updated_at"`
}

// Customers is ...
type Customers struct {
	ID                uint64 `json:"id,omitempty" validate:"omitempty"`
	Name              string `json:"name" validate:"required,max=50"`
	Email             string `json:"email" validate:"required,email"`
	PhoneNumber       uint64 `json:"phone_number" validate:"required,numeric"`
	PhoneID           string `json:"phone_id" validate:"required,min=2,max=3"`
	Password          string `json:"password" validate:"required,min=6,max=50"`
	Saldo             string `json:"saldo" validate:"omitempty"`
	CounterReputation string `json:"counter_reputation" validate:"omitempty"`
	DivideReputation  string `json:"divide_reputation" validate:"omitempty"`
	Trip              string `json:"trip" validate:"omitempty"`
	Point             string `json:"point" validate:"omitempty"`
	PinRegister       string `json:"pin_register" validate:"omitempty"`
	PinReset          string `json:"pin_reset" validate:"omitempty"`
	Latitude          string `json:"latitude" validate:"omitempty"`
	Longitude         string `json:"longitude" validate:"omitempty"`
	Gcm               string `json:"gcm" validate:"omitempty"`
	URLAvatar         string `json:"url_avatar" validate:"omitempty"`
	RadiusPickup      string `json:"radius_pickup" validate:"omitempty"`
	Status            string `json:"status" validate:"omitempty"`
	LastOrder         string ` json:"last_order"`
	CreatedAt         string ` json:"created_at"`
	UpdatedAt         string ` json:"updated_at"`
}

// Restaurants is ...
type Restaurants struct {
	ID                uint64  `json:"id,omitempty" validate:"omitempty"`
	NmResto           string  `json:"nm_resto" validate:"required,max=255"`
	AlamatResto       string  `json:"alamat_resto" validate:"required,max=255"`
	KetResto          string  `json:"ket_resto" validate:"required,max=255"`
	MinHrg            *uint64 `json:"min_hrg" validate:"gte=0,lte=200000"`
	CounterReputation *uint64 `json:"counter_reputation" validate:"required,numeric"`
	DivideReputation  *uint64 `json:"divide_reputation" validate:"required,numeric"`
	KatOnkir          *uint64 `json:"kat_onkir" validate:"gte=0,lte=5"`
	PosisLat          *uint64 `json:"posisi_lat" validate:"required,latitude"`
	PosisiLong        *uint64 `json:"posisi_long" validate:"required,longitude"`
	//Buka_senin         uint64 `json:"buka_senin" validate:"required,numeric"`
	//Tutup_senin        uint64 `json:"tutup_senin" validate:"required,numeric"`
	UrlLogo   string `json:"url_img,omitempty" validate:"max=50"`
	Base46Img string `json:"base46_img,omitempty" validate:"required,base64"`
	Status    int    `json:"status" validate:"omitempty"`
	CreatedAt string ` json:"created_at"`
	UpdatedAt string ` json:"updated_at"`
}

// Cooks is ...
type Cooks struct {
	ID                uint64  `json:"id,omitempty" validate:"omitempty"`
	NmCook            string  `json:"nm_cook" validate:"required,max=255"`
	AlamatCook        string  `json:"alamat_cook" validate:"required,max=255"`
	KetCook           string  `json:"ket_cook" validate:"required,max=255"`
	MinHrg            *uint64 `json:"min_hrg" validate:"gte=0,lte=200000"`
	CounterReputation *uint64 `json:"counter_reputation" validate:"required,numeric"`
	DivideReputation  *uint64 `json:"divide_reputation" validate:"required,numeric"`
	KatOnkir          *uint64 `json:"kat_onkir" validate:"gte=0,lte=5"`
	PosisLat          *uint64 `json:"posisi_lat" validate:"required,latitude"`
	PosisiLong        *uint64 `json:"posisi_long" validate:"required,longitude"`
	//Buka_senin         uint64 `json:"buka_senin" validate:"required,numeric"`
	//Tutup_senin        uint64 `json:"tutup_senin" validate:"required,numeric"`
	UrlLogo   string `json:"url_img,omitempty" validate:"max=50"`
	Base46Img string `json:"base46_img,omitempty" validate:"required,base64"`
	Status    int    `json:"status" validate:"omitempty"`
	CreatedAt string ` json:"created_at"`
	UpdatedAt string ` json:"updated_at"`
}

// Shops is ...
type Shops struct {
	ID                uint64  `json:"id,omitempty" validate:"omitempty"`
	NmShop            string  `json:"nm_shop" validate:"required,max=255"`
	AlamatShop        string  `json:"alamat_shop" validate:"required,max=255"`
	KetShop           string  `json:"ket_shop" validate:"required,max=255"`
	MinHrg            *uint64 `json:"min_hrg" validate:"gte=0,lte=200000"`
	CounterReputation *uint64 `json:"counter_reputation" validate:"required,numeric"`
	DivideReputation  *uint64 `json:"divide_reputation" validate:"required,numeric"`
	KatOnkir          *uint64 `json:"kat_onkir" validate:"gte=0,lte=5"`
	PosisLat          *uint64 `json:"posisi_lat" validate:"required,latitude"`
	PosisiLong        *uint64 `json:"posisi_long" validate:"required,longitude"`
	//Buka_senin         uint64 `json:"buka_senin" validate:"required,numeric"`
	//Tutup_senin        uint64 `json:"tutup_senin" validate:"required,numeric"`
	UrlLogo   string `json:"url_img,omitempty" validate:"max=50"`
	Base46Img string `json:"base46_img,omitempty" validate:"required,base64"`
	Status    int    `json:"status" validate:"omitempty"`
	CreatedAt string ` json:"created_at"`
	UpdatedAt string ` json:"updated_at"`
}

// Drivers is ...
type Drivers struct {
	ID                uint64 `json:"id,omitempty" validate:"omitempty"`
	Name              string `json:"name" validate:"required,max=50"`
	Email             string `json:"email" validate:"required,email"`
	PhoneNumber       uint64 `json:"phone_number" validate:"required,numeric"`
	PhoneID           string `json:"phone_id" validate:"required,min=2,max=3"`
	Password          string `json:"password" validate:"required,min=6,max=50"`
	CategoryDriver    string `json:"category_driver" validate:"required"`
	Saldo             string `json:"saldo" validate:"omitempty"`
	CounterReputation string `json:"counter_reputation" validate:"omitempty"`
	DivideReputation  string `json:"divide_reputation" validate:"omitempty"`
	Trip              string `json:"trip" validate:"omitempty"`
	Point             string `json:"point" validate:"omitempty"`
	PinRegister       string `json:"pin_register" validate:"omitempty"`
	PinReset          string `json:"pin_reset" validate:"omitempty"`
	Latitude          string `json:"latitude" validate:"omitempty"`
	Longitude         string `json:"longitude" validate:"omitempty"`
	Gcm               string `json:"gcm" validate:"omitempty"`
	URLAvatar         string `json:"url_avatar" validate:"omitempty"`
	RadiusPickup      string `json:"radius_pickup" validate:"omitempty"`
	ActiveDriving     string `json:"active_driving" validate:"omitempty"`
	Status            string `json:"status" validate:"omitempty"`
	LastOrder         string ` json:"last_order"`
	CreatedAt         string ` json:"created_at"`
	UpdatedAt         string ` json:"updated_at"`
}

// Gcms is ...
type Gcms struct {
	ID        uint64 `json:"id,omitempty" validate:"required,numeric"`
	Gcm       string `json:"gcm" validate:"required,max=255"`
	KeyServer string `json:"key_server" validate:"required,max=255"`
	CreatedAt string ` json:"created_at"`
	UpdatedAt string ` json:"updated_at"`
}

// PrepareInbox is ...
func (u *Inboxs) PrepareInbox() {
	//u.ID = u.ID
	u.Title = html.EscapeString(strings.TrimSpace(u.Title))
	u.Message = html.EscapeString(strings.TrimSpace(u.Message))
	u.Tag = html.EscapeString(strings.TrimSpace(u.Tag))
}

// CustomerPrepare is ...
func (u *Customers) CustomerPrepare() {
	u.ID = 0
	u.Name = html.EscapeString(strings.TrimSpace(u.Name))
	//u.Email = html.EscapeString(strings.TrimSpace(u.Email))
	u.PhoneID = html.EscapeString(strings.TrimSpace(u.PhoneID))
	u.Password = html.EscapeString(strings.TrimSpace(u.Password))
	//	u.Photo = html.EscapeString(strings.TrimSpace(u.Photo))
	//html.EscapeString(strings.TrimSpace(u.Password))
	//u.LastOrder = time.Now()
	//u.CreatedAt = time.Now()
	//u.UpdatedAt = time.Now()
}

// PrepareUserLogin is ...
func (u *UserLogin) PrepareUserLogin() {
	u.ID = 0
	//u.Email = html.EscapeString(strings.TrimSpace(u.Email))
	u.PhoneID = html.EscapeString(strings.TrimSpace(u.PhoneID))
	u.Password = html.EscapeString(strings.TrimSpace(u.Password))
	u.Usertype = html.EscapeString(strings.TrimSpace(u.Usertype))

}

// PrepareUserRegister is ...
func (u *UserRegister) PrepareUserRegister() {
	u.ID = 0
	u.Name = html.EscapeString(strings.TrimSpace(u.Name))
	u.Email = html.EscapeString(strings.TrimSpace(u.Email))
	u.Password = html.EscapeString(strings.TrimSpace(u.Password))
	u.PhoneID = html.EscapeString(strings.TrimSpace(u.PhoneID))
	u.Gcm = html.EscapeString(strings.TrimSpace(u.Gcm))
	u.Usertype = html.EscapeString(strings.TrimSpace(u.Usertype))
}

// PrepareCategoryFood is ...
func (u *CategoryFoods) PrepareCategoryFood() {
	//u.ID = u.ID
	u.CategoryFood = html.EscapeString(strings.TrimSpace(u.CategoryFood))
}

// PrepareCategoryShop is ...
func (u *CategoryShops) PrepareCategoryShop() {
	//u.ID = u.ID
	u.CategoryShop = html.EscapeString(strings.TrimSpace(u.CategoryShop))
}

// PrepareCategoryCook is ...
func (u *CategoryCooks) PrepareCategoryCook() {
	//u.ID = u.ID
	u.CategoryCook = html.EscapeString(strings.TrimSpace(u.CategoryCook))
}

// PrepareItemFood is ...
func (u *ItemFoods) PrepareItemFood() {
	//u.ID = u.ID
	u.NmMenu = html.EscapeString(strings.TrimSpace(u.NmMenu))
	u.KetMenu = html.EscapeString(strings.TrimSpace(u.KetMenu))
}

// PrepareItemCook is ...
func (u *ItemCooks) PrepareItemCook() {
	//u.ID = u.ID
	u.NmCook = html.EscapeString(strings.TrimSpace(u.NmCook))
	u.KetCook = html.EscapeString(strings.TrimSpace(u.KetCook))
}

// PrepareItemShop is ...
func (u *ItemShops) PrepareItemShop() {
	//u.ID = u.ID
	u.NmShop = html.EscapeString(strings.TrimSpace(u.NmShop))
	u.KetShop = html.EscapeString(strings.TrimSpace(u.KetShop))
}

// PrepareBank is ...
func (u *Banks) PrepareBank() {
	//u.ID = u.ID
	u.NoRek = html.EscapeString(strings.TrimSpace(u.NoRek))
	u.NmPendek = html.EscapeString(strings.TrimSpace(u.NmPendek))
	u.NmPanjang = html.EscapeString(strings.TrimSpace(u.NmPanjang))
}

// PrepareDriverPrice is ...
func (u *DriverPrices) PrepareDriverPrice() {
	//u.ID = u.ID
	u.CategoryDriver = html.EscapeString(strings.TrimSpace(u.CategoryDriver))
	//u.NmPendek = html.EscapeString(strings.TrimSpace(u.NmPendek))
	//u.NmPanjang = html.EscapeString(strings.TrimSpace(u.NmPanjang))
}

// PrepareGcm is ...
func (u *Gcms) PrepareGcm() {
	//u.ID = u.ID
	u.Gcm = html.EscapeString(strings.TrimSpace(u.Gcm))
	u.KeyServer = html.EscapeString(strings.TrimSpace(u.KeyServer))
}

// PrepareAdmin is ...
// PrepareRestaurant is ...
func (u *Admins) PrepareAdmin() {
	//u.ID = u.ID
	u.Name = html.EscapeString(strings.TrimSpace(u.Name))
	u.Gcm = html.EscapeString(strings.TrimSpace(u.Gcm))
}

// PrepareRestaurant is ...
func (u *Restaurants) PrepareRestaurant() {
	//u.ID = u.ID
	u.NmResto = html.EscapeString(strings.TrimSpace(u.NmResto))

}

// PrepareCook is ...
func (u *Cooks) PrepareCook() {
	//u.ID = u.ID
	u.NmCook = html.EscapeString(strings.TrimSpace(u.NmCook))

}

// PrepareShop is ...
func (u *Shops) PrepareShop() {
	//u.ID = u.ID
	u.NmShop = html.EscapeString(strings.TrimSpace(u.NmShop))

}
