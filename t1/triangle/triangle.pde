float sizer;
void setup() {
  size(800, 600, P3D);

  fill(130);

  sizer = 50;
}

void draw() {
  background(0);
  translate(400, 200, 0); 
  
  rotateY((PI + mouseX/float(width) * PI)*2);
  //rotateX((PI + mouseY/float(height) * PI)*2);
  
  //float cameraY = 2*height/3.0;
  //float fov = (width/2)/float(width) * PI/2;
  //float cameraZ = cameraY / tan(fov / 2.0);
  //float aspect = float(width)/float(height);
  
  //perspective(fov, aspect, cameraZ/10.0, cameraZ*10.0);
  for (int i=0; i<4; i++) {
    box(sizer);
    translate(0, sizer, 0);
  }
  box(sizer);
  for (int i = 0; i<4; i++) {
    translate(sizer, 0, 0);
    box(sizer);
  }
  translate(-(sizer*4), -(sizer*4), sizer);
  box(sizer);
  translate(0, 0, sizer);
  box(sizer);
  
  beginShape();
  vertex(-(sizer/2),-(sizer/2),(sizer/2));
  vertex((sizer/2),-(sizer/2),(sizer/2));
  vertex((sizer/2),-(sizer/2),((3*sizer)/2));
  vertex(-(sizer/2),-(sizer/2),((3*sizer)/2));
  endShape();
  beginShape();
  vertex((sizer/2),-(sizer/2),(sizer/2));
  vertex((sizer/2),(sizer/2),(sizer/2));
  vertex((sizer/2),-(sizer/2),((3*sizer)/2));
  endShape();
  
  beginShape();
  vertex(-(sizer/2),-(sizer/2),(sizer/2));
  vertex(-(sizer/2),(sizer/2),(sizer/2));
  vertex(-(sizer/2),-(sizer/2),((3*sizer)/2));
  endShape();
  
  beginShape();
  vertex(-(sizer/2),(sizer/2),(sizer/2));
  vertex((sizer/2),(sizer/2),(sizer/2));
  vertex((sizer/2),-(sizer/2),((3*sizer)/2));
  vertex(-(sizer/2),-(sizer/2),((3*sizer)/2));
  endShape();
  
 // vertex(-25,-25,75);
  
}
