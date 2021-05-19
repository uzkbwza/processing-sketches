import processing.svg.*;

FlowField field;

int w = 720;
int h = 720;
int num_flow = 400; 
float step_length = 4;
int num_steps = 400;
float noiseScale = 0.005;
float margin = 10;

void setup() {
  size(720, 720);
  //noiseDetail(42, 0.50);
  field = new FlowField(w, h, 0);
  for (int x=0; x<w; x++) {
    for (int y=0; y<h; y++) {
      //float angle = (x / (float)w) * PI;
      field.set(x, y, noise(x * noiseScale, y * noiseScale));
      //println(field.get(x,y));
    }
  }
  noLoop();
  //println(field.get(0, 0));
  beginRecord(SVG, "file.svg");
}

float quantize(float val, float interval) {
  return interval * ceil(val / interval);
}

void draw() {
  background(255);
  stroke(0);
  noFill();
  strokeWeight(5);
  
  for (int i=0; i<num_flow / 2; i++) {
    //if (i % 2 == 0) 
      //stroke(127);
    //else
      //stroke(0);
    drawFlow(random(w), random(h));
  }
  float highest = 0.0;
  float lowest = 255.0;
 //<>//
  endRecord();
}

void drawFlow(float x, float y) {
  beginShape();
  float angle = 0;
  for (int i = 0; i<num_steps; i++) {
    if (x >= 0 && x < width && y >= 0 && y < height)
      vertex(x, y);
    if (x >= 0 && x < w && y >= 0 && y < h) 
      angle = field.get((int)x, (int)y) * TAU;

    float x_step = step_length * cos(angle);
    float y_step = step_length * sin(angle);
    x = x + x_step;
    y = y + y_step;
  }
  circle(x, y, 20);
  endShape();
}
