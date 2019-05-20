package main

import (
	"encoding/json"
	"net/http"
)

type Accounts struct {
	Accounts []Account `json:"accounts"`
}

type Account struct {
	Name string `json:"name"`
}

func accountsHandler(w http.ResponseWriter, r *http.Request) {
	a := Accounts{[]Account{Account{"John"}, Account{"Sary"}}}

	j, err := json.Marshal(a)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.Write(j)
}

func main() {
	http.HandleFunc("/accounts", accountsHandler)
	http.ListenAndServe(":3000", nil)
}
