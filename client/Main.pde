void setup(){
  fullScreen(P3D);
  frameRate(60); //save your machine
  noCursor();     
  
  try {
    robot = new Robot();
  } catch (AWTException e) {
    println("Robot initialization failed: " + e);
  }
  Game game = new Game(100);

char[][][] simpleMap = {
  {
    {'#','#','#','#','#'},
    {' ',' ',' ',' ',' '},
    {'#','#',' ','#','#'},
    {' ',' ',' ',' ',' '},
    {'#','#','#','#','#'}
  },
  {
    {' ',' ',' ',' ',' '},
    {' ',' ',' ',' ',' '},
    {' ',' ',' ',' ',' '},
    {' ',' ',' ',' ',' '},
    {' ',' ',' ',' ',' '}
  },
  {
    {'#','#','#','#','#'},
    {' ',' ',' ',' ',' '},
    {'#','#',' ','#','#'},
    {' ',' ',' ',' ',' '},
    {'#','#','#','#','#'}
  }
};

game.loadMap(simpleMap);
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
      
for(gameObject g : objList){
    render(g);
  
    PVector pos = new PVector(camX, camY, camZ);
    if(camY <= 0 || (g.getType().contains("GROUND")&&g.collide(pos))){
      grounded = true;
    }else{
      grounded = false;
    }
    
    //g.report();
  }
  drawCameraInfo();
}
