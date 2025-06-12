void setup() {
  fadeTextCount = 360;
  fullScreen(P3D);
  frameRate(60);
  noCursor();
 
levelList = new String[] {
  "GROUND:0,0,0;200,10,200|GROUND:250,-30,0;40,10,40|GOAL:300,-60,0;30,10,30",
  
  "GROUND:0,0,0;200,10,200|GROUND:300,-40,0;30,10,30|GROUND:500,-80,0;30,10,30|GOAL:650,-120,0;30,10,30|DEATH:0,99,0;2000,200,2000",
  
  "GROUND:0,0,0;200,10,200|GROUND:250,-50,50;30,10,30|GROUND:200,-100,100;30,10,30|GROUND:300,-150,50;30,10,30|GROUND:450,-200,0;30,10,30|GOAL:600,-250,0;30,10,30|DEATH:0,74,0;2000,150,2000",
  
  "GROUND:0,0,0;200,10,200|GROUND:300,-60,0;25,10,25|GROUND:500,-120,50;25,10,25|GROUND:600,-180,100;25,10,25|GROUND:500,-240,150;25,10,25|GROUND:300,-300,100;25,10,25|GROUND:200,-360,50;25,10,25|GOAL:100,-420,0;30,10,30|DEATH:0,99,0;800,200,300|DEATH:0,-500,0;2000,100,2000",
  
  "GROUND:0,0,0;200,10,200|GROUND:250,-50,0;20,10,20|GROUND:400,-100,50;20,10,20|GROUND:300,-150,100;20,10,20|GROUND:150,-200,150;20,10,20|GROUND:50,-250,100;20,10,20|GROUND:200,-300,50;20,10,20|GROUND:400,-350,0;20,10,20|GROUND:600,-400,50;20,10,20|GOAL:750,-450,100;30,10,30|DEATH:0,74,0;2000,150,2000|DEATH:0,-500,0;900,100,300|DEATH:800,-200,0;100,600,300"
};

  logic = new GameLogic();
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
  curGround = new GameObject("TEST", new PVector(1, 1, 1), new PVector(1000, 1000, 1000));
  r = new Renderer();
  gameState = STATE_MENU;
}

void draw() {
  if (ipEntryActive) {
    background(0);
    fill(255);
    textSize(32);
    text("Enter Server IP (or press ENTER for offline):", width/4, height/2 - 40);
    text(inputIP, width/4, height/2 + 40);
  } else {
  tick();
  background(100);
  pushMatrix();
  //|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| MENU STATES
  


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


  //|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| CAMERA CALL
  camera(
    camX, camY, camZ,
    camX + cos(camYaw) * cos(camPitch),
    camY + sin(camPitch),
    camZ + sin(camYaw) * cos(camPitch),
    0, 1, 0
    );
  //|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| RENDER CALL
  renderCall();

  tick();
  
}
}
void renderCall(){
  PVector playerPos = new PVector(camX, camY, camZ);
  
 /* if(camY == 0){
    println("GROUNDEATH");
  gameState = STATE_GAMEOVER;                                                                              < THIS IS HOW I MEANT THE GAME TO PLAY BUT IT IS WAAAAAAAY TO HARD
        popMatrix();
    return;
  }*/ 
if(onlineMode){
  for (float[] other : positions) {
    if ((int)other[3] == currentLevel) { 
      objList.add(new GameObject("PLAYERGROUND", new PVector(100,20,100), new PVector(other[0],other[1],other[2])));
    }
  }}
  for (GameObject obj : objList) {
    if(obj.collide(playerPos)){
    if (obj.getType().contains("GOAL")) {
        nextLevel();
        popMatrix();
        return;
    }
    else if (obj.getType().contains("DEATH")) {
        gameState = STATE_GAMEOVER;
        println("DEBUG1");
        popMatrix();
        return;
    }
    else if (obj.getType().contains("GROUND")) {
      

        curGround = obj;
        float groundTop = obj.getMesh().getPos().y - obj.getMesh().getScale().y / 2;


        camY = groundTop-2;

        aG = 0;
        grounded = true;
      println("GOLISION" + obj.getType());
    }
    }
    r.render(obj);
  }

  updateCamera();
  if (!curGround.collide(playerPos.add(new PVector(0, 3, 0)))) { //rayCast 3 units down kinda
    grounded = false;
  }
  
for(int i = 0; i<objList.size();i++){
  if(objList.get(i).getType().contains("PLAYER")){
    objList.remove(i);
    i--;
  }
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

void keyPressed() {
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
  if (ipEntryActive) {
    if (key == ENTER || key == RETURN) {
      ipEntryActive = false;
      if (inputIP.length() > 0) {
        try {
          client = new Client(this, inputIP, 12345);
          onlineMode = true;
          println("Connected to: " + inputIP);
          tick(); // this tick is important -- otherwise the positions array throws a ton of NPEs
        } catch (Exception e) {
          println("Connection failed: " + e);
          onlineMode = false;
        }
      } else {
        onlineMode = false;
        println("Running in offline mode");
      }
    } else if (key == BACKSPACE) {
      if (inputIP.length() > 0) {
        inputIP = inputIP.substring(0, inputIP.length()-1);
      }
    } else if ((key >= '0' && key <= '9') || key == '.') {
      inputIP += key;
    }
  }
}
 
