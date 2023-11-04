
float WIDTH = 1920;
float HEIGHT = 1080;

float unit = 32;
ArrayList<Integer> pallet = new ArrayList<Integer>();

void setup()
{
  size(1920, 1080);
  colorMode(HSB, 360, 100, 100, 100);
  pallet.add(color(120, 0, 95, 100));
  pallet.add(#e8ede8);
  pallet.add(color(120, 6, 84, 100));
  pallet.add(#266678);
  pallet.add(color(120, 6, 84, 50));
  rectMode(CENTER);
  noLoop();
}


void draw()
{
  background(pallet.get(0));
  noStroke();
  fill(pallet.get(1));
  rect(0, 0, unit*32, unit*16);
  fill(pallet.get(3));
  pushMatrix();
  rotate(radians(40));
  translate(20*unit, 2*unit);
  rect(0, 0, unit*30, unit*10);
  popMatrix();
  shadow_rect(width/2, height/2, 50, 70, false, false, pallet.get(2), pallet.get(3));
  
  for (int i=0; i<20; ++i)
  {
    pushMatrix();
    float x = random(width-14*unit, width-2*unit);
    float y = -0.65*x + 65*unit + random(-3*unit, 3*unit);
    rotate_and_move(x, y, random(360));
    fill(pallet.get(4));
    rect(0, 0, unit*2, unit*1);
    popMatrix();
  }
}


void rotate_and_move(float x, float y, float degree)
{
  PVector v = new PVector(x, y);
  float fai = v.heading();
  float theta = radians(degree);
  rotate(theta);
  translate(v.mag()*cos(fai-theta), v.mag()*sin(fai-theta));
}


void shadow_rect(float x, float y, float w, float h, boolean upper, boolean lefter, int color1, int color2)
{
  float diff_x = w*0.2;
  float diff_y = h*0.2;
  if (upper == true)
  {
    diff_y *= -1;
  }
  if (lefter == true)
  {
    diff_x *= -1;
  }
  noFill();
  strokeWeight(3);
  stroke(color2);
  rect(x+diff_x, y+diff_y, w, h);
  noStroke();
  fill(color1);
  rect(x, y, w, h);
}
