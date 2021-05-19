

class Module {
  AABB frame;
  Control control;
  public Module(AABB frame) {
    this.frame = frame;
    //this.control = new Knobs(frame);
  }
  
  public void draw() {
    if (this.control != null)
      this.control.draw();
  }
}

class PopulatedModule extends Module {
   public PopulatedModule(AABB frame) {
    super(frame);
    this.control = new Knobs(frame);
  }
}

class ModuleContainer extends Module {
  Module mod;
  public ModuleContainer(AABB frame) {
    super(frame);
    float padding = random(GRID_SIZE / 10);
    AABB containedFrame = new AABB (frame.x1 + padding, frame.y1 + padding, frame.w - padding * 2, frame.h - padding * 2);
    this.mod = randomLeafModule(containedFrame);
  }
  
  public void draw() {
    //stroke(COLOR_1);
    //rect(frame.x1, frame.y1, frame.w, frame.h);
    //rect(mod.frame.x1, mod.frame.y1, mod.frame.w, mod.frame.h);
    super.draw();
    this.mod.draw();
  }
}

class BisectedModule extends Module {
  Module mod1;
  Module mod2;
  public BisectedModule(AABB frame) {
    super(frame);
    PVector bisectPoint = new PVector(random(frame.w/3) + frame.w/3, random(frame.h/3) + frame.h/3);
    boolean horizontal = 
      (frame.w > frame.h && random(100) > BISECT_PERPENDICULAR_SPLIT_CHANCE) ||
      (frame.h > frame.w && random(100) <= BISECT_PERPENDICULAR_SPLIT_CHANCE);
    AABB frame1;
    AABB frame2;
    if (horizontal) {
      frame1 = new AABB(frame.x1, frame.y1, frame.w, bisectPoint.y);
      frame2 = new AABB(frame.x1, frame.y1 + bisectPoint.y, frame.w, frame.h - bisectPoint.y);
    } else {
      frame1 = new AABB(frame.x1, frame.y1, bisectPoint.x, frame.h);
      frame2 = new AABB(frame.x1 + bisectPoint.x, frame.y1, frame.w - bisectPoint.x, frame.h);
    }
    mod1 = new ModuleContainer(frame1);
    mod2 = new ModuleContainer(frame2);
  }
  
  public void draw() {
    //super.draw();
    //rect(frame.x1, frame.y1, frame.w, frame.h);
    stroke(COLOR_3);
    mod1.draw();
    stroke(COLOR_2);
    mod2.draw();
  }
  
}
Module randomLeafModule(AABB frame) {
  //int[] choices = { 1, 2 };
  //int choice = choices[int(random(choices.length))];
  
  //if (choice == 1) {
  //  return new ModuleContainer(frame, dims);
  //} else if (choice == 2) {
  //  return new BisectedModule(frame, dims);
  //}
  return new PopulatedModule(frame);
}

Module randomModule(AABB frame) {
  int[] choices = { 1, 2 };
  int choice = choices[int(random(choices.length))];
  //println(choice);
  if (choice == 1) {
    return new ModuleContainer(frame);
  } else if (choice == 2) {
    return new BisectedModule(frame);
  }
  return new PopulatedModule(frame);
}
