import processing.net.*;
import java.util.HashMap;

Server server;
HashMap<Client, String> buffers = new HashMap<Client, String>();
JSONObject players = new JSONObject();

void setup() {
  size(400, 400);
  server = new Server(this, 12345);
  println("Server started on port 12345");
}

void draw() {
  Client thisClient = server.available();
  if (thisClient != null) {
    if (!buffers.containsKey(thisClient)) {
      buffers.put(thisClient, "");
    }

    String incoming = thisClient.readString();
    if (incoming != null) {
      incoming = incoming.trim();
      String currentBuffer = buffers.get(thisClient) + incoming;

      if (currentBuffer.startsWith("{") && currentBuffer.endsWith("}")) {
        try {
          JSONObject data = parseJSONObject(currentBuffer);
          if (data != null) {
            String pid = data.getString("id");
            JSONObject pos = new JSONObject();
            pos.setFloat("x", data.getFloat("x"));
            pos.setFloat("y", data.getFloat("y"));
            pos.setFloat("z", data.getFloat("z"));
            players.setJSONObject(pid, pos);
            println("Updated: " + pid + " → " + pos);
          }
          buffers.put(thisClient, "");
        } catch (Exception e) {
          // Ignore JSON error
          buffers.put(thisClient, currentBuffer);
        }
      } else {
        buffers.put(thisClient, currentBuffer);
      }
    }
  }

  background(0);
  fill(255);
  text(players.toString(), 10, 20);
}
