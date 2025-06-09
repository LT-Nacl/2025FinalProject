class Collider extends Mesh{
  public Collider(Mesh m){
    super(m.getScale(), m.getPos());
  }
  
  public boolean collide(PVector p){

  
  //COLLIDER SET FOR BOX MESHES -- WILL WORK APROXIMATELY FOR OTHER SHAPES
  PVector s = super.scale;
  float W = s.x;
  float H = s.y;
  float D = s.z;
  PVector pAdj = p.add( super.position.mult(-1)); //center the point around the bounding box
    if(
      pAdj.x < W/2 && pAdj.x > -1*W/2 &&
      pAdj.y < H/2 && pAdj.y > -1*H/2 &&
      pAdj.z < D/2 && pAdj.z > -1*D/2 
    ){
      return true;
    }else{
      return false;
    }
  }
}
