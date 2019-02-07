// Vamo a hacer una curva de Bezier cúbica

// Funcion de bezier cubica en una dimension
float b3(float P0, float P1, float P2, float P3, float t) {
  return (float)(P0 * Math.pow((1 - t), 3) + 3*P1*t * Math.pow((1 - t), 2) + 3*P2*Math.pow(t, 2) * (1 - t) + P3*Math.pow(t, 3));
}

// Funcion que aplica bezier cubica en todas las dimensiones
Vector bezier3(Vector P0, Vector P1, Vector P2, Vector P3, float t) {
  float x = b3(P0.x(), P1.x(), P2.x(), P3.x(), t);
  float y = b3(P0.y(), P1.y(), P2.y(), P3.y(), t);
  float z = b3(P0.z(), P1.z(), P2.z(), P3.z(), t);

  return new Vector(x, y, z);
}


// Generic function
void drawCurve() {
  ArrayList<Vector> curvePoints = new ArrayList<Vector>();
  Vector P0 = controlFrames.get(0).position();
  Vector P1 = controlFrames.get(1).position();
  Vector P2 = controlFrames.get(2).position();
  Vector P3 = controlFrames.get(3).position();

  switch(curveType) {
    case "b":
      for(int i = 0; i <= 100; i ++) {
        float t = i * 0.01;
        Vector P = bezier3(P0, P1, P2, P3, t);
        curvePoints.add(P);
      }
      break;

    case "h":
      Vector H1 = new Vector(P0.x() + P1.x()/3, P0.y() + P1.y()/3, P0.z() + P1.z()/3);
      Vector H2 = new Vector(P3.x() - P2.x()/3, P3.y() - P2.y()/3, P3.z() - P2.z()/3);
      for(int i = 0; i <= 100; i ++) {
        float t = i * 0.01;
        Vector P = bezier3(P0, H1, H2, P3, t);
        curvePoints.add(P);
      }
      break;

    case "n":
      break;
  }

  for(int i = 0; i < curvePoints.size(); i ++) {
    Vector P = curvePoints.get(i);
    pushStyle();
      stroke(255, 0, 0);
      strokeWeight(5);
      if(i != 0) {
        Vector O = curvePoints.get(i - 1);
        line(O.x(), O.y(), O.z(), P.x(), P.y(), P.z());
      }
    popStyle();
  }
}
