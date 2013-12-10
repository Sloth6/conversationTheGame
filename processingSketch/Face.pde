class Face {
  boolean found;
  PVector[] mesh;
  PVector[] meshBuffer;
  float norm = 0.0;
  int offX = 0;
  int offY = 0;
  int health = 100;
  int lastBlob = 0;
  float natEyebrows = 0.0;
  int fireDelay = 400;
  ArrayList<Projectile> myPrjs;
  PImage hat;
  float power = 0;
  boolean shielded = false;
  int d;

  float diff = 0.0;
  float w = 0.0;
  float h = 0.0;

  boolean count = true;

  boolean setHappened = false; 
  float browNormal = 0.0;
  float eyeNormal = 0.0;
  //  float nat

  boolean helmets;
  Face(int x, int y, int d, ArrayList<Projectile> PL, boolean helmets) {
    offX = x;
    offY = y;
    myPrjs = PL;
    this.d = d;
    this.helmets = helmets; 
    mesh       = new PVector[66];
    meshBuffer = new PVector[66];
    if(int(random(2)) == 0) {
      hat = loadImage("/Helmets/min1.png");
    } else {
      hat = loadImage("/Helmets/min2.png");
    }
    for (int i = 0; i < mesh.length; i++) {
      mesh[i] = new PVector();
      meshBuffer[i] = new PVector();
    }
  }

  void reset() {
    health = 100;
  }
  void set() {
    browNormal = browDis()/h();
    eyeNormal = eyeDis()/h();
    setHappened = true;
  }
  float eyeDis() {
    return sqrt(sq(mesh[47].x-mesh[43].x) + sq(mesh[47].y-mesh[43 ].y));
  }

  float browDis() {
    return sqrt(sq(mesh[24].x-mesh[44].x) + sq(mesh[24].y-mesh[44].y));
  }
  float h() {
    return sqrt(sq(mesh[8].x-mesh[27].x) + sq(mesh[8].y-mesh[27].y));
  }
  float w() {
    return sqrt(sq(mesh[0].x-mesh[16].x) + sq(mesh[0].y-mesh[16].y));
  }

  boolean intersect(Projectile P) {
    int x = P.getX();
    int y = P.getY();
    int r = P.getR();
    PVector f = mesh[30];
    float fx = f.x+offX;
    float fy = f.y+offY;
    float w;
    float h;
    if (this.shielded) {  
      w = w()*1.5;
      h = h()*2;
    } 
    else {
      w = w();
      h = h()*1.5;
    }
    float in = (((x-fx)*(x-fx))/(w*w/4)) + (((y-fy)*(y-fy))/(h*h/4));
    //    ellipse(p.x+offX, p.y+offY, w()*1, h()*1.5);
    if ( in <= 1) {
      if (!this.shielded) {
        health -=5;
      }
      return true;
    }
    return false;
  }

  void renderUi () {

    strokeWeight(2);
    stroke(0);
    noFill();
    rect(50 + offX, 10, 200, 20);
    fill(0, 200, 0);
    rect(51 + offX, 11, map(health, 0, 100, 0, 198), 18);

    stroke(0);
    noFill();
    rect(50 + offX, 30, 200, 20);
    fill(236, 236, 90);
    float derp = map(power, 0, 100, 1, 198);
    if (derp > 198) { 
      derp = 198.0;
    }
    rect(51 + offX, 30, derp, 18);
  }

  void render () {
    if (health <= 0) {
      return;
    }
    int r = int(float(100-health)*.82);
    int g = int(float(100-health)*2.05);
    int b = int(float(100-health)*.88); 
    int radius = 2;
    int alpha = 155 + int(power); 
    textFont(f);
    //Face Color  
    fill(146+r, 205- g, 142-b);
    noStroke();

    beginShape();
    for (int i = 0; i < 17; i++) {
      PVector p = mesh[i];
      vertex(p.x+offX, p.y+offY);
    }
    endShape();
    beginShape();
    curveVertex(mesh[0].x+offX, mesh[0].y+1+offY);
    curveVertex(mesh[0].x+offX, mesh[0].y+1+offY); // the first control point
    curveVertex(mesh[19].x+offX-15, mesh[19].y-20+offY); // is also the start point of curve
    curveVertex(mesh[24].x+offX+15, mesh[24].y-20+offY);
    curveVertex(mesh[16].x+offX, mesh[16].y+1+offY);
    curveVertex(mesh[16].x+offX, mesh[16].y+1+offY);
    endShape();

    strokeWeight(4);
    stroke(186, 182, 36);
    fill(186, 182, 36);
    //Left Eyebrow. 
    for (int i = 18; i < 22; i++) {
      PVector p = mesh[i];
      PVector prev = mesh[i-1];
      line(prev.x+offX, prev.y+offY, p.x+offX, p.y+offY);
    }
    //Right Eyebrow.
    for (int i = 23; i < 27; i++) {
      PVector p = mesh[i];
      PVector prev = mesh[i-1];
      line(prev.x+offX, prev.y+offY, p.x+offX, p.y+offY);
    }

    //Left Eye.
    noStroke();
    fill(76, 143, 222);
    makeShape(36, 41);
    //Right Eye.
    makeShape(42, 47);

    //Nose
    strokeWeight(4);
    stroke(186, 182, 36);
    fill(186, 182, 36);
    for (int i = 28; i < 36; i++) {
      if (i != 31) {
        PVector p = mesh[i];
        PVector prev = mesh[i-1];
        line(prev.x+offX, prev.y+offY, p.x+offX, p.y+offY);
      }
    }

    //Mouth.
    noStroke();
    fill(228, 0, 54, 50+power*2);
    makeShape(48, 59);
    fill(146, 205, 142);
    makeShape(60, 65);

    //Shield
    fill(0);
    PVector p = mesh[30];

    if (shielded) {
      //      PVector p = mesh[30];
      stroke(147, 210, 249);
      noFill();
      ellipse(p.x+offX, p.y+offY, w()*1.5, h()*2);
    }

    if (helmets) {
      PVector n1= mesh[27];
      PVector n2 = mesh[30];
      float ro = atan2(n1.y - n2.y, n1.x- n2.x) - 3*PI/2;

      PVector s2 = mesh[16];
      PVector s1 = mesh[0];
      float xx = (s1.x + s2.x)/2;
      float h = h();
      float yScale = 7*h()/displayHeight;
      pushMatrix();
      scale(8*w()/displayWidth, yScale);
      //    translate(-hat.width/2, -hat.height/2);

      //    translate(xx, s1.y);
      //    translate(width/2, height/2);
      //    rotate(ro);
      //    translate(-hat.width/2, -hat.height/2);

      //    translate(width/4, height/4);
      //    translate(xx-.8*w(), p.y-2.5*h());
      //    rotate(ro);



      translate((xx+offX)/(8*w()/displayWidth), (s1.y-(h/3)+offY)/yScale);

      image(hat, -hat.width/2, -hat.height/2);

      popMatrix();
    }

    //    image(hat,c.x+offX, c.y+offY); 

    //    Draw Numbers

    //    fill(0);
    //    for (int i = 0; i < mesh.length; i++) {
    //    PVector q = mesh[i];
    //    text(""+i, q.x+offX, q.y+offY);

    //    }
    //    //    image(hat, offX, offY);
    //    renderUi();
  }
  void makeShape(int a, int b) {
    beginShape();
    for (int i = a; i <= b; i++) {
      PVector p = mesh[i];
      vertex(p.x+offX, p.y+offY);
    }
    PVector q = mesh[a];
    vertex(q.x+offX, q.y+offY);
    endShape();
  }

  // 24 and 44
  int browMag() {
    return int(((browDis()/h()) - browNormal)*100);
  }

  boolean mouthOpen() {
    if (abs(mesh[64].y - mesh[61].y)/norm > .3) {
      return true;
    } 
    else {
      return false;
    }
  }

  void found(int i) {
    found = i == 1;
  }
  boolean eyesClosed() {
    //    println(eyeDis()/h());
    if (eyeDis()/h() < .035) {
      return true;
    } 
    else {
      return false;
    }
  }

  public boolean isShielded() {
    return this.shielded;
  }

  public void addDiff(PVector p, PVector v) {
    float oldX = map(v.x, meshBuffer[0].x, meshBuffer[16].x, mesh[0].x, mesh[16].x);
    float oldY = map(v.y, meshBuffer[27].y, meshBuffer[8].y, mesh[27].y, mesh[8].y);
    //    print(mesh[16].x);
    //    println(sqrt(sq(oldX-p.x) + sq(oldY-p.y)));
    diff += sqrt(sq(oldX-p.x) + sq(oldY-p.y));
  }

  public void afterMesh() {
    diff = 0.0;
    PVector p;
    PVector v;

    for (int i = 0; i < 66; i ++) {
      v = meshBuffer[i];
      p = mesh[i];
      if (setHappened) {
        addDiff(p, v);
        power += diff /4000;
        if (power >100) {
          power = 100.0;
        }
      }
      //      println(diff/20);
      mesh[i].x = v.x;
      mesh[i].y = v.y;
    }
    int r =0;
    norm = sqrt(sq(mesh[30].x-mesh[27].x) + sq(mesh[30].y-mesh[27].y));
    eyesClosed();
    r = abs(int(mesh[64].y-mesh[61].y));
    if (mouthOpen() && millis()- lastBlob > fireDelay && power > r) {

      myPrjs.add( new Projectile(int(mesh[64].x+mesh[61].x)/2 + offX, 
      int(mesh[64].y+mesh[61].y)/2 + offY, r, d, -1*browMag()));
      lastBlob = millis();
      power -= r;
    }

    if (eyesClosed() && this.power > 2) {
      shielded = true;
      this.power -=2;
    }
    else {
      shielded = false;
    }
  }

  void init() {
    if (found) {
    }
  }


  public void loadMesh(float x0, float y0, float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4, float x5, float y5, float x6, float y6, float x7, float y7, float x8, float y8, float x9, float y9, float x10, float y10, float x11, float y11, float x12, float y12, float x13, float y13, float x14, float y14, float x15, float y15, float x16, float y16, float x17, float y17, float x18, float y18, float x19, float y19, float x20, float y20, float x21, float y21, float x22, float y22, float x23, float y23, float x24, float y24, float x25, float y25, float x26, float y26, float x27, float y27, float x28, float y28, float x29, float y29, float x30, float y30, float x31, float y31, float x32, float y32, float x33, float y33, float x34, float y34, float x35, float y35, float x36, float y36, float x37, float y37, float x38, float y38, float x39, float y39, float x40, float y40, float x41, float y41, float x42, float y42, float x43, float y43, float x44, float y44, float x45, float y45, float x46, float y46, float x47, float y47, float x48, float y48, float x49, float y49, float x50, float y50, float x51, float y51, float x52, float y52, float x53, float y53, float x54, float y54, float x55, float y55, float x56, float y56, float x57, float y57, float x58, float y58, float x59, float y59, float x60, float y60, float x61, float y61, float x62, float y62, float x63, float y63, float x64, float y64, float x65, float y65) {
    //    println("loading mesh...");
    meshBuffer[0].x = x0;
    meshBuffer[0].y = y0;
    meshBuffer[1].x = x1; 
    meshBuffer[1].y = y1;
    meshBuffer[2].x = x2; 
    meshBuffer[2].y = y2;
    meshBuffer[3].x = x3; 
    meshBuffer[3].y = y3;
    meshBuffer[4].x = x4; 
    meshBuffer[4].y = y4;
    meshBuffer[5].x = x5; 
    meshBuffer[5].y = y5;
    meshBuffer[6].x = x6; 
    meshBuffer[6].y = y6;
    meshBuffer[7].x = x7; 
    meshBuffer[7].y = y7;
    meshBuffer[8].x = x8; 
    meshBuffer[8].y = y8;
    meshBuffer[9].x = x9; 
    meshBuffer[9].y = y9;
    meshBuffer[10].x = x10; 
    meshBuffer[10].y = y10;
    meshBuffer[11].x = x11; 
    meshBuffer[11].y = y11;
    meshBuffer[12].x = x12; 
    meshBuffer[12].y = y12;
    meshBuffer[13].x = x13; 
    meshBuffer[13].y = y13;
    meshBuffer[14].x = x14; 
    meshBuffer[14].y = y14;
    meshBuffer[15].x = x15; 
    meshBuffer[15].y = y15;
    meshBuffer[16].x = x16; 
    meshBuffer[16].y = y16;
    meshBuffer[17].x = x17; 
    meshBuffer[17].y = y17;
    meshBuffer[18].x = x18; 
    meshBuffer[18].y = y18;
    meshBuffer[19].x = x19; 
    meshBuffer[19].y = y19;
    meshBuffer[20].x = x20; 
    meshBuffer[20].y = y20;
    meshBuffer[21].x = x21; 
    meshBuffer[21].y = y21;
    meshBuffer[22].x = x22; 
    meshBuffer[22].y = y22;
    meshBuffer[23].x = x23; 
    meshBuffer[23].y = y23;
    meshBuffer[24].x = x24; 
    meshBuffer[24].y = y24;
    meshBuffer[25].x = x25; 
    meshBuffer[25].y = y25;
    meshBuffer[26].x = x26; 
    meshBuffer[26].y = y26;
    meshBuffer[27].x = x27; 
    meshBuffer[27].y = y27;
    meshBuffer[28].x = x28; 
    meshBuffer[28].y = y28;
    meshBuffer[29].x = x29; 
    meshBuffer[29].y = y29;
    meshBuffer[30].x = x30; 
    meshBuffer[30].y = y30;
    meshBuffer[31].x = x31; 
    meshBuffer[31].y = y31;
    meshBuffer[32].x = x32; 
    meshBuffer[32].y = y32;
    meshBuffer[33].x = x33; 
    meshBuffer[33].y = y33;
    meshBuffer[34].x = x34; 
    meshBuffer[34].y = y34;
    meshBuffer[35].x = x35; 
    meshBuffer[35].y = y35;
    meshBuffer[36].x = x36; 
    meshBuffer[36].y = y36;
    meshBuffer[37].x = x37; 
    meshBuffer[37].y = y37;
    meshBuffer[38].x = x38; 
    meshBuffer[38].y = y38;
    meshBuffer[39].x = x39; 
    meshBuffer[39].y = y39;
    meshBuffer[40].x = x40; 
    meshBuffer[40].y = y40;
    meshBuffer[41].x = x41; 
    meshBuffer[41].y = y41;
    meshBuffer[42].x = x42; 
    meshBuffer[42].y = y42;
    meshBuffer[43].x = x43; 
    meshBuffer[43].y = y43;
    meshBuffer[44].x = x44; 
    meshBuffer[44].y = y44;
    meshBuffer[45].x = x45; 
    meshBuffer[45].y = y45;
    meshBuffer[46].x = x46; 
    meshBuffer[46].y = y46;
    meshBuffer[47].x = x47; 
    meshBuffer[47].y = y47;
    meshBuffer[48].x = x48; 
    meshBuffer[48].y = y48;
    meshBuffer[49].x = x49; 
    meshBuffer[49].y = y49;
    meshBuffer[50].x = x50; 
    meshBuffer[50].y = y50;
    meshBuffer[51].x = x51; 
    meshBuffer[51].y = y51;
    meshBuffer[52].x = x52; 
    meshBuffer[52].y = y52;
    meshBuffer[53].x = x53; 
    meshBuffer[53].y = y53;
    meshBuffer[54].x = x54; 
    meshBuffer[54].y = y54;
    meshBuffer[55].x = x55; 
    meshBuffer[55].y = y55;
    meshBuffer[56].x = x56; 
    meshBuffer[56].y = y56;
    meshBuffer[57].x = x57; 
    meshBuffer[57].y = y57;
    meshBuffer[58].x = x58; 
    meshBuffer[58].y = y58;
    meshBuffer[59].x = x59; 
    meshBuffer[59].y = y59;
    meshBuffer[60].x = x60; 
    meshBuffer[60].y = y60;
    meshBuffer[61].x = x61; 
    meshBuffer[61].y = y61;
    meshBuffer[62].x = x62; 
    meshBuffer[62].y = y62;
    meshBuffer[63].x = x63; 
    meshBuffer[63].y = y63;
    meshBuffer[64].x = x64; 
    meshBuffer[64].y = y64;
    meshBuffer[65].x = x65; 
    meshBuffer[65].y = y65;
    afterMesh();
  }
}

