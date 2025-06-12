void drawMenu() {
  background(20);
  textAlign(CENTER, CENTER);
  textSize(40);
  fill(255);
  text("THE BEST GAME", width/2, height/2 - 60);
  textSize(20);
  text("Press ENTER to Start", width/2, height/2 + 10);
}

void drawGameOver() {
  background(0);
  textAlign(CENTER, CENTER);
  textSize(40);
  fill(255, 0, 0);
  text("GAME OVER", width/2, height/2 - 60);
  textSize(20);
  fill(255);
  text("Press ENTER to return to Menu", width/2, height/2 + 10);
}

void win() {
  background(0);
  textAlign(CENTER, CENTER);
  textSize(40);
  fill(255, 0, 0);
  text("YOU WIN", width/2, height/2 - 60);
  textSize(20);
  fill(255);
  text("Press ENTER to return to Menu", width/2, height/2 + 10);
}


void resetLevel() {
  grounded = false;

  camX = 0;
  camY = -50;
  camZ = 0;
  aG = 0;

  logic.generateLevelFromString(levelList[currentLevel]);
  objList.clear();
  objList.addAll(logic.getPlatforms());
}

void nextLevel() {
  currentLevel++;
  

  if (currentLevel > levelList.length) {
    gameState = STATE_WIN;
    currentLevel = levelList.length - 1;
    println("Game completed! All levels finished!");
    return;
  }
  

  if (logic != null && levelList != null) {
    logic.generateLevelFromString(levelList[currentLevel]);
    objList = logic.getPlatforms();
    camX = 0; 
    camY = -50;
    camZ = 0;
    aG = 0; 
    grounded = false; 
    fadeTextCount = 360;
    
    println("Advanced to level: " + currentLevel);
    println("Level has " + objList.size() + " objects");
  } 
}
