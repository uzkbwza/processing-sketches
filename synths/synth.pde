class Synth {
  AABB frame;
  AABB moduleGrid;
  ArrayList<Module> modules;
  float openSpace;
  float maxOpenSpace;
  
  public Synth(float x, float y, float w, float h) {
    frame = new AABB(x, y, w, h);
    moduleGrid = new AABB(0, 0, floor(w / GRID_SIZE), floor(h / GRID_SIZE));
    modules = new ArrayList();
    openSpace = moduleGrid.w * moduleGrid.h;
    maxOpenSpace = openSpace;
  }
  
  public void pack() {
    int counter = 0;
    while (openSpace > 0 && counter < TRIES) {
      tryAddModule();
      counter++;
    }
  }
  
  boolean tryAddModule() {
    float start_x = int(random(moduleGrid.w + 1 - MIN_MODULE_WIDTH)); //<>//
    float start_y = int(random(moduleGrid.h + 1 - MIN_MODULE_HEIGHT));
    int desired_w = int(random(MAX_MODULE_WIDTH - MIN_MODULE_WIDTH) + MIN_MODULE_WIDTH);
    int desired_h = int(random(MAX_MODULE_HEIGHT - MIN_MODULE_HEIGHT) + MIN_MODULE_HEIGHT);
    float actual_w = MIN_MODULE_WIDTH;
    float actual_h = MIN_MODULE_HEIGHT;
    if (openSpace / maxOpenSpace < 0.5) {
       actual_w = 1;
       actual_h = 1;
       desired_w = 10000;
       desired_h = 10000;
    }
    boolean fits = false;
    for (int w=(int)actual_w; w < desired_w; w++) {
      AABB box = new AABB(start_x, start_y, w, actual_h);
      if (checkGridForSpace(box)) {
        actual_w = w;
        fits = true;  
      }
      else
        break;
    }
    for (int h=(int)actual_h; h < desired_h; h++) {
      AABB box = new AABB(start_x, start_y, actual_w, h);
      if (checkGridForSpace(box)) {
        actual_h = h;
        fits = true;
      }
      else
        break;
    }
    
    if (fits) {
      AABB rec = new AABB(start_x, start_y, actual_w, actual_h);
      Module mod = createModuleFromDims(start_x, start_y, actual_w, actual_h);
      openSpace -= rec.w * rec.h;
      modules.add(mod);
    }
    return fits;
  }
  
  Module createModuleFromDims(float start_x, float start_y, float w, float h) {
    AABB frame = new AABB(this.frame.x1 + start_x * GRID_SIZE, this.frame.y1 + start_y * GRID_SIZE, w * GRID_SIZE, h * GRID_SIZE);
    return randomModule(frame);
  }
 
  AABB dimsToFrame(AABB dims) {
    return new AABB(this.frame.x1 + dims.x1 * GRID_SIZE, this.frame.y1 + dims.y1 * GRID_SIZE, dims.w * GRID_SIZE, dims.h * GRID_SIZE);
  }
  
  boolean checkGridForSpace(AABB rec) {
    if (!moduleGrid.containsPoint(rec.x2, rec.y2)) 
      return false;
    for (Module module : modules) {
      if (module.frame.overlaps(dimsToFrame(rec)))
        return false;
    }
    return true;
  }
  
  public void draw() {
    //stroke(COLOR_1);
    rect(frame.x1, frame.y1, frame.w, frame.h);
    for (Module module : modules) {
      module.draw();
    }
  }
  
}
