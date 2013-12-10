
void draw() {
  if (settingIp) {
    background(254, 235, 160);
    int indent = displayWidth/2-300;
    textFont(f);
    fill(10);
    // Display everything
    String txt = "Please enter the IP address of the other player\n"+
      "Your IP address is "+myIp+" \n Press 'L' for localhost";
    text(txt, indent, displayHeight/3+40);
    text("->"+input, indent, displayHeight/3+250);
  } 
  else if (!gameOver) {

    update();
    background(254, 235, 160);
    stroke(100);

    a.render();
    b.render();
    if (!inited) {
      fill(0);
      String txt = "PRESS SPACE WHEN YOUR FACE IS DETECTED CORRECTLY";
      text(txt, displayWidth/2 - 300, 100);
    }

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
  else {
    textSize(64);
    fill(0);
    String txt;
    if (a.health<=0) {
      txt = "YOU LOSE. \n press 'r' to restart.";
    } 
    else {
      txt = "YOU WIN!!. \n press 'r' to restart.";
    }
    text(txt, displayWidth/2 - 300, 100);
  }
}
