import controlP5.*;
float MIN_MODULE_WIDTH = 3;
float MIN_MODULE_HEIGHT = 2;
float MAX_MODULE_WIDTH = 30;
float MAX_MODULE_HEIGHT = 20;
color COLOR_1;
color COLOR_2;
color COLOR_3;
float PADDING = 20;
float GRID_SIZE = 150;
int TRIES = 10000000;
float BISECT_CHANCE = 30;
float BISECT_PERPENDICULAR_SPLIT_CHANCE = 75;
float MIN_KNOB_SIZE = 50;
//int seed = 10;
Synth synth;
KnobStyle knobStyle1;
KnobStyle knobStyle2;

void setup() {
  size(1240, 940);
  colorMode(HSB, 100);
  COLOR_1 = color(0, 100, 100);
  COLOR_2 = color(70, 100, 100);
  COLOR_3 = color(30, 100, 100);
  strokeWeight(2);
  noFill();
  noLoop();
  //randomSeed(seed);
  synth = new Synth(PADDING, PADDING, width - PADDING * 2, height - PADDING * 2);
}

void draw() {
  stroke(COLOR_1);
  background(100);
  synth.pack();
  synth.draw();
  
}
