class GameObject{
 private Mesh m;
 private Mesh c;
 private String TYPE;
 
 public GameObject(String T, PVector S, PVector P){
   TYPE = T;
   
   
   //type can have unordered number of tags, tags are checked for presence
   m = new Mesh(S,P);
   c = new Collider(m);
 }
 
 Mesh getMesh(){
   return m;
 }
 
 Mesh getCollider(){
   return c; 
 }
 
 boolean collide(PVector p){
   return ((Collider)c).collide(p);
 }
 String getType(){
   return TYPE;
 }
}
