
class Renderer{
  
public void render(GameObject o) {
  Mesh m = o.getMesh();
  String t = o.getType();
  color col = color(150);
  
  pushMatrix(); 
  translate(m.getPos().x, m.getPos().y, m.getPos().z);
  noStroke();
  
  if (t.contains("GROUND")) {
    col = color(0, 255, 0);
  } else if (t.contains("DEATH")) {
    col = color(255, 0, 0);
  }
  if (t.contains("GOAL")) {
    col = color(255, 255, 0); 
  }
  if (t.contains("PLAYER")){
    col = color(100,0,100);
  }
  
  fill(col);
  box(m.getScale().x, m.getScale().y, m.getScale().z);
  
  
  popMatrix(); 
}
}
