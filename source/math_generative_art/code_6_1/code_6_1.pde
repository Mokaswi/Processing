int mod = 17;
float scalar = 0;
void setup()
{
    size(500, 500);
    background(255);
    colorMode(HSB, 360, 100, 100);
    scalar =(float)width / mod;
    for(int i=0; i<mod; i++)
    {
        for(int j=0; j<mod; j++)
        {
            func2(i, j);
        }
    }
}


void func1(int i, int j)
{
    int num = (i+j) % mod;
    // int num = (i%j) % mod;   // 乗法表の場合.
    PVector v = new PVector(j, i);
    v.mult(scalar);
    fill(255);
    rect(v.x, v.y, scalar, scalar);
    fill(0);
    textSize(scalar);
    textAlign(LEFT, TOP);
    text(num, v.x, v.y);
}

void func2(int i, int j)
{
    ellipseMode(CENTER);
    int num = (i+j) % mod;
    // int num = (i%j) % mod;   // 乗法表の場合.
    PVector v = new PVector(j, i);
    v.mult(scalar);
    fill(num * 360.0/mod, 80, 80);
    noStroke();
    ellipse(v.x+scalar/2, v.y+scalar/2, scalar/2, scalar/2);
    // fill(0, 0, 0);
    // elipse(v.y, v.y, scalara*num/mod, scalar*num/mod);
}