import MyLib.*;

final String URL  = "https://coolors.co/22162b-451f55-724e91-e54f6d-f8c630";
PGraphics noiseGra;
Core core = new Core(this);

void setup(){
	size(600, 600); 
	int[] noise_strength_list = new int[]{0, 20, 50};
	noiseGra = core.create_noise_image(width, height, noise_strength_list);
	frameRate(60);
}

void draw(){
	randomSeed(0);
	background(100);
	//car(width/ 2, height /2 , random(0.3, 0.6) * width, random(0.3, 0.6) * height);
	drawHorizontal();
	image(noiseGra, 0, 0);
}

// todo: library化.
//上から並べる
void drawHorizontal()
{
	int[] cols = core.create_palette_from_url(URL);
	for(float y = -0.1 * height;  y < height * 1.2; y += 0.15* height)
	{
		float x = random(-0.2, 0) * width;
		fill(255);
		while(x < width)
		{
			float w = random(0.1,0.35) * width;
			float h = random(0.08, 0.18) * height;
			core.draw_car(x + w/2,  y - h/2, w, h, cols);
			x += w * random(1.2, 1.4);
		}
	}
}