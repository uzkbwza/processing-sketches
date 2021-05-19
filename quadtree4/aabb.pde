class AABB {
  int x;
  int y;
  int w;
  int h;
  public AABB(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  public boolean Contains(PVector point) {
    return point.x >= this.x 
      && point.y >= this.y 
      && point.x < this.x + this.w
      && point.y < this.y + this.h;
  }
}
