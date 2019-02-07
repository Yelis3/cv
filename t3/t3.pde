ArrayList<Frame> controlFrames = new ArrayList<Frame>();
int n = 4; // Numero de puntos de control para una curva grado n-1

class Boid {

  // En algun punto de la clase se hace el 1er punto :v
  public Frame frame;
  // fields
  Vector position, velocity, acceleration, alignment, cohesion, separation; // position, velocity, and acceleration in
  // a vector datatype
  float neighborhoodRadius; // radius in which it looks for fellow boids
  float maxSpeed = 4; // maximum magnitude for the velocity vector
  float maxSteerForce = .1f; // maximum magnitude of the steering vector
  float sc = 3; // scale factor for the render of the boid
  float flap = 0;
  float t = 0;


  ///////////////////////////////////////////  Declaracion Face to Vertex

     float three= 3 * sc;
     float two= 2 * sc;
     int[][] faces= {{0,1,2},
                     {0,1,3},
                     {0,3,2},
                     {3,1,2}};
     float[][] vertes= {{three, 0, 0},
                       {-three, two, 0},
                       {-three, -two, 0},
                       {-three, 0, two}};





       // for(int i=0;i<4;i++){
       //  for(int j=0;j<3;j++){
       //    int v=faces[i][j];
       //    sh.vertex(vertes[v][0],vertes[v][1],vertes[v][2]);
       //  }
       //}


    ///////////////////////////////////////////  Declaracion Vertex to Vertex




      ArrayList< ArrayList<float[]> > figure = new ArrayList< ArrayList<float[]> >();
     float[] vertes0= {three, 0, 0};
     float[] vertes1=  {-three, two, 0};
     float[] vertes2={-three, -two, 0};
     float[] vertes3=  {-three, 0, two};


     float[] v0= {1, 2, 3};
     float[] v1=  {0, 2, 3};
     float[] v2={0, 1, 3};
     float[] v3=  {0, 1, 2};

     ArrayList<float[]> ver0 = new ArrayList<float[]>();

     ArrayList<float[]> ver1 = new ArrayList<float[]>();

     ArrayList<float[]> ver2 = new ArrayList<float[]>();

     ArrayList<float[]> ver3 = new ArrayList<float[]>();

     ///////////////////////////////////////////  Fin Declaracion



  PShape sh;   ////////// Modo retenido
  Boid(Vector inPos) {
    position = new Vector();
    position.set(inPos);
    frame = new Frame(scene) {
      // Note that within visit() geometry is defined at the
      // frame local coordinate system.
      @Override
      public void visit() {
        if (animate)
          run(flock);
        render();
      }
    };
    frame.setPosition(new Vector(position.x(), position.y(), position.z()));
    velocity = new Vector(random(-1, 1), random(-1, 1), random(1, -1));
    acceleration = new Vector(0, 0, 0);
    neighborhoodRadius = 100;

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////   Modo retenido ///////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if(!modeR){


    sh = createShape();

     if(typeR){

       // println("Entro a retenido true");

       sh.beginShape(TRIANGLE_STRIP);
           sh.stroke(color(255,0, 0));
          sh.fill(color(0, 255, 0, 125));
       for(int i=0;i<4;i++){
         for(int j=0;j<3;j++){
           int v=faces[i][j];
           sh.vertex(vertes[v][0],vertes[v][1],vertes[v][2]);
         }
       }



       sh.endShape();
     }
     if(!typeR){
       println("Entro a retenido false");
       ver0.add(vertes0);
       ver0.add(v0);
       figure.add(ver0);


       ver1.add(vertes1);
       ver1.add(v1);
       figure.add(ver1);


       ver2.add(vertes2);
       ver2.add(v2);
       figure.add(ver2);


       ver3.add(vertes3);
       ver3.add(v3);
       figure.add(ver3);

       sh.beginShape(TRIANGLE_STRIP);
           sh.stroke(color(0, 255, 0));
          sh.fill(color(255, 0, 0, 125));
        for(int i=0; i< 4;i++){
           ArrayList<float[]> v = figure.get(i);
           float[] o = v.get(0);
           float[] d = v.get(1);
           for(int j=0; j<3;j++){
             ArrayList<float[]> ve = figure.get((int) d[j]);
             float[] de = ve.get(0);
             //sh.line(o[0],o[1],o[2],de[0],de[1],de[2]);

             int ver=0;
             switch(i){
               case 0:
                 ver =(int) v0[j];
               break;

               case 1:
                  ver =(int) v1[j];
               break;

               case 2:
                 ver =(int) v2[j];
               break;

               case 3:
                 ver =(int) v3[j];
               break;
             }

             switch(ver){
               case 0:
                 fill(color(234, 0, 234, 125));
                 sh.vertex(vertes0[0],vertes0[1],vertes0[2]);
               break;

               case 1:
                   fill(color(234, 0, 234, 125));
                  sh.vertex(vertes1[0],vertes1[1],vertes1[2]);
               break;

               case 2:
                 fill(color(234, 0, 234, 125));
                 sh.vertex(vertes2[0],vertes2[1],vertes2[2]);

               break;

               case 3:
                 fill(color(234, 0, 234, 125));
                 sh.vertex(vertes3[0],vertes3[1],vertes3[2]);

               break;
             }
           }
         }

        sh.endShape();
     }

    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  }

