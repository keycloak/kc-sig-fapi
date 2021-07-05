package main

import (
	"encoding/json"
	"github.com/google/uuid"
	"net/http"
	"time"
)

type Data struct {
	Consent Consent `json:"data"`
}

type Consent struct {
	ID string `json:"consentId"`
	Creation string `json:"creationDateTime"`
	Status string `json:"status"`
	StatusUpdate string `json:"statusUpdateDateTime"`
	Permissions[] string `json:"permissions"`
	Exp string `json:"expirationDateTime"`
	TransactionFrom string `json:"transactionFromDateTime"`
	TransactionTo string `json:"transactionToDateTime"`
	Hypermedia Hypermedia `json:"hypermedia"`
	Meta Meta `json:"meta"`
}

type Hypermedia struct {
	Self string `json:"self"`
	First string `json:"first"`
	Prev string `json:"prev"`
	Next string `json:"next"`
	Last string `json:"last"`
}

type Meta struct {
	Records string `json:"totalRecords"`
	Pages string `json:"totalPages"`
	Date string `json:"requestDateTime"`
}

func consentHandler(w http.ResponseWriter, r *http.Request) {
	var FapiInteractionId string = uuid.New().String()

	var now = time.Now()
	var exp = now.Add(5*time.Minute)

	a := Data{
		Consent {
			ID: "1",
			Creation: now.Format(time.RFC3339),
			Status: "AWAITING_AUTHORISATION",
			StatusUpdate: now.Format(time.RFC3339),
			Permissions: []string {"ACCOUNTS_READ", "ACCOUNTS_OVERDRAFT_LIMITS_READ", "RESOURCES_READ"},
			Exp: exp.Format(time.RFC3339),
			TransactionFrom: now.Format(time.RFC3339),
			TransactionTo: exp.Format(time.RFC3339),
			Hypermedia: Hypermedia {
				Self: "https://api.mockbank.com.br/open-banking/api/v1/resource",
				First: "https://api.mockbank.com.br/open-banking/api/v1/resource",
				Prev: "https://api.mockbank.com.br/open-banking/api/v1/resource",
				Next: "https://api.mockbank.com.br/open-banking/api/v1/resource",
				Last: "https://api.mockbank.com.br/open-banking/api/v1/resource",
			},
			Meta: Meta {
				Records: "1",
				Pages: "1",
				Date: now.Format(time.RFC3339),
			},
		},
	}

	j, err := json.Marshal(a)

	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json; charset=UTF-8")
	w.Header().Set("x-fapi-interaction-id", FapiInteractionId)

	// Change the response depending on the method being requested
	switch r.Method {
		case "POST":
			w.WriteHeader(http.StatusCreated)
			w.Write(j)
		default:
			w.WriteHeader(http.StatusNotFound)
			w.Write([]byte(`{"message": "Can't find method requested"}`))
	}

}

func main() {
	http.HandleFunc("/consents", consentHandler)
	http.ListenAndServe(":3000", nil)
}
