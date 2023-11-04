int numA = 10;
int numB = 6;
int thr = 160;
float ratio = (float) numB / numA;
void setup()
{
    size(500, 500);
    colorMode(HSB, 1);
    divSquare(0, 0, width);
}

void draw()
{

}

// 正方形を長方形に分割する関数.
void divSquare(float xPos, float yPos, float wd)
{å
    int itr = 0;
    float xEndPos = wd + xPos;
    float yEndPos = wd + yPos;
    fill(color(random(1), 1 ,1));
    rect(xPos, yPos, wd, wd);
    while(wd > thr)
    {
        itr++;
        if(itr % 2 == 1)
        {
            while (xPos + wd * ratio < xEndPos + 0.1)
            {
                divRectangle(xPos, yPos, wd * ratio);
                xPos += wd * ratio;
            }
            wd = xEndPos - xPos;
        }
        else
        {
            while (yPos + wd / ratio < yEndPos + 0.1)
            {
                divRectangle(xPos, yPos, wd);
                yPos += wd / ratio;
            }
            wd = yEndPos - yPos;
        }
    }
}

// 長方形を正方形に分割する関数.
void divRectangle(float xPos, float yPos, float wd)
{
    int itr = 0;
    float xEndPos = xPos + wd;
    float yEndPos = yPos + wd / ratio;
    fill(color(random(1), 1, 1));
    rect(xPos, yPos, wd, wd);
    while(wd > thr)
    {
        itr++;
        if(itr % 2 == 1)
        {
            while (xPos + wd < xEndPos + 0.1)
            {
                divSquare(xPos, yPos, wd);
                xPos += wd;
            }
            wd = xEndPos - xPos;
        }
        else
        {
            while (yPos + wd < yEndPos + 0.1)
            {
                divSquare(xPos, yPos, wd);
                yPos += wd;
            }
            wd = yEndPos - yPos;
        }
    }
}

void mouseClicked()
{
    numA = (int)random(1, 20);
    numB = (int)random(1, 20);
    while(numA == numB)
    {
        numB = (int)random(1, 20);
    }
    thr = (int)random(10, 300);
    ratio = (float)numA / numB;
    background(0, 0, 1);
    divSquare(0, 0, width);
}