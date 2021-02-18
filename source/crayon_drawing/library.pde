
void draw_crayon_like_line(PVector start_point, PVector end_point, int clr[], float alp, int baseSize)
{
    float angle = atan2(end_point.y - start_point.y,
                    end_point.x - start_point.x);
    
    float drawPointX = start_point.x;
    float drawPointY = start_point.y;

    int boundsX = width + baseSize;
    int boundsY = height + baseSize;

    while(-baseSize < drawPointX
    &&    drawPointX < boundsX
    &&    -baseSize < drawPointY
    &&    drawPointY < boundsY)
    {
        float shapePitch = random(baseSize/4, baseSize*3/4);
        float shapeSize = random(shapePitch);
        
        float plusX = cos(angle) * shapePitch;
        float plusY = sin(angle) * shapePitch;

        fill(clr[int(random(clr.length))], alp);

        drawShape(drawPointX, drawPointY, shapeSize, plusX, plusY, angle);

        drawPointX = drawPointX + plusX;
        drawPointY = drawPointY + plusY;
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