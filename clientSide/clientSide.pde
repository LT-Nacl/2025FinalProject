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

  // Send as single line with newline at the end
  client.write(playerData.toString() + "\n");
}

void receivePlayersData() {
  while (client.available() > 0) {
    String line = client.readStringUntil('\n');
    if (line == null) continue;
    line = line.trim();
    if (!line.startsWith("{") && !line.startsWith("[")) continue; // Only process JSON

    try {
      JSONArray data = parseJSONArray(line);
      if (data != null) {
        playersData = data;
        
      }
    } catch (Exception e) {
      println("Invalid JSON from server: {" + e.getMessage() + "}");
    }
  }
}

void tick(){
if (client != null && client.active()) {
    sendPlayerPosition();
    receivePlayersData();
    
    
    int count = 0;
  for (int i = 0; i < playersData.size(); i++) {
    JSONObject player = playersData.getJSONObject(i);
    if (!player.getString("id").equals(myID)) count++;
  }

  positions = new float[count][3];
  int idx = 0;
  for (int i = 0; i < playersData.size(); i++) {
    JSONObject player = playersData.getJSONObject(i);
    if (!player.getString("id").equals(myID)) {
      positions[idx][0] = player.getFloat("x");
      positions[idx][1] = player.getFloat("y");
      positions[idx][2] = player.getFloat("z");
      idx++;
    }
  }

    
    
    
    
  } else {
    text("Disconnected from server.", 10, 20);
  }
}
