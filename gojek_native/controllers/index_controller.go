package controllers

//import (
//	"fmt"
//	"net/http"
//)

//func Index1(w http.ResponseWriter, r *http.Request) {
//	fmt.Fprintf(w, "hello\n")
//}

import (
	"errors"
	"net/http"

	"github.com/zulkiflisaid/coba/responses"
)

// Index is ...
func Index(w http.ResponseWriter, r *http.Request) {

	responses.ERROR(w, http.StatusBadRequest, errors.New("404 page not found"))
	return
}
