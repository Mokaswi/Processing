import MyLib.*;
Core core = new Core(this);
void setup() {
  size( 500, 500 );
  background( 255 );
  smooth();
  noLoop();
  colorMode( HSB, 360, 100, 100, 100 );
}
 
void draw() {
   
  int repeatNum = 20;
  int shapePitch = 20;
  int shapeSize = 100;
   
  int pitchWidth = shapePitch * ( repeatNum - 1 );
  int leftX = ( width - pitchWidth ) / 2;
 
  for( int i = 0; i < repeatNum; i++ ) {
    for( int j = 0; j < repeatNum; j++ ) {
      float drawPointX = leftX + j * shapePitch;
      float drawPointY = leftX + i * shapePitch;
       
      float colorHue = random( 360 );
      color cls = color( colorHue, 70, 100, 60 );
      core.draw_crescent( drawPointX, drawPointY, shapeSize, cls );
    }
  }
}
