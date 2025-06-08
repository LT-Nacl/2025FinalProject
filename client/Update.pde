
void updateCamera() {
  t = millis();
  if (keyPressed) {
    if (key == 'w' || keyCode == UP) {  
      camX += cos(camYaw) * camSpeed;
      camZ += sin(camYaw) * camSpeed;
    }
    if (key == 's' || keyCode == DOWN) {
      camX -= cos(camYaw) * camSpeed;
      camZ -= sin(camYaw) * camSpeed;
    }
    if (key == 'a' || keyCode == LEFT) {
      camX -= cos(camYaw + PI / 2) * camSpeed;
      camZ -= sin(camYaw + PI / 2) * camSpeed;
    }
    if (key == 'd' || keyCode == RIGHT) {
      camX += cos(camYaw + PI / 2) * camSpeed;
      camZ += sin(camYaw + PI / 2) * camSpeed;
    }
    if (key == 'e'){
      camY+=camSpeed;
    }
    if (key == ' ' && grounded){
      if(t-t1>1000){
      aG-=5;
      t1 = millis();
      }
    }
    /*if (key == ' '){
      
      camY-= -1;
      aG -= 3;
      t1 = millis();
      System.out.println("jump");
    }
  }
   */
}
      aG += grav;
      camY+=aG;
  
    
   if(camY>=0 || grounded){
    aG = 0;
    camY=0;
    if(grounded) System.out.println("grounded");
   }

  

  
  float mouseXDelta = mouseX - width / 2;
  float mouseYDelta = mouseY - height / 2;
  camYaw += mouseXDelta * mouseSensitivity;
  camPitch += mouseYDelta * mouseSensitivity;

  camPitch = constrain(camPitch, -PI / 2 + .001f, PI / 2-.001f);
    cursor(CROSS);
  moveMouse(width / 2, height / 2);
}

void moveMouse(int x, int y) {
  robot.mouseMove(x, y);
}

void drawCameraInfo() {
  hint(DISABLE_DEPTH_TEST);
  camera();
  textMode(MODEL);
  
  fill(0);
  textSize(20);
  textAlign(LEFT, TOP);
  
  String info = String.format(
    "Position: (%.1f, %.1f, %.1f)\n" +
    "Yaw: %.1f°\n" +
    "Pitch: %.1f°",
    camX, camY, camZ,
    degrees(camYaw),
    degrees(camPitch)
  );
  fill(0);
  text(info, 20, 20);
  fill(255);
  hint(ENABLE_DEPTH_TEST);
}
