package main

import (
	"bytes"
	"crypto/tls"
	"encoding/json"
	"log"
	"net/http"
	"time"
)

type Accounts struct {
	Accounts []Account `json:"accounts"`
}

type Account struct {
	Name string `json:"name"`
}

type AuthDelegateRequest struct {
	BindingMessage  string `json:"binding_message"`
	LoginHint       string `json:"login_hint"`
	ConsentRequired bool   `json:"is_consent_required"`
	Scope           string `json:"scope"`
	AcrValues       string `json:"acr_values"`
}

type AuthenticationResultNotification struct {
	Status string `json:"status"`
}

func accountsHandler(w http.ResponseWriter, r *http.Request) {
	log.Printf("Incoming request from %s, %s.", r.Host, r.RemoteAddr)

	// receive json and Authorization header for bearer token for token authentication afterwards
	var authDelegateRequest AuthDelegateRequest
	json.NewDecoder(r.Body).Decode(&authDelegateRequest)
	log.Printf("    acr_values : %s", authDelegateRequest.AcrValues)
	log.Printf("    binding_message : %s", authDelegateRequest.BindingMessage)
	log.Printf("    is_consent_required : %t", authDelegateRequest.ConsentRequired)
	log.Printf("    login_hint : %s", authDelegateRequest.LoginHint)
	log.Printf("    scope : %s", authDelegateRequest.Scope)

	bearerToken := r.Header.Get("Authorization")
	log.Printf("Bearer Token on Authorization Header = %s", bearerToken)

	time.AfterFunc(time.Second*30, func() {
		log.Printf("Callback : Outgoing request.")

		u := "https://as.keycloak-fapi.org/auth/realms/test/protocol/openid-connect/ext/ciba/auth/callback/"
		notification := new(AuthenticationResultNotification)
		notification.Status = "SUCCEED"
		//notification.Status = "CANCELLED"
		k, _ := json.Marshal(notification)
		req, _ := http.NewRequest("POST", u, bytes.NewBuffer(k))
		req.Header.Set("Authorization", bearerToken)
		req.Header.Set("Content-Type", "application/json")

		tr := &http.Transport{
			TLSClientConfig: &tls.Config{
				InsecureSkipVerify: true,
				ServerName:         "as.keycloak-fapi.org",
			},
		}
		client := &http.Client{
			Transport: tr,
		}
		res, err := client.Do(req)
		log.Printf("Callback : Incoming response.")
		if err != nil {
			log.Printf("Error :  " + err.Error())
		} else {
			log.Printf("Success : " + res.Status)
		}
		defer res.Body.Close()
	})

	w.WriteHeader(http.StatusCreated)

	log.Printf("Outgoing response.")
}

func main() {
	log.Println("Auth Entity Server booted.")
	http.HandleFunc("/", accountsHandler)
	http.ListenAndServe(":3001", nil)
}
