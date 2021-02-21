ArrayList<AppBase> apps;
int selected;

void setup()
{
    size(960, 540);
    colorMode(HSB, 360, 100, 100);

    apps = new ArrayList<AppBase>();
    apps.add(new RedCircle(this));
    apps.add(new BlueSquare(this));

    for(AppBase app:apps)
    {
        app.setup();
    }
    selected = 0;
}

void draw()
{
    apps.get(selected).update();
    apps.get(selected).draw();
}

void keyPressed()
{
    if(key == '0')
    {
        selected = 0;
    }
    else if(key == '1')
    {
        selected = 1;
    }
}

void mousePressed()
{
    apps.get(selected).mousePressed();
}