package main

import (
	"fmt"
	"log"
	"net/http"

	_ "github.com/go-sql-driver/mysql"
	"github.com/zulkiflisaid/coba/controllers"
	"github.com/zulkiflisaid/coba/controllers/master"
	"github.com/zulkiflisaid/coba/controllers/tran"
	"github.com/zulkiflisaid/coba/middlewares"
)

type mytype struct{}

//MyResponseWriter is ..
type MyResponseWriter struct {
	http.ResponseWriter
	code int
}

//WriteHeader is ..
func (mw *MyResponseWriter) WriteHeader(code int) {
	mw.code = code
	mw.ResponseWriter.WriteHeader(code)
}

//ServeHTTP is ..
func (t *mytype) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	//w.WriteHeader(http.StatusOK)
	fmt.Fprintf(w, "Welcome to api")
}

//StatusHandler is ..
func StatusHandler(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
	fmt.Fprintf(w, "OK")
}

//RunSomeCode is ..
func RunSomeCode(handler http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		log.Printf("Got a %s request for: %v", r.Method, r.URL)
		myrw := &MyResponseWriter{ResponseWriter: w, code: -1}
		handler.ServeHTTP(myrw, r)
		log.Println("Response status: ", myrw.code)
	})
}

//main is ..
func main() {
	/*mux := http.NewServeMux()
	log.Println("Server started on: http://localhost:8080")
	t := new(mytype)
	http.Handle("/", t)

	mux.HandleFunc("/status/", StatusHandler)
	*/
	t := new(mytype)
	http.Handle("/", t)
	http.Handle("/img/", http.StripPrefix("/img/", http.FileServer(http.Dir("./img"))))

	//Register Login Validasi PIN

	http.HandleFunc("/register", middlewares.SetMiddlewareJSON(controllers.Register))
	http.HandleFunc("/validasiregister", middlewares.SetMiddlewareJSON(controllers.ValidasiRegister))
	http.HandleFunc("/login", middlewares.SetMiddlewareJSON(controllers.Login))
	http.HandleFunc("/validasireset", middlewares.SetMiddlewareJSON(controllers.ValidasiReset))
	http.HandleFunc("/resetpassword", middlewares.SetMiddlewareJSON(controllers.ResetPassword))
	//http.HandleFunc("/", controllers.Index)

	// Promotion
	//http.HandleFunc("/addpromotion", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.AddPromotion)))
	//http.HandleFunc("/updatepromotion", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.UpdatePromotion)))
	//http.HandleFunc("/deletepromotion", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.DeletePromotion)))
	//http.HandleFunc("/getpromotionbyid", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.GetPromotionByID)))
	http.HandleFunc("/getallpromotion", middlewares.SetMiddlewareJSON(master.GetAllPromotion))

	//customer
	http.HandleFunc("/deletecustomer", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.DeleteCustomer)))
	http.HandleFunc("/getcustomerbyid", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.GetCustomerByID)))
	http.HandleFunc("/getallcustomer", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.GetAllCustomer)))

	//driver
	http.HandleFunc("/deletedriver", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.DeleteDriver)))
	http.HandleFunc("/getdriverbyid", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.GetDriverByID)))
	http.HandleFunc("/getalldriver", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.GetAllDriver)))

	//bank
	http.HandleFunc("/addbank", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.AddBank)))
	http.HandleFunc("/updatebank", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.UpdateBank)))
	http.HandleFunc("/deletebank", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.DeleteBank)))
	http.HandleFunc("/getbankbyid", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.GetBankByID)))
	http.HandleFunc("/getallbank", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.GetAllBank)))

	//driverprice
	http.HandleFunc("/adddriverprice", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.AddDriverPrice)))
	http.HandleFunc("/updatedriverprice", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.UpdateDriverPrice)))
	http.HandleFunc("/deletedriverprice", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.DeleteDriverPrice)))
	http.HandleFunc("/getdriverpricebyid", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.GetDriverPriceById)))
	http.HandleFunc("/getalldriverprice", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.GetAllDriverPrice)))

	//getallgcm
	http.HandleFunc("/addgcm", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.AddGcm)))
	http.HandleFunc("/updategcm", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.UpdateGcm)))
	http.HandleFunc("/deletegcm", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.DeleteGcm)))
	http.HandleFunc("/getgcmbyid", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.GetGcmById)))
	http.HandleFunc("/getallgcm", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.GetAllGcm)))

	//admin
	http.HandleFunc("/addadmin", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.AddAdmin)))
	http.HandleFunc("/updateadmin", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.UpdateAdmin)))
	http.HandleFunc("/deleteadmin", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.DeleteAdmin)))
	http.HandleFunc("/getadminbyid", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.GetAdminById)))
	http.HandleFunc("/getalladmin", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.GetAllAdmin)))

	//restaurant
	http.HandleFunc("/addresto", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.AddResto)))
	http.HandleFunc("/updateresto", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.UpdateResto)))
	http.HandleFunc("/deleterestot", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.DeleteResto)))
	http.HandleFunc("/getrestobyid", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.GetRestoById)))
	http.HandleFunc("/getallresto", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.GetAllResto)))

	//category_food
	http.HandleFunc("/addcategoryfood", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.AddCategoryFood)))
	http.HandleFunc("/updatecategoryfood", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.UpdateCategoryFood)))
	http.HandleFunc("/deletecategoryfood", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.DeleteCategoryFood)))
	http.HandleFunc("/getcategoryfoodbyid", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.GetCategoryFoodById)))
	http.HandleFunc("/getallcategoryfood", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.GetAllCategoryFood)))

	//Cooks
	http.HandleFunc("/addcook", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.AddCook)))
	http.HandleFunc("/updatecook", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.UpdateCook)))
	http.HandleFunc("/deletecook", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.DeleteCook)))
	http.HandleFunc("/getcookyid", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.GetCookById)))
	http.HandleFunc("/getallcook", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.GetAllCook)))

	//category cook
	http.HandleFunc("/addcategorycook", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.AddCategoryCook)))
	http.HandleFunc("/updatecategorycook", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.UpdateCategoryCook)))
	http.HandleFunc("/deletecategorycook", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.DeleteCategoryCook)))
	http.HandleFunc("/getcategorycookbyid", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.GetCategoryCookById)))
	http.HandleFunc("/getallcategorycook", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.GetAllCategoryCook)))

	//Shops
	http.HandleFunc("/addshop", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.AddShop)))
	http.HandleFunc("/updateshop", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.UpdateShop)))
	http.HandleFunc("/deleteshop", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.DeleteShop)))
	http.HandleFunc("/getshopyid", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.GetShopById)))
	http.HandleFunc("/getallshop", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.GetAllShop)))

	//Category Shop
	http.HandleFunc("/addcategoryshop", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.AddCategoryShop)))
	http.HandleFunc("/updatecategoryshop", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.UpdateCategoryShop)))
	http.HandleFunc("/deletecategoryshop", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.DeleteCategoryShop)))
	http.HandleFunc("/getcategoryshopbyid", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.GetCategoryShopById)))
	http.HandleFunc("/getallcategoryshop", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.GetAllCategoryShop)))

	//Inbox
	http.HandleFunc("/addinbox", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.AddInbox)))
	http.HandleFunc("/updateinbox", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.UpdateInbox)))
	http.HandleFunc("/deleteinbox", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.DeleteInbox)))
	http.HandleFunc("/getinboxbyid", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.GetInboxById)))
	http.HandleFunc("/getallinbox", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.GetAllInbox)))

	//itemgood
	http.HandleFunc("/additemgood", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.AddItemFood)))
	http.HandleFunc("/updateitemgood", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.UpdateItemFood)))
	http.HandleFunc("/deleteitemgood", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.DeleteItemFood)))
	http.HandleFunc("/getitemgoodbyid", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.GetItemFoodById)))
	http.HandleFunc("/getallitemgood", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.GetAllItemFood)))

	//itemcook
	http.HandleFunc("/additemcook", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.AddItemCook)))
	http.HandleFunc("/updateitemcook", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.UpdateItemCook)))
	http.HandleFunc("/deleteitemcook", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.DeleteItemCook)))
	http.HandleFunc("/getitemcookbyid", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.GetItemCookById)))
	http.HandleFunc("/getallitemcook", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.GetAllItemCook)))

	//itemshop
	http.HandleFunc("/additemshop", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.AddItemShop)))
	http.HandleFunc("/updateitemshop", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.UpdateItemShop)))
	http.HandleFunc("/deleteitemshop", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.DeleteItemShop)))
	http.HandleFunc("/getitemshopbyid", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.GetItemShopById)))
	http.HandleFunc("/getallitemshop", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(master.GetAllItemShop)))

	//chat
	http.HandleFunc("/addimgchat", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(tran.AddImgChat)))
	http.HandleFunc("/getimgchat", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(tran.GetImgChat)))
	//http.HandleFunc("/getimgchat", tran.GetImgChat)

	//################################################
	//transaksi
	//################################################
	//topup
	http.HandleFunc("/addtopup", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(tran.AddTopup)))
	http.HandleFunc("/addbuktitopup", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(tran.AddBuktiTopup)))
	http.HandleFunc("/imgtopup", tran.ImgTopUp)
	http.HandleFunc("/deletetopup", tran.DeleteTopUp)
	http.HandleFunc("/gettopupbyid", tran.GetTopUpByID)
	http.HandleFunc("/getalltopup", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(tran.GetAllTopUp)))

	//transaksi ojek/car4/car6
	http.HandleFunc("/getpricerute", tran.GetPriceRute)
	http.HandleFunc("/newordergojek", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(tran.NewOrderGojek)))
	http.HandleFunc("/cancelordergojek", middlewares.SetMiddlewareJSON(middlewares.SetMiddlewareAuthentication(tran.CancelOrderGojek)))
	http.HandleFunc("/acceptordergojek", tran.AcceptOrderGojek)
	http.HandleFunc("/finishordergojek", tran.FinishOrderGojek)
	http.HandleFunc("/getorderojekbyid", tran.GetOrderOjekByID)
	http.HandleFunc("/getorderojekall", tran.GetOrderOjekAll)

	//transaksi kurir

	//transaksi foods

	//transaksi cooks

	//transaksi shops

	//WrappedMux := RunSomeCode(mux)

	//log.Fatal(http.ListenAndServe(":8080", WrappedMux))
	err := http.ListenAndServeTLS(":443", "server.crt", "server.key", nil)
	if err != nil {
		//http.ListenAndServe(":8080", nil)
		//http.ListenAndServe("127.0.0.1:8080", WrappedMux)
		//http.ListenAndServe("127.0.0.1:8080", nil)
		print("running 192.168.1.44:8080")
		http.ListenAndServe("192.168.1.44:8080", nil)

	}

}
