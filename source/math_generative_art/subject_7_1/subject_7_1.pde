import MyLib.*;
Core core = new Core(this);

int[][][] state = {{{250, 0}, {0, 500}, {500, 500}}};
int num = 5;
int gen = 0;


void setup()
{
    size(500, 500);
    background(255);
    noStroke();
}

void draw()
{
    core.draw_sierpinski_gasket(250, 0, 0, 500, 500, 500, 10);
}
