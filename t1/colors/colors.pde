int smallSquare = 155, bigSquare = 400;
int innerColor = color(160,102,5);
int i = 255, sign = 1;
int extColor1 = color(255, 235, 59),  extColor2 = color(132, 44, 16);
  
void setup() {
  size(600, 600);
}

void draw() {
  noStroke();
  
  fill(color(i%255, 235, 59));
  rect(width/2 - bigSquare/2, height/2 - bigSquare/2, bigSquare, bigSquare);
  
  fill(innerColor);
  rect(width/2 - smallSquare/2, height/2 - smallSquare/2, smallSquare, smallSquare);
  
  
  i++;
}
