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

void setup() {
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

void bindHandlers() {
  oscP5.plug(this, "meshAFound", "/found");
  oscP5.plug(this, "loadMeshA", "/raw");

  oscP5.plug(this, "meshBFound", "/foundB");
  oscP5.plug(this, "loadMeshB", "/rawB");
  
  oscP5.plug(this, "setB", "/set");
}
void update() {
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


void draw() {
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
    OscMessage myMessage = new OscMessage("/set");
    oscP5.send(myMessage, remote);
  }
  else if (key == 'l') {
    input = "localhost";
  }
}

