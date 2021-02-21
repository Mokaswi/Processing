class RedCircle extends AppBase {
  PVector pos;
  PVector vel;
  PVector acc;
  RedCircle(PApplet _parent) {
    super(_parent);
  }
  @Override void setup() {
    pos = new PVector(parent.width/2, parent.height/2, 0);
    vel = PVector.random2D().mult(4);
    acc = new PVector(0,0.1);
    parent.colorMode(HSB, 360, 100, 100);
  }
  @Override void update() {
    vel.add(acc);
    pos.add(vel);
    if(pos.x < 0 || pos.x > width){
      vel.x *= -1;
    }
    if(pos.y < 0 || pos.y > height){
      vel.y *= -1;
    }
  }
  @Override void draw() {
    parent.noStroke();
    parent.background(0, 0, 100);
    parent.fill(0, 80, 100);
    parent.ellipse(pos.x, pos.y, 50, 50);
  }
}