class Control {
  AABB frame;
  public Control(AABB frame) {
    this.frame = frame;
  }
  
  public void draw() {
  
  }
}

enum SizeVariation {
    None,
    Random,
    MiddleBig,
    OuterBig,
    Alternating,
}

class Knobs extends Control {
  float baseRadius;
  float sizeVariance;
  SizeVariation sizeVariation;
  float outerPadding;
  float innerPadding;
  int rows;
  int cols;
  float cellHeight;
  float cellWidth;
  float maxRadius;
  boolean horizontal;
  ArrayList<Knob> knobs;
  public class Knob {
    float x;
    float y;
    float size;
    
    public Knob(float x, float y, float size) {
      this.x = x;
      this.y = y;
      this.size = size;
    }
    
    public void draw() {
      circle(x, y, size);
    }
  }
  public Knobs(AABB frame) {
    super(frame);
    outerPadding = random(min(frame.w, frame.h) / 4);
    rows = int(1 + random(min(500, (frame.h - outerPadding*2) / MIN_KNOB_SIZE) - 1));
    cols = int(1 + random(min(500, (frame.w - outerPadding*2) / MIN_KNOB_SIZE) - 1));
    
    cellHeight = (frame.h - outerPadding*2) / rows;
    cellWidth = (frame.w - outerPadding*2) / cols;
    maxRadius = min(cellHeight, cellWidth);
    innerPadding = random(maxRadius * 0.15);
    baseRadius = maxRadius/4 + random(maxRadius/2);
    sizeVariance = random((maxRadius - baseRadius));
    horizontal = frame.w > frame.h;
    
    SizeVariation[] variations = SizeVariation.values();
    sizeVariation = variations[int(random(variations.length))];
    //sizeVariation = SizeVariation.MiddleBig;

    knobs = createKnobs();
  }
  
  private ArrayList<Knob> createKnobs() {
    ArrayList<Knob> knobs = new ArrayList();
    for (int cx=0; cx<cols; cx++) {
      for (int cy=0; cy<rows; cy++) {
        float x = frame.x1 + outerPadding + cellWidth * cx;
        float y = frame.y1 + outerPadding + cellHeight * cy;
        float variance = 0;
        switch (sizeVariation) {
          case Random: 
            variance = random(-sizeVariance, sizeVariance);
            break;
          case MiddleBig:
            //println("here");
            if (horizontal) {
              if (cols % 2 == 1 && cx == cols/2) {
                  variance = sizeVariance;
              } else if (cols % 2 == 0 && (cx == cols/2 || cx == cols/2 - 1)) {
                  variance = sizeVariance;
              }
            } else {
              if (rows % 2 == 1 && cy == rows/2) {
                  variance = sizeVariance;
              } else if (rows % 2 == 0 && (cy == rows/2 || cy == rows/2 - 1)) {
                  variance = sizeVariance;
              }
            }
            break;
          default:
            variance = 0;
        }
        //variance = random(-sizeVariance, sizeVariance);
        Knob knob = new Knob(x + cellWidth/2, y + cellHeight/2, baseRadius + variance - innerPadding);
        knobs.add(knob);
      }
    }
    return knobs;
    
  }
  
  public void draw() {
    for (Knob knob : knobs)
      
      knob.draw();
  }
}
