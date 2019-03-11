// Daniel Shiffman
// http://codingtra.in
// http://patreon.com/codingtrain

// Videos
// https://youtu.be/HyK_Q5rrcr4
// https://youtu.be/D8UgRyRnvXU
// https://youtu.be/8Ju_uxJ9v44
// https://youtu.be/_p5IH0L63wo

// Depth-first search
// Recursive backtracker
// https://en.wikipedia.org/wiki/Maze_generation_algorithm
import frames.primitives.*;
import frames.core.*;
import frames.processing.*;

import org.gamecontrolplus.*;
import net.java.games.input.*;

ControlIO control;
ControlDevice device; // my SpaceNavigator
ControlSlider j1x; // Positions
ControlSlider j1y;
ControlSlider z1;
ControlSlider j2x; // Rotations
ControlSlider j2y;
//ControlSlider snZRot;
ControlButton a; // Buttons
ControlButton b;
ControlButton lb; // Buttons
ControlButton rb;
ControlHat hat;

Scene scene;
float xp=0;
float yp=0;
float zp=0;

int cols, rows;
int w = 40;
ArrayList<Cell> grid = new ArrayList<Cell>();

Cell current;

ArrayList<Cell> stack = new ArrayList<Cell>();

PImage label, floor;


void setup() {
  size(600, 600, P3D);
  openSpaceNavigator();
  scene = new Scene(this);
  scene.setRadius(1500);
  //scene.fit(1);
  cols = floor(width/w);
  rows = floor(height/w);
  label = loadImage("lachoy.jpg");
  floor = loadImage("floor.jpg");
  //frameRate(5);

  for (int j = 0; j < rows; j++) {
    for (int i = 0; i < cols; i++) {
      Cell cell = new Cell(i, j, label, floor);
      grid.add(cell);
    }
  }

  current = grid.get(0);
  
  scene.eye().setPosition(10,-10,30);
  

}

void draw() {

  //translate(0,0,-600);
  rotateX(PI/2);
  
  //scene.translate("SPCNAV", 10 * j1x.getValue(), 10 * j1y.getValue(), 10 * z1.getValue());
  //scene.rotate("SPCNAV", -j2x.getValue() * 20 * PI / width, j2y.getValue() * 20 * PI / width, snZRot.getValue() * 20 * PI / width);
  
  spaceNavigatorInteraction();
  
  grid.get(0).walls[3]=false;
  grid.get(grid.size()-1).walls[2]=false;
  
  background(51);
  for (int i = 0; i < grid.size(); i++) {
    grid.get(i).show();
  }

  current.visited = true;
  current.highlight();
  
  // STEP 1
  Cell next = current.checkNeighbors();
  if (next != null) {
    next.visited = true;

    // STEP 2
    stack.add(current);

    // STEP 3
    removeWalls(current, next);

    // STEP 4
    current = next;
  } else if (stack.size() > 0) {
    current = stack.remove(stack.size()-1);
  }
}

int index(int i, int j) {
  if (i < 0 || j < 0 || i > cols-1 || j > rows-1) {
    return 0;
  }
  return i + j * cols;
}

void spaceNavigatorInteraction() {
  
  xp=10 * (hat.right()?-1:(hat.left()?1:0));
  yp=10 * (hat.up()?1:(hat.down()?-1:0));
  zp=1 * z1.getValue();
  scene.translate( xp, yp,zp );
  scene.translate(-5* j1x.getValue(), 0,j1y.getValue() );
  //scene.rotate( -j2x.getValue() * 20 * PI / width, j2y.getValue() * 20 * PI / width, z1.getValue() * 20 * PI / width);
  
    
    //scene.translate( 10, 10 , 10 );
 //scene.rotate(  (lb.pressed()? 1:0)*-5* PI / width, (rb.pressed()? 1:0) *5* PI / width,  0, scene.eye());
 scene.lookAround((j2x.getValue()*5* PI / width),(j2y.getValue()*5* PI / width));
 //println(scene.eye().position());
 //println(hat.right());
}

void mouseMoved() {
  scene.cast();
}

void mouseDragged() {
  if (mouseButton == LEFT)
    scene.spin();
  else if (mouseButton == RIGHT)
    scene.translate();
  else
    scene.scale(scene.mouseDX());
}

void mouseWheel(MouseEvent event) {
  scene.moveForward(event.getCount() * 20);
}

void removeWalls(Cell a, Cell b) {
  int x = a.i - b.i;
  if (x == 1) {
    a.walls[3] = false;
    b.walls[1] = false;
  } else if (x == -1) {
    a.walls[1] = false;
    b.walls[3] = false;
  }
  int y = a.j - b.j;
  if (y == 1) {
    a.walls[0] = false;
    b.walls[2] = false;
  } else if (y == -1) {
    a.walls[2] = false;
    b.walls[0] = false;
  }
}

void openSpaceNavigator() {
  println(System.getProperty("os.name"));
  control = ControlIO.getInstance(this);
  String os = System.getProperty("os.name").toLowerCase();
  if (os.indexOf("nix") >= 0 || os.indexOf("nux") >= 0)
    device = control.getMatchedDevice("xbox360");// magic name for linux
  else
    device = control.getMatchedDevice("xbox360");//magic name, for windows
  if (device == null) {
    println("No suitable device configured");
    System.exit(-1); // End the program NOW!
  }
  //device.setTolerance(5.00f);
  j1x = device.getSlider("j1x");
  j1y = device.getSlider("j1y");
  z1 = device.getSlider("z1");
  j2x = device.getSlider("j2x");
  j2y = device.getSlider("j2y");
  //snZRot = device.getSlider(5);
  a = device.getButton("a");
  b = device.getButton("b");
  lb = device.getButton("lb");
  rb = device.getButton("rb");
  hat = device.getHat("hat");
}
