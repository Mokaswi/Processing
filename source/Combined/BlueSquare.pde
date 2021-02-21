class BlueSquare extends AppBase {
  PVector pos;
  PVector vel;
  
  BlueSquare(PApplet _parent) {
    super(_parent);
  }
  @Override void setup() {
    pos = new PVector(parent.width/2, parent.height/2, 0);
    vel = PVector.random2D().mult(4);
    parent.colorMode(HSB, 360, 100, 100);
  }
  @Override void update() {
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
    parent.fill(220, 80, 100);
    parent.rectMode(CENTER);
    parent.rect(pos.x, pos.y, 50, 50);
  }
}