int circleFill = color(0, 0, 0), lineColor = color(255, 255, 255);
int circlePosition = 1000, sign = 1;

void setup() {
  size(1500, 500);
  
  smooth();
}

void draw() {
  if(keyPressed && (key == 'b' || key == 'B')) {
    if(frameCount%25 == 0) switchCircleColor();
  }
  else circleFill = color(0, 0, 0);
  
  if(keyPressed && (key == 'l' || key == 'L')) lineColor = color(0, 0, 0);
  else lineColor = color(255, 255, 255);
  
  if(keyPressed && (key == 'c' || key == 'C')) changeBackgroundColor();
  else background(255, 255, 255);
  
  if(keyPressed && (key == 'l' || key == 'L')) lineColor = color(0, 0, 0);
  else lineColor = color(255, 255, 255);
  
  if(keyPressed && (key == 'a' || key == 'A')) moveCircle();
  else circlePosition = 1000;
  
  stroke(lineColor);
  strokeWeight(20);
  line(0, 250, width, 250);
  
  stroke(0, 0, 0);
  strokeWeight(20);
  line(50, 250, 110, 250);
  line(80, 220, 80, 280);
  
  fill(circleFill);
  noStroke();
  ellipse(circlePosition, height/2, 70, 70);
}

void switchCircleColor() {
  if(circleFill == color(255, 255, 255)) circleFill = color(0, 0, 0);
  else circleFill = color(255, 255, 255);
}

void changeBackgroundColor() {
  lineColor = color(150, 150, 150);
  background(150, 150, 150);
}

void moveCircle() {
  if(circlePosition > 1400 || circlePosition < 600) sign = sign*(-1);
  circlePosition += sign*6;
}
