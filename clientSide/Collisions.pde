class Collider extends Mesh{
  public Collider(Mesh m){
    super(m.getScale().copy(), m.getPos().copy());
  }
  

  //COLLIDER SET FOR BOX MESHES -- WILL WORK APROXIMATELY FOR OTHER SHAPES
public boolean collide(PVector p) {
  PVector objPos = super.position;
  PVector s = super.scale;
  float W = s.x;
  float H = s.y; 
  float D = s.z;
  
  return (
    p.x > objPos.x - W/2 && p.x < objPos.x + W/2 &&
    p.y > objPos.y - H/2 && p.y < objPos.y + H/2 &&
    p.z > objPos.z - D/2 && p.z < objPos.z + D/2
  );
}

//homegrown pseudo-AABB method -- all coliders are treated like axis-aligned bounding boxes, and you just have to consider if the points being checked is within each projection of the box
}
