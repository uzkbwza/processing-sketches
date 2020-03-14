class Particle {
  PVector location;
  int age;
  int max_age = 3;
  float diameter;

  Particle(float x, float y, float diameter, int max_age) {
    age = 0;
    location = new PVector(x, y);
    this.diameter = diameter;
    this.max_age = max_age;
  }
  
  void update() {
    age++;
    diameter = map(age, 0, max_age, diameter, 0);
    //println(diameter);
  }
  
  void display() {
    noFill();
    strokeWeight(1);
    stroke(255);
    ellipse(location.x, location.y, diameter, diameter);
  }
}
