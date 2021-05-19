class QuadTree {
  public AABB boundary;
  public QuadTree NW, NE, SW, SE;
  int capacity;
  ArrayList<PVector> points;
  int depth;
  
  
  public QuadTree(int capacity, AABB boundary, int depth) {
    this.points = new ArrayList();
    this.capacity = capacity;
    this.boundary = boundary;
    this.depth = depth;
  }
  
  public boolean Insert(PVector point) {
    if (!boundary.Contains(point) || points.contains(point)) 
      return false; //<>//
      
    if (!HasChildren() && !IsAtCapacity()) {
      this.points.add(point); //<>//
      return true;  
    }
    Subdivide();
    if (NW.Insert(point)) return true;
    if (NE.Insert(point)) return true;
    if (SW.Insert(point)) return true;
    if (SE.Insert(point)) return true;
    return false;
  }
  
  public void Draw() {
    PVector c = getAverage(boundary.x, boundary.y, boundary.w, boundary.h); //<>//
    //pg.fill(c.x, c.y, c.z);
    stroke(0, 0, 0);
    noFill();
    //pg.noStroke();
    rect(boundary.x, boundary.y, boundary.w, boundary.h);
    for (PVector point : points) {
      //stroke(255, 0, 0);
      //point(point.x, point.y);
    }
    if (HasChildren()) {
      NW.Draw();
      NE.Draw();
      SW.Draw();
      SE.Draw();
    }
  }
  
  private boolean HasChildren() {
    return NW != null;
  }
  
  private boolean IsAtCapacity() {
    return points.size() >= capacity;
  }
  
  public void Subdivide() {
    if (!HasChildren()) {
      NW = new QuadTree(this.capacity, new AABB(boundary.x, boundary.y, boundary.w/2, boundary.h/2), this.depth + 1);
      NE = new QuadTree(this.capacity, new AABB(boundary.x + boundary.w/2, boundary.y, boundary.w/2, boundary.h/2), this.depth + 1);
      SW = new QuadTree(this.capacity, new AABB(boundary.x, boundary.y + boundary.h/2, boundary.w/2, boundary.h/2), this.depth + 1);
      SE = new QuadTree(this.capacity, new AABB(boundary.x + boundary.w/2, boundary.y + boundary.h/2, boundary.w/2, boundary.h/2), this.depth + 1);
      Draw();
    }
  }
}
