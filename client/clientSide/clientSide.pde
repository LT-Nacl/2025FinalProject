import processing.net.*;

Client client;
String myID = str((int)random(100000));
JSONArray playersData = new JSONArray();

float camX = 0, camY = 0, camZ = 0;

void setup() {
  size(600, 400);
  client = new Client(this, "127.0.0.1", 12345); 

}

void draw() {
  background(30);
  tick();
  fill(255);
  textSize(14);
  text("My ID: " + myID, 10, 40);
  text("Position: " + camX + ", " + camY + ", " + camZ, 10, 60);
  text("All players:", 10, 90);
  text(playersData.toString(), 10, 110, width - 20, height - 120);

}


void updatePlayerPosition() {
  if (keyPressed) {
    if (key == 'a') camX -= 2;
    if (key == 'd') camX += 2;
    if (key == 'w') camZ -= 2;
    if (key == 's') camZ += 2;
    if (key == 'q') camY -= 2;
    if (key == 'e') camY += 2;
  }
}                                        
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
    updatePlayerPosition();
    sendPlayerPosition();
    receivePlayersData();
  } else {
    text("Disconnected from server.", 10, 20);
  }
}
