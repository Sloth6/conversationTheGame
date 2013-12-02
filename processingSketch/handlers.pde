public void setB() {
 b.set(); 
}


public void meshAFound(int i) {
//  println("found: " + i); // 1 == found, 0 == not found
  a.found(i);
  
  OscMessage myMessage = new OscMessage("/foundB");
  myMessage.add(i);
  oscP5.send(myMessage, remote);
}

public void meshBFound(int i) {
  b.found(i);
}

// this meshAthod was generated programmatically. It's fugly.
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

void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.isPlugged()==false) {
//    println("UNPLUGGED: " + theOscMessage);
  }
}
