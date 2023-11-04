color color_list[] = new color[5];
int num = 260;

void setup()
{
  size(1000, 1000, P3D);
  noLoop();
  noStroke();
  colorMode(HSB, 360, 100, 100, 100);
  color_list[0] = color(random(360), 50, 50, 70);
  color_list[1] = color(random(360), 50, 50, 70);
  color_list[2] = color(random(360), 50, 50, 70);
  color_list[3] = color(random(360), 50, 50, 70);
  color_list[4] = color(random(360), 50, 50, 70);
}

void draw()
{
  colorMode(RGB, 255, 255, 255);
  background(255);
  translate(width/2, height/2, 0);
  rotateY(radians(-25));
  rotateX(radians(5));
  float centx = 0;
  float centy = 0;
  float sphere_radius = 330;
  for (int i = 0; i < num; i++)
  {
    float t = random(360);
    if (t < 15 || t > 345)
    {
      i--;
      continue;
    }
    colorMode(HSB, 360, 100, 100);
    color col = color_list[(int)(random(color_list.length))];
    float z = sphere_radius * cos(radians(t));
    float radius = random(sphere_radius) + 50;
    float start_s_angle = random(360);
    float end_s_angle = start_s_angle + noise(random(10)) * 100 + 60;
    float angle_step = 5;
    if (i > num/10 * 2)
    {
      angle_step = 1;
    }
    draw_arch(radius, centx, centy, z, start_s_angle, end_s_angle, angle_step, col);
  }
}


void draw_arch(float radius, float centx, float centy, float centz, float start_s_angle, float end_s_angle, float angle_step, color col) 
{
    fill(col);
    float box_x = 10;
    float box_z = 2;
    float box_y = random(box_x/2);
    if (angle_step == 1)
    {
      float outside_radius = radius;
      box_y = sqrt( pow(outside_radius*cos(radians(angle_step)) - outside_radius*cos(radians(0)), 2) + 
                    pow(outside_radius*sin(radians(angle_step)) - outside_radius*sin(radians(0)), 2));
    }
    for (float s = start_s_angle; s < end_s_angle; s+=angle_step)
    {
      float x = centx + radius * cos(radians(s));
      float y = centy + radius * sin(radians(s));
      pushMatrix();
      translate(x, y, centz);
      rotateZ(radians(s));
      box(box_x, box_y, box_z);
      popMatrix();
    }
}