  public void run(ArrayList<Boid> bl) {
    t += .1;
    flap = 10 * sin(t);
    // acceleration.add(steer(new Vector(mouseX,mouseY,300),true));
    // acceleration.add(new Vector(0,.05,0));
    if (avoidWalls) {
      acceleration.add(Vector.multiply(avoid(new Vector(position.x(), flockHeight, position.z())), 5));
      acceleration.add(Vector.multiply(avoid(new Vector(position.x(), 0, position.z())), 5));
      acceleration.add(Vector.multiply(avoid(new Vector(flockWidth, position.y(), position.z())), 5));
      acceleration.add(Vector.multiply(avoid(new Vector(0, position.y(), position.z())), 5));
      acceleration.add(Vector.multiply(avoid(new Vector(position.x(), position.y(), 0)), 5));
      acceleration.add(Vector.multiply(avoid(new Vector(position.x(), position.y(), flockDepth)), 5));
    }
    flock(bl);
    move();
    checkBounds();
  }

  Vector avoid(Vector target) {
    Vector steer = new Vector(); // creates vector for steering
    steer.set(Vector.subtract(position, target)); // steering vector points away from
    steer.multiply(1 / sq(Vector.distance(position, target)));
    return steer;
  }

  //-----------behaviors---------------

  void flock(ArrayList<Boid> boids) {
    //alignment
    alignment = new Vector(0, 0, 0);
    int alignmentCount = 0;
    //cohesion
    Vector posSum = new Vector();
    int cohesionCount = 0;
    //separation
    separation = new Vector(0, 0, 0);
    Vector repulse;
    for (int i = 0; i < boids.size(); i++) {
      Boid boid = boids.get(i);
      //alignment
      float distance = Vector.distance(position, boid.position);
      if (distance > 0 && distance <= neighborhoodRadius) {
        alignment.add(boid.velocity);
        alignmentCount++;
      }
      //cohesion
      float dist = dist(position.x(), position.y(), boid.position.x(), boid.position.y());
      if (dist > 0 && dist <= neighborhoodRadius) {
        posSum.add(boid.position);
        cohesionCount++;
      }
      //separation
      if (distance > 0 && distance <= neighborhoodRadius) {
        repulse = Vector.subtract(position, boid.position);
        repulse.normalize();
        repulse.divide(distance);
        separation.add(repulse);
      }
    }
    //alignment
    if (alignmentCount > 0) {
      alignment.divide((float) alignmentCount);
      alignment.limit(maxSteerForce);
    }
    //cohesion
    if (cohesionCount > 0)
      posSum.divide((float) cohesionCount);
    cohesion = Vector.subtract(posSum, position);
    cohesion.limit(maxSteerForce);

    acceleration.add(Vector.multiply(alignment, 1));
    acceleration.add(Vector.multiply(cohesion, 3));
    acceleration.add(Vector.multiply(separation, 1));
  }

