package utils

import (
	"bytes"
	"crypto/rand"
	"encoding/base64"
	"encoding/json"
	"errors"
	"fmt"
	"image"

	//_ "image/gif"
	_ "image/jpeg"
	_ "image/png"
	"io/ioutil"
	"net"
	"net/http"
	"os"
	"strconv"
	"strings"
	"sync"
	"time"

	"github.com/valyala/fasthttp"
	"github.com/zulkiflisaid/coba/configs"
	"golang.org/x/crypto/bcrypt"
)

// Hash is
func Hash(password string) ([]byte, error) {
	return bcrypt.GenerateFromPassword([]byte(password), bcrypt.MinCost)
}

// UploadImageBase64 is
func UploadImageBase64(fileNameBase string, content string) error {

	decode, err := base64.StdEncoding.DecodeString(content)
	if err != nil {
		return err
	}

	file, err := os.Create(fileNameBase)
	if err != nil {
		return err
	}

	defer file.Close()
	_, err = file.Write(decode)
	if err != nil {
		return err
	}

	return err
}

// UploadImageBase64ByFormat is
func UploadImageBase64ByFormat(pathImage, fileName string, content string) (string, error) {
	idx := strings.Index(content, ";base64,")
	if idx < 0 {
		return "", errors.New(`"Invalid image!"`)
	}

	reader := base64.NewDecoder(base64.StdEncoding, strings.NewReader(content[idx+8:]))
	buff := bytes.Buffer{}
	_, err := buff.ReadFrom(reader)
	if err != nil {
		return "", err
	}
	imgCfg, fmt, err := image.DecodeConfig(bytes.NewReader(buff.Bytes()))
	if err != nil {
		return "", err
	}
	if fmt == "jpeg" || fmt == "jpg" || fmt == "png" {

	} else {
		return "", errors.New(`"Invalid image!"`)
	}
	//jika validasi ukuran gambar
	if imgCfg.Width < 100 || imgCfg.Height < 100 {
		return "", errors.New(`"Invalid size image!"`)
	}

	fileNameBase := pathImage + fileName + "." + fmt
	ioutil.WriteFile(fileNameBase, buff.Bytes(), 0644)

	/*file, err := os.Create(fileNameBase)
	if err != nil {
		return "", err
	}
	defer file.Close()
	_, err = io.Copy(file, reader)
	if err != nil {
		return "", err
	}*/

	return fileName + "." + fmt, err

}

// NextRandom is
func NextRandom() string {

	var rand uint32
	var randmu sync.Mutex
	randmu.Lock()
	rr := rand
	if rr == 0 {
		rr = uint32(time.Now().UnixNano() + int64(os.Getpid()))
	}
	rr = rr*1664525 + 1013904223 // constants from Numerical Recipes
	rand = rr
	randmu.Unlock()
	return strconv.Itoa(int(1e9 + rr%1e9))[1:]
}

// RandomUIID is
func RandomUIID(bytenya int, lenReturn int) (string, error) {
	var err error
	b := make([]byte, bytenya)
	_, err = rand.Read(b)
	if err != nil {
		//fmt.Println("Error: ", err)
		return "", err
	}
	uuid := ""
	if lenReturn == 2 {
		uuid = fmt.Sprintf("%X", b[0:lenReturn])
	} else if lenReturn == 4 {
		uuid = fmt.Sprintf("%X", b[0:lenReturn])

	} else if lenReturn == 6 {
		uuid = fmt.Sprintf("%X", b[0:lenReturn])
	} else {
		uuid = fmt.Sprintf("%X", b[0:])
	}
	return uuid, err

}

//DateToString is sebagai prefix kode transaksi
func DateToString() (string, error) {
	var err error
	hariIni := time.Now()
	uuidTgl := hariIni.Format("060102")

	return uuidTgl, err

}

// GetURL is
func GetURL(url string) (resp1 *http.Response, err error) {

	var netTransport = &http.Transport{
		Dial: (&net.Dialer{
			Timeout: 5 * time.Second,
		}).Dial,
		TLSHandshakeTimeout: 5 * time.Second,
	}
	var netClient = &http.Client{
		Timeout:   time.Second * 10,
		Transport: netTransport,
	}

	//fmt.Println(url)
	//req, err := http.NewRequest("GET", url, nil)
	resp, err := netClient.Get(url)
	if err != nil {
		return resp1, err
	}
	return resp, err
}

