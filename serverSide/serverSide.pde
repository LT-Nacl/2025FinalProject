import processing.net.*;
import java.util.HashMap;

Server server;
HashMap<Client, String> buffers = new HashMap<Client, String>();
ArrayList<Client> allClients = new ArrayList<Client>();
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
    allClients.add(thisClient); // track the client
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
          println("Updated: " + pid + pos);
        }
        buffers.put(thisClient, "");
      } catch (Exception e) {
        buffers.put(thisClient, currentBuffer);
      }
    } else {
      buffers.put(thisClient, currentBuffer);
    }
  }
}


  // Create player list
  JSONArray allPlayers = new JSONArray();
  for (Object o : players.keys()) {
    String pid = (String)o;
    JSONObject player = players.getJSONObject(pid);
    JSONObject withID = new JSONObject();
    withID.setString("id", pid);
    withID.setFloat("x", player.getFloat("x"));
    withID.setFloat("y", player.getFloat("y"));
    withID.setFloat("z", player.getFloat("z"));
    allPlayers.append(withID);
  }

  for (int i = allClients.size() - 1; i >= 0; i--) {
  Client c = allClients.get(i);
  if (c.active()) {
    c.write(allPlayers.toString() + "\n");
  } else {
    allClients.remove(i); // ✅ remove disconnected clients
  }
}

  background(0);
  fill(255);
  text(allPlayers.toString(), 10, 20);
}
