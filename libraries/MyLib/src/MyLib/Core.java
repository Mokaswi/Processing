package MyLib;

import processing.core.*;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintStream;

public class Core {
    PApplet pa;
    public Core(PApplet pa) 
    {
        this.pa = pa;
    }

    // 
    // カラーコード(e.g."f8c630")をintのカラーに変換する関数.
    //
    public int convert_color_code_to_int(String color_code)
    {
        return pa.unhex("FF" + color_code);
    }
    //
    // URLの例.
    // final String URL  = "https://coolors.co/22162b-451f55-724e91-e54f6d-f8c630";
    //
    public int[] create_palette_from_url(String url)
    {
        int slashIndex = url.lastIndexOf("/");          //一番後ろの"/"のインデックス
        String colStr = url.substring(slashIndex + 1);  // "22162b-451f55-724e91-e54f6d-f8c630"
        
        String[] cols = colStr.split("-");              //["22162b", "451f55", "724e91", "e54f6d", "f8c630"]
        int[] dst = new int[cols.length];
        for(int i = 0; i < cols.length; i++)
        {
            dst[i] = convert_color_code_to_int(cols[i]);
        }

        return dst;
    }
    //
    // 配列からランダムに値を返す関数.
    // 特定の値のリストからランダムに選びたい場合に使用する.
    //
    public int random_from_array(int[] src)
    {
        return src[(int)pa.random(src.length)];
    }

