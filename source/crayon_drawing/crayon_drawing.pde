///
/// this code is origin https://cc.musabi.ac.jp/kenkyu/cf/renew/program/processing/processing18.html
///

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
}

void draw()
{
    int[] colorArray = new int[24];
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
    int baseSize = 12;
    float shapeSize = 0.0;

    float shapePitch = 0;
    float angle = 0.0;
    float plusX = 0.0;
    float plusY = 0.0;

    int boundsX = width + baseSize;
    int boundsY = height + baseSize;

    float drawPointX = 0.0;
    float drawPointY = 0.0;

    // for(int i=0; i<pointNum-1; i++)
    for(int i=0; i<1; i++)
    {
        angle = atan2(pointArray[i+1][1] - pointArray[i][1],
                      pointArray[i+1][0] - pointArray[i][0]);
        
        drawPointX = pointArray[i][0];
        drawPointY = pointArray[i][1];

        int colorIndex = int(random(colorArray.length));

        while(-baseSize < drawPointX
        &&    drawPointX < boundsX
        &&    -baseSize < drawPointY
        &&    drawPointY < boundsY)
        {
            shapePitch = random(baseSize/4, baseSize*3/4);
            shapeSize = random(shapePitch);
            
            plusX = cos(angle) * shapePitch;
            plusY = sin(angle) * shapePitch;

            fill(colorArray[colorIndex], random(128, 204));

            drawShape(drawPointX, drawPointY, shapeSize, plusX, plusY, angle);

            drawPointX = drawPointX + plusX;
            drawPointY = drawPointY + plusY;
        }
    }
}

void drawShape(float centerX, float centerY, float drawSize, float vx, float vy, float ang)
{
    float yuragiX = random(-drawSize/2, drawSize/2);
    float yuragiY = random(-drawSize/2, drawSize/2);
    arc(centerX + yuragiX, centerY + yuragiY, drawSize, drawSize, ang, ang+radians(random(90, 270)));

    float subSize = random(drawSize/2, drawSize);
    arc(centerX+vx/2, centerY+vy/2, subSize, subSize, ang, ang+radians(random(180, 360)));

    subSize = random(drawSize/2, drawSize);

    float tmpRad = random(180, 360);
    if(tmpRad > ang)
    {
        ang += 360;
    }
    arc(centerX - vx/2, centerY - vy/2, subSize, subSize, radians(random(tmpRad)), ang);

    if(vx > vy)
    {
        yuragiX = 0;
        yuragiY = random(drawSize);
    }
    else
    {
        yuragiX = random(drawSize);
        yuragiY = 0;
    }

    beginShape();
    vertex(centerX, centerY);
    bezierVertex(centerX- vx/4+yuragiX, centerY - vy/4 + yuragiY, centerX + vx/2+yuragiX, centerY + vy/2 + yuragiY, centerX + vx, centerY + vy);
    bezierVertex(centerX- vx/2+yuragiX, centerY - vy/2 + yuragiY, centerX + vx/4+yuragiX, centerY + vy/4 + yuragiY, centerX, centerY);
    endShape();

    float splashWidth = 12;
    float splashNum = random(6);
    float splashSize = random(3);
    for(int i=0; i<splashNum; i++)
    {
        arc(centerX + random(-splashWidth, splashWidth), centerY + random(-splashWidth, splashWidth), splashSize, splashSize, 0, radians(180));
    }
}


void mousePressed() {
  redraw();			// ボタンが押されたときだけ実行
}