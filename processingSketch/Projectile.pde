class Projectile {
  int x, y, r, vx, vy, R;
  PImage img;
  Projectile(int x,int y,int r,int vx,int vy) {
    this.x = x;
    this.y = y;
    this.R = r;
    this.r = 1;
    this.vx = vx;
    this.vy = vy;
//    if(this.vx >0){
//      this.img = loadImage("/data/speech1.png");
//    }else{
//      this.img = loadImage("/data/speech2.png");
//    }
//    this.img.resize(2*r,0);
  }
  void update() {
    x += vx;
    y += vy;
    if(r < R){
       r+=5; 
//       this.img.resize(2*r,0);
    }
  }
  
  boolean intersect(Projectile P) {
      return (abs(P.getX() - x) < (P.getR() + r)/2 && abs(P.getY() - y) < (P.getR() + r)/2  );
  }
  
  void render() {
    
//    image(this.img, x-40,y-27);
    noStroke();
    fill(147, 210, 249);
    ellipse(x, y, r, r);
    beginShape();
    if(this.vx<0) {
      vertex(x, y);
      vertex(x+r/2, y);
      vertex(x+r/2, y+r/2);
      vertex(x,y+r/2);
    }else{
     vertex(x, y);
      vertex(x-r/2, y);
      vertex(x-r/2, y+r/2);
      vertex(x,y+r/2);
    }
    
    endShape();
    
    
  }
  
  public void reflect() {
    this.vx *=-1;
    this.r *=.5;
  }
  
  void subR(int r) {
   this.r -= r; 
   this.R -= r;
  }
  
  int getX(){
    return x;
  }
  int getY(){
    return y;
  }
  int getR(){
    return r;
  }
}

