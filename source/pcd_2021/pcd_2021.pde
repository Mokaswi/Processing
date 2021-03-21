final String URL  = "https://coolors.co/22162b-451f55-724e91-e54f6d-f8c630";
PGraphics noiseGra;
int[] cols;


void setup(){
	size(600, 600); 
	// noLoop(); 
	
	noiseGra = createGraphics(width, height);
	noiseGra.beginDraw();
	noiseGra.loadPixels();
	int[] src = new int[]{0, 20, 50};
	for(int  x=0; x<width; x++)
	{
		for(int y=0; y<height; y++)
		{
			noiseGra.set(x, y, color(255, noise(x/10,y/10,x*y/50)*random_from_array(src)));
			println(noiseGra.pixels[x+y*width]);
		}
	}
	// noiseGra.updatePixels();
	noiseGra.endDraw();
	cols = createPalette(URL);
	frameRate(60);
}

void draw(){
	randomSeed(0);
	background(100);
	//car(width/ 2, height /2 , random(0.3, 0.6) * width, random(0.3, 0.6) * height);
	drawHorizontal();
	image(noiseGra, 0, 0);
}


void car(float x, float y, float w, float h)
{
	//param
	float headH = random(0.2, 0.5) * h;
	float headW = w * random(0.3, 0.7);
	float headR = min(headW, headH) * random(0.1, 0.5);
	
	float tireDia = random(0.2, 0.5) * h;
	float tireDia2 = tireDia * random(0.3, 0.7);
	float tireSpan = random(tireDia, w - tireDia);
	
	float bodyH = h - headH - tireDia * 0.5;
	float bodyR = (w -headW) * random(0.1, 0.5);
	
	//color
	int[] cols = shuffle(createPalette(URL));
	noStroke();
	
	rectMode(CENTER);
	ellipseMode(CENTER);
	
	pushMatrix();
	translate(x, y + noise(x, y, frameCount / 15) * 10);
	
	//head
	fill(cols[0]);
	rect(0, -h / 2 + headH / 2,  headW, headH, headR, headR , 0 , 0);
	
	//window
	fill(cols[1]);
	float winNum = int(random(2, 6));
	float winSpan = headW / winNum;
	float winW = winSpan - 5;
	float winH = headH * random(0.3, 0.6);
	float winR = winSpan * random(0.1, 0.2);
	for(int i = 0; i < winNum; i++)
	{
		float winX = - headW / 2 + winSpan * (i  + 0.5) ;
		float winY = - h / 2 + headH / 2  + headR /2 ;
		rect(winX, winY, winW, winH, winR);
	} 
	
	//body
	fill(cols[0]);
	rect(0, -h / 2 + headH + bodyH / 2, w , bodyH, bodyR, bodyR, 0, 0);
	
	//
	float cycle = 60;
	float frameRatio = frameCount % cycle / cycle;
	
	//tire
	if(random(0.0, 1.0) < 0.9)
	{
		fill(cols[2]);
		ellipse(tireSpan / 2, h / 2 - tireDia /2, tireDia, tireDia);
		ellipse(-tireSpan / 2, h / 2 - tireDia /2, tireDia, tireDia);
		fill(cols[1]);
		float angle = frameRatio * -TAU;
		arc(tireSpan / 2, h / 2 - tireDia /2, tireDia2, tireDia2, angle, angle + PI);
		//ellipse(tireSpan / 2, h / 2 - tireDia /2, tireDia2, tireDia2);
		arc(-tireSpan / 2, h / 2 - tireDia /2, tireDia2, tireDia2, angle, angle + PI);
		//ellipse(-tireSpan / 2, h / 2 - tireDia /2, tireDia2, tireDia2);	
	}
	popMatrix();
}


//上から並べる
void drawHorizontal()
{
	for(float y = -0.1 * height;  y < height * 1.2; y += 0.15* height)
	{
		float x = random(-0.2, 0) * width;
		fill(255);
		while(x < width)
		{
			float w = random(0.1,0.35) * width;
			float h = random(0.08, 0.18) * height;
			car(x + w/2,  y - h/2, w , h);
			x += w * random(1.2, 1.4);
		}
	}
}

int[] createPalette(String url)
{
	int slashIndex = url.lastIndexOf("/");//一番後ろの"/"のインデックス
	String colStr = url.substring(slashIndex + 1); 
	// "3a4f41-b9314f-d5a18e-dec3be-e1dee3"
	
	String[] cols = colStr.split("-"); 
	//["3a4f41", "b9314f", "d5a18e", "dec3be", "e1dee3"]
	int[] dst = new int[cols.length];
	
	for(int i = 0; i < cols.length; i++)
	{
		dst[i] = convert_color_code_to_int(cols[i]);
	}
	//["#3a4f41", "#b9314f", "#d5a18e", "#dec3be", "#e1dee3"]

	return dst;
}


int convert_color_code_to_int(String color_code)
{
	return unhex("FF" + color_code);
}

int[] shuffle(int[] src)
{
	int[] dst = src.clone();
	for(int i=src.length-1; i > 0; --i)
	{
		int j = (int)Math.floor((double)(random(0.0, 1.0) * (i+1)));
		int tmp = dst[i];
		dst[i] = dst[j];
		dst[j] = tmp;
	}
	return dst;
}

int random_from_array(int[] src)
{
	return src[(int)random(src.length)];
}