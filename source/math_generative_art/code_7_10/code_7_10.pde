int num = 250;
int[][] state = new int[num][num];
int mod = 6;
void setup()
{
    size(500, 500);
    background(255, 255, 255);
    colorMode(HSB, 1);
    initialize();
    frameRate(24);  // 0.5秒ごとに遷移
}

void draw()
{
    drawCell();
    updateState();
}

void initialize()
{
    for(int i=0; i<num; ++i)
    {
        for(int j=0; j<num; j++)
        {
            if(i == num/2 && j == num/2)
            {
                state[i][j] = 1;
            }
            else
            {
                state[i][j] = 0;
            }
        }
    }
}


void drawCell()
{
    float scalar = (float)height / num;
    float y = 0;
    float x = 0;
    for (int i=0; i<num; ++i)
    {
        x = 0;
        for(int j=0; j<num; j++)
        {
            noStroke();
            fill(state[i][j] * 1.0 /mod, state[i][j] * 1.0 /mod, 1);
            rect(x, y, scalar, scalar);
            x += scalar;
        }
        y += scalar;
    }
}

void updateState()
{
    int[][] nextState = new int[num][num];
    for(int i=0; i<num; i++)
    {
        for(int j=0; j<num; j++)
        {
            nextState[i][j] = transition(i, j);
        }
    }
    state = nextState;
}

int transition(int i, int j)
{
    int nextC = 0;
    nextC = state[(i-1+num) % num][j]   // 上のセル.
          + state[i][(j-1+num) % num]   // 左のセル.
          + state[i][(j+1) % num]       // 右のセル.
          + state[(i+1) % num][j];      // 下のセル.
    nextC = nextC % mod;
    return nextC;
}
void mouseClicked()
{
  initialize();
  mod = int(random(2, 20));
  println(mod);
  background(0, 0, 1);
}
