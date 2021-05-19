QuadTree tree;
import processing.svg.*;

int capacity = 1;
float threshold = 260;
float thresholdIncrease = 0.6505250;
int maxDepth = 7;
int minDepth = 1;
int frameInterval = 1;
int frame = 0;
float resolution = 10;
float cursorTrails = 10;
PVector previousPoint;
PImage img;
float prevX = 0;
float prevY = 0;
float subdivideChance = 0.90;

void setup() {
  size(1280, 1280);
  beginRecord(SVG, "filename.svg");
  img = loadImage("0018751759_20.jpg");
  img.resize(width, height);
  img.loadPixels();
  frameRate(60);
  noLoop();
  strokeWeight(2);
}
 //<>//
void draw() {
  background(255);
  
  QuadTree tree = new QuadTree(capacity, new AABB(0, 0, width, height), 0);
  subdivideBrightnesses(tree);
  tree.Draw();
  
  if (mousePressed) {
    if (prevX == 0 && prevY == 0) {
      prevX = mouseX;
      prevY = mouseY;
    }
    
    for (int i=0; i<resolution; i++) {
      tree.Insert(new PVector(lerp(prevX, mouseX, i/resolution), lerp(prevY, mouseY, i/resolution)));
    }
    
    ////noStroke();
    //stroke(128, 200, 255);
    //noFill();
    //strokeWeight(1);
    //fill(50);
    
    for (int i=0; i<cursorTrails; i++) {
      circle(lerp(prevX, mouseX, i/cursorTrails), lerp(prevY, mouseY, i/cursorTrails), 10 + 10 * i/cursorTrails);
    }
    
    prevX = mouseX;
    prevY = mouseY;


    stroke(255, 0, 0);
    
    circle(mouseX, mouseY, 20);
  } else {
    prevX = 0;
    prevY = 0;
  }
  println("done");
  endRecord();
}

void subdivideAverages(QuadTree t) {
  if (t.HasChildren()) return;
  
  AABB range = new AABB(t.boundary.x, t.boundary.y, t.boundary.w, t.boundary.h);
  PVector average = getAverage(range.x, range.y, range.w, range.h);
  float variation = distFromAverage(range.x, range.y, range.w, range.h, average);
  if (variation > threshold) {
    t.Subdivide();
    subdivideAverages(t.NW);
    subdivideAverages(t.NE);
    subdivideAverages(t.SW);
    subdivideAverages(t.SE);
  }
}

void subdivideBrightnesses(QuadTree t) {
  if (t.HasChildren()) return;
  
  AABB range = new AABB(t.boundary.x, t.boundary.y, t.boundary.w, t.boundary.h);
  float brightness = getAverageBrightness(range.x, range.y, range.w, range.h);
  if ((brightness < threshold * (pow(thresholdIncrease, t.depth)) || t.depth < minDepth) && !(t.depth > maxDepth) && random(1) < subdivideChance) {
    t.Subdivide();
    subdivideBrightnesses(t.NW);
    subdivideBrightnesses(t.NE);
    subdivideBrightnesses(t.SW);
    subdivideBrightnesses(t.SE);
  }
}

PVector getAverage(int img_x, int img_y, int cell_w, int cell_h) {
  PVector sum = new PVector(0, 0, 0);
  for (int x=0; x<cell_w; x++) {
    for (int y=0; y<cell_h; y++) {
      int loc = (img_x + x) + (img_y + y) * img.width;
      color pixel = img.pixels[loc];
      sum.add(new PVector(
        red(pixel),
        green(pixel),
        blue(pixel))
      );
    }
  }
  sum.div(cell_w * cell_h);
  return sum;
}

float getAverageBrightness(int img_x, int img_y, int cell_w, int cell_h) {
  float sum = 0;
  for (int x=0; x<cell_w; x++) {
    for (int y=0; y<cell_h; y++) {
      int loc = (img_x + x) + (img_y + y) * img.width;
      color pixel = img.pixels[loc];
      sum += brightness(pixel);
    }
  }
  sum /= (cell_w * cell_h);
  return sum;
}

float distFromAverage(int img_x, int img_y, int cell_w, int cell_h, PVector avg) {
  float sum = 0;
  for (int x=0; x<cell_w; x++) {
    for (int y=0; y<cell_h; y++) {
      int loc = (img_x + x) + (img_y + y) * img.width;
      color pixel = img.pixels[loc];
      PVector pix = (new PVector(
        red(pixel),
        green(pixel),
        blue(pixel))
      );
      sum += avg.dist(pix);
    }
  }
  return sum / (cell_w * cell_h);
} //<>//
