public class Circle {
  public PVector pos;
  public float radius;
  private float resolution;
  private float distortAmount;
  private float distortScale;
  private float starting = 0;
  
  private Circle(CircleBuilder builder) {
     this.pos = builder.pos;
     this.radius = builder.radius;
     this.resolution = builder.resolution;
     this.distortAmount = builder.distortAmount;
     this.distortScale = builder.distortScale;
     this.starting = builder.starting;
  }
  
  public void draw() {
    ArrayList<PVector> vertices = this.getVertices();
    noFill();
    beginShape();
    for (PVector v : vertices) {
      float noiseShift = (noise(v.x * this.distortScale, v.y * this.distortScale));
      PVector drawPos = PVector.add(PVector.mult(PVector.fromAngle(noiseShift * TAU), this.distortAmount), v);
      circle(drawPos.x, drawPos.y, noiseShift * noiseShift * 15);
      //vertex(drawPos.x, drawPos.y);
    }
  endShape(CLOSE);

  }
  
  private ArrayList<PVector> getVertices() {
    ArrayList<PVector> vertices = new ArrayList();
    
    float interval = TAU / this.resolution;
    for (float t=0; t<=TAU; t+=interval) {
       float x = this.pos.x + this.radius * cos(starting + t);
       float y = this.pos.y + this.radius * sin(starting + t);
       vertices.add(new PVector(x, y));
    }
    return vertices;
  }
}

public class CircleBuilder {
    private PVector pos;
    private float radius;
    private int resolution = 100;
    private float distortAmount = 0;
    private float distortScale = 0.05;
    private float starting = 0;
    
    public CircleBuilder(float x, float y, float radius) {
       this.pos = new PVector(x, y);
       this.radius = radius;
    }
    
    public CircleBuilder distortAmount(float distortAmount) {
      this.distortAmount = distortAmount;
      return this;
    }
    
    public CircleBuilder distortScale(float distortScale) {
      this.distortScale = distortScale;
      return this;
    }
    
    public CircleBuilder resolution(int resolution) {
      this.resolution = resolution;
      return this;
    }
    
    public CircleBuilder starting(float starting) {
      this.starting = starting;
      return this;
    }
    public Circle build() {
      Circle circle = new Circle(this);
      return circle;
    }
  } 