  void move() {
    velocity.add(acceleration); // add acceleration to velocity
    velocity.limit(maxSpeed); // make sure the velocity vector magnitude does not
    // exceed maxSpeed
    position.add(velocity); // add velocity to position
    frame.setPosition(position);
    frame.setRotation(Quaternion.multiply(new Quaternion(new Vector(0, 1, 0), atan2(-velocity.z(), velocity.x())),
      new Quaternion(new Vector(0, 0, 1), asin(velocity.y() / velocity.magnitude()))));
    acceleration.multiply(0); // reset acceleration
  }

  void checkBounds() {
    if (position.x() > flockWidth)
      position.setX(0);
    if (position.x() < 0)
      position.setX(flockWidth);
    if (position.y() > flockHeight)
      position.setY(0);
    if (position.y() < 0)
      position.setY(flockHeight);
    if (position.z() > flockDepth)
      position.setZ(0);
    if (position.z() < 0)
      position.setZ(flockDepth);
  }

  void render() {



    pushStyle();

    // uncomment to draw boid axes
    //scene.drawAxes(10);

    strokeWeight(2);
    stroke(color(40, 255, 40));
    fill(color(0, 255, 0, 125));

    // highlight boids under the mouse
    if (scene.trackedFrame("mouseMoved") == frame) {
      stroke(color(0, 0, 255));
      fill(color(0, 0, 255));
    }

    // highlight avatar
    if (frame ==  avatar) {
      stroke(color(255, 0, 0));
      fill(color(255, 0, 0));
    }
     ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
     //////////////////////////////////////////////////   Modo retenido ///////////////////////////////////////////////////////////////////////
     //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if(!modeR){
      shape(sh);
    }

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////   Modo inmediato ///////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if(modeR){

      /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      //////////////////////////////////////////////////////////    Face to vertex  ///////////////////////////////////////////////////////////////
      /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      if(typeR){

       beginShape(TRIANGLES);
       stroke(color(0, 255, 0));
      fill(color(255, 40, 255, 125));
         for(int i=0;i<4;i++){
          for(int j=0;j<3;j++){
            int v=faces[i][j];
            vertex(vertes[v][0],vertes[v][1],vertes[v][2]);
          }
        }
       endShape();
      }


      /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      //////////////////////////////////////////////////////////    Vertex to vertex  ///////////////////////////////////////////////////////////////
      /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      if(!typeR){




       ver0.add(vertes0);
       ver0.add(v0);
       figure.add(ver0);


       ver1.add(vertes1);
       ver1.add(v1);
       figure.add(ver1);


       ver2.add(vertes2);
       ver2.add(v2);
       figure.add(ver2);


       ver3.add(vertes3);
       ver3.add(v3);
       figure.add(ver3);

       beginShape(TRIANGLES);
       stroke(color(255, 40, 255));
      fill(color(0, 255, 0, 125));
        for(int i=0; i< 4;i++){
           ArrayList<float[]> v = figure.get(i);
           float[] o = v.get(0);
           float[] d = v.get(1);
           for(int j=0; j<3;j++){

             //ArrayList<float[]> ve = figure.get((int) d[j]);
             //float[] de = ve.get(0);
             //line(o[0],o[1],o[2],de[0],de[1],de[2]);


             int ver=0;
             switch(i){
               case 0:
                 ver =(int) v0[j];
               break;

               case 1:
                  ver =(int) v1[j];
               break;

               case 2:
                 ver =(int) v2[j];
               break;

               case 3:
                 ver =(int) v3[j];
               break;
             }

             switch(ver){
               case 0:
                 fill(color(234, 0, 234, 125));
                 vertex(vertes0[0],vertes0[1],vertes0[2]);
               break;

               case 1:
                   fill(color(234, 0, 234, 125));
                  vertex(vertes1[0],vertes1[1],vertes1[2]);
               break;

               case 2:
                 fill(color(234, 0, 234, 125));
                 vertex(vertes2[0],vertes2[1],vertes2[2]);

               break;

               case 3:
                 fill(color(234, 0, 234, 125));
                 vertex(vertes3[0],vertes3[1],vertes3[2]);

               break;
             }


           }
       }

      endShape();

      }



