import java.util.*;
import java.awt.Robot;
import java.awt.event.InputEvent;
import java.awt.AWTException;

int AIR = 0;
int DIRT = 1;
int GRASS = 2;
int STONE = 3;

PImage DIRTt, GRASSt, STONEt;
Chunk myChunk;

float camX = 0, camY = 0, camZ = 30;
float camSpeed = 2;
float camYaw = 0, camPitch = 0;
float mouseSensitivity = 0.01f;
Robot robot = null;

void setup() {
  fullScreen(P3D);  
  noCursor();     
  
  try {
    robot = new Robot();
  } catch (AWTException e) {
    println("Robot initialization failed: " + e);
  }
  
  // Load textures (make sure these files exist in the data folder)
  DIRTt = loadImage("dirt.png");
  GRASSt = loadImage("grass.png");
  STONEt = loadImage("stone.png");
  
  myChunk = generateRandomChunk(0, 0, 0);
}

void draw() {
  background(255);
  updateCamera();
  camera(camX, camY, camZ, 
         camX + cos(camYaw) * cos(camPitch), 
         camY + sin(camPitch), 
         camZ + sin(camYaw) * cos(camPitch), 
         0, 1, 0);
  
  myChunk.update();
  
  drawCameraInfo();
}

void drawCameraInfo() {
  hint(DISABLE_DEPTH_TEST);
  camera();
  textMode(MODEL);
  
  fill(0);
  textSize(20);
  textAlign(LEFT, TOP);
  
  String info = String.format(
    "Position: (%.1f, %.1f, %.1f)\n" +
    "Yaw: %.1f°\n" +
    "Pitch: %.1f°",
    camX, camY, camZ,
    degrees(camYaw),
    degrees(camPitch)
  );
  
  text(info, 20, 20);
  
  hint(ENABLE_DEPTH_TEST);
}

// Rest of your existing code (Block, Chunk, etc.) remains unchanged...

void updateCamera() {
  if (keyPressed) {
    if (key == 'w' || keyCode == UP) {
      camX += cos(camYaw) * camSpeed;
      camZ += sin(camYaw) * camSpeed;
    }
    if (key == 's' || keyCode == DOWN) {
      camX -= cos(camYaw) * camSpeed;
      camZ -= sin(camYaw) * camSpeed;
    }
    if (key == 'a' || keyCode == LEFT) {
      camX -= cos(camYaw + PI / 2) * camSpeed;
      camZ -= sin(camYaw + PI / 2) * camSpeed;
    }
    if (key == 'd' || keyCode == RIGHT) {
      camX += cos(camYaw + PI / 2) * camSpeed;
      camZ += sin(camYaw + PI / 2) * camSpeed;
    }
  }

  
  float mouseXDelta = mouseX - width / 2;
  float mouseYDelta = mouseY - height / 2;
  camYaw += mouseXDelta * mouseSensitivity;
  camPitch += mouseYDelta * mouseSensitivity;

  camPitch = constrain(camPitch, -PI / 2, PI / 2);
  camYaw = constrain(camYaw, -PI, PI);
    cursor(CROSS);
  moveMouse(width / 2, height / 2);
}

void moveMouse(int x, int y) {
  // Adjust the mouse to stay at the center
  robot.mouseMove(x, y);
}

Chunk generateRandomChunk(int x, int y, int z) {
  Random rand = new Random();
  Chunk chunk = new Chunk(x, y, z);
  
  int size = 10; 
  for (int i = 0; i < size; i++) {
    for (int j = 0; j < size; j++) {
      for (int k = 0; k < size; k++) {
        // Randomly choose the block type (0: AIR, 1: DIRT, 2: GRASS, 3: STONE)
        
        int blockType = rand.nextInt(4);  // Random block type between 0 and 3
        System.out.println("BLOCK: "+x+i+", "+ y+j + ", " + z+k);
        Block b = new Block(x + i, y + j, z + k, blockType);
        chunk.addBlock(b);  
      }
    }
  }

  return chunk;
}



