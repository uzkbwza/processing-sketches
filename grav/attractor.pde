class Attractor extends Mover {
  public boolean active = false;
  
  Attractor(float x, float y, float mass) {
    super(x, y, mass);
  }
  
  PVector attract(Mover m) {
    PVector r = PVector.sub(location, m.location);
    float r2 = r.mag();
    PVector dist = r.copy();
    r2 = constrain(r2, 5, 25);
    r = r.normalize(); // r is the unit vector pointing one object to another, but
    // we needed to get its magnitude for r^2, which is the distance between this
    // mover and the attractor squared.
    float strength = (G * mass * m.mass) / (r2 * r2);
    
    r.mult(strength); // r becomes our force
    //println(r);
    if (dist.mag() > m.diameter/2 + diameter/2) {
    }
    return r;
  }
  
  void move() {
    if (active) {
      PVector mouse_diff = new PVector(pmouseX - mouseX, pmouseY - mouseY);
      location.sub(mouse_diff);
    }
  }
  
  void check_mouse() {
    if (active)
      return;
    PVector mouse_location = new PVector(mouseX, mouseY);
    PVector mouse_dist = PVector.sub(mouse_location, location);
    active = mouse_dist.mag() < diameter / 2;
  }
}
