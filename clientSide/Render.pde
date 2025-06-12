public void render(gameObject o) {
  Mesh m = o.getMesh();
  String t = o.getType();
  color col = color(150);
  
  pushMatrix(); // Save current transformation matrix
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
  
  fill(col);
  box(m.getScale().x, m.getScale().y, m.getScale().z);
  
  
  popMatrix(); // Restore transformation matrix - prevents accumulation
}
