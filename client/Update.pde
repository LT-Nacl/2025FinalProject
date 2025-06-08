float vCamX=0;
float vCamZ=0;
void updateCamera() {
  t = millis();
  
  if (keyPressed) {
    if (key == 'w' || keyCode == UP) {  
      vCamX += cos(camYaw);
      vCamZ += sin(camYaw);
    }
    if (key == 's' || keyCode == DOWN) {
      vCamX -= cos(camYaw);
      vCamZ -= sin(camYaw);
    }
    if (key == 'a' || keyCode == LEFT) {
      vCamX -= cos(camYaw + PI / 2);
      vCamZ -= sin(camYaw + PI / 2);
    }
    if (key == 'd' || keyCode == RIGHT) {
      vCamX += cos(camYaw + PI / 2);
      vCamZ += sin(camYaw + PI / 2);
    }
    if (key == 'e'){
      camY+=camSpeed;
    }
    if (key == ' ' && grounded){
      aG-=20;
      camY-=.04f;
      grounded = false;
    }

  }else{
    //slow down naturally.
    if(vCamX!=0){
    vCamX += -.5 * vCamX/abs(vCamX);
    }
    if(vCamZ!=0){
    vCamZ += -.5 * vCamZ/abs(vCamZ);
    }
  }
      vCamX=constrain(vCamX,-1f*camSpeed,camSpeed);
      vCamZ=constrain(vCamZ,-1f*camSpeed,camSpeed);
      camX+=vCamX;
      camZ+=vCamZ;
      aG += grav;
      camY+=aG;
    
   if(camY>=0||grounded){
    aG = 0;
    camY=0;
    grounded = true;
   System.out.println("grounded");
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
  
  fill(255);
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
  fill(255);
  text(info, 20, 20);
  fill(255);
  hint(ENABLE_DEPTH_TEST);
}
