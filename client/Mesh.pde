class Mesh{
  private float[] scale;
  private float[] position;
  public Mesh(float[] scale, float[] position){
    this.scale = scale;
    this.position = position;
  }
  public float[] getScale(){
    return scale;
  }
  public float[] getPos(){
    return position;
  }
  
  public void setPos(float[] p){
    for(int i = 0; i<p.length; i++){
      position[i] = p[i];
    }
  }
}
