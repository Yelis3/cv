// Vamo a hacer una curva de Bezier cúbica

// Funcion de bezier cubica en una dimension
float b3(float P0, float P1, float P2, float P3, float t) {
  return (float)(P0 * Math.pow((1 - t), 3) + 3*P1*t * Math.pow((1 - t), 2) + 3*P2*Math.pow(t, 2) * (1 - t) + P3*Math.pow(t, 3));
}
// Funcion que aplica bezier cubica en todas las dimensiones
Vector bezier3(Vector[] cP, float t) {
  float x = b3(cP[0].x(), cP[1].x(), cP[2].x(), cP[3].x(), t);
  float y = b3(cP[0].y(), cP[1].y(), cP[2].y(), cP[3].y(), t);
  float z = b3(cP[0].z(), cP[1].z(), cP[2].z(), cP[3].z(), t);

  return new Vector(x, y, z);
}

// Funcion de bezier grdo 7 en una dimension
float b7(float P0, float P1, float P2, float P3, float P4, float P5, float P6, float P7, float t) {
  return (float)(P0 * Math.pow((1 - t), 7) + 7*P1*t * Math.pow((1 - t), 6) + 21*P2*Math.pow(t, 2) * Math.pow(1 - t, 5) + 35*P3*Math.pow(t, 3) * Math.pow(1 - t, 4)
  + 35*P4*Math.pow(t, 4) * Math.pow(1 - t, 3) + 21*P5*Math.pow(t, 5) * Math.pow(1 - t, 2) + 7*P6*Math.pow(t, 6) * (1 - t) + P7*Math.pow(t, 7));
}
// Funcion que aplica bezier grdo 7 en todas las dimensiones
Vector bezier7(Vector[] cP, float t) {
  float x = b7(cP[0].x(), cP[1].x(), cP[2].x(), cP[3].x(), cP[4].x(), cP[5].x(), cP[6].x(), cP[7].x(), t);
  float y = b7(cP[0].y(), cP[1].y(), cP[2].y(), cP[3].y(), cP[4].y(), cP[5].y(), cP[6].y(), cP[7].y(), t);
  float z = b7(cP[0].z(), cP[1].z(), cP[2].z(), cP[3].z(), cP[4].z(), cP[5].z(), cP[6].z(), cP[7].z(), t);

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
    case "b": {
      if(n == 4) {
        Vector[] controlPoints = {P0, P1, P2, P3};
        for(int i = 0; i <= 100; i ++) {
          float t = i * 0.01;
          Vector P = bezier3(controlPoints, t);
          curvePoints.add(P);
        }
      } else {
        Vector P4 = controlFrames.get(4).position();
        Vector P5 = controlFrames.get(5).position();
        Vector P6 = controlFrames.get(6).position();
        Vector P7 = controlFrames.get(7).position();
        Vector[] controlPoints = {P0, P1, P2, P3, P4, P5, P6, P7};
        for(int i = 0; i <= 100; i ++) {
          float t = i * 0.01;
          Vector P = bezier7(controlPoints, t);
          curvePoints.add(P);
        }
      }
      break;
    }

    case "h": {
      Vector H1 = new Vector(P0.x() + P1.x()/3, P0.y() + P1.y()/3, P0.z() + P1.z()/3);
      Vector H2 = new Vector(P3.x() - P2.x()/3, P3.y() - P2.y()/3, P3.z() - P2.z()/3);
      Vector[] controlPoints = {P0, H1, H2, P3};
      for(int i = 0; i <= 100; i ++) {
        float t = i * 0.01;
        Vector P = bezier3(controlPoints, t);
        curvePoints.add(P);
      }
      break;
    }

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
