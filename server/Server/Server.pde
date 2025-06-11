import processing.net.*;
import processing.data.*;

Server server;
ArrayList<Client> clients = new ArrayList<Client>();

void setup() {
  size(400, 200);
  server = new Server(this, 12345);  // Listen on port 12345
  println("Server started");
}

void draw() {
  // Check for new clients
  Client thisClient = server.available();
  if (thisClient != null) {
    clients.add(thisClient);
    println("New client connected. Total clients: " + clients.size());
  }

  // Check for messages from clients
  for (int i = clients.size() - 1; i >= 0; i--) {
    Client c = clients.get(i);
    if (c.available() > 0) {
      String msg = c.readString();
      if (msg != null) {
        msg = msg.trim();
        println("Received from client " + i + ": " + msg);

        // Try parsing as JSON
        try {
          JSONObject json = parseJSONObject(msg);
          println("Parsed JSON: " + json);
        } catch (Exception e) {
          println("Invalid JSON from client " + i);
        }
      }
    }

    // Remove disconnected clients
    if (!c.active()) {
      clients.remove(i);
      println("Client disconnected. Total clients: " + clients.size());
    }
  }
}

void keyPressed() {
  // Send a JSON message to the first client when any key is pressed
  if (clients.size() > 0) {
    JSONObject json = new JSONObject();
    json.setString("type", "greeting");
    json.setString("message", "Hello from the server!");

    Client target = clients.get(0);  // Change index to target other clients
    target.write(json.toString() + "\n");
    println("Sent to client 0: " + json.toString());
  }
}
