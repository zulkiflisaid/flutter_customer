package models

import (
	"github.com/zulkiflisaid/coba/configs"
	"github.com/zulkiflisaid/coba/structs"
)

// ModelGetCount is ...
func ModelGetCount(tables string) (uint64, error) {
	var err error
	var RowCoont uint64
	RowCoont = 0

	db := configs.Conn()
	selCountDB, err := db.Query("SELECT count(*) as count_data FROM " + tables)
	if err != nil {
		return 0, err
	}
	defer db.Close()
	for selCountDB.Next() {
		err = selCountDB.Scan(&RowCoont)
		if err != nil {
			return 0, err
		}
	}

	return RowCoont, err
}

// ModelGcmServer is ...
func ModelGcmServer() (structs.GcmServer, error) {
	var err error
	gcmServer := structs.GcmServer{}
	db := configs.Conn()
	selDB, err := db.Query("SELECT gcm,key_server FROM gcms WHERE id=?", "1")
	if err != nil {
		return gcmServer, err
	}

	defer db.Close()
	for selDB.Next() {
		var gcm, key string
		err = selDB.Scan(&gcm, &key)
		if err != nil {
			return gcmServer, err
		}
		gcmServer.Gcm = gcm
		gcmServer.Key = key
	}

	return gcmServer, err
}
