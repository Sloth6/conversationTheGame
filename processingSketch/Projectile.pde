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
  void update() {
    x += vx;
    y += vy;
    if(r < R){
       r+=5; 
    }
  }
  
  boolean intersect(Projectile P) {
      return (abs(P.getX() - x) < (P.getR() + r)/2 && abs(P.getY() - y) < (P.getR() + r)/2  );
  }
  
  void render() {
    ellipse(x, y, r, r);
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

