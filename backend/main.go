package main

import (
  "fmt"
  "log"
  "net/http"
  "encoding/json"
  "github.com/gorilla/websocket"
)

var upgrader = websocket.Upgrader{
	CheckOrigin: func(r *http.Request) bool {
		return true
	},
}

var clients = make(map[*websocket.Conn]bool)
var broadcast = make(chan [] byte)

type Message struct {
	Name string `json:"username"`
	Text string `json:"text"`
}

func handleConnections(w http.ResponseWriter, r *http.Request) {
  ws, err := upgrader.Upgrade(w, r , nil)
  if err != nil {
  	log.Fatal(err)
  }
  defer ws.Close()

  clients[ws] = true

  for {
	 //Read message from the client
	 messageType, p , err := ws.ReadMessage()
	 if err != nil {
	 	log.Fatal(err)
	 }

	 var message Message
	 err_2 := json.Unmarshal(p, &message)
	if err_2 != nil {
		log.Printf("Error in unrmashalling JSON")
		log.Fatal(err_2)
	}
	//Sending message to all clients
	if (messageType == websocket.TextMessage) {
		broadcast <- p
		}
	}
}

func handleMessages() {
	for {
		msg := <-broadcast
		//Send it out to every client that is currently connected
		for client := range clients{
		  log.Printf("Sending %s",msg)
		  msg, _ := json.Marshal(msg)
		  err := client.WriteMessage(websocket.TextMessage, msg)
		  if err != nil {
		  	log.Printf("error: %v", err)
			client.Close()
			delete(clients,client)
		  }
		}
	}
}

func main() {
  http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
  	fmt.Fprintf(w, "Chat Backend started and running")})

  go handleMessages()
  http.HandleFunc("/backend/socket", handleConnections)
  fmt.Println("WebSocket server started at ws://localhost:3000/ws")
  fmt.Println(http.ListenAndServe("0.0.0.0:3000", nil))
}
