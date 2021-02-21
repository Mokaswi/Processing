// TODO: add comment.
// TODO: chage pde -> java.

// start_point:線の描画開始座標.
// end_point:線の描画終了座標.
// clr: 塗る色(配列でランダム指定可能).
// alp: 透明度.
// baseSize: ?
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

//　線の一点分を描画する.
// centerX: 描画の中心(線分上の線)のX座標.
// centerY: 描画の中心(線分上の線)のY座標.
// drawSize: メインの円の大きさ.
// vx:サブ円弧の散らばり具合.
// vy:サブ円弧の散らばり具合.
// ang:?円弧の描画する角度に影響.
void drawShape(float centerX, float centerY, float drawSize, float vx, float vy, float ang)
{
    float yuragiX = random(-drawSize/2, drawSize/2);
    float yuragiY = random(-drawSize/2, drawSize/2);
    // メインの円弧.
    arc(centerX + yuragiX, centerY + yuragiY, drawSize, drawSize, ang, ang+radians(random(90, 270)));

    // サブの円弧1.
    // サブって書いているけど存在感は結構ある.
    float subSize = random(drawSize/2, drawSize);
    arc(centerX+vx/2, centerY+vy/2, subSize, subSize, ang, ang+radians(random(180, 360)));

    subSize = random(drawSize/2, drawSize);

    float tmpRad = random(180, 360);
    if(tmpRad > ang)
    {
        ang += 360;
    }
    // サブの円弧2.
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

    // 中心線の描画.
    // 綺麗な直線ではなくちょっと曲げることで手書き感がでている.
    beginShape();
    vertex(centerX, centerY);
    bezierVertex(centerX- vx/4+yuragiX, centerY - vy/4 + yuragiY, centerX + vx/2+yuragiX, centerY + vy/2 + yuragiY, centerX + vx, centerY + vy);
    bezierVertex(centerX- vx/2+yuragiX, centerY - vy/2 + yuragiY, centerX + vx/4+yuragiX, centerY + vy/4 + yuragiY, centerX, centerY);
    endShape();

    float splashWidth = 12;         // どれくらい散らばらさせるか.
    float splashNum = random(6);    // 数.
    float splashSize = random(3);   // 大きさ.
    for(int i=0; i<splashNum; i++)
    {
        // メインの線の周囲の絵の具が飛び散ったあとを描画.
        // 半円を直線に対してsplasWidthの幅分散らして描画しているだけ.
        arc(centerX + random(-splashWidth, splashWidth), centerY + random(-splashWidth, splashWidth), splashSize, splashSize, 0, radians(180));
    }
}