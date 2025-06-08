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
