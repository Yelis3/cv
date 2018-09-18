int smallSquare = 155, bigSquare = 400;
int innColor = color(160,102,5);
int i = 250, j = 160, sign = 1, extColor = color(i, j, 1);
  
void setup() {
  size(600, 600);
  background(255, 255, 255);
}

void draw() {
  noStroke();
  
  if(mousePressed) extColor = color(255, 255, 255);
  else extColor = color(i, j, 1);
  
  fill(extColor);
  rect(width/2 - bigSquare/2, height/2 - bigSquare/2, bigSquare, bigSquare);
  
  fill(innColor);
  rect(width/2 - smallSquare/2, height/2 - smallSquare/2, smallSquare, smallSquare);
  
  
  i += sign*4;
  j += sign*4;
  if(i >= 255 || j >= 160) {
    sign = -1;
  }
  if(i <= 90 || j <= 0) {
    sign = 1;
  }
}
