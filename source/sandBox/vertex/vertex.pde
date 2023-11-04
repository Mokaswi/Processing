

void setup()
{
  size(600, 600);
  noLoop();
}

void draw()
{
  colorMode(HSB, 360, 100, 100, 100);
  background(360);
  smooth();
  noStroke();
  
  float unit = 25;
  
  for (int j = 0; j<height/unit; ++j)
  {
    for (int i = 0; i<width/unit; ++i)
    {
      pushMatrix();
      translate(i*unit, j*unit);
      rotate(random(360));
      fill(192, 100, 64, 60);
      rect_m(0, 0, unit, unit); 
      popMatrix();
    }
  }
  for (int j = 0; j<height/unit; j+= random(1, 10))
  {
    for (int i = 0; i<width/unit; i+= random(4, 10))
    {
        fill(130, 100, 64, 60);
        rect(i*unit, j*unit, unit*0.5, unit*0.5);
    }
  }
}

void rect_m(float x, float y, float w, float h)
{
  beginShape();
  vertex(x, y);
  vertex(x+w*0.8, y);
  vertex(x+w*0.3, y+h);
  vertex(x, y+h);
  endShape(CLOSE);
}
