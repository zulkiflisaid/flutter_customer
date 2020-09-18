package tran

//import (
//	"fmt"
//	"net/http"
//)

//func Index1(w http.ResponseWriter, r *http.Request) {
//	fmt.Fprintf(w, "hello\n")
//}

import (
	"encoding/json"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"net/http"
	"os"

	//_ "github.com/go-sql-driver/mysql"

	"github.com/zulkiflisaid/coba/responses"
	"github.com/zulkiflisaid/coba/structs"
	"github.com/zulkiflisaid/coba/utils"
	"gopkg.in/go-playground/validator.v9"
)

//AddImgChat is
func AddImgChat(w http.ResponseWriter, r *http.Request) {

	r.Body = http.MaxBytesReader(w, r.Body, 500*1024) // 500*1024=500kb     2*10241024=2Mb
	body, err := ioutil.ReadAll(r.Body)
	if err != nil {
		responses.ERROR(w, http.StatusBadRequest, err)
		return
	}

	m := structs.ChatImgs{}
	m.ImageName = "upload/chat/200102-D9FF-135223287.jpeg"
	err = json.Unmarshal(body, &m)
	if err != nil {
		responses.ERROR_unmarshal(w, http.StatusBadRequest, err)
		return
	}
	//validasi
	validate := validator.New()
	err = validate.Struct(m)
	if err != nil {
		responses.ERROR_validation(w, http.StatusUnprocessableEntity, err)
		return
	}

	//random uiid
	uuid16Angka, err := utils.RandomUIID(8, 2)
	if err != nil {
		responses.ERROR(w, http.StatusBadRequest, err)
		return
	}
	//random angka
	NextRandom := utils.NextRandom()

	//string prefix tanggal
	dateToString, err := utils.DateToString()
	if err != nil {
		responses.ERROR(w, http.StatusBadRequest, err)
		return
	}

	pathImage := "upload/chat/"
	ImgBukti, err := utils.UploadImageBase64ByFormat(pathImage, dateToString+"-"+uuid16Angka+"-"+NextRandom, "data:image/png;base64,"+m.Base46Img)
	if err != nil {
		responses.ERROR(w, http.StatusUnprocessableEntity, err)
		return
	}
	log.Println(pathImage + ImgBukti)
	responses.JSON(w, http.StatusOK, json.RawMessage(`{"status": true,"imgurl":"`+pathImage+ImgBukti+`"}`))

}

//GetImgChat is
func GetImgChat(w http.ResponseWriter, r *http.Request) {

	imgname := r.URL.Query().Get("imgname")

	m := structs.ChatImgs{}
	m.ImageName = "upload/chat/" + imgname
	m.Base46Img = "YQ=="

	validate := validator.New()
	err := validate.Struct(m)
	if err != nil {
		fmt.Println("1")
		ErrorImageChat(w, r)
		return
	}

	existingImageFile, err := os.Open(m.ImageName)
	if err != nil {
		fmt.Println("33")
		ErrorImageChat(w, r)
		return
	}
	defer existingImageFile.Close()
	//w.Header().Set("Content-Type", "image/png")
	w.Header().Set("Content-Type", "image/jpeg")
	io.Copy(w, existingImageFile)

	return

}

//ErrorImageChat is
func ErrorImageChat(w http.ResponseWriter, r *http.Request) {
	aaaa, err := os.Open("upload/chat/no.png")
	if err != nil {
		w.Header().Set("Content-Type", "image/png")
		return
	}

	defer aaaa.Close()
	w.Header().Set("Content-Type", "image/png") // <-- set the content-type header
	io.Copy(w, aaaa)

	return
}