class Block {
  private int type = AIR;
  private int[][] vList;

  Block(int x, int y, int z, int t) {
    type = t;
    vList = new int[8][3];
    vList[0] = new int[]{x, y, z};
    vList[1] = new int[]{x + 1, y, z};
    vList[2] = new int[]{x + 1, y + 1, z};
    vList[3] = new int[]{x + 1, y + 1, z + 1};
    vList[4] = new int[]{x, y + 1, z};
    vList[5] = new int[]{x, y + 1, z + 1};
    vList[6] = new int[]{x, y, z + 1};
    vList[7] = new int[]{x + 1, y, z + 1};
  }
  
  Block(int x, int y, int z) {
    vList = new int[8][3];
    vList[0] = new int[]{x, y, z};
    vList[1] = new int[]{x + 1, y, z};
    vList[2] = new int[]{x + 1, y + 1, z};
    vList[3] = new int[]{x + 1, y + 1, z + 1};
    vList[4] = new int[]{x, y + 1, z};
    vList[5] = new int[]{x, y + 1, z + 1};
    vList[6] = new int[]{x, y, z + 1};
    vList[7] = new int[]{x + 1, y, z + 1};
  }
  
  int[][] getVert(){return vList;}
  int getType(){return type;}
  void setType(int t){type = t;}
}

class Chunk{
  int x,y,z;
  private ArrayList<Block> bList = new ArrayList<Block>();
  Chunk(int x1, int y1, int z1){
    x=x1;
    y=y1;
    z=z1;
  }
  void addBlock(Block b){
    bList.add(b);
  }
  ArrayList<Block> getUniqueBlocks() { //check that blocks won't be entirely obscured -- rudimentary optimization
    HashMap<String, Integer> vertCount = new HashMap<String, Integer>(); //mostly the same from python. Thx Mr. DW!

    for (Block b : bList) {
      int[][] verts = b.getVert();
      for (int[] v : verts) {
        String key = v[0] + "," + v[1] + "," + v[2];
        vertCount.put(key, vertCount.getOrDefault(key, 0) + 1);
      }
    }

    ArrayList<Block> result = new ArrayList<Block>();
    for (Block b : bList) {
      int[][] verts = b.getVert();
      for (int[] v : verts) {
        String key = v[0] + "," + v[1] + "," + v[2];
        if (vertCount.get(key) == 1) {
          result.add(b);
          break;
        }
      }
    }

    return result;
  }

