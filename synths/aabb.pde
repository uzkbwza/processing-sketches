class AABB {
  float x1;
  float y1;
  float x2;
  float y2;
  float w;
  float h;
  
  public AABB(float x, float y, float w, float h) {
    this.x1 = x;
    this.x2 = x + w;
    this.y1 = y;
    this.y2 = y + h;
    this.w = w;
    this.h = h;
  }
  
  public AABB(PVector pos, PVector size) {
    this(pos.x, pos.y, size.x, size.y);
  }
  
  public AABB(float x, float y, PVector size) {
    this(x, y, size.x, size.y);
  }
  
  public AABB(PVector pos, float w, float h) {
    this(pos.x, pos.y, w, h);
  }
  
  public boolean containsPoint(float px, float py) {
    return px > x1
      && py > y1
      && px <= x2
      && py <= y2;
  }  
  
  public boolean containsPoint(PVector point) {
    return this.containsPoint(point.x, point.y);
  }

  
  public boolean overlaps(AABB other) {
    return !(other.x2 <= x1
          || other.x1 >= x2
          || other.y2 <= y1
          || other.y1 >= y2
    );
  } 
}
