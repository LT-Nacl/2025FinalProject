boolean DEVMODE = false; // draw colliders


  public void render(gameObject o){
    Mesh m = o.getMesh();
    Mesh c = o.getCollider();
    String t = o.getType();
    color col = color(0);
    pushMatrix();
      translate(m.getPos().x,m.getPos().y,m.getPos().z);
      noStroke();
      if(t.contains("GROUND")){
        col = color(0,255,0);
      }  
      fill(col);
      box(m.getScale().x, m.getScale().y, m.getScale().z);
      if(DEVMODE){
         col = color(255,255,0);
         fill(col);
         box(c.getScale().x, c.getScale().y, c.getScale().z);
      }
    popMatrix();
  }
