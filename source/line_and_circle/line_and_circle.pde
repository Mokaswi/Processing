PVector[] pointArray;
int pointNum = 100; 

void setup()
{
    size(730, 488);
    background(255);
    smooth();
    noLoop();
    ellipseMode(RADIUS);
    pointArray = new PVector[pointNum];
    for(int i=0; i<pointNum; i++)
    {
        pointArray[i] = new PVector(random(width), random(height));
    }
}

void draw()
{
    float shapeSize = width/30;

    noStroke();
    fill(51);
    rect(0, 0, width, height);

    noFill();
    stroke(255);

    for(int i=0; i<pointNum-1; i++)
    {
        line(pointArray[i].x, pointArray[i].y, pointArray[i+1].x, pointArray[i+1].y);
        float lineRepeatNum = random(1, 6);
        makeLine(pointArray[i].x, pointArray[i].y, shapeSize, lineRepeatNum);
    }
}

void makeLine(float centerX, float centerY, float radius, float num)
{
    for(int i=0; i<num; i++)
    {
        makeLine_i(centerX, centerY, radius);
    }
}

void makeLine_i(float centerX, float centerY, float radius)
{
    float leftX = centerX - radius;
    float rightX = centerX + radius;
    float topY = centerY - radius;
    float bottomY = centerY + radius;

    float ctlPoint = radius * 0.55;

    float centerX2 = centerX + random(-radius/3, radius/3);
    float centerY2 = centerY + random(-radius/3, radius/3);

    leftX = leftX + random(-radius/3, radius/3);
    rightX = rightX + random(-radius/3, radius/3);
    topY = topY + random(-radius/3, radius/3);
    bottomY = bottomY + random(-radius/3, radius/3);

    beginShape();
    vertex(centerX2, topY);
    bezierVertex(centerX2+ctlPoint, topY, rightX, centerY2-ctlPoint, rightX, centerY2);
    bezierVertex(rightX, centerY2+ctlPoint, centerX2+ctlPoint, bottomY, centerX2, bottomY);
    bezierVertex(centerX2-ctlPoint, bottomY, leftX, centerY2+ctlPoint, leftX, centerY2);
    bezierVertex(leftX, centerY2-ctlPoint, centerX2-ctlPoint, topY, centerX2, topY);
    endShape();

}