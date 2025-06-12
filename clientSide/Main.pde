void setup() {
  fadeTextCount = 360;
  fullScreen(P3D);
  frameRate(60); //save your machine
  noCursor();
  client = new Client(this, "192.168.86.36", 12345);
  logic = new gameLogic();
  levelList = new String[] {
    // Level 0: Basic platform
    "GROUND:0,0,0;100,10,100|GOAL:0,-20,150;30,10,30|DEATH:0,200,0;500,10,500",

    // Level 1: Simple stairs
    "GROUND:0,0,0;100,10,100|GROUND:0,-10,50;100,10,100|GOAL:0,-20,100;30,10,30|DEATH:0,200,0;500,10,500",

    // Level 2: Floating goal
    "GROUND:0,0,0;100,10,100|GOAL:0,-50,200;30,10,30|DEATH:0,200,0;500,10,500"
  };


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
  background(100);
  pushMatrix();
  tick();
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
      println("Rendering other player at: x=" + other[0] + ", y=" + other[1] + ", z=" + other[2] + ", level=" + other[3]);
    }
  }
  for (gameObject obj : objList) {
    if (obj.getType().contains("GOAL") && obj.collide(playerPos)) {
      nextLevel();
      popMatrix();
      return;
    }
    if (obj.getType().contains("DEATH")) {

      if (obj.collide(playerPos)) {
        gameState = STATE_GAMEOVER;
        popMatrix();
        return;
      }
    }
    if (obj.getType().contains("GROUND")) {
      if (obj.collide(playerPos)) {

        curGround = obj;
        float groundTop = obj.getMesh().getPos().y - obj.getMesh().getScale().y / 2;


        camY = groundTop-2;

        aG = 0;
        grounded = true;
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
  popMatrix();
}
