void setup()
{
  size(512, 512);
  background(color(0, 0, 0));

  noSmooth();
  noLoop();
}

final float radius = 1.0f;

void draw()
{
  PVector pc = new PVector(0.0, 0.0, 5.0);
  PVector pe = new PVector(0.0, 0.0, -5.0);
  PVector pw = new PVector(0.0, 0.0, 0.0);
  for (int y=0; y<height; ++y)
  {
    pw.y = -2.0*y/(height-1.0) + 1.0;
    for (int x=0; x<width; ++x)
    {
      // convert (x, y) to 3D coordinate
      // sphare: x^2 + y^2 + (z-5)^2 = 1
      pw.x = 2.0*x/(width-1.0) - 1.0;
      PVector de = pw.sub(pe);
      PVector vtmp = pe.sub(pc);
      float A = de.magSq();
      float B = 2 * de.dot(vtmp);
      float C = vtmp.magSq() - radius*radius;
      float condition = B*B-4*A*C;
      if (condition >= 0.0)
      {
        stroke(color(255, 0, 0));
      }
      else
      {
        stroke(color(0, 0, 255));
      }
      point(x, y);
    }
  }
}
