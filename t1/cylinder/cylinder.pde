int h = 500, w = 800;
int circleRadios = 15;
int lineLength = 10;
int y =0, sign = 1;

void setup() {
  size(800, 500);
}

void draw() {
  background(0,0,0);
  
  // draw circles
  for(int i=0; i<22; i++) {
    drawCircle(30*i, y);
  }
  
  // change positions
  if(y <= 0) sign =1;
  if(y >= h) sign = -1;
  y = y + 9*sign;
}

void drawCircle(int x, int y) {
  ellipse(x, y, circleRadios, circleRadios);
  stroke(255);
  line(x-lineLength, y, x+lineLength, y);
  line(x, y-lineLength, x, y+lineLength);
}
