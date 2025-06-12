void setup() {
  fadeTextCount = 360;
  fullScreen(P3D);
  frameRate(60); //save your machine
  noCursor();
 
levelList = new String[] {

  "GROUND:0,0,0;200,10,200|" +
  "GROUND:300,0,0;150,10,150|" +
  "GOAL:300,-15,0;30,10,30|",
  
  "GROUND:0,0,0;500,60,500|" +
  "GROUND:800,-150,0;250,40,250|" +
  "GROUND:400,-300,800;200,40,200|" +
  "GROUND:1200,-450,400;180,40,180|" +
  "GROUND:600,-600,1200;160,40,160|" +
  "GOAL:600,-650,1200;60,20,60|" +
  "DEATH:0,400,0;2000,100,2000"
};

 client = new Client(this, "192.168.86.36", 12345);
  logic = new gameLogic();
  logic.generateLevelFromString(levelList[currentLevel]);
  objList = logic.getPlatforms();


  try {
    robot = new Robot();
  }
  catch (AWTException e) {
    println("Robot initialization failed: " + e);
  }
  perspective(PI/3.0, float(width)/float(height), 1, 10000);
  //render fix!!!
  curGround = new gameObject("TEST", new PVector(1, 1, 1), new PVector(1000, 1000, 1000));
}

void draw() {
  tick();
  background(100);
  pushMatrix();
  
  if (gameState == STATE_MENU && key == ENTER) {
    gameState = STATE_PLAYING;
    camX = 0;
    camY = -50;
    camZ = 0;
    aG = 0;
  }
  if (gameState == STATE_GAMEOVER && key == ENTER) {
    gameState = STATE_MENU;
  }
  if (gameState == STATE_WIN && key == ENTER) {
    gameState = STATE_MENU;
  }


  if (gameState == STATE_MENU) {
    drawMenu();
    popMatrix();
    return;
  }
  if (gameState == STATE_WIN) {
    win();
    popMatrix();
    return;
  }

  if (gameState == STATE_GAMEOVER) {
    drawGameOver();
    popMatrix();
    return;
  }



  camera(
    camX, camY, camZ,
    camX + cos(camYaw) * cos(camPitch),
    camY + sin(camPitch),
    camZ + sin(camYaw) * cos(camPitch),
    0, 1, 0
    );

  PVector playerPos = new PVector(camX, camY, camZ);
  //BIG LOAD LOOP
  //ALL EYES HERE \/
  for (float[] other : positions) {
    if ((int)other[3] == currentLevel) { // Check level
      pushMatrix();
      translate(other[0], other[1], other[2]);
      fill(255, 0, 0); // Red for other players
      box(5);
      popMatrix();
    }
  }
  for (gameObject obj : objList) {
    if(obj.collide(playerPos)){
    if (obj.getType().contains("GOAL")  ) {
      nextLevel();
      popMatrix();
    return;
   }
    if (obj.getType().contains("DEATH")) {
       
        gameState = STATE_GAMEOVER;
        popMatrix();
    return;
   }
    if (obj.getType().contains("GROUND")) {
      

        curGround = obj;
        float groundTop = obj.getMesh().getPos().y - obj.getMesh().getScale().y / 2;


        camY = groundTop-2;

        aG = 0;
        grounded = true;
      println("GOLISION" + obj.getType());
    }
    }
    render(obj);
  }
  //BIG LOAD LOOP
  //ALL EYES HERE /\
  updateCamera();
  if (!curGround.collide(playerPos.add(new PVector(0, 3, 0)))) { //rayCast 3 units down kinda
    grounded = false;
    // System.out.println(curGround.getType());
  }
  drawCameraInfo();
  if (fadeTextCount>0) {
    textAlign(CENTER, CENTER);
    textSize(40);
    fill(255);
    hint(DISABLE_DEPTH_TEST);
    text("Level: " + currentLevel, width/2, height/2 - 60);
    fadeTextCount--;
    hint(ENABLE_DEPTH_TEST);
  }
  tick();
  popMatrix();
}
