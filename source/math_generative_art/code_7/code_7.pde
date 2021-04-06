int num = 250;
int[] state = {1};
int gen = 0;
int mod = 2;
void setup()
{
    size(500, 500);
    background(255, 255, 255, 255);
    colorMode(HSB, 360, 100, 100, 100);
}

void draw()
{
    if(gen < num)
    {
        // drawNumber(gen);
        drawCell(gen);
        updateState();
    }
}

void drawNumber(float y)
{
    float scalar = width / num; // 表示するマス目の大きさ.
    float x = (width - state.length*scalar) * 0.5;
    y *= scalar;
    fill(0);
    for(int i=0; i<state.length; ++i)
    {
        textSize(scalar * 0.5);
        text(state[i], x+scalar*0.5, y+scalar*0.5);
        x+= scalar;
    }
}

void drawCell(float y)
{
    float scalar = (float)width / num;
    float x = (width - state.length * scalar) * 0.5;
    y *= scalar;
    noStroke();
    for (int i=0; i<state.length; ++i)
    {
        if(state[i] != 0)
        {
            colorMode(HSB, 360, 100, 100, 100);
            fill(360 * state[i] * 1.0 / mod, 80, 80, 100);
        }
        else
        {
            colorMode(RGB);
            fill(255, 255, 255);
        }
        rect(x, y, scalar, scalar);
        x += scalar;
    }
}

void updateState()
{
    int[] BOUNDARY = {0, 0};
    int[] nextState = new int[state.length + 2];
    state = splice(state, BOUNDARY, 0);
    state = splice(state, BOUNDARY, state.length);
    for(int i=1; i<state.length-1; i++)
    {
        nextState[i-1] = transition(state[i-1], state[i], state[i+1]);
    }
    state = nextState;
    gen++;
}

int transition(int a, int b, int c)
{
    int d = 0;

    int ruleInt = (int)(a * pow(2, 2) + b*pow(2,1) + c*pow(2,0));
    d = ru
    return d;
}

// void updateState()
// {
//     int[] BOUNDARY = {0};
//     int[] nextState = new int[state.length + 1];
//     state = splice(state, BOUNDARY, 0);
//     state = splice(state, BOUNDARY, state.length);
//     for(int i=0; i<state.length-1; ++i)
//     {
//         nextState[i] = transition(i);
//     }
//     state = nextState;
//     gen++;
// }

int transition(int i)
{
    return (state[i+1] + state[i]) % mod;
}