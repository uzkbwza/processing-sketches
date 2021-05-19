QuadTree tree;
import processing.svg.*;

int capacity = 1;
int maxDepth = 7;
int divisions = 4;
float threshold = 10;
int frameInterval = 1;
int frame = 0;
float resolution = 57;
float cursorTrails = 10;
PVector previousPoint;
PImage img;
float prevX = 0;
float prevY = 0;
float padding = 30;

void setup() {
  size(1024, 1024, SVG, "file.svg");
  //size(1024, 1024);
  img = loadImage("me2.jpg");
  img.resize(width, height);
  frameRate(60);
  noLoop();
  
}

void draw() {  
  blendMode(NORMAL);
  background(255);
  QuadTree tree = new QuadTree(capacity, new AABB(0, 0, width, height));
  //tree.Subdivide();
  subdivideRandomly(tree, 70);
  //blendMode(SCREEN);
  tree.Draw();
  println("Done.");
  //--threshold;
  ++frame;
}
