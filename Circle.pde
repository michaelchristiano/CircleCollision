class Circle{
  int ID;
  PVector pos = new PVector();
  PVector vel = new PVector();
  PVector acc = new PVector();
  float r;
  float maxSpeed = 1;
  int alpha = 80;
  boolean colliding = false;
  
  
  Circle(int _ID, float x, float y, float _r){
    ID = _ID;
    pos.x = x;
    pos.y = y;
    r = _r;
    vel.x = random(-maxSpeed, maxSpeed);
    vel.y = random(-maxSpeed, maxSpeed);
    vel.limit(maxSpeed);
  }
  
  void show(){
      
      fill(255,alpha);
      //stroke(255);
      noStroke();
      pushMatrix();
      translate(pos.x,pos.y);
      circle(0,0,2*r);
      stroke(255,0,0);
      popMatrix();
      if(alpha>80)
        alpha-=1;
  }
  
  void update(){
      edges();
          
      pos.add(vel);
      vel.limit(maxSpeed);
      vel.add(acc);
      acc.mult(0);
      
      if(colliding)
        alpha = 200;
      this.colliding = false;
  }
  
  void edges() {
    if(pos.x + r > wallRight){
      vel.x *= -1;
      pos.x = wallRight - r;
      alpha = 200;
    }
    
    if(pos.x - r < wallLeft){
      vel.x *= -1;
      pos.x = wallLeft + r;
      alpha = 200;
    }
      
      
    if(pos.y + r > wallBottom){
      vel.y *= -1;
      pos.y = wallBottom - r;
      alpha = 200;
    }
    if(pos.y - r < wallTop) {
        vel.y *= -1;
        pos.y = wallTop + r;
        alpha = 200;
    }
  }
}