    //
    // scrで渡されたリストの要素をシャッフル(順番を入れ替えて)返す関数.
    // srcは書き換えない.
    //
    public int[] shuffle(int[] src)
    {
        int[] dst = src.clone();
        for(int i=src.length-1; i > 0; --i)
        {
            int j = (int)Math.floor((double)pa.random(0.0f, 1.0f) * (i+1));
            int tmp = dst[i];
            dst[i] = dst[j];
            dst[j] = tmp;
        }
        return dst;
    }
    //
    // クレヨンになっているが水彩画っぽい線を描く関数.
    // start_point:線の描画開始座標.
    // end_point:線の描画終了座標.
    // clr: 塗る色(配列でランダム指定可能).
    // alp: 透明度.
    // baseSize: ?
    //
    public void draw_crayon_like_line(PVector start_point, PVector end_point, int clr[], float alp, int baseSize)
    {
        float angle = pa.atan2(end_point.y - start_point.y,
                        end_point.x - start_point.x);
        
        float drawPointX = start_point.x;
        float drawPointY = start_point.y;

        int boundsX = pa.width + baseSize;
        int boundsY = pa.height + baseSize;

        while(-baseSize < drawPointX
        &&    drawPointX < boundsX
        &&    -baseSize < drawPointY
        &&    drawPointY < boundsY)
        {
            float shapePitch = pa.random(baseSize/4, baseSize*3/4);
            float shapeSize = pa.random(shapePitch);
            
            float plusX = pa.cos(angle) * shapePitch;
            float plusY = pa.sin(angle) * shapePitch;

            pa.fill(clr[(int)pa.random(clr.length)], alp);

            draw_crayon_like_line_i(drawPointX, drawPointY, shapeSize, plusX, plusY, angle);

            drawPointX = drawPointX + plusX;
            drawPointY = drawPointY + plusY;
        }
    }
    //
    //　線の一点分を描画する.
    // centerX: 描画の中心(線分上の線)のX座標.
    // centerY: 描画の中心(線分上の線)のY座標.
    // drawSize: メインの円の大きさ.
    // vx:サブ円弧の散らばり具合.
    // vy:サブ円弧の散らばり具合.
    // ang:?円弧の描画する角度に影響.
    //
    private void draw_crayon_like_line_i(float centerX, float centerY, float drawSize, float vx, float vy, float ang)
    {
        float yuragiX = pa.random(-drawSize/2, drawSize/2);
        float yuragiY = pa.random(-drawSize/2, drawSize/2);
        // メインの円弧.
        pa.arc(centerX + yuragiX, centerY + yuragiY, drawSize, drawSize, ang, ang+pa.radians(pa.random(90, 270)));

        // サブの円弧1.
        // サブって書いているけど存在感は結構ある.
        float subSize = pa.random(drawSize/2, drawSize);
        pa.arc(centerX+vx/2, centerY+vy/2, subSize, subSize, ang, ang+pa.radians(pa.random(180, 360)));

        subSize = pa.random(drawSize/2, drawSize);

        float tmpRad = pa.random(180, 360);
        if(tmpRad > ang)
        {
            ang += 360;
        }
        // サブの円弧2.
        pa.arc(centerX - vx/2, centerY - vy/2, subSize, subSize, pa.radians(pa.random(tmpRad)), ang);

        if(vx > vy)
        {
            yuragiX = 0;
            yuragiY = pa.random(drawSize);
        }
        else
        {
            yuragiX = pa.random(drawSize);
            yuragiY = 0;
        }

        // 中心線の描画.
        // 綺麗な直線ではなくちょっと曲げることで手書き感がでている.
        pa.beginShape();
        pa.vertex(centerX, centerY);
        pa.bezierVertex(centerX- vx/4+yuragiX, centerY - vy/4 + yuragiY, centerX + vx/2+yuragiX, centerY + vy/2 + yuragiY, centerX + vx, centerY + vy);
        pa.bezierVertex(centerX- vx/2+yuragiX, centerY - vy/2 + yuragiY, centerX + vx/4+yuragiX, centerY + vy/4 + yuragiY, centerX, centerY);
        pa.endShape();

        float splashWidth = 12;         // どれくらい散らばらさせるか.
        float splashNum = pa.random(6);    // 数.
        float splashSize = pa.random(3);   // 大きさ.
        for(int i=0; i<splashNum; i++)
        {
            // メインの線の周囲の絵の具が飛び散ったあとを描画.
            // 半円を直線に対してsplasWidthの幅分散らして描画しているだけ.
            pa.arc(centerX + pa.random(-splashWidth, splashWidth), centerY + pa.random(-splashWidth, splashWidth), splashSize, splashSize, 0, pa.radians(180));
        }
    }
    ///
    /// (width, height)の大きさのノイズの画像を生成する.
    /// noise_strength_list: 画像に加えるノイズの強さのリスト、ここからランダムに選んだノイズを加える.
    /// 手書き感が出る.
    ///
    public PGraphics create_noise_image(int width, int height, int[] noise_strength_list)
    {
        PGraphics dst = pa.createGraphics(width, height);
        dst.beginDraw();
        dst.loadPixels();
        int[] src = new int[]{0, 20, 50};
        for(int x=0; x<width; x++)
        {
            for(int y=0; y<height; y++)
            {
                dst.set(x, y, pa.color(255, pa.noise(x/10,y/10,x*y/50)*random_from_array(noise_strength_list)));
            }
        }
        // dst.updatePixels(); // .set呼ぶなら不要.
        dst.endDraw();
        return dst;
    }

