package configs

import (
	"database/sql"
)

//Conn is
func Conn() (db *sql.DB) {
	dbDriver := "mysql"
	dbUser := "root"
	dbPass := ""
	dbName := "fullstack_api"
	db, err := sql.Open(dbDriver, dbUser+":"+dbPass+"@tcp(localhost:3306)/"+dbName)
	if err != nil {
		panic(err.Error())
	}
	return db
}

//ConfigURL is
func ConfigURL() string {
	return "http://localhost:8080/"
}

//URLGcm is
func URLGcm() string {
	return "https://fcm.googleapis.com/fcm/send"
}

//KeyGcmServer is
func KeyGcmServer() string {
	return "AAAAqb3QmLo:APA91bGYHDpiqCE__s7kOJud_mScdRynRzZEGj_usgg6N4yZ1nDY3RNwBWVbxzYSzTxhbixR3zT3h84CbVOO1ISV3RUwMAls42K5iDmS9cyFaTrA1QpNgKKuM2SfRSbzG_R-y8iN4ksk"
}

//KeyAPIMap is ...
func KeyAPIMap() string {
	//asli dari akun zulcompoubd
	//return "AIzaSyA706610W0aD4w2ueNR6seGrlHj5SpYOyM"
	//https://distan.gorontaloprov.go.id/data-alsintan/
	return "AIzaSyBTokiA2EScfsUgZeuTcsTdpcrV11qAw8E"
}
