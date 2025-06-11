class gameLogic {
  ArrayList<gameObject> platforms;

  gameLogic() {
    platforms = new ArrayList<gameObject>();
  }

  void generateLevelFromString(String data) {
    platforms.clear();
    String[] entries = data.split("\\|");
    for (String entry : entries) {
      String[] parts = entry.split(":");
      if (parts.length != 2) continue;

      String type = parts[0].trim();
      String[] vectors = parts[1].split(";");
      if (vectors.length != 2) continue;

      PVector pos = parsePVector(vectors[0]);
      PVector scale = parsePVector(vectors[1]);

      platforms.add(new gameObject(type, scale, pos));
    }
  }

  ArrayList<gameObject> getPlatforms() {
    return platforms;
  }

  PVector parsePVector(String s) {
    String[] nums = s.split(",");
    if (nums.length != 3) return new PVector(0, 0, 0);
    return new PVector(float(nums[0]), float(nums[1]), float(nums[2]));
  }
}