    ///
    /// 車を描画する.
    /// x, y:描画位置.
    /// w, h:描画サイズ.
    /// cols: 塗る色(大きさ2以上、color型)
    ///
    public void draw_car(float x, float y, float w, float h, int[] cols)
    {
        //param
        float headH = pa.random(0.2f, 0.5f) * h;
        float headW = w * pa.random(0.3f, 0.7f);
        float headR = pa.min(headW, headH) * pa.random(0.1f, 0.5f);
        
        float tireDia = pa.random(0.2f, 0.5f) * h;
        float tireDia2 = tireDia * pa.random(0.3f, 0.7f);
        float tireSpan = pa.random(tireDia, w - tireDia);
        
        float bodyH = h - headH - tireDia * 0.5f;
        float bodyR = (w -headW) * pa.random(0.1f, 0.5f);
        
        //color
        int[] cols_i = shuffle(cols);
        pa.noStroke();
        
        pa.rectMode(pa.CENTER);
        pa.ellipseMode(pa.CENTER);
        
        pa.pushMatrix();
        pa.translate(x, y + pa.noise(x, y, pa.frameCount / 15) * 10);
        
        //head
        pa.fill(cols_i[0]);
        pa.rect(0, -h / 2 + headH / 2,  headW, headH, headR, headR , 0 , 0);
        
        //window
        pa.fill(cols_i[1]);
        float winNum = (int)pa.random(2, 6);
        float winSpan = headW / winNum;
        float winW = winSpan - 5;
        float winH = headH * pa.random(0.3f, 0.6f);
        float winR = winSpan * pa.random(0.1f, 0.2f);
        for(int i = 0; i < winNum; i++)
        {
            float winX = - headW / 2 + winSpan * (i  + 0.5f) ;
            float winY = - h / 2 + headH / 2  + headR /2 ;
            pa.rect(winX, winY, winW, winH, winR);
        } 
        
        //body
        pa.fill(cols_i[0]);
        pa.rect(0, -h / 2 + headH + bodyH / 2, w , bodyH, bodyR, bodyR, 0, 0);
        
        //
        float cycle = 60;
        float frameRatio = pa.frameCount % cycle / cycle;
        
        //tire
        if(pa.random(0.0f, 1.0f) < 0.9f)
        {
            pa.fill(cols_i[2]);
            pa.ellipse(tireSpan / 2, h / 2 - tireDia /2, tireDia, tireDia);
            pa.ellipse(-tireSpan / 2, h / 2 - tireDia /2, tireDia, tireDia);
            pa.fill(cols_i[1]);
            float angle = frameRatio * -pa.TAU;
            pa.arc(tireSpan / 2, h / 2 - tireDia /2, tireDia2, tireDia2, angle, angle + pa.PI);
            //ellipse(tireSpan / 2, h / 2 - tireDia /2, tireDia2, tireDia2);
            pa.arc(-tireSpan / 2, h / 2 - tireDia /2, tireDia2, tireDia2, angle, angle + pa.PI);
            //ellipse(-tireSpan / 2, h / 2 - tireDia /2, tireDia2, tireDia2);	
        }
        pa.popMatrix();
    }
    public void draw_crescent( float centerX, float centerY, int drawSize, int clr)
    {
        pa.fill(clr);
        pa.noStroke();
        float tmpX = pa.random( -drawSize/4, drawSize/4 );
        float yuragiX = pa.random( 5 );
            
        float topX = centerX + tmpX;
        float bottomX = centerX - tmpX;
        
        pa.beginShape();
        pa.vertex( topX, centerY - drawSize/2 );
        pa.bezierVertex( topX + yuragiX, centerY - drawSize/4,
                        topX + yuragiX, centerY,
                        bottomX, centerY + drawSize/2 );
        pa.bezierVertex( topX - yuragiX, centerY,
                        topX - yuragiX, centerY - drawSize/4,
                        topX, centerY - drawSize/2 );
        pa.endShape();
        
    }
    public void draw_sierpinski_gasket(int x1, int y1, int x2, int y2, int x3, int y3,  int num)
    {
        int[][][] state = {{{x1, y1}, {x2, y2}, {x3, y3}}};
        for(int i=0; i<num; i++)
        {
            state = draw_sierpinski_gasket_i(state);
        }
    }
    
