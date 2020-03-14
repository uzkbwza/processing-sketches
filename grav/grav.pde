import com.hamoid.*;
import java.time.*;
import java.text.SimpleDateFormat;
import java.util.Date;


float time = 0.0;
float incr = 0.01;
float G = 3.58;
float max_vel = 100;
float max_accel = 8.565;

VideoExport videoExport;

int num_movers = 1000;
int grid_resolution = 20;
ArrayList<Mover> ms = new ArrayList<Mover>();
ArrayList<Mover>[][] grid = new ArrayList[grid_resolution][grid_resolution];
ArrayList<Particle> particles = new ArrayList<Particle>();

void setup() {
  String fileName = new SimpleDateFormat("yyyy-MM-dd-HH-mm-ss").format(new Date());
  hint(ENABLE_STROKE_PURE);
  videoExport = new VideoExport(this, fileName.toString() + ".mp4");
  videoExport.setFrameRate(60);
  //frameRate(60);
  videoExport.startMovie();
  size(860, 860, P3D);  
  smooth(8);
  for (int i = 0; i < grid_resolution; i++) {
    for (int j = 0; j < grid_resolution; j++) {
      grid[i][j] = new ArrayList<Mover>();
    }
  }
  for (int i = 0; i < num_movers; i++) {
    float padding = 200;
    ms.add(new Mover(random(padding, width - padding), random(padding, height - padding), random(0.1, 3.0)));
    float mag = random(7);
    float angle = random(TWO_PI);
    PVector force = new PVector(cos(angle), sin(angle));
    force.mult(mag);
    ms.get(i).applyForce(force);
  }
  //fill(255, 10);
  //rect(0, 0, width, height);
  background(0);
}

void draw() {
  translate(width/2, height/2);
  rotateZ(time / 10);
  translate(-width/2, -height/2, 300);
  background(0);
  stroke(255, 20);
  strokeWeight(1);
  //Mover target = ms.get(0); 
  float gr = float(grid_resolution);
  for (float i = 0; i <= gr; i++) {
    line(i * (width / gr), 0, i * (width / gr), height); 
    line(0, i * (height / gr), width, i * (height / gr)); 
  }
  for (int i = 0; i < grid_resolution; i++) {
     for (int j = 0; j < grid_resolution; j++) {
      grid[i][j] = new ArrayList<Mover>();
    }
  }
  pushMatrix();
  translate(0, 0, 2);
  for (Mover m: ms) {
    int column = constrain(int(m.location.x) / int(width / gr), 0, grid_resolution - 1);
    int row = constrain(int(m.location.y) / int(height / gr), 0, grid_resolution - 1);
    //Particle p = new Particle(m.location.x, m.location.y, m.diameter / 2, max(int(m.velocity.mag() / 2), 3));
    //particles.add(p);
    //println(column, row);
    grid[column][row].add(m);
  }
  popMatrix();
  pushMatrix();
  translate(0, 0, 2);
  for (int i = 0; i < particles.size(); i++) {
    Particle p = particles.get(i);
    p.display();
    p.update();
    if (p.age > p.max_age) {
      particles.remove(i);
    }
  }
  popMatrix();
  pushMatrix();
  translate(0, 0, 2);
  for (Mover m: ms) {
    
    int column = constrain(int(m.location.x) / int(width / gr), 0, grid_resolution - 1);
    int row = constrain(int(m.location.y) / int(height / gr), 0, grid_resolution - 1);
    //check neighboring cells
    m.display(column, row);
    for (int i = column - 1; i <= column + 1; i++) {
      for (int j = row - 1; j <= row + 1; j++) {
        if (i >= grid_resolution || i < 0 || j >= grid_resolution || j < 0)
          continue;
        for (Mover o: grid[i][j]) {
          //println("attracting m from ", column, row, "to o at ", i, j); 
          if (m == o)
            continue;
          //float r = map(row, 0, grid_resolution, 0, 255);
          //float g = map(column, 0, grid_resolution, 255, 0);
          //float b = map(row, 0, grid_resolution, 255, 0);
          PVector f = o.attract(m);
          strokeJoin(ROUND);
          //blendMode(SCREEN);
          stroke(255, abs(255 * f.mag() * 2));
          strokeWeight(min(0.5 + f.mag(), m.diameter / 1.5));
          //line(m.location.x, m.location.y, o.location.x, o.location.y);
          blendMode(NORMAL);
          m.applyForce(f);
        }
      }
    }
    m.update();
  }
  
  popMatrix();
  time += incr;
  videoExport.saveFrame();
}

void keyPressed() {
  if (key == 'q') {
    videoExport.endMovie();
    exit();
  }
  if (key == 'p') {
  }
}
