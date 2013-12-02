class Face {
  boolean found;
  PVector[] mesh;
  float norm = 0.0;
  int offX = 0;
  int offY = 0;
  int health = 100;
  int lastBlob = 0;
  float natEyebrows = 0.0;
  int fireDelay = 400;
  ArrayList<Projectile> myPrjs;
  ArrayList<Projectile> myPrjs1;
  float diff = 0.0;
  int d;
  
  boolean count = true;

  boolean setHappened = false; 
  float browNormal = 0.0;
  //  float nat

  Face(int x, int y, int d, ArrayList<Projectile> PL) {
    offX = x;
    offY = y;
    myPrjs = PL;
    this.d = d;
    mesh = new PVector[66];
    for (int i = 0; i < mesh.length; i++) {
      mesh[i] = new PVector();
    }
  }

  void set() {
//    h = 
//    w = sqrt(sq(mesh[0].x-mesh[16].x) + sq(mesh[0].y-mesh[16].y));
    browNormal = browDis()/h();
    setHappened = true;
  }
  
  float browDis() {
   return sqrt(sq(mesh[24].x-mesh[44].x) + sq(mesh[24].y-mesh[44].y));
  }
  float h() {
    return sqrt(sq(mesh[8].x-mesh[27].x) + sq(mesh[8].y-mesh[27].y));
  }
  
  boolean intersect(Projectile P) {
    int x = P.getX();
    int y = P.getY();
    int r = P.getR();

    for (int i = 0; i < 17; i ++) {
      PVector p = mesh[i];
      if (abs(x-int(p.x+offX)) < r/2 && abs(y-int(p.y+offY)) < r/2) {
        health -=5;
        return true;
      }
    }
    return false;
  }

  void render () {
    int r = 255 - int(float(health)*(2.55));
    int g = 255 - r; 
    fill(r, g, 0);
    for (int i = 0; i < mesh.length-1; i++) {
      PVector p = mesh[i];
      textFont(f);
      //      fill(255);
//      text(""+i, p.x+offX, p.y+offY);
      if (false ) {
        ellipse(500 - p.x, p.y+offY, 5, 5);
      } 
      else {
        ellipse(p.x+offX, p.y+offY, 5, 5);
      }

      //      if (i > 0) {
      //        PVector prev = mesh[i-1];
      //        line(prev.x+offX, prev.y, p.x+offX, p.y+offY);
      //      }
    }
  }
  // 24 and 44
  int browMag() {
    return int(((browDis()/h()) - browNormal)*100);
  }
  
  boolean mouthOpen() {
    if (abs(mesh[64].y - mesh[61].y)/norm > .5) {
      return true;
    } else {
      return false;
    }
  }

  void found(int i) {
    found = i == 1;
  }

  public void afterMesh() {
    count = !count;
    int r =0;
    norm = sqrt(sq(mesh[30].x-mesh[27].x) + sq(mesh[30].y-mesh[27].y));
    if (mouthOpen() && millis()- lastBlob > fireDelay) {
      r = abs(int(mesh[64].y-mesh[61].y));
      myPrjs.add( new Projectile(int(mesh[64].x+mesh[61].x)/2 + offX, 
      int(mesh[64].y+mesh[61].y)/2 + offY, r, d, -1*browMag()));
      lastBlob = millis();
    }

  }

  void init() {
    if (found) {
      // do stuff here.
    }
  }

  public void loadMesh(float x0, float y0, float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4, float x5, float y5, float x6, float y6, float x7, float y7, float x8, float y8, float x9, float y9, float x10, float y10, float x11, float y11, float x12, float y12, float x13, float y13, float x14, float y14, float x15, float y15, float x16, float y16, float x17, float y17, float x18, float y18, float x19, float y19, float x20, float y20, float x21, float y21, float x22, float y22, float x23, float y23, float x24, float y24, float x25, float y25, float x26, float y26, float x27, float y27, float x28, float y28, float x29, float y29, float x30, float y30, float x31, float y31, float x32, float y32, float x33, float y33, float x34, float y34, float x35, float y35, float x36, float y36, float x37, float y37, float x38, float y38, float x39, float y39, float x40, float y40, float x41, float y41, float x42, float y42, float x43, float y43, float x44, float y44, float x45, float y45, float x46, float y46, float x47, float y47, float x48, float y48, float x49, float y49, float x50, float y50, float x51, float y51, float x52, float y52, float x53, float y53, float x54, float y54, float x55, float y55, float x56, float y56, float x57, float y57, float x58, float y58, float x59, float y59, float x60, float y60, float x61, float y61, float x62, float y62, float x63, float y63, float x64, float y64, float x65, float y65) {
    //    println("loading mesh...");  
    mesh[0].x = x0;
    mesh[0].y = y0;
    mesh[1].x = x1; 
    mesh[1].y = y1;
    mesh[2].x = x2; 
    mesh[2].y = y2;
    mesh[3].x = x3; 
    mesh[3].y = y3;
    mesh[4].x = x4; 
    mesh[4].y = y4;
    mesh[5].x = x5; 
    mesh[5].y = y5;
    mesh[6].x = x6; 
    mesh[6].y = y6;
    mesh[7].x = x7; 
    mesh[7].y = y7;
    mesh[8].x = x8; 
    mesh[8].y = y8;
    mesh[9].x = x9; 
    mesh[9].y = y9;
    mesh[10].x = x10; 
    mesh[10].y = y10;
    mesh[11].x = x11; 
    mesh[11].y = y11;
    mesh[12].x = x12; 
    mesh[12].y = y12;
    mesh[13].x = x13; 
    mesh[13].y = y13;
    mesh[14].x = x14; 
    mesh[14].y = y14;
    mesh[15].x = x15; 
    mesh[15].y = y15;
    mesh[16].x = x16; 
    mesh[16].y = y16;
    mesh[17].x = x17; 
    mesh[17].y = y17;
    mesh[18].x = x18; 
    mesh[18].y = y18;
    mesh[19].x = x19; 
    mesh[19].y = y19;
    mesh[20].x = x20; 
    mesh[20].y = y20;
    mesh[21].x = x21; 
    mesh[21].y = y21;
    mesh[22].x = x22; 
    mesh[22].y = y22;
    mesh[23].x = x23; 
    mesh[23].y = y23;
    mesh[24].x = x24; 
    mesh[24].y = y24;
    mesh[25].x = x25; 
    mesh[25].y = y25;
    mesh[26].x = x26; 
    mesh[26].y = y26;
    mesh[27].x = x27; 
    mesh[27].y = y27;
    mesh[28].x = x28; 
    mesh[28].y = y28;
    mesh[29].x = x29; 
    mesh[29].y = y29;
    mesh[30].x = x30; 
    mesh[30].y = y30;
    mesh[31].x = x31; 
    mesh[31].y = y31;
    mesh[32].x = x32; 
    mesh[32].y = y32;
    mesh[33].x = x33; 
    mesh[33].y = y33;
    mesh[34].x = x34; 
    mesh[34].y = y34;
    mesh[35].x = x35; 
    mesh[35].y = y35;
    mesh[36].x = x36; 
    mesh[36].y = y36;
    mesh[37].x = x37; 
    mesh[37].y = y37;
    mesh[38].x = x38; 
    mesh[38].y = y38;
    mesh[39].x = x39; 
    mesh[39].y = y39;
    mesh[40].x = x40; 
    mesh[40].y = y40;
    mesh[41].x = x41; 
    mesh[41].y = y41;
    mesh[42].x = x42; 
    mesh[42].y = y42;
    mesh[43].x = x43; 
    mesh[43].y = y43;
    mesh[44].x = x44; 
    mesh[44].y = y44;
    mesh[45].x = x45; 
    mesh[45].y = y45;
    mesh[46].x = x46; 
    mesh[46].y = y46;
    mesh[47].x = x47; 
    mesh[47].y = y47;
    mesh[48].x = x48; 
    mesh[48].y = y48;
    mesh[49].x = x49; 
    mesh[49].y = y49;
    mesh[50].x = x50; 
    mesh[50].y = y50;
    mesh[51].x = x51; 
    mesh[51].y = y51;
    mesh[52].x = x52; 
    mesh[52].y = y52;
    mesh[53].x = x53; 
    mesh[53].y = y53;
    mesh[54].x = x54; 
    mesh[54].y = y54;
    mesh[55].x = x55; 
    mesh[55].y = y55;
    mesh[56].x = x56; 
    mesh[56].y = y56;
    mesh[57].x = x57; 
    mesh[57].y = y57;
    mesh[58].x = x58; 
    mesh[58].y = y58;
    mesh[59].x = x59; 
    mesh[59].y = y59;
    mesh[60].x = x60; 
    mesh[60].y = y60;
    mesh[61].x = x61; 
    mesh[61].y = y61;
    mesh[62].x = x62; 
    mesh[62].y = y62;
    mesh[63].x = x63; 
    mesh[63].y = y63;
    mesh[64].x = x64; 
    mesh[64].y = y64;
    mesh[65].x = x65; 
    mesh[65].y = y65;
    afterMesh();
  }
}