    public int[][][] draw_sierpinski_gasket_i(int[][][] state)
    {
        pa.background(255);
        pa.noStroke();
        for(int i=0; i<state.length; ++i)
        {
            pa.fill(0);
            pa.triangle(state[i][0][0], state[i][0][1],
                     state[i][1][0], state[i][1][1],
                     state[i][2][0], state[i][2][1]);
        }
        int[][][] newState = new int[state.length*3][3][2];
        for(int i=0; i<newState.length; ++i)
        {
            int index = i/3;
            if(i%3 == 0)
            {
                newState[i][0][0] = state[index][0][0];
                newState[i][0][1] = state[index][0][1];
                newState[i][1][0] = (int)(0.5*(state[index][1][0] + state[index][0][0]));
                newState[i][1][1] = (int)(0.5*(state[index][1][1] + state[index][0][1]));
                newState[i][2][0] = (int)(0.5*(state[index][0][0] + state[index][2][0]));
                newState[i][2][1] = (int)(0.5*(state[index][0][1] + state[index][2][1]));
            }
            else if(i%3 == 1)
            {
                newState[i][0][0] = (int)(0.5*(state[index][1][0] + state[index][0][0]));
                newState[i][0][1] = (int)(0.5*(state[index][1][1] + state[index][0][1]));
                newState[i][1][0] = state[index][1][0];
                newState[i][1][1] = state[index][1][1];
                newState[i][2][0] = (int)(0.5*(state[index][2][0] + state[index][1][0]));
                newState[i][2][1] = (int)(0.5*(state[index][2][1] + state[index][1][1]));
            }
            else
            {
                newState[i][0][0] = (int)(0.5*(state[index][0][0] + state[index][2][0]));
                newState[i][0][1] = (int)(0.5*(state[index][0][1] + state[index][2][1]));
                newState[i][1][0] = (int)(0.5*(state[index][2][0] + state[index][1][0]));
                newState[i][1][1] = (int)(0.5*(state[index][2][1] + state[index][1][1]));
                newState[i][2][0] = state[index][2][0];
                newState[i][2][1] = state[index][2][1];
            }
        }
        return newState;
    }

    public static enum Direction
    {
        X,
        Y,
    }
    public static enum DrawMode
    {
        Parallel_to_coordinate,
        Vertical_to_line,
    }
    public void draw_while_noise_line(float xs, float ys, float xe, float ye, float size, float range, DrawMode drawMode, Direction direction)
    {
        float slope = 0;
        float rad = 0;
        if(xe != xs)
        {
            slope = (ye-ys) / (xe-xs);
            rad = pa.atan2(ye - ys, xe - xs);
        }
        else
        {
            slope = 1;
            rad = (float)0.5*pa.PI;
        }
        float x_on_line = xs;
        float y_on_line = ys;
        float x0 = xs;
        float y0 = ys;
        int[] sign_list = new int[]{-1, 1};
        while(x_on_line <= xe + 0.1
        &&    y_on_line <= ye + 0.1)
        {
            float diff = (float)0.5*size;
            float x_on_line_diff = diff*pa.cos(rad);
            float y_on_line_diff = x_on_line_diff * slope;
            if(rad == 0.5*pa.PI)
            {
                x_on_line_diff = 0;
                y_on_line_diff = diff;
            }
            x_on_line += x_on_line_diff;
            y_on_line += y_on_line_diff;
            float x1 = 0;
            float y1 = 0;
            if(drawMode == DrawMode.Vertical_to_line)
            {
                float _diff = pa.random(-range, range);
                if(pa.random(1) >= 0.80)
                {
                    _diff = random_from_array(sign_list) * pa.random(range, 3*range);
                }
                x1 = x_on_line + _diff * (-1) * pa.sin(rad);
                y1 = y_on_line + _diff * pa.cos(rad);
                if(rad == 0.5*pa.PI)
                {
                    x1 = x_on_line + _diff;
                    y1 = y_on_line;
                }
            }
            else if(drawMode == DrawMode.Parallel_to_coordinate)
            {
                if (direction == Direction.X)
                {
                    x1 = x_on_line;
                    float y_diff = pa.random(-range, range);
                    if(pa.random(1) >= 0.80)
                    {
                        y_diff = random_from_array(sign_list) * pa.random(range, 3*range);
                    }
                    y1 = y_on_line + y_diff * pa.cos(rad);
                }
                else if (direction == Direction.Y)
                {
                    y1 = y_on_line;
                    float x_diff = pa.random(-range, range);
                    if(pa.random(1) >= 0.80)
                    {
                        x_diff = random_from_array(sign_list) * pa.random(range, 3*range);
                    }
                    x1 = x_on_line + x_diff * pa.sin(rad);
                }
            }
            pa.stroke(pa.random(360), 80, 80, 100);
            pa.strokeWeight(size);
            pa.line(x0, y0, x1, y1);
            x0 = x1;
            y0 = y1;
        }
    }
}