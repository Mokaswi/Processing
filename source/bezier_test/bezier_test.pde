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
      fill( colorHue, 70, 100, 60 );
      noStroke();
      drawShape( drawPointX, drawPointY, shapeSize );
    }
  }
 
}
 
void drawShape( float centerX, float centerY, int drawSize ) {
 
  float tmpX = random( -drawSize/4, drawSize/4 );
  float yuragiX = random( 5 );
   
  float topX = centerX + tmpX;
  float bottomX = centerX - tmpX;
 
  beginShape();
  vertex( topX, centerY - drawSize/2 );
  bezierVertex( topX + yuragiX, centerY - drawSize/4,
                topX + yuragiX, centerY,
                bottomX, centerY + drawSize/2 );
  bezierVertex( topX - yuragiX, centerY,
                topX - yuragiX, centerY - drawSize/4,
                topX, centerY - drawSize/2 );
  endShape();
 
}