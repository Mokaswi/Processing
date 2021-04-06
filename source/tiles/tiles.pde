///
/// https://note.com/reona396/n/n8b661f567ffd
///

import MyLib.*;

Core core = new Core(this);

boolean changeFlag = false;
int counter = 0;
int num = 50;
int yy = 0;

int palette[] = new int[]{#dcd6f7, #a6b1e1, #b4869f, #985f6f, #4e4c67};

void setup()
{
    size(1080, 1080);
    noLoop();
    noStroke();
}

void draw()
{
    background(#e7ecf2);

    for(int i=0; i<=num; ++i)
    {
        fill(core.random_from_array(palette));
        int oy = (int)random(-200, 200);

        beginShape();
        for(int x=0; x<=width; x++)
        {
            int y = oy+yy;

            vertex(x, y);
            counter++;

            if(!changeFlag && random(100)<8)
            {
                oy = (int)random(-200, 200);
                changeFlag = true;
            }
            if(counter>30)
            {
                changeFlag = false;
                counter = 0;
            }
        }
        vertex(width, yy);
        vertex(0, yy);
        endShape(CLOSE);
        yy += (int)height / num;
    }
}