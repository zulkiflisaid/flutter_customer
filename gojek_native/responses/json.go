package responses

import (
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"strings"

	"gopkg.in/go-playground/validator.v9"
)

func JSON(w http.ResponseWriter, statusCode int, data interface{}) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(statusCode)

	err := json.NewEncoder(w).Encode(data)
	if err != nil {
		fmt.Fprintf(w, "%s", err.Error())
	}
}
func ERROR(w http.ResponseWriter, statusCode int, err error) {

	if err != nil {
		JSON(w, statusCode, struct {
			Error string `json:"error"`
		}{
			Error: err.Error(),
		})
		return
	}
	JSON(w, http.StatusBadRequest, nil)
}
func ERROR_mysql(w http.ResponseWriter, statusCode int, err error) {
	stringError := err.Error()

	//string_error = strings.ReplaceAll(string_error, "Error 1062: ", "")
	//string_error = strings.ReplaceAll(string_error, "for key", "form")
	if strings.Contains(stringError, "Error 1062") {
		//string_error = strings.ReplaceAll(string_error, "Error 1062: ", "")
		//	string_error = strings.ReplaceAll(string_error, "Duplicate entry ", "")
		//string_error = strings.ReplaceAll(string_error, "for key ", "")
		//Error 1062: Duplicate entry '+62-82213924427' for key 'Phone Number'

		//	value := s[1]
		//fmt.Println(s[1] + "1")
		//fmt.Println(s[2] + "2")
		//fmt.Println(s[3] + "3")
		//fmt.Println(s[4] + "4")
		//fmt.Println(s[5] + "5")
		stringError = strings.ReplaceAll(stringError, "+62-", "+62")
		s := strings.Split(stringError, "'")
		stringError = s[3] + " " + s[1] + " talah digunakan."

	}

	err = errors.New(stringError)

	if err != nil {
		ERROR(w, statusCode, err)
		return
	}
	JSON(w, http.StatusBadRequest, nil)
}

// ERROR_validation is ...
func ERROR_validation(w http.ResponseWriter, statusCode int, err error) {

	/*if _, ok := err.(*validator.InvalidValidationError); ok {
		fmt.Println("----------------------")
		fmt.Println(err)
		//return
	}
	*/

	stringError := ""
	stringErrors := ""
	for _, err := range err.(validator.ValidationErrors) {
		/*fmt.Println("================")
		fmt.Println(" Namespace " + err.Namespace())
		fmt.Println(" Field " + err.Field())
		fmt.Println(" StructNamespace " + err.StructNamespace())
		fmt.Println(" StructField " + err.StructField())
		fmt.Println(" Tag " + err.Tag())
		fmt.Println(err.ActualTag())
		fmt.Println(err.Kind())
		fmt.Println(err.Type())
		fmt.Println(err.Value())
		fmt.Println(" Param " + err.Param())

		fmt.Println()*/
		fmt.Println(err.Value())
		//stringErrors := fmt.Sprintf("%v", err.Value())
		stringError = "Silahkan isi " + err.Field() + " dengan benar." //+ " " + err.Tag() + " " + err.Param() + ". "
		stringErrors = stringErrors + "" + stringError
		/*Namespace Banks.NmPendek
			Field NmPendek
			StructNamespace Banks.NmPendek
			StructField NmPendek
			Tag max
		    max
		    string
		    string
		    ddddddddddddddddddddrdddrrrrrrrrrrrrrrrrrrrrddddddddddddddddd
			Param 50*/
		//Key: 'Banks.NmPendek' Error:Field validation for 'NmPendek' failed on the 'max' tag
	}

	err = errors.New(stringErrors)

	if err != nil {
		ERROR(w, statusCode, err)
		return
	}
	JSON(w, http.StatusBadRequest, nil)
}
func ERROR_unmarshal(w http.ResponseWriter, statusCode int, err error) {
	string_error := err.Error()

	fmt.Println(string_error)

	//json: cannot unmarshal number into Go struct field Banks.no_rek of type string
	//value masuk
	string_error = strings.Replace(string_error, "json: cannot unmarshal ", "", 1)
	//string_error = strings.ReplaceAll(string_error, "json: cannot unmarshal", "")
	string_error = strings.Replace(string_error, "number into Go struct field", "form", 1)
	string_error = strings.Replace(string_error, "string into Go struct field", "form", 1)
	string_error = strings.Replace(string_error, "bool into Go struct field", "form", 1)
	//value seharusnya
	string_error = strings.Replace(string_error, "of type number", "hanya dapat berisi angka", 1)
	string_error = strings.Replace(string_error, "of type string", "hanya dapat berisi karakter alfanumerik atau alfabet", 1)
	string_error = strings.Replace(string_error, "of type bool", "hanya dapat berisi true dan false", 1)

	err = errors.New(string_error)

	if err != nil {
		ERROR(w, statusCode, err)
		return
	}
	JSON(w, http.StatusBadRequest, nil)
}
