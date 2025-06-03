import java.util.*;
import java.awt.Robot;
import java.awt.event.InputEvent;
import java.awt.AWTException;
float camX = 0, camY = -100, camZ = 0;
float camSpeed = 10;
float camYaw = 0, camPitch = 0;
float mouseSensitivity = 0.01f;
Robot robot = null;
ArrayList<gameObject> objList = new ArrayList<gameObject>();
ArrayList<int[]> tmp = new ArrayList<int[]>();

void setup(){
  fullScreen(P3D);
  frameRate(24); //save your machine
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

   
  if(camY<0){
    if( frameCount%24==0){
      aG++;
      System.out.println("blud");
    }
    camY+=aG;
  }else{
    aG = 0;
    camY=0;
  }
  updateCamera();
  camera(camX, camY, camZ, 
         camX + cos(camYaw) * cos(camPitch), 
         camY + sin(camPitch), 
         camZ + sin(camYaw) * cos(camPitch), 
         0, 1, 0);
      box(1000);
for(gameObject g : objList){
    g.r();
    //g.report();
  }
  drawCameraInfo();
}
void mouseClicked(){
  float distance = 100;
float dx = cos(camYaw) * cos(camPitch);
float dy = sin(camPitch);
float dz = sin(camYaw) * cos(camPitch);
int px = 10*(int)(camX + dx * distance);
int py = 10*(int)(camY + dy * distance);
int pz = 10*(int)(camZ + dz * distance);
tmp.add(new int[]{(int)(px/10), (int)(py/10), (int)(pz)/10});
  objList.add(new gameObject("blud", "blud",new Mesh("blud", tmp)));
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
  fill(255);
  text(info, 20, 20);
  
  hint(ENABLE_DEPTH_TEST);
}

void updateCamera() {
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
    if (key == 'q'){
      camY-=camSpeed;    
    }
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
import java.util.ArrayList;

class Mesh{
  private String id;
  private ArrayList<int[]> points;
  public Mesh(String i){
    id = i;
    points = new ArrayList<int[]>();
  }
  public Mesh(String i, Mesh other){
    id = i;
    points = other.getPoints();
  }
  public Mesh(String i, ArrayList<int[]> pp){
    id = i;
    points = pp;
  }
  void addPoints(int[] p){
      points.add(p);
  }
  String getID(){
    return id;
  }
   ArrayList<int[]> getPoints(){
      return points;
  };
  void cullPoints(Mesh other){ //call on self to remove vertices
    for(int[] p : other.getPoints()){
      if(points.indexOf(p)==-1){
         this.addPoints(p);
       }
    }
  } 
}

class gameObject{
  private String id; 
  private String type;
  private Mesh m1;
  private Mesh c1; //colider mesh
  public gameObject(String i, String t, Mesh m){
    type = t;
    m1 = new Mesh(i + "_MESH", m);
    c1 = new Mesh(i + "_COLLIDER", m);
  }
  Mesh getMesh(){
    return m1;
  }
  void report(){
    System.out.println(id);
    System.out.println(m1.getID()+": ");
    for(int[] p : m1.getPoints()){
      System.out.println("X: " + p[0]+ " Y: " + p[1] + " Z: " + p[2]);
    }
    System.out.println(c1.getID()+": ");
    for(int[] p : c1.getPoints()){
      System.out.println("X: " + p[0]+ " Y: " + p[1] + " Z: " + p[2]);
    }
  }
  String getType(){
    return type;
  }
  Boolean collide(int[] p){
    ArrayList<int[]> cPoints=c1.getPoints();
    if(cPoints.size()==2){
      int[] blt = cPoints.get(0);
      int[] frb = cPoints.get(1);
      int x = p[0]; int y = p[1]; int z = p[2];
      int x1 = blt[0]; int y1 = blt[1]; int z1 = blt[2];
      int x2 = frb[0]; int y2 = blt[1]; int z2 = frb[2];
      if(
        x > x1 && y > y1 && z > z1 &&
        x < x2 && y < y2 && z < z2
      ){
        return true;
      }
    }
    return false;
  }
  void r(){
    render(m1);
  }
}

void render(Mesh m){
      ArrayList<int[]> mPoints=m.getPoints();
      fill(100,0,0);
      beginShape();
     for(int[] i : mPoints){
        vertex(i[0],i[1],i[2]);
      translate(10*i[0]/10,10*i[1]/10,10*i[2]/10);
      box(10);
      translate(10*(-1*i[0])/10,10*-1*i[1]/10,-10*i[2]/10);
      }
      endShape(CLOSE);
}