      //draw boid

    }
    popStyle();
  }
}

/**
 * Flock of Boids
 * by Jean Pierre Charalambos.
 *
 * This example displays the famous artificial life program "Boids", developed by
 * Craig Reynolds in 1986 [1] and then adapted to Processing by Matt Wetmore in
 * 2010 (https://www.openprocessing.org/sketch/6910#), in 'third person' eye mode.
 * The Boid under the mouse will be colored blue. If you click on a boid it will
 * be selected as the scene avatar for the eye to follow it.
 *
 * 1. Reynolds, C. W. Flocks, Herds and Schools: A Distributed Behavioral Model. 87.
 * http://www.cs.toronto.edu/~dt/siggraph97-course/cwr87/
 * 2. Check also this nice presentation about the paper:
 * https://pdfs.semanticscholar.org/73b1/5c60672971c44ef6304a39af19dc963cd0af.pdf
 * 3. Google for more...
 *
 * Press ' ' to switch between the different eye modes.
 * Press 'a' to toggle (start/stop) animation.
 * Press 'p' to print the current frame rate.
 * Press 'm' to change the boid visual mode.
 * Press 'v' to toggle boids' wall skipping.
 * Press 's' to call scene.fitBallInterpolation().
 */

import frames.primitives.*;
import frames.core.*;
import frames.processing.*;

Scene scene;
////////////////////////////////////////////////////  Inicio curvas ////////////////////////////
Interpolator interpolator;
//flock bounding box
static int flockWidth = 1280;
static int flockHeight = 720;
static int flockDepth = 600;
static boolean avoidWalls = true;
static boolean typeR=true;
static boolean modeR=false;

int initBoidNum = 900; // amount of boids to start the program with
ArrayList<Boid> flock;
Frame avatar;
boolean animate = true;
String curveType = "b";


void setup() {
  size(1000, 800, P3D);
  scene = new Scene(this);
  scene.setFrustum(new Vector(0, 0, 0), new Vector(flockWidth, flockHeight, flockDepth));
  scene.setAnchor(scene.center());
  //scene.setFieldOfView(PI / 3);
  scene.fit();
  // create and fill the list of boids
  flock = new ArrayList();
  for (int i = 0; i < initBoidNum; i++)
  flock.add(new Boid(new Vector(flockWidth / 2, flockHeight / 2, flockDepth / 2)));
}


void draw() {
  background(10, 50, 25);
  ambientLight(128, 128, 128);
  directionalLight(255, 255, 255, 0, 1, -100);
  walls();
  scene.traverse();


  // --- DRAW BEZIER, HERMIT AND NATURAL CURVES --- //
  for(int i = 0; i < controlFrames.size(); i++) {
    Vector P = controlFrames.get(i).position();
    pushStyle();
      stroke(0, 0, 255);
      strokeWeight(15);
      point(P.x(), P.y(), P.z());
    popStyle();
  }

  if(controlFrames.size() != 0) {
    drawCurve();
  }

}


void walls() {
  pushStyle();
  noFill();
  stroke(255, 255, 0);

  line(0, 0, 0, 0, flockHeight, 0);
  line(0, 0, flockDepth, 0, flockHeight, flockDepth);
  line(0, 0, 0, flockWidth, 0, 0);
  line(0, 0, flockDepth, flockWidth, 0, flockDepth);

  line(flockWidth, 0, 0, flockWidth, flockHeight, 0);
  line(flockWidth, 0, flockDepth, flockWidth, flockHeight, flockDepth);
  line(0, flockHeight, 0, flockWidth, flockHeight, 0);
  line(0, flockHeight, flockDepth, flockWidth, flockHeight, flockDepth);

  line(0, 0, 0, 0, 0, flockDepth);
  line(0, flockHeight, 0, 0, flockHeight, flockDepth);
  line(flockWidth, 0, 0, flockWidth, 0, flockDepth);
  line(flockWidth, flockHeight, 0, flockWidth, flockHeight, flockDepth);
  popStyle();
}

