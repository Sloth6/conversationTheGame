import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import oscP5.*; 
import netP5.*; 
import java.net.InetAddress; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class processingSketch extends PApplet {




InetAddress inet;

OscP5 oscP5;
NetAddress remote;
PFont f;
ArrayList<Projectile> projsA;
ArrayList<Projectile> projsB;
Face a;
Face b; 
boolean settingIp = true;
String input = "";
String myIp = ""; 

public void setup() {
  f = createFont("Arial", 18, true);
  size(1200, 480);
  frameRate(30);


  try {
    inet = InetAddress.getLocalHost();
    myIp = inet.getHostAddress();
  } 
  catch (Exception e) {
    myIp = "???";
  }

  // Each face owns a global list of projectiles. 
  projsA = new ArrayList<Projectile>();
  projsB = new ArrayList<Projectile>();

  // Create both faces, (x, y, direction of projectiles, and their projectile list)
  a = new Face(0, 0, 7, projsA);
  b = new Face(500, 0, -7, projsB);

  //  remote = new NetAddress("128.2.251.137", 8338);

  oscP5 = new OscP5(this, 8338);

  
}

public void bindHandlers() {
  oscP5.plug(this, "meshAFound", "/found");
  oscP5.plug(this, "loadMeshA", "/raw");

  oscP5.plug(this, "meshBFound", "/foundB");
  oscP5.plug(this, "loadMeshB", "/rawB");
  
  oscP5.plug(this, "setB", "/set");
}
public void update() {
  //  print(projs.size());
  for (int i = 0; i < projsA.size(); i ++) {
    Projectile pA = projsA.get(i);
    pA.update();
    if (b.intersect(pA)) {
//      print("hit!");
      projsA.remove(i);
    }
    if (pA.getX() > 1200) {
      projsA.remove(i);
    }
    for (int j = 0; j < projsB.size(); j++) {
      Projectile pB = projsB.get(j);
      if (pA.intersect(pB)) {
        if (pA.getR() > pB.getR()) {
          projsB.remove(j);
          pA.subR(pB.getR());
        } 
        else if (pB.getR() > pA.getR()) {
          projsA.remove(i);
          pB.subR(pA.getR());
        } 
        else {
          projsA.remove(i);
          projsB.remove(j);
        }
      }
    }
  }
  for (int i = 0; i < projsB.size(); i ++) {
    Projectile pB = projsB.get(i);
    pB.update();
    if (a.intersect(pB)) {
//      print("hit!");
      projsB.remove(i);
      if (pB.getX() < 0) {
        projsB.remove(i);
      }
    }
  }
}


public void draw() {
  if (settingIp) {
    background(255);
    int indent = 25;
    // Set the font and fill for text
    textFont(f);
    fill(0);
    // Display everything
    String txt = "Please enter the IP address of the other player\n"+
      "Your IP address is "+myIp+" \n 'l' for localhost";
    text(txt, indent, 40);
    text("->"+input, indent, 150);
    //    text(saved, indent, 130);
  } 
  else {

    update();
    background(0);
    stroke(100);
    
    a.render();
    b.render();
    
    
    for (int i = 0; i < projsA.size(); i ++) {
      Projectile P = projsA.get(i);
      P.render();
    }
//    println(projsB.size());
    for (int i = 0; i < projsB.size(); i ++) {
      Projectile P = projsB.get(i);
      P.render();
    }
  }
}

public void keyPressed() {
  if ((key >= '0' && key <= '9') || key == '.') {
    input+=key;
  } 
  else if (key == BACKSPACE && input.length() > 0) {
    input = input.substring(0, input.length() - 1);
  } 
  else if (key == RETURN || key == ENTER) {
    if (input.length() > 0 || (input.length() > 1 && input.charAt(0) != '-')) {
      settingIp = false;
      remote = new NetAddress(input, 8338);
      bindHandlers();
      
      //      convert = true;
    }
    //    size(800, 600);
  }
  else if (key == ' ') {
    a.set();
    OscMessage myMessage = new OscMessage("/set");
    oscP5.send(myMessage, remote);
  }
  else if (key == 'l') {
    input = "localhost";
  }
}

class Face {
  boolean found;
  PVector[] mesh;
  PVector[] meshBuffer;
  float norm = 0.0f;
  int offX = 0;
  int offY = 0;
  int health = 100;
  int lastBlob = 0;
  float natEyebrows = 0.0f;
  int fireDelay = 400;
  ArrayList<Projectile> myPrjs;

  float power = 0;

  int d;

  float diff = 0.0f;
  float w = 0.0f;
  float h = 0.0f;

  boolean count = true;

  boolean setHappened = false; 
  float browNormal = 0.0f;
  //  float nat

  Face(int x, int y, int d, ArrayList<Projectile> PL) {
    offX = x;
    offY = y;
    myPrjs = PL;
    this.d = d;
    mesh       = new PVector[66];
    meshBuffer = new PVector[66];

    for (int i = 0; i < mesh.length; i++) {
      mesh[i] = new PVector();
      meshBuffer[i] = new PVector();
    }
  }

  public void set() {
    browNormal = browDis()/h();
    setHappened = true;
  }

  public float browDis() {
    return sqrt(sq(mesh[24].x-mesh[44].x) + sq(mesh[24].y-mesh[44].y));
  }
  public float h() {
    return sqrt(sq(mesh[8].x-mesh[27].x) + sq(mesh[8].y-mesh[27].y));
  }
  public float w() {
    return sqrt(sq(mesh[0].x-mesh[16].x) + sq(mesh[0].y-mesh[16].y));
  }

  public boolean intersect(Projectile P) {
    int x = P.getX();
    int y = P.getY();
    int r = P.getR();

    for (int i = 0; i < 17; i ++) {
      PVector p = mesh[i];
      if (abs(x-PApplet.parseInt(p.x+offX)) < r/2 && abs(y-PApplet.parseInt(p.y+offY)) < r/2) {
        health -=5;
        return true;
      }
    }
    return false;
  }

  public void render () {
    int r = 255 - PApplet.parseInt(PApplet.parseFloat(health)*(2.55f));
    int g = 255 - r;
    int radius = 2;//int(power)+2;
    fill(r, g, 0);
    //      textFont(f);
      //      fill(255);
//      text(""+i, p.x+offX, p.y+offY);

//      ellipse(p.x+offX, p.y+offY, radius, radius);
    
    
    beginShape();
    for (int i = 0; i < 40; i++) {
      PVector p = mesh[i];
      vertex(p.x,p.y);
      if (i > 0) {
        PVector prev = mesh[i-1];
        line(prev.x+offX, prev.y, p.x+offX, p.y+offY);
      }
    }
    endShape(CLOSE);
    
 }
  // 24 and 44
  public int browMag() {
    return PApplet.parseInt(((browDis()/h()) - browNormal)*100);
  }

  public boolean mouthOpen() {
    if (abs(mesh[64].y - mesh[61].y)/norm > .5f) {
      return true;
    } 
    else {
      return false;
    }
  }

  public void found(int i) {
    found = i == 1;
  }

  public void addDiff(PVector p, PVector v) {
    float oldX = map(v.x, meshBuffer[0].x, meshBuffer[16].x, mesh[0].x, mesh[16].x);
    float oldY = map(v.y, meshBuffer[27].y, meshBuffer[8].y, mesh[27].y, mesh[8].y);
//    print(mesh[16].x);
//    println(sqrt(sq(oldX-p.x) + sq(oldY-p.y)));
    diff += sqrt(sq(oldX-p.x) + sq(oldY-p.y));
  }

  public void afterMesh() {
//    print("ere");
    diff = 0.0f;

    PVector p;
    PVector v;
    for (int i = 0; i < 66; i ++) {
      //     println(i);
      v = meshBuffer[i];
      p = mesh[i];

      if (setHappened) {
        addDiff(p, v);
      }
      mesh[i].x = v.x;
      mesh[i].y = v.y;
    }
    //    println(diff/100);
//    if (diff < 1000) {
//      power += diff/500;
//    }
    int r =0;
    norm = sqrt(sq(mesh[30].x-mesh[27].x) + sq(mesh[30].y-mesh[27].y));
    r = abs(PApplet.parseInt(mesh[64].y-mesh[61].y));
    if (mouthOpen() && millis()- lastBlob > fireDelay ) {

      myPrjs.add( new Projectile(PApplet.parseInt(mesh[64].x+mesh[61].x)/2 + offX, 
      PApplet.parseInt(mesh[64].y+mesh[61].y)/2 + offY, r, d, -1*browMag()));
      lastBlob = millis();
      power -= r;
    }
  }

  public void init() {
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

class Projectile {
  int x, y, r, vx, vy, R;
  Projectile(int x,int y,int r,int vx,int vy) {
    this.x = x;
    this.y = y;
    this.R = r;
    this.r = 1;
    this.vx = vx;
    this.vy = vy;
  }
  public void update() {
    x += vx;
    y += vy;
    if(r < R){
       r+=5; 
    }
  }
  
  public boolean intersect(Projectile P) {
      return (abs(P.getX() - x) < (P.getR() + r)/2 && abs(P.getY() - y) < (P.getR() + r)/2  );
  }
  
  public void render() {
    ellipse(x, y, r, r);
  }
  
  public void subR(int r) {
   this.r -= r; 
  }
  
  public int getX(){
    return x;
  }
  public int getY(){
    return y;
  }
  public int getR(){
    return r;
  }
}

public void setB() {
  b.set();
}


public void meshAFound(int i) {
  try {
    a.found(i);

    OscMessage myMessage = new OscMessage("/foundB");
    myMessage.add(i);
    oscP5.send(myMessage, remote);
  }
  
  catch (ArrayIndexOutOfBoundsException e) {
    println ("Hey, that\u2019s note a valid index!");
  } 
  catch (NullPointerException e) {
    println("I think you forgot to create the array!");
  } 
  catch (Exception e) {
    println("Hmmm, I dunno, something weird happened!");
    e.printStackTrace();
  }
}

public void meshBFound(int i) {
  b.found(i);
}


public void loadMeshA(float x0, float y0, float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4, float x5, float y5, float x6, float y6, float x7, float y7, float x8, float y8, float x9, float y9, float x10, float y10, float x11, float y11, float x12, float y12, float x13, float y13, float x14, float y14, float x15, float y15, float x16, float y16, float x17, float y17, float x18, float y18, float x19, float y19, float x20, float y20, float x21, float y21, float x22, float y22, float x23, float y23, float x24, float y24, float x25, float y25, float x26, float y26, float x27, float y27, float x28, float y28, float x29, float y29, float x30, float y30, float x31, float y31, float x32, float y32, float x33, float y33, float x34, float y34, float x35, float y35, float x36, float y36, float x37, float y37, float x38, float y38, float x39, float y39, float x40, float y40, float x41, float y41, float x42, float y42, float x43, float y43, float x44, float y44, float x45, float y45, float x46, float y46, float x47, float y47, float x48, float y48, float x49, float y49, float x50, float y50, float x51, float y51, float x52, float y52, float x53, float y53, float x54, float y54, float x55, float y55, float x56, float y56, float x57, float y57, float x58, float y58, float x59, float y59, float x60, float y60, float x61, float y61, float x62, float y62, float x63, float y63, float x64, float y64, float x65, float y65) {
  //  println("loading meshA...");  

  a.loadMesh( x0, y0, x1, y1, x2, y2, x3, y3, x4, y4, x5, y5, x6, y6, x7, y7, x8, y8, x9, y9, x10, y10, x11, y11, x12, y12, x13, y13, x14, y14, x15, y15, x16, y16, x17, y17, x18, y18, x19, y19, x20, y20, x21, y21, x22, y22, x23, y23, x24, y24, x25, y25, x26, y26, x27, y27, x28, y28, x29, y29, x30, y30, x31, y31, x32, y32, x33, y33, x34, y34, x35, y35, x36, y36, x37, y37, x38, y38, x39, y39, x40, y40, x41, y41, x42, y42, x43, y43, x44, y44, x45, y45, x46, y46, x47, y47, x48, y48, x49, y49, x50, y50, x51, y51, x52, y52, x53, y53, x54, y54, x55, y55, x56, y56, x57, y57, x58, y58, x59, y59, x60, y60, x61, y61, x62, y62, x63, y63, x64, y64, x65, y65);
  OscMessage myMessage = new OscMessage("/rawB");
  myMessage.add(x0);
  myMessage.add(y0);
  myMessage.add(x1);
  myMessage.add(y1);
  myMessage.add(x2);
  myMessage.add(y2);
  myMessage.add(x3);
  myMessage.add(y3);
  myMessage.add(x4);
  myMessage.add(y4);
  myMessage.add(x5);
  myMessage.add(y5);
  myMessage.add(x6);
  myMessage.add(y6);
  myMessage.add(x7);
  myMessage.add(y7);
  myMessage.add(x8);
  myMessage.add(y8);
  myMessage.add(x9);
  myMessage.add(y9);
  myMessage.add(x10);
  myMessage.add(y10);
  myMessage.add(x11);
  myMessage.add(y11);
  myMessage.add(x12);
  myMessage.add(y12);
  myMessage.add(x13);
  myMessage.add(y13);
  myMessage.add(x14);
  myMessage.add(y14);
  myMessage.add(x15);
  myMessage.add(y15);
  myMessage.add(x16);
  myMessage.add(y16);
  myMessage.add(x17);
  myMessage.add(y17);
  myMessage.add(x18);
  myMessage.add(y18);
  myMessage.add(x19);
  myMessage.add(y19);
  myMessage.add(x20);
  myMessage.add(y20);
  myMessage.add(x21);
  myMessage.add(y21);
  myMessage.add(x22);
  myMessage.add(y22);
  myMessage.add(x23);
  myMessage.add(y23);
  myMessage.add(x24);
  myMessage.add(y24);
  myMessage.add(x25);
  myMessage.add(y25);
  myMessage.add(x26);
  myMessage.add(y26);
  myMessage.add(x27);
  myMessage.add(y27);
  myMessage.add(x28);
  myMessage.add(y28);
  myMessage.add(x29);
  myMessage.add(y29);
  myMessage.add(x30);
  myMessage.add(y30);
  myMessage.add(x31);
  myMessage.add(y31);
  myMessage.add(x32);
  myMessage.add(y32);
  myMessage.add(x33);
  myMessage.add(y33);
  myMessage.add(x34);
  myMessage.add(y34);
  myMessage.add(x35);
  myMessage.add(y35);
  myMessage.add(x36);
  myMessage.add(y36);
  myMessage.add(x37);
  myMessage.add(y37);
  myMessage.add(x38);
  myMessage.add(y38);
  myMessage.add(x39);
  myMessage.add(y39);
  myMessage.add(x40);
  myMessage.add(y40);
  myMessage.add(x41);
  myMessage.add(y41);
  myMessage.add(x42);
  myMessage.add(y42);
  myMessage.add(x43);
  myMessage.add(y43);
  myMessage.add(x44);
  myMessage.add(y44);
  myMessage.add(x45);
  myMessage.add(y45);
  myMessage.add(x46);
  myMessage.add(y46);
  myMessage.add(x47);
  myMessage.add(y47);
  myMessage.add(x48);
  myMessage.add(y48);
  myMessage.add(x49);
  myMessage.add(y49);
  myMessage.add(x50);
  myMessage.add(y50);
  myMessage.add(x51);
  myMessage.add(y51);
  myMessage.add(x52);
  myMessage.add(y52);
  myMessage.add(x53);
  myMessage.add(y53);
  myMessage.add(x54);
  myMessage.add(y54);
  myMessage.add(x55);
  myMessage.add(y55);
  myMessage.add(x56);
  myMessage.add(y56);
  myMessage.add(x57);
  myMessage.add(y57);
  myMessage.add(x58);
  myMessage.add(y58);
  myMessage.add(x59);
  myMessage.add(y59);
  myMessage.add(x60);
  myMessage.add(y60);
  myMessage.add(x61);
  myMessage.add(y61);
  myMessage.add(x62);
  myMessage.add(y62);
  myMessage.add(x63);
  myMessage.add(y63);
  myMessage.add(x64);
  myMessage.add(y64);
  myMessage.add(x65);
  myMessage.add(y65);
  oscP5.send(myMessage, remote);
}
public void loadMeshB(float x0, float y0, float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4, float x5, float y5, float x6, float y6, float x7, float y7, float x8, float y8, float x9, float y9, float x10, float y10, float x11, float y11, float x12, float y12, float x13, float y13, float x14, float y14, float x15, float y15, float x16, float y16, float x17, float y17, float x18, float y18, float x19, float y19, float x20, float y20, float x21, float y21, float x22, float y22, float x23, float y23, float x24, float y24, float x25, float y25, float x26, float y26, float x27, float y27, float x28, float y28, float x29, float y29, float x30, float y30, float x31, float y31, float x32, float y32, float x33, float y33, float x34, float y34, float x35, float y35, float x36, float y36, float x37, float y37, float x38, float y38, float x39, float y39, float x40, float y40, float x41, float y41, float x42, float y42, float x43, float y43, float x44, float y44, float x45, float y45, float x46, float y46, float x47, float y47, float x48, float y48, float x49, float y49, float x50, float y50, float x51, float y51, float x52, float y52, float x53, float y53, float x54, float y54, float x55, float y55, float x56, float y56, float x57, float y57, float x58, float y58, float x59, float y59, float x60, float y60, float x61, float y61, float x62, float y62, float x63, float y63, float x64, float y64, float x65, float y65) {
  //  println("loading meshB...");  
  b.loadMesh( x0, y0, x1, y1, x2, y2, x3, y3, x4, y4, x5, y5, x6, y6, x7, y7, x8, y8, x9, y9, x10, y10, x11, y11, x12, y12, x13, y13, x14, y14, x15, y15, x16, y16, x17, y17, x18, y18, x19, y19, x20, y20, x21, y21, x22, y22, x23, y23, x24, y24, x25, y25, x26, y26, x27, y27, x28, y28, x29, y29, x30, y30, x31, y31, x32, y32, x33, y33, x34, y34, x35, y35, x36, y36, x37, y37, x38, y38, x39, y39, x40, y40, x41, y41, x42, y42, x43, y43, x44, y44, x45, y45, x46, y46, x47, y47, x48, y48, x49, y49, x50, y50, x51, y51, x52, y52, x53, y53, x54, y54, x55, y55, x56, y56, x57, y57, x58, y58, x59, y59, x60, y60, x61, y61, x62, y62, x63, y63, x64, y64, x65, y65);
}

public void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.isPlugged()==false) {
    //    println("UNPLUGGED: " + theOscMessage);
  }
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "processingSketch" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
