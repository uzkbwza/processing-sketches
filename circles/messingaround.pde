import processing.svg.*;
//import Circle;

boolean saveImage = true;
float t = 0;
float moveDist = 10;
int num = 100;
//int max = 100;
void setup() {
  size(720, 720, SVG, "file.svg");
  if (saveImage) {
    //beginRecord(SVG, "file.svg");
    noLoop();
  }
}

void draw() {
  background(255);
  t += 0.1;
  strokeWeight(1);
  float x = float(width)/2;
  float y = float(height)/2;
  drawRings(x + 1, y, 190, 10, 100, 0.050);
  drawRings(x - 1, y, 20, 100, 230, 0.0501);

}

void drawRings(float x, float y, float r, float g, float b, float distortScale) {

  for (int i=1; i<=num; i++) {
    Circle circle2 = new CircleBuilder(x, y, (float)i*width / (num * 3))
    .resolution(i + 1)
    .starting(noise(i * 0.01) * TAU)
    .distortAmount(5)
    .distortScale(distortScale)
    .build();
    stroke(r, g, b);
    fill(r, g, b);
    circle2.draw();
    //Circle circle3 = new CircleBuilder(x, y, (float)i*12)
    //.resolution(50)
    //.distortAmount(10)
    //.starting(TAU*0.125)
    //.distortScale(0.0015)
    //.build();
    //stroke(0, 0, 255);
    //circle3.draw();
  }
}

void drawCircle(float h, float k, float r, int resolution) {
  float interval = TAU / resolution;
  for (float t=0; t<=TAU; t+=interval) {
     float x = h + r * cos(t);
     float y = k + r * sin(t);
     vertex(x, y);
  }
}