void updateAvatar(Frame frame) {
  if (frame != avatar) {
    avatar = frame;
    if (avatar != null)
      thirdPerson();
    else if (scene.eye().reference() != null)
      resetEye();
  }
}

// Sets current avatar as the eye reference and interpolate the eye to it
void thirdPerson() {
  scene.eye().setReference(avatar);
  scene.fit(avatar, 1);
}

// Resets the eye
void resetEye() {
  // same as: scene.eye().setReference(null);
  scene.eye().resetReference();
  scene.lookAt(scene.center());
  scene.fit(1);
}

// picks up a boid avatar, may be null
void mouseClicked() {
  // two options to update the boid avatar:
  // 1. Synchronously
  updateAvatar(scene.track("mouseClicked", mouseX, mouseY));
  // which is the same as these two lines:
  // scene.track("mouseClicked", mouseX, mouseY);
  // updateAvatar(scene.trackedFrame("mouseClicked"));
  // 2. Asynchronously
  // which requires updateAvatar(scene.trackedFrame("mouseClicked")) to be called within draw()
  // scene.cast("mouseClicked", mouseX, mouseY);
}

// 'first-person' interaction
void mouseDragged() {
  if (scene.eye().reference() == null)
    if (mouseButton == LEFT)
      // same as: scene.spin(scene.eye());
      scene.spin();
    else if (mouseButton == RIGHT)
      // same as: scene.translate(scene.eye());
      scene.translate();
    else
      // same as: scene.zoom(mouseX - pmouseX, scene.eye());
      scene.moveForward(mouseX - pmouseX);
}

// highlighting and 'third-person' interaction
void mouseMoved(MouseEvent event) {
  // 1. highlighting
  scene.cast("mouseMoved", mouseX, mouseY);
  // 2. third-person interaction
  if (scene.eye().reference() != null)
    // press shift to move the mouse without looking around
    if (!event.isShiftDown())
      scene.lookAround();
}

void mouseWheel(MouseEvent event) {
  // same as: scene.scale(event.getCount() * 20, scene.eye());
  scene.scale(event.getCount() * 20);
}

void randomControlPoints() {
  controlFrames.clear();
  for(int i=0; i<n; i++) {
    int index = int(random(0, initBoidNum));
    controlFrames.add(flock.get(index).frame);
  }
}

void keyPressed() {
  switch(key) {
  case 'a':
    animate = !animate;
    break;
  case 's':
    if (scene.eye().reference() == null)
      scene.fit();
    break;
  case 't':
    scene.shiftTimers();
    break;
  case 'v':
    avoidWalls = !avoidWalls;
    break;
  case 'b': // Apply the Bezier curve
    curveType = "b";
    break;
  case 'h': // Apply hermite curve
    if(n != 4) n = 4;
    randomControlPoints();
    curveType = "h";
    break;
  case 'n': // Apply natural curve
    if(n != 4) n = 4;
    randomControlPoints();
    curveType = "n";
    break;
  case 'p':
    randomControlPoints();
    break;
  case '+': // Change between 4 and 8 control points
    if(n == 4 && curveType.equals("b")) n = 8;
    else n = 4;
    randomControlPoints();
    break;
  case '-': // Hide curve
    controlFrames.clear();
    break;
  case ' ':
    if (scene.eye().reference() != null)
      resetEye();
    else if (avatar != null)
      thirdPerson();
    break;

    case 'm':
    modeR=!modeR;
    break;

    case 'c':
    typeR=!typeR;
    break;
  }
}
