package main

import (
	"encoding/json"
	"net/http"
	"log"
	"math/rand"
	"time"
	"strings"
	"encoding/base64"
)

type Accounts struct {
	Accounts []Account `json:"accounts"`
}

type Account struct {
	Name string `json:"name"`
}

type Data struct {
	Data AccountRequestId `json:"Data"`
}

type AccountRequestId struct {
	AccountRequestId string `json:"AccountRequestId"`
}

type IntentBindCheckRequest struct {
	IntentId string `json:"intent_id"`
	ClientId string `json:"client_id"`
}

type IntentBindCheckResponse struct {
	IsBound bool `json:"is_bound"`
}

func randomInt(min, max int) int {
	return min + rand.Intn(max-min)
}

func randomString(len int) string {
	bytes := make([]byte, len)
	for i := 0; i < len; i++ {
	    bytes[i] = byte(randomInt(65, 90))
	}
	return string(bytes)
}

func readJson(s string) interface{} {
	b := []byte(s)
	var jsonObj interface{}
	_ = json.Unmarshal(b, &jsonObj)
	return jsonObj
}

func decode_jwt_proc(str_token string) string {
    aaa := strings.Split(str_token,".")
    str_bbb := strings.Replace(aaa[1],"-","+",-1)
    str_ccc := strings.Replace(str_bbb,"_","/",-1)

    llx := len(str_ccc)
    nnx := ((4 - llx % 4) % 4)
    ssx := strings.Repeat("=" , nnx)
    str_ddd := strings.Join([]string{str_ccc,ssx},"")
    ppp, err :=  base64.StdEncoding.DecodeString(str_ddd)
    if err != nil {
		log.Printf("error: ", err)
		return ""
    }

    uEnc := base64.URLEncoding.EncodeToString([]byte(ppp))
    decode, _ := base64.URLEncoding.DecodeString(uEnc)

    return string(decode)
}

var intentIdMap = make(map[string]string)

func accountsHandler(w http.ResponseWriter, r *http.Request) {
	a := Accounts{[]Account{Account{"John"}, Account{"Sary"}}}

	j, err := json.Marshal(a)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json; charset=UTF-8")
	w.Write(j)
}

func accountRequestHandler(w http.ResponseWriter, r *http.Request) {
	h := r.Header.Get("authorization")
	log.Printf("authorization : %s", h)
	log.Printf("parsed jwt = %s", decode_jwt_proc(strings.Replace(h,"DPoP ","",-1)))
	jsonObj := readJson(decode_jwt_proc(strings.Replace(h,"DPoP ","",-1)))
	clientId := jsonObj.(map[string]interface{})["azp"].(string)
	log.Printf("  azp field = %s", clientId)

	intentId := randomString(16)
	log.Printf("generated intentId : %s", intentId)
	a := Data{AccountRequestId{intentId}}

	j, err := json.Marshal(a)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	intentIdMap[intentId] = clientId
	log.Printf("intentId->clientId : %s", intentIdMap[intentId])

	w.Header().Set("Content-Type", "application/json; charset=UTF-8")
	w.Write(j)
}

func intentBindCheckHandler(w http.ResponseWriter, r *http.Request) {
	log.Printf("Incoming request from %s, %s.", r.Host, r.RemoteAddr)

	var intentBindCheckRequest IntentBindCheckRequest
	json.NewDecoder(r.Body).Decode(&intentBindCheckRequest)
	log.Printf("    intent_id : %s", intentBindCheckRequest.IntentId)
	log.Printf("    client_id : %s", intentBindCheckRequest.ClientId)

	response := new(IntentBindCheckResponse)

	v, included := intentIdMap[intentBindCheckRequest.IntentId]
	if !included {
		log.Printf("not included")
		response.IsBound = false
	} else if v != intentBindCheckRequest.ClientId {
		log.Printf("not bound")
		response.IsBound = false
	} else {
		log.Printf("bound")
		response.IsBound = true
	}
	k, err := json.Marshal(response)
	if err != nil {
		log.Printf("Failed to marshal response. err: %v", err)
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	w.Header().Set("Content-Type", "application/json; charset=UTF-8")
	w.Write(k)
}

func main() {
	rand.Seed(time.Now().UnixNano())
	http.HandleFunc("/account-requests", accountRequestHandler)
	http.HandleFunc("/check-intent-client-bound", intentBindCheckHandler)
	http.HandleFunc("/", accountsHandler)
	http.ListenAndServe(":3000", nil)
}
