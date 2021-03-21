int num = 8;
int[] state = {1};
int gen = 0;
vid setup()
{
    size(500, 500);
}

void draw()
{
    if(gen < num)
    {
        drawNumber(gen);
        updateState()
    }
}