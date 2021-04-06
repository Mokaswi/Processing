import MyLib.*;

Core core = new Core(this);

void setup()
{
    size(500, 500);
    noLoop();
    background(0, 0, 0);
    colorMode(HSB, 360, 100, 100, 100);
    core.draw_while_noise_line(0, 200, 500, 300, 5, 10, Core.DrawMode.Parallel_to_coordinate, Core.Direction.X);
    core.draw_while_noise_line(100, 0, 100, 500, 5, 10, Core.DrawMode.Parallel_to_coordinate, Core.Direction.Y);
    core.draw_while_noise_line(100, 0, 300, 500, 5, 50, Core.DrawMode.Parallel_to_coordinate, Core.Direction.Y);
    core.draw_while_noise_line(0, 0, 500, 500, 5, 50, Core.DrawMode.Parallel_to_coordinate, Core.Direction.Y);
    core.draw_while_noise_line(0, 300, 500, 500, 5, 50, Core.DrawMode.Vertical_to_line, Core.Direction.X);
    core.draw_while_noise_line(200, 0, 200, 500, 5, 50, Core.DrawMode.Vertical_to_line, Core.Direction.Y);
}

void draw()
{

}