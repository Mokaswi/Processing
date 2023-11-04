int _numChildren = 7;
int _maxLevels = 7;

Branch _trunk;
void setup()
{
  size(750, 500);
  background(255);
  noFill();
  smooth();
  newTree();
}

void draw()
{
  background(255);
  _trunk.updateMe(width/2, height/2);
  _trunk.drawMe();
}

void newTree()
{
  _trunk = new Branch (1, 0, width/2, 50);
  _trunk.drawMe();
}
