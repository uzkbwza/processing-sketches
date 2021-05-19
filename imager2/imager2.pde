import processing.svg.*;
import java.util.function.Function;

PImage img;

int divisions = 50;
float t = 0;
ArrayList<ArrayList<Float>> imageValues;
int cell_w;
int cell_h;

void setup() {
  size(1200, 1200, SVG, "file.svg");
  
  img = loadImage("me.jpg");
  img.resize(1200, 1200);
  cell_w = img.width / divisions;
  cell_h = img.height / divisions;
}

void draw() {
  t += 0.1;
  background(255);
  noLoop();
  //image(img, 0, 0);
  noStroke();
  img.loadPixels();
  for (int cx=0; cx<divisions; cx++) {
    for (int cy=0; cy<divisions; cy++) {
      float shade = getAverage(cx, cy);
      fill(shade);
      //rect(cx * cell_w, cy * cell_h, cell_w, cell_h);
      float density = shade / 255.0;
      drawSymbol(cx, cy, density);
    }
  }
}

float getAverage(int cell_x, int cell_y) {
  int img_x = cell_x * cell_w;
  int img_y = cell_y * cell_h;
  float sum = 0;
    
  for (int x=0; x<cell_w; x++) {
    for (int y=0; y<cell_h; y++) {
      int loc = (img_x + x) + (img_y + y) * img.width;
      sum += brightness(img.pixels[loc]);
    }
  }
  return sum / (cell_w * cell_h);
}

void drawSymbol(int cell_x, int cell_y, float density) {
  //density = map(density, 0, 1, 1, 10);
  density = 1 - density;
  if (density < 0.1) return;
  density = map(density, 0.1, 1, 0, 1);
  noFill();
  stroke(0);
  strokeWeight(3);
  int canvas_x = cell_x * cell_w;
  int canvas_y = cell_y * cell_h;
  
  pushMatrix();
  translate(canvas_x + cell_w/2, canvas_y + cell_h/2);
  rotate(density * sin((float)cell_y / divisions) * TAU);
  arc(0, 0, cell_w, cell_h, 0, (PI + HALF_PI) * density); 
  popMatrix();
}
