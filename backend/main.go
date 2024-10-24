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
var broadcast = make(chan struct{
	sender *websocket.Conn
	message []byte
})

type Message struct {
	Name string `json:"username"`
	Text string `json:"text"`
}

func handleConnections(w http.ResponseWriter, r *http.Request) {
  log.Println("Handling Websocket Connection on /backend/socket")
  ws, err := upgrader.Upgrade(w, r, nil)
  if err != nil {
  	log.Printf("Error upgrading to WebSocket: %v", err)
  	return
  }
  defer func() {
  	delete(clients, ws)
  	ws.Close()
  }()

  clients[ws] = true

  for {
	// Read message from the client
	messageType, p, err := ws.ReadMessage()
	if err != nil {
	  log.Printf("Error reading message: %v", err)
	  break // Exit the loop but don't crash the server
	}

	var message Message
	err = json.Unmarshal(p, &message)
	if err != nil {
		log.Printf("Error unmarshalling JSON: %v", err)
		continue // Log the error and continue to the next message
	}

	// Sending message to all clients
	if messageType == websocket.TextMessage {
		broadcast <- struct{
			sender *websocket.Conn
			message []byte
		}{
		sender: ws,
		message: p,
		}
	}
  }
}

func handleMessages() {
	for {
		msg := <-broadcast
		// Send it out to every client that is currently connected
		for client := range clients {
		  if client != msg.sender {
		  
		  
		  log.Printf("Sending: %s", msg.message)
		  err := client.WriteMessage(websocket.TextMessage, msg.message)
		  if err != nil {
			log.Printf("Error sending message: %v", err)
			client.Close()
			delete(clients, client)
			}
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
  log.Fatal(http.ListenAndServe("0.0.0.0:3000", nil))
}