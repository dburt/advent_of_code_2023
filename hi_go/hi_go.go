package main

import (
	"encoding/json"
	"fmt"
	"net/http"
)

type Joke struct {
    ID     string `json:"id"`
    Joke   string `json:"joke"`
    Status int    `json:"status"`
}

func fetchDadJoke() (*Joke, error) {
	// assemble request
	req, err := http.NewRequest("GET", "https://icanhazdadjoke.com", nil)
	if err != nil {
		fmt.Println("fetchDadJoke: http.NewRequest failed: ", err)
		return nil, err
	}
	req.Header.Add("Accept", "application/json")
	req.Header.Add("Content-Type", "application/json")

	// make request
	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		fmt.Println("fetchDadJoke: client.Do failed: ", err)
		return nil, err
	}
	defer resp.Body.Close()

	// parse json
	var joke Joke
	if err := json.NewDecoder(resp.Body).Decode(&joke); err != nil {
		fmt.Println("fetchDadJoke: jsonDecoder.Decode failed: ", err)
		return &joke, err
	}

	return &joke, nil
}

func main() {
	fmt.Println("Hello, world!")
	joke, err := fetchDadJoke()
	if err != nil {
		fmt.Println("main: fetchDadJoke failed", err)
	}
	fmt.Println(joke.Joke)
}
