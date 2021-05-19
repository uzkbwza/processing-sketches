class FlowField {
  float[][] field;
  
  FlowField(int w, int h, float init) {
    field = new float[h][w];
    for (int y=0; y<h; y++) {
      for (int x=0; x<w; x++) {
        field[y][x] = init;
      }
    }
  }
  
  public float get(int x, int y) {
    return field[y][x];
  }
  
  public void set(int x, int y, float val) {
    field[y][x] = val;

  }
}
