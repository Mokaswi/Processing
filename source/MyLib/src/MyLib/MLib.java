package MyLib;

import processing.core.*;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintStream;

public class MLib {
    PApplet pa;
    PVector[] pointArray;
    int pointNum = 100;
    int width;
    int height;
    public MLib(PApplet pa) 
    {
        this.pa = pa;
    }
    public void setting(int width, int height)
    {
        width = width;
        height = height;
        pa.size(width, height);
    }
    public void setup()
    {
        width = 730;
        height = 488;
        pa.background(255);
        pa.smooth();
        pa.noLoop();
        pa.ellipseMode(pa.RADIUS);
        pointArray = new PVector[pointNum];
        for(int i=0; i<pointNum; i++)
        {
            pointArray[i] = new PVector(pa.random(width), pa.random(height));
        }
    }
    public void draw()
    {
        float shapeSize = width/30;
    
        pa.noStroke();
        pa.fill(51);
        pa.rect(0, 0, width, height);
        pa.noFill();
        pa.stroke(255);
    
        for(int i=0; i<pointNum-1; i++)
        {
        System.out.println("i");
        pa.line(pointArray[i].x, pointArray[i].y, pointArray[i+1].x, pointArray[i+1].y);
        }
    }
}