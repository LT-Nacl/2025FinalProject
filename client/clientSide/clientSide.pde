import processing.net.*;
import processing.data.*;

Client client;
JSONObject localState;
JSONObject myField;

void setup() {
  client = new Client(this, "127.0.0.1", 12345);
  localState = new JSONObject();
  myField = new JSONObject();
  myField.setString("example", "init");
}

void draw() {
  if (client.available() > 0) {
    String msg = client.readStringUntil('\n');
    if (msg != null) {
      msg = msg.trim();
      if (msg.length() > 0) {
        localState = parseJSONObject(msg);
        String clientDataStr = localState.getString("clientData");
        myField = parseJSONObject(clientDataStr);
      }
    }
  }

  println("Local State: " + localState.toString());
  println("My Field: " + myField.toString());

  if (frameCount % 300 == 0) {
    demoUpdate();
  }
}

void demoUpdate() {
  myField.setString("example", str(millis()));
  client.write(myField.toString() + "\n");
}
