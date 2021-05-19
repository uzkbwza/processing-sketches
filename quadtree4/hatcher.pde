float squareSize = 4;
float numLines = 1;
float offset = 5;

void hatch(AABB boundary, float density) {
  density = divisions - density;
  float x1_ = boundary.x;
  float y1_ = boundary.y;
  float w_ = boundary.w;
  float h_ = boundary.h;
  float x2_ = x1_ + w_;
  float y2_ = y1_ + h_;
  float across = w_ / squareSize;
  float down = h_ / squareSize;
  //println(down);
  strokeWeight(1.8);
  noFill();
  for (float cx = 0; cx < across; cx++) {
    for (float cy = 0; cy < down; cy++) {
      float x1 = x1_ + cx * squareSize;
      float y1 = y1_ + cy * squareSize;
      
      float w = squareSize;
      float h = squareSize;
      float y2 = y1 + h;
      float x2 = x1 + w;
      
      color c1 = color(0,0, 0);
      color c2 = color(0,0, 0);
      if (density >= 3) {
        for(float x=x1; x<x1+w; x+=squareSize/numLines) {
          stroke(c1);
          line(x, y1, x, y2);
        }
        for(float y=y1; y<y1+h; y+=squareSize/numLines) {
          stroke(c2);
          line(x1, y, x2, y);
        }
        
      } else if (density >= 2) {
        for(float y=y1; y<y1+h; y+=squareSize/numLines) {
          stroke(c1);
          line(x1, y, x2, y);
        }
      } else if (density >= 1) {
        for(float x=x1; x<x1+w; x+=squareSize/numLines) {
          stroke(c2);
          line(x, y1, x, y2);
        }
      }
    }
  }

}
