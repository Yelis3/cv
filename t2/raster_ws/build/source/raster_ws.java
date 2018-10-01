import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import frames.timing.*; 
import frames.primitives.*; 
import frames.core.*; 
import frames.processing.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class raster_ws extends PApplet {






// 1. Frames' objects
Scene scene;
Frame frame;
Vector v1, v2, v3;
// timing
TimingTask spinningTask;
boolean yDirection;
// scaling is a power of 2
int n = 4;
int anti = 1;

// 2. Hints
boolean triangleHint = true;
boolean gridHint = true;
boolean debug = true;

// 3. Use FX2D, JAVA2D, P2D or P3D
String renderer = P3D;

public void setup() {
  //use 2^n to change the dimensions
  
  scene = new Scene(this);
  if (scene.is3D())
  scene.setType(Scene.Type.ORTHOGRAPHIC);
  scene.setRadius(width/2);
  scene.fitBallInterpolation();

  // not really needed here but create a spinning task
  // just to illustrate some frames.timing features. For
  // example, to see how 3D spinning from the horizon
  // (no bias from above nor from below) induces movement
  // on the frame instance (the one used to represent
  // onscreen pixels): upwards or backwards (or to the left
  // vs to the right)?
  // Press ' ' to play it
  // Press 'y' to change the spinning axes defined in the
  // world system.
  spinningTask = new TimingTask() {
    @Override
    public void execute() {
      scene.eye().orbit(scene.is2D() ? new Vector(0, 0, 1) :
      yDirection ? new Vector(0, 1, 0) : new Vector(1, 0, 0), PI / 100);
    }
  };
  scene.registerTask(spinningTask);

  frame = new Frame();
  frame.setScaling(width/pow(2, n));

  // init the triangle that's gonna be rasterized
  randomizeTriangle();
}

public void draw() {
  background(0);
  stroke(0, 255, 0);
  if (gridHint)
  scene.drawGrid(scene.radius(), (int)pow(2, n));
  if (triangleHint)
  drawTriangleHint();
  pushMatrix();
  pushStyle();
  scene.applyTransformation(frame);
  triangleRaster();
  popStyle();
  popMatrix();
}

// Implement this function to rasterize the triangle.
// Coordinates are given in the frame system which has a dimension of 2^n
public void triangleRaster() {
  // frame.location converts points from world to frame
  // here we convert v1 to illustrate the idea

  pushStyle();
  noStroke();
  fill(255, 255, 0, 125);
  // stroke(255, 0, 0, 125);
  // point(frame.location(v1).x(), frame.location(v1).y());
  // stroke(0, 255, 0, 125);
  // point(frame.location(v2).x(), frame.location(v2).y());
  // stroke(0, 0, 255, 125);
  // point(frame.location(v3).x(), frame.location(v3).y());

  int potencia = (int)Math.pow(2, n-1);
  for(float i = - potencia; i < potencia; i++){
    for(float j = - potencia; j <= potencia; j++){
      Vector p = new Vector(i+0.5f, j+0.5f);
      if(isInside(p)) {
        colorPixel(p, antiAliasing(i,j));
        rect(i, j, 1, 1);
      }
    }
  }

  popStyle();
}

public float antiAliasing(float x, float y){
  float pixelWidth = 1/(anti*1.0f);
  int subPixels=0;
  for(int i=0; i < anti;i++){
    for(int j = 0; j < anti ;j++){
      float xX = x + pixelWidth * i;
      float yY = y + pixelWidth * j;
      Vector subPixel = new Vector(xX,yY);
      if(isInside(subPixel)){
        subPixels +=1;
      }
    }
  }

  float antialiasing = Math.round(255*(subPixels/(1.0f * anti * anti)));;
  return antialiasing;
}

public void colorPixel(Vector p, float antiali) {
  Float color_1 = edgeFunction(frame.location(v2), frame.location(v3), p);
  Float color_3 = edgeFunction(frame.location(v1), frame.location(v2), p);
  Float color_2 = edgeFunction(frame.location(v3), frame.location(v1), p);

  Float totalArea = edgeFunction(frame.location(v1), frame.location(v2), frame.location(v3));

  // color_1 /= totalArea;
  // color_2 /= totalArea;
  // color_3 /= totalArea;
  color_1 /= totalArea;
  color_2 /= totalArea;
  color_3 /= totalArea;

  fill(255*color_1, 255*color_2, 255*color_3,antiali);
}

public boolean isInside(Vector p) {
  boolean e1 = edgeFunction(frame.location(v1), frame.location(v2), p) >= 0;
  boolean e2 = edgeFunction(frame.location(v2), frame.location(v3), p) >= 0;
  boolean e3 = edgeFunction(frame.location(v3), frame.location(v1), p) >= 0;

  return (e1 && e2 && e3) || (!e1 && !e2 && !e3);
}

public float edgeFunction(Vector a, Vector b, Vector c) {
  float ax = a.x(), ay = a.y();
  float bx = b.x(),  by = b.y();
  float cx = c.x(), cy = c.y();

  return (cx - ax) * (by - ay) - (cy - ay) * (bx - ax);
}

public void randomizeTriangle() {
  int low = -width/2;
  int high = width/2;
  v1 = new Vector(random(low, high), random(low, high));
  v2 = new Vector(random(low, high), random(low, high));
  v3 = new Vector(random(low, high), random(low, high));
}

public void drawTriangleHint() {
  pushStyle();
  noFill();
  strokeWeight(2);
  stroke(255, 0, 0);
  triangle(v1.x(), v1.y(), v2.x(), v2.y(), v3.x(), v3.y());
  strokeWeight(5);
  stroke(0, 255, 255);
  point(v1.x(), v1.y());
  point(v2.x(), v2.y());
  point(v3.x(), v3.y());
  popStyle();
}

public void keyPressed() {
  if (key == 'g')
  gridHint = !gridHint;
  if (key == 't')
  triangleHint = !triangleHint;
  if (key == 'd')
  debug = !debug;
  if (key == '+') {
    n = n < 7 ? n+1 : 2;
    frame.setScaling(width/pow( 2, n));
  }
  if (key == '-') {
    n = n >2 ? n-1 : 7;
    frame.setScaling(width/pow( 2, n));
  }
  if (key == 'r')
  randomizeTriangle();
  if (key == ' ')
  if (spinningTask.isActive())
  spinningTask.stop();
  else
  spinningTask.run(20);
  if (key == 'y')
  yDirection = !yDirection;
  if (key == 'i'){
  anti = anti*2;
    if (anti > 8){
      anti=1;
    }
  }
}
  public void settings() {  size(1024, 810, renderer); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "raster_ws" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
