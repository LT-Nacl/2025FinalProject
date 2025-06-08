void setup(){
  fullScreen(P3D);
  frameRate(60); //save your machine
  noCursor();     
  
  try {
    robot = new Robot();
  } catch (AWTException e) {
    println("Robot initialization failed: " + e);
  }
  }
float aG = 0;
void draw(){
  
  background(0);

   
  
  updateCamera();
  camera(camX, camY, camZ, 
         camX + cos(camYaw) * cos(camPitch), 
         camY + sin(camPitch), 
         camZ + sin(camYaw) * cos(camPitch), 
         0, 1, 0);
         pushMatrix();
      translate(0,600,0);
      
      box(1000);
        popMatrix();
      
for(gameObject g : objList){

    if(camY < -50){
      grounded = true;
    }
    g.r();
    //g.report();
  }
  drawCameraInfo();
}
