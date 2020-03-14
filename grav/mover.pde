
class Mover {
  PVector location;
  PVector acceleration;
  PVector velocity;
  float mass;
  float diameter;
  float r;
  float g;
  float b;
  
  Mover(float x, float y, float mass) {
    location = new PVector(x, y);
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
    this.mass = mass;
    diameter = 0.5 + (mass * 1.5);
    PVector col = new PVector(random(1), random(1), random(1));
    col.normalize();
    r = col.x * 255;
    g = col.y * 255;
    b = col.z * 255;
    
  }  
  
  PVector attract(Mover m) {
    PVector r = PVector.sub(location, m.location);
    PVector dist = r.copy();
    float r2 = r.mag();
    float biggest = max(diameter, m.diameter);

    r2 = constrain(r2, biggest, 50.0);
    
    r = r.normalize(); // r is the unit vector pointing one object to another, but
    // we needed to get its magnitude for r^2, which is the distance between this
    // mover and the attractor squared.
    float strength = (G * mass * m.mass) / (r2 * r2);
    
    r.mult(strength); // r becomes our force
    //println(r);
    float closest = m.diameter/2 + diameter/2;
    if (dist.mag() < closest) {
      //applyForce(PVector.mult(m.acceleration, 0.09));
      r = (PVector.mult(r,-2.0));
      //r.cross(PVector.mult(m.acceleration, -1));
    }
    return r;
  }
  
  void display(float column, float row) {
    //float r = map(column, 0, grid_resolution, 0, 255);
    //float g = map(column, 0, grid_resolution, 255, 0);
    //float b = map(row, 0, grid_resolution, 0, 255);
    strokeWeight(mass);
    fill(255);
    noStroke();
    //stroke(255);
    ellipse(location.x, location.y, diameter, diameter);
  }
  
  void checkCollision() {
    if (location.x < 0 || location.x > width)
      velocity.x = -velocity.x;
    if (location.y < 0 || location.y > height)
      velocity.y = -velocity.y;
  }
  
  void applyGravity() {
    applyForce(new PVector(0, 0.01 * mass));
  }
  
  
  void update() {
    checkCollision();
    airFriction();
    acceleration.limit(max_accel);
    velocity.add(acceleration);
    velocity.limit(max_vel);
    location.add(velocity); 
    acceleration.mult(0);
  }
  
  void airFriction() {
    float mu = 0.285;
    float N = 1;
    float mag = mu * N;
    float f = -mag;
    PVector frictionForce = PVector.mult(velocity, f);
    applyForce(frictionForce);
  }
  
  void drag(float drag) {
    float density = 1;
    float speed = pow(velocity.mag(), 2);
    PVector v = velocity.copy();
    v.normalize();
    v.mult(-0.5 * density * speed * drag);
    applyForce(v);
  }
  
  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    acceleration.add(f);
  }
  
}
