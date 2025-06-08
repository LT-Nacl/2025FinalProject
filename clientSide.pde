import java.util.*;
import java.awt.Robot;



void mouseClicked(){
  float distance = 100;
float dx = cos(camYaw) * cos(camPitch);
float dy = sin(camPitch);
float dz = sin(camYaw) * cos(camPitch);
int px = 10*(int)(camX + dx * distance);
int py = 10*(int)(camY + dy * distance);
int pz = 10*(int)(camZ + dz * distance);
tmp.add(new int[]{(int)(px/10), (int)(py/10), (int)(pz)/10});
  objList.add(new gameObject("blud", "blud",new Mesh("blud", (ArrayList)tmp.clone())));
  tmp.remove(tmp.size()-1);
}


void render(Mesh m){
      ArrayList<int[]> mPoints=m.getPoints();
      fill(100,0,0);
      beginShape();
     for(int[] i : mPoints){
        vertex(i[0],i[1],i[2]);
      pushMatrix();
      translate(10*i[0]/10,10*i[1]/10,10*i[2]/10);
      box(10);
      popMatrix();
      }
      endShape(CLOSE);
}
