package main

import (
	"encoding/json"
	"flag"
	"io/ioutil"
	"log"
	"net/http"
	"strings"
)

type JWKS struct {
	Keys []json.RawMessage `json:"keys"`
}

func createJWKS(dir string) ([]json.RawMessage, error) {
	files, err := ioutil.ReadDir(dir)
	if err != nil {
		panic(err)
	}

	jwks := []json.RawMessage{}

	for _, file := range files {
		n := file.Name()
		if !file.IsDir() && strings.HasPrefix(n, "jwk_") && strings.HasSuffix(n, "-pub.json") {
			log.Printf("Read jwk: %s", n)
			b, err := ioutil.ReadFile(dir + "/" + n)
			if err != nil {
				return nil, err
			}
			jwks = append(jwks, b)
		}
	}

	return jwks, nil
}

func jwksHandler(w http.ResponseWriter, r *http.Request) {
	jwks := JWKS{Keys: keys}
	j, err := json.Marshal(jwks)
	if err != nil {
		log.Printf("Failed to marshal jwks. err: %v", err)
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json; charset=UTF-8")
	w.Write(j)
}

var keys []json.RawMessage

func main() {
	flag.Parse()
	dir := flag.Arg(0)
	if dir == "" {
		log.Fatalf("Need directory path.")
	}

	var err error
	keys, err = createJWKS(dir)
	if err != nil {
		log.Fatalf("Failed to setup jwks. err: %v", err)
	}

	http.HandleFunc("/", jwksHandler)
	http.ListenAndServe(":3000", nil)
}
