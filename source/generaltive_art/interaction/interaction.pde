int _num = 10;
Circle[] _circleArr = {};

void setup()
{
  size(500, 300);
  background(255);
  smooth();
  strokeWeight(1);
  fill(150, 50);
  drawCircles();
  //noLoop();
  //drawCircles();
  //drawCircles();
  //drawCircles();
  for (int i=0; i<_circleArr.length; ++i)
  {
    Circle thisCirc = _circleArr[i];
    thisCirc.updateMe();
  }
}

void draw()
{
  background(255);
  for (int i=0; i<_circleArr.length; ++i)
  {
    Circle thisCirc = _circleArr[i];
    thisCirc.updateMe();
  }
}

void mouseReleased()
{
  drawCircles();
}

void drawCircles()
{
  for (int i=0; i<_num; ++i)
  {
    Circle thisCirc = new Circle();
    thisCirc.drawMe();
    _circleArr = (Circle[])append(_circleArr, thisCirc);
  }
}
