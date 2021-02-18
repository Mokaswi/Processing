///
/// this code is origin https://cc.musabi.ac.jp/kenkyu/cf/renew/program/processing/processing18.html
///
int[] colorArray = new int[24];

void settings()
{
    size(730, 488);
}

void setup() 
{
    background(255);
    smooth();
    noLoop();
    noStroke();
    ellipseMode(RADIUS);
    colorArray[0] = color(0, 0, 0);
    colorArray[1] = color(255, 255, 255);
    colorArray[2] = color(255, 255, 238);
    colorArray[3] = color(255, 255, 221);
    colorArray[4] = color(255, 255, 204);
    colorArray[5] = color(255, 255, 187);
    colorArray[6] = color(238, 238, 204);
    colorArray[7] = color( 255, 238, 170 );
    colorArray[8] = color( 221, 204, 153 );
    colorArray[9] = color( 255, 238, 102 );
    colorArray[10] = color( 255, 204, 102 );
    colorArray[11] = color( 170, 170, 119 );
    colorArray[12] = color( 221, 204, 51 );
    colorArray[13] = color( 0, 51, 0 );
    colorArray[14] = color( 68, 51, 0 );
    colorArray[15] = color( 85, 51, 0 );
    colorArray[16] = color( 51, 34, 0 );
    colorArray[17] = color( 51, 34, 0 );
    colorArray[18] = color( 34, 17, 0 );
    colorArray[19] = color( 17, 34, 0 );
    colorArray[20] = color( 238, 255, 238 );
    colorArray[21] = color( 221, 238, 221 );
    colorArray[22] = color( 119, 136, 119 );
    colorArray[23] = color( 153, 54, 54 );
}

void draw()
{
    int pointNum = 200;
    float [][] pointArray = new float[pointNum][2];
    for(int i=0; i<pointNum; i++)
    {
        if(i%4 == 0)
        {
            pointArray[i][0] = 1;
            pointArray[i][1] = random(height);
        }
        else if(i%4 == 1)
        {
            pointArray[i][0] = width;
            pointArray[i][1] = random(height);
        }
        else if(i%4 == 2)
        {
            pointArray[i][0] = random(width);
            pointArray[i][1] = 1;
        }
        else if(i%4 == 3)
        {
            pointArray[i][0] = random(width);
            pointArray[i][1] = height;
        }
    }

    // for(int i=0; i<pointNum-1; i++)
    for(int i=0; i<1; i++)
    {
        int clr[] = new int[1];
        clr[0] = colorArray[int(random(colorArray.length))];
        PVector start_point = new PVector(pointArray[i][0], pointArray[i][1]);
        PVector end_point = new PVector(pointArray[i+1][0], pointArray[i+1][1]);
        draw_crayon_like_line(start_point,
                              end_point,
                              clr,
                              random(128, 204),
                              12);
    }
}

void mousePressed() {
  redraw();			// ボタンが押されたときだけ実行
}