  Boolean adj(Block a,Block b){
    return countSharedVerts(a,b) == 4;
  }
  int countSharedVerts(Block a, Block b) {
  int[][] av = a.getVert();
  int[][] bv = b.getVert();
  int count = 0;

  for (int[] va : av) {
    for (int[] vb : bv) {
      if (va[0] == vb[0] && va[1] == vb[1] && va[2] == vb[2]) {
        count++;
      }
    }
  }

  return count;
}

ArrayList<ArrayList<Block>> getContiguousGroups() {
  ArrayList<Block> uniques = getUniqueBlocks();
  ArrayList<ArrayList<Block>> result = new ArrayList<ArrayList<Block>>();
  HashMap<Block, Boolean> visited = new HashMap<Block, Boolean>();

  for (Block b : uniques) {
    if (!visited.containsKey(b)) {
      ArrayList<Block> group = new ArrayList<Block>();
      LinkedList<Block> queue = new LinkedList<Block>();
      int type = b.getType();

      queue.add(b);
      visited.put(b, true);

      while (!queue.isEmpty()) {
        Block current = queue.remove();
        group.add(current);

        for (Block other : uniques) {
          if (!visited.containsKey(other) && other.getType() == type && adj(current, other)) {
            queue.add(other);
            visited.put(other, true);
          }
        }
      }

      result.add(group);
    }
  }

  return result;
}

void update(){
  ArrayList<ArrayList<Block>> meshes = getContiguousGroups();
  for(ArrayList<Block> mesh : meshes){
    if(mesh.get(0).getType()!=0){
    mesh(mesh);
    }
  }
}

void mesh(ArrayList<Block> mesh) {
  if (mesh.isEmpty()) return;

  int type = mesh.get(0).getType();
  PImage tex = null;
  PImage DIRTt = loadImage("dirt.png");
  PImage GRASSt = loadImage("dirt.png");
  PImage STONEt = loadImage("dirt.png");
  if (type == DIRT) tex = DIRTt;
  else if (type == GRASS) tex = GRASSt;
  else if (type == STONE) tex = STONEt;

  PShape shape = createShape();
  shape.beginShape(QUADS);
  shape.texture(tex);

  for (Block b : mesh) {
    int[][] v = b.getVert();

    // Offset all vertices by the chunk's position
    int[][] vo = new int[8][3];
    for (int i = 0; i < 8; i++) {
      vo[i][0] = v[i][0] + x;
      vo[i][1] = v[i][1] + y;
      vo[i][2] = v[i][2] + z;
    }

    boolean posX = false;
    boolean negX = false;
    boolean posY = false;
    boolean negY = false;
    boolean posZ = false;
    boolean negZ = false;

    for (Block other : mesh) {
      if (other == b) continue;
      if (adj(b, other)) {
        int dx = other.getVert()[0][0] - v[0][0];
        int dy = other.getVert()[0][1] - v[0][1];
        int dz = other.getVert()[0][2] - v[0][2];
        if (dx == 1) posX = true;
        if (dx == -1) negX = true;
        if (dy == 1) posY = true;
        if (dy == -1) negY = true;
        if (dz == 1) posZ = true;
        if (dz == -1) negZ = true;
      }
    }

    if (!posX) {
      shape.vertex(vo[1][0], vo[1][1], vo[1][2], 1, 0);
      shape.vertex(vo[2][0], vo[2][1], vo[2][2], 1, 1);
      shape.vertex(vo[3][0], vo[3][1], vo[3][2], 0, 1);
      shape.vertex(vo[7][0], vo[7][1], vo[7][2], 0, 0);
    }

    if (!negX) {
      shape.vertex(vo[0][0], vo[0][1], vo[0][2], 0, 0);
      shape.vertex(vo[6][0], vo[6][1], vo[6][2], 1, 0);
      shape.vertex(vo[5][0], vo[5][1], vo[5][2], 1, 1);
      shape.vertex(vo[4][0], vo[4][1], vo[4][2], 0, 1);
    }

    if (!posY) {
      shape.vertex(vo[4][0], vo[4][1], vo[4][2], 0, 0);
      shape.vertex(vo[5][0], vo[5][1], vo[5][2], 1, 0);
      shape.vertex(vo[3][0], vo[3][1], vo[3][2], 1, 1);
      shape.vertex(vo[2][0], vo[2][1], vo[2][2], 0, 1);
    }

    if (!negY) {
      shape.vertex(vo[0][0], vo[0][1], vo[0][2], 0, 0);
      shape.vertex(vo[1][0], vo[1][1], vo[1][2], 1, 0);
      shape.vertex(vo[7][0], vo[7][1], vo[7][2], 1, 1);
      shape.vertex(vo[6][0], vo[6][1], vo[6][2], 0, 1);
    }

    if (!posZ) {
      shape.vertex(vo[6][0], vo[6][1], vo[6][2], 0, 0);
      shape.vertex(vo[7][0], vo[7][1], vo[7][2], 1, 0);
      shape.vertex(vo[3][0], vo[3][1], vo[3][2], 1, 1);
      shape.vertex(vo[5][0], vo[5][1], vo[5][2], 0, 1);
    }

    if (!negZ) {
      shape.vertex(vo[0][0], vo[0][1], vo[0][2], 0, 0);
      shape.vertex(vo[4][0], vo[4][1], vo[4][2], 1, 0);
      shape.vertex(vo[2][0], vo[2][1], vo[2][2], 1, 1);
      shape.vertex(vo[1][0], vo[1][1], vo[1][2], 0, 1);
    }
  }

  shape.endShape();
  shape(shape);
}

}