// PostURL is
func PostURL(url string, byteArray []byte) (resp1 *http.Response, err error) {

	var netTransport = &http.Transport{
		Dial: (&net.Dialer{
			Timeout: 5 * time.Second,
		}).Dial,
		TLSHandshakeTimeout: 5 * time.Second,
	}
	var netClient = &http.Client{
		Timeout:   time.Second * 10,
		Transport: netTransport,
	}
	r, _ := http.NewRequest(http.MethodPost, url, bytes.NewBuffer(byteArray)) // URL-encoded payload
	r.Header.Set("Authorization", "key="+configs.KeyGcmServer())
	r.Header.Set("Content-Type", "application/json")
	//r.Header.Add("Authorization", "auth_token=\"XXXXXXX\"")
	//r.Header.Add("Content-Type", "application/x-www-form-urlencoded")
	//r.Header.Add("Content-Length", strconv.Itoa(len(byteArray)))

	resp, err := netClient.Do(r)
	if err != nil {
		return resp1, err
	}
	defer resp.Body.Close()
	return resp, err
}

// PostURLF is
func PostURLF(url string, v interface{}) ([]byte, error) {
	var err error
	//var strPost = []byte("POST")
	var ress []byte

	byteArray, err := json.Marshal(v)
	if err != nil {
		//responses.JSON(w, http.StatusOK, json.RawMessage(`{"status": true}`))
		return ress, err
	}

	req := fasthttp.AcquireRequest()
	defer fasthttp.ReleaseRequest(req)
	req.SetBody(byteArray)
	req.Header.SetMethodBytes([]byte("POST"))
	req.Header.SetContentType("application/json")
	req.Header.Set("Authorization", "key="+configs.KeyGcmServer())
	//r.Header.Set("Authorization", "key="+configs.KeyGcmServer())
	//	r.Header.Set("Content-Type", "application/json")
	req.SetRequestURIBytes([]byte(configs.URLGcm()))

	res := fasthttp.AcquireResponse()
	if err := fasthttp.Do(req, res); err != nil {
		//	responses.JSON(w, http.StatusOK, json.RawMessage(`{"status": true}`))
		return ress, err

	}
	defer fasthttp.ReleaseResponse(res)
	if res.StatusCode() != fasthttp.StatusOK {
		//fmt.Printf("Expected status code %d but got %d\n", fasthttp.StatusOK, res.StatusCode())
		//responses.JSON(w, http.StatusOK, json.RawMessage(`{"status": true}`))
		return res.Body(), err
	}
	//body1 := res.Body()
	//fmt.Println(json.RawMessage(body1))
	// Do something with body.
	//defer fasthttp.ReleaseResponse(res)
	return res.Body(), err
}

// fasthttpRequest is
func fasthttpRequest() {
	req := fasthttp.AcquireRequest()
	defer fasthttp.ReleaseRequest(req)
	req.SetRequestURI("https://maps.googleapis.com/maps/api/directions/json?mode=driving&key=AIzaSyBTokiA2EScfsUgZeuTcsTdpcrV11qAw8E&origin=-3.464214,%20119.140585&destination=-3.481263,%20119.141014")
	// fasthttp does not automatically request a gzipped response.
	// We must explicitly ask for it.
	req.Header.Set("Accept-Encoding", "gzip")

	resp := fasthttp.AcquireResponse()
	defer fasthttp.ReleaseResponse(resp)

	// Perform the request
	err := fasthttp.Do(req, resp)
	if err != nil {
		fmt.Printf("Client get failed: %s\n", err)
		return
	}
	if resp.StatusCode() != fasthttp.StatusOK {
		fmt.Printf("Expected status code %d but got %d\n", fasthttp.StatusOK, resp.StatusCode())
		return
	}

	// Verify the content type
	contentType := resp.Header.Peek("Content-Type")
	if bytes.Index(contentType, []byte("application/json")) != 0 {
		fmt.Printf("Expected content type application/json but got %s\n", contentType)
		return
	}

	// Do we need to decompress the response?
	contentEncoding := resp.Header.Peek("Content-Encoding")
	var body []byte
	if bytes.EqualFold(contentEncoding, []byte("gzip")) {
		fmt.Println("Unzipping...")
		body, _ = resp.BodyGunzip()
	} else {
		body = resp.Body()
	}

	fmt.Printf("Response body is: %s", body)

	return
}
