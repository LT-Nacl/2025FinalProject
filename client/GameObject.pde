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
  
  void r(){
    render(m1);
  }
}
