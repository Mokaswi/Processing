import processing.opengl.*;

int radius = 100;

void setup()
{
  size(500, 300, OPENGL);
  background(255);
  stroke(0);
}

void draw()
{
  background(255);
  
  translate(width/2, height/2, 0);
  rotateY(frameCount * 0.01);
  rotateX(frameCount * 0.01);
  
  float s = 0;
  float t = 0;
  float lastx = 0;
  float lasty = 0;
  float lastz = 0;
  while (t < 180)
  {
    s += 18;
    t += 1;
    float radianS = radians(s);
    float radianT = radians(t);
    
    float thisx = 0 + (radius * cos(radianS) * sin(radianT)) + noise(random(50)) * 50;
    float thisy = 0 + (radius * sin(radianS) * sin(radianT)) + noise(random(20)) * 20;
    float thisz = 0 + (radius * cos(radianT)) + noise(random(23)) * 23;
    
    if (lastx != 0)
    {
      line(thisx, thisy, thisz, lastx, lasty, lastz);
    }
    lastx = thisx;
    //lasty = lasty;
    lasty = thisy;
    lastz = thisz;
    //lastz = lastz;
  }
  line(-lastx, -lasty, -lastz, lastx, lasty, lastz);
}
