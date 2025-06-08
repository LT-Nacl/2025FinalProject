class Game {
  int blockSize;
  Game(int blockSize) {
    this.blockSize = blockSize;
  }

  void loadMap(char[][][] map) {
    objList.clear();
    for (int x = 0; x < map.length; x++) {
      for (int y = 0; y < map[0].length; y++) {
        for (int z = 0; z < map[0][0].length; z++) {
          if (map[x][y][z] != ' ') {
            int[] pos = {
              x * blockSize,
              y * blockSize,
              z * blockSize
            };
            objList.add(new gameObject(pos));
          }
        }
      }
    }
  }
}
