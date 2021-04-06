int numA = 3;
int numB = 10;
int thr = 3;
int count = 0;

void setup()
{
    size(500, 500);
    colorMode(HSB, 1);
    float ratio = (float) numB / numA;
    divSquare(0, 0, width, ratio);
}

void draw()
{

}

// 正方形を長方形に分割する関数.
void divSquare(float xPos, float yPos, float wd, float ratio)
{
    int itr = 0;
    float xEndPos = wd + xPos;
    float yEndPos = wd + yPos;
    while(wd > 0.1)
    {
        itr++;
        fill(color(random(1), 1, 1));
        if(itr % 2 == 1)
        {
            while (xPos + wd * ratio < xEndPos + 0.1)
            {
                if(count++ >= thr)
                {
                    rect(xPos, yPos, wd * ratio, wd);
                }
                else
                {
                    divRectangle(xPos, yPos, wd * ratio, wd);
                }
                xPos += wd * ratio;
            }
            wd = xEndPos - xPos;
        }
        else
        {
            while (yPos + wd / ratio < yEndPos + 0.1)
            {
                if(count++ >= thr)
                {
                    rect(xPos, yPos, wd * ratio, wd);
                }
                else
                {
                    divRectangle(xPos, yPos, wd * ratio, wd);
                }
                yPos += wd / ratio;
            }
            wd = yEndPos - yPos;
        }
    }
}

// 長方形を正方形に分割する関数.
void divRectangle(float xPos, float yPos, float width, float height)
{
    int itr = 0;
    float wd = 0;
    if(width > height)
    {
        wd = width;
    }
    else
    {
        wd = height;
    }
    float xEndPos = width + xPos;
    float yEndPos = height + yPos;
    while(wd > 0.1)
    {
        itr++;
        fill(color(random(1), 1, 1));
        if(itr % 2 == 1)
        {
            while (xPos + wd < xEndPos + 0.1)
            {
                if(count++ >= thr)
                {
                    rect(xPos, yPos, wd, wd);
                }
                else
                {
                    divSquare(xPos, yPos, wd, width / height);
                }
                xPos += wd;
            }
            wd = xEndPos - xPos;
        }
        else
        {
            while (yPos + wd < yEndPos + 0.1)
            {
                if(count++ >= thr)
                {
                    rect(xPos, yPos, wd, wd);
                }
                else
                {
                    divSquare(xPos, yPos, wd, width / height);
                }
                yPos += wd;
            }
            wd = yEndPos - yPos;
        }
    }
}