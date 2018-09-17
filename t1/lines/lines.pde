int squareSize = 80;

void setup() {
  size(1200, 600);
  background(0);
  noStroke();
  
  // draw big blue squares
  fill(color(215, 235, 252));
  for(float i=0; i<(height/squareSize)+1; i++) {
    rect(i*squareSize*2, 0, squareSize, height);
  }
  
  fill(color(135, 172, 235));
  for(float i=0.5; i<(width/squareSize)+1; i++) {
    rect(0, i*squareSize*2, width, squareSize);
  }
}

void draw() {
  if (mousePressed == true) {
    // draw small checked squares
    int rotate;
    for(int i=0; i<(height/squareSize)*2+2; i++) {
      if(floor(i/2)%2 == 0) rotate = 3; else rotate = 1;
      for(int j=0; j<(width/squareSize)*2; j++) {
        if(rotate == 1) rotate = 3; else rotate = 1;
        checkedSquare(j*squareSize, i*squareSize, rotate);
      }
    }
  }
}

void checkedSquare(int x, int y, int r) {
  pushMatrix();
  translate(x, y);
  rotate(r*PI/4);
  
  fill(0);
  rect(-10, -10, 10, 10);
  rect(0, 0, 10, 10);
  
  fill(255);
  rect(0, -10, 10, 10);
  rect(-10, 0, 10, 10);
  popMatrix();
}
