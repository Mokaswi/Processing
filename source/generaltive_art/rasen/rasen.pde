size(700, 700);
background(255);
smooth();
colorMode(HSB, 360, 100, 100);

 int centx = (int)(0.50*width);
 int centy = (int)(0.50*height);

 noFill();
 float x, y;
 for (int i=0; i<70; ++i)
 {
   float lastx = -999;
   float lasty = -999;
   float radius = 10;
   float radiusNoise = random(10);
   stroke(120+random(20), random(30)+16, random(40)+40 , 100);
   strokeWeight(random(20) * 0.10);
   int startangle = (int)random(360);
   int endangle = 1440 + (int)random(1440);
   int anglestep = 5 + (int)random(3);
   for (float ang = startangle; ang <= endangle; ang += anglestep)
   {
     radiusNoise += 0.05;
     radius += 0.5;
     float thisRadius = radius + (noise(radiusNoise) * 200) - 100;
     float rad = radians(ang);
     x = centx + (thisRadius * cos(rad));
     y = centy + (thisRadius * sin(rad));
     if (lastx > -999)
     {
       line(x, y, lastx, lasty);
     }
     lastx = x;
     lasty = y;
   }
 }
