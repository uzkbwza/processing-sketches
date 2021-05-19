class QuadTree<V> {
  public AABB boundary;
  public QuadTree NW, NE, SW, SE;
  int capacity;
  ArrayList<PointValue> points;
  int depth = 0;
  
  private class PointValue<V> {
    PVector point;
    V value;
    
    PointValue(PVector point, V value) {
      this.point = point;
      this.value = value;
    }
  } //<>//
  
  public QuadTree(int capacity, AABB boundary) {
    this.points = new ArrayList();
    this.capacity = capacity;
    this.boundary = boundary;
  }
  
  public boolean Insert(PVector point, V value) {
    if (!boundary.Contains(point) || points.contains(point)) 
      return false;
      
    if (!HasChildren() && !IsAtCapacity()) {
      this.points.add(new PointValue(point, value)); //<>//
      return true;  
    }
    if (Subdivide()) {
      if (NW.Insert(point, value)) return true;
      if (NE.Insert(point, value)) return true;
      if (SW.Insert(point, value)) return true;
      if (SE.Insert(point, value)) return true;
    }
    return false;
  }
  
  public void Draw() {
    //PVector c = getAverage(boundary.x, boundary.y, boundary.w, boundary.h); //<>//
    //pg.fill(c.x, c.y, c.z);

    //pg.noFill();
    if (!HasChildren()) {
      float c = quantize(getAverageBrightness(boundary.x, boundary.y, boundary.w, boundary.h), divisions, 255);
      //pg.fill(c * 255);
      //pg.rect(boundary.x, boundary.y, boundary.w, boundary.h);
      //pg.fill(255, 255, 255, 105);
      //pg.rect(boundary.x, boundary.y, boundary.w, boundary.h);
      hatch(boundary,  c * divisions);
      //pg.stroke(0, 0, 0);
      //strokeWeight(0.5);
      //hatch(boundary, c);
    }
    
    for (PointValue p : points) {
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
  
  public boolean Subdivide() {
    if (!HasChildren() && depth < maxDepth) {
      NW = new QuadTree(this.capacity, new AABB(boundary.x, boundary.y, boundary.w/2, boundary.h/2));
      NE = new QuadTree(this.capacity, new AABB(boundary.x + boundary.w/2, boundary.y, boundary.w/2, boundary.h/2));
      SW = new QuadTree(this.capacity, new AABB(boundary.x, boundary.y + boundary.h/2, boundary.w/2, boundary.h/2));
      SE = new QuadTree(this.capacity, new AABB(boundary.x + boundary.w/2, boundary.y + boundary.h/2, boundary.w/2, boundary.h/2));
      NW.depth = this.depth + 1;
      NE.depth = this.depth + 1;
      SW.depth = this.depth + 1;
      SE.depth = this.depth + 1;
      //Draw();
      return true;
    }
    return false;
  }
}
