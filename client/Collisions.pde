class Collider extends Mesh{
  public Collider(Mesh m){
    super(m.getScale().copy(), m.getPos().copy());
  }
  

  //COLLIDER SET FOR BOX MESHES -- WILL WORK APROXIMATELY FOR OTHER SHAPES
public boolean collide(PVector p) {
  PVector s = super.scale;
  float W = s.x;
  float H = s.y;
  float D = s.z;

  PVector pAdj = p.copy().sub(super.position);

  return (
    pAdj.x > -W/2 && pAdj.x < W/2 &&
    pAdj.y > -H/2 && pAdj.y < H/2 &&
    pAdj.z > -D/2 && pAdj.z < D/2
  );
}

}
