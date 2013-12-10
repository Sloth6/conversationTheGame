import oscP5.*;
import netP5.*;
import java.net.InetAddress;
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

PImage bckGrnd;
PImage hat1;
PImage hat2;
boolean inited = false;
boolean gameOver = false;
boolean helmets = false;
void setup() {
  f = createFont("Arial", 32, true);
  size(1200, 480);
  frameRate(30);

  size(displayWidth, displayHeight);
  float scale = float(displayHeight)/float(displayHeight);
  scale(scale, scale);
  float offset = float(displayWidth)/2/scale - float(displayWidth)/2;
  translate( offset, 0);

  //  bckGrnd = loadImage("clouds.jpg");
  bckGrnd = loadImage("/data/Squares.png");

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
  a = new Face(0, displayHeight/40, 10, projsA, helmets);
  b = new Face(displayWidth/2, displayHeight/40, -10, projsB, helmets);

  //  remote = new NetAddress("128.2.251.137", 8338);

  oscP5 = new OscP5(this, 8338);
}

void bindHandlers() {
  oscP5.plug(this, "meshAFound", "/found");
  oscP5.plug(this, "loadMeshA", "/raw");

  oscP5.plug(this, "meshBFound", "/foundB");
  oscP5.plug(this, "loadMeshB", "/rawB");

  oscP5.plug(this, "setB", "/set");
  oscP5.plug(this, "reset", "/reset");
  
  oscP5.plug(this, "win", "/win");
}
void update() {
  //  print(projs.size());
  for (int i = 0; i < projsA.size(); i ++) {
    Projectile pA = projsA.get(i);
    pA.update();
    if (b.intersect(pA)) {
      projsA.remove(i); 
    }
    if (pA.getX() > displayWidth) {
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
      projsB.remove(i);
    }
    if (pB.getX() < 0) {
      projsB.remove(i);
    }
  }
  
  if(a.health <=0 || b.health <= 0) {
    handleEnd();
     
  }
}
void handleEnd(){
  gameOver = true;
  OscMessage myMessage = new OscMessage("/win");
  oscP5.send(myMessage, remote);
}

void keyPressed() {
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
    inited = true;
    OscMessage myMessage = new OscMessage("/set");
    oscP5.send(myMessage, remote);
  }
  else if (key == 'l' || key == 'L') {
    input = "localhost";
  }
  else if (key == 'r') {
    gameOver = false;
    a.reset();
    OscMessage myMessage = new OscMessage("/reset");
    oscP5.send(myMessage, remote);
  }
}

