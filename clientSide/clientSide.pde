import processing.net.*;

Client client;
String myID = str((int)random(100000));
JSONArray playersData = new JSONArray();

/*void draw() {
  background(30);
  tick();
  fill(255);
  textSize(14);
  text("My ID: " + myID, 10, 40);
  text("Position: " + camX + ", " + camY + ", " + camZ, 10, 60);
  text("All players:", 10, 90);
  text(playersData.toString(), 10, 110, width - 20, height - 120);

} legacy tick
*/ 

                               
void sendPlayerPosition() {
  if (client == null || !client.active()) return;

  JSONObject playerData = new JSONObject();
  playerData.setString("id", myID);
  playerData.setFloat("x", camX);
  playerData.setFloat("y", camY);
  playerData.setFloat("z", camZ);
  playerData.setInt("level", currentLevel); // Send current level

  client.write(playerData.toString() + "\n");
}
String inputBuffer = "";

void receivePlayersData() {
  while (client.available() > 0) {
    String incoming = client.readString();
    if (incoming == null) continue;
    inputBuffer += incoming;
    println("Received raw data: " + incoming);

    // Check if buffer contains a complete JSONArray
    inputBuffer = inputBuffer.trim();
    if (inputBuffer.startsWith("[") && inputBuffer.endsWith("]")) {
      try {
        JSONArray data = parseJSONArray(inputBuffer);
        if (data != null) {
          playersData = data;
          println("JACKPOT: " + data.toString());
          inputBuffer = ""; // Clear buffer after successful parse
        }
      } catch (Exception e) {
        println("JSON parse error: " + e.getMessage() + " | Buffer: " + inputBuffer);
      }
    }
  }
}

void tick() {
  if (client != null && client.active()) {
    sendPlayerPosition();
    receivePlayersData();
    
    int count = 0;
    for (int i = 0; i < playersData.size(); i++) {
      JSONObject player = playersData.getJSONObject(i);
      if (!player.getString("id").equals(myID)) count++;
    }

    positions = new float[count][4]; // [x, y, z, level]
    int idx = 0;
    for (int i = 0; i < playersData.size(); i++) {
      JSONObject player = playersData.getJSONObject(i);
      String pid = player.getString("id");
      if (!pid.equals(myID)) {
        positions[idx][0] = player.getFloat("x");
        positions[idx][1] = player.getFloat("y");
        positions[idx][2] = player.getFloat("z");
        positions[idx][3] = player.getInt("level"); // Store level
        println("Other player " + pid + ": x=" + positions[idx][0] + ", y=" + positions[idx][1] + ", z=" + positions[idx][2] + ", level=" + positions[idx][3]);
        idx++;
      }
    }
  } else {
    text("Disconnected from server.", 10, 20);
  }
}
