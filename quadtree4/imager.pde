
void subdivideAverages(QuadTree t) {
  if (t.HasChildren()) return;

  AABB range = new AABB(t.boundary.x, t.boundary.y, t.boundary.w, t.boundary.h);
  PVector average = getAverage(range.x, range.y, range.w, range.h);
  float variation = distFromAverage(range.x, range.y, range.w, range.h, average);
  if (variation > threshold) {
    if (t.Subdivide()) {
      subdivideAverages(t.NW);
      subdivideAverages(t.NE);
      subdivideAverages(t.SW);
      subdivideAverages(t.SE);
    }
  }
}

void subdivideRandomly(QuadTree t, int chance) {
  if (t.HasChildren()) return;
  if (random(100) < chance) {
    if (t.Subdivide()) {
      subdivideRandomly(t.NW, chance);
      subdivideRandomly(t.NE, chance);
      subdivideRandomly(t.SW, chance);
      subdivideRandomly(t.SE, chance); 
    }
  }
}

void subdivideAverageBrightnesses(QuadTree t) {
  if (t.HasChildren()) return;

  AABB range = new AABB(t.boundary.x, t.boundary.y, t.boundary.w, t.boundary.h);
  float average = getAverageBrightness(range.x, range.y, range.w, range.h);
  float variation = distFromAverageBrightness(range.x, range.y, range.w, range.h, average);
  if (variation > threshold) {
    if (t.Subdivide() || t.depth == 0) {
      subdivideAverageBrightnesses(t.NW);
      subdivideAverageBrightnesses(t.NE);
      subdivideAverageBrightnesses(t.SW);
      subdivideAverageBrightnesses(t.SE);
    }
  }
}



void subdivideBrightnesses(QuadTree t) {
  if (t.HasChildren()) return;

  AABB range = new AABB(t.boundary.x, t.boundary.y, t.boundary.w, t.boundary.h);
  float brightness = getAverageBrightness(range.x, range.y, range.w, range.h);
  if (brightness < threshold) {
    if (t.Subdivide()) {
      subdivideBrightnesses(t.NW);
      subdivideBrightnesses(t.NE);
      subdivideBrightnesses(t.SW);
      subdivideBrightnesses(t.SE);
    }
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
}

float distFromAverageBrightness(int img_x, int img_y, int cell_w, int cell_h, float avg) {
  float sum = 0;
  for (int x=0; x<cell_w; x++) {
    for (int y=0; y<cell_h; y++) {
      int loc = (img_x + x) + (img_y + y) * img.width;
      color pixel = img.pixels[loc];
      float pix = brightness(pixel);
      sum += abs(avg - pix);
    }
  }
  return sum / (cell_w * cell_h);
}

float quantize(float value, float divs, float scale) {
  float interval = scale / divs;
  return (floor(value / interval) * interval) / scale;
}
