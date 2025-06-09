class Mesh{
  //MESH FORMAT EXPLANATION---POSITION VECTOR CONTAINS CENTER---SCALE IS W H D
  //default render mode will be a box, but p3d functionality allows custom models
  //optimization can be offloaded to more efficient 3d programs like blender
  private PVector scale;
  private PVector position;
  public Mesh(PVector scale, PVector position){
    this.scale = scale;
    this.position = position;
  }
  public PVector getScale(){
    return scale;
  }
  public PVector getPos(){
    return position;
  }
  
  public void setPos(PVector p){
   position = p;
  }
  
  public void setScale(PVector s){
    scale = s;
  }
}
