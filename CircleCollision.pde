Circle[] circles;
int wallLeft, wallRight, wallTop, wallBottom;
int border = 50;

boolean record = false;
int frame = 0;
import com.hamoid.*;
VideoExport videoExport;

void setup(){
  size(1000,1000);
  wallLeft = border;
  wallRight = width - border;
  wallTop = border;
  wallBottom = height - border;
  circles = new Circle[10];
  
  for(int i = 0; i<circles.length; i++){
    circles[i] = new Circle(i, random(wallLeft+border, wallRight-border),
                            random(wallTop+border,wallBottom-border), random(50,100));
  }
  
  if (record){
    videoExport = new VideoExport(this, "CircleCollision.mp4");
    videoExport.setFrameRate(30);
    videoExport.startMovie();
  }
}

void draw(){
  background(0); 
  noFill();
  stroke(255);
  rectMode(CORNER);
  rect(wallLeft, wallTop, wallRight-wallLeft, wallBottom - wallTop);
  
  for(int i = 0; i<circles.length; i++){
    for(int j = 0; j<circles.length; j++){
      if((i!=j) && distanceCheck(circles[i],circles[j])){
        if(!circles[i].colliding && !circles[j].colliding)
          collide(circles[i],circles[j]);        
      }   
    }
  }
  
  for(Circle c : circles){
    c.update();
    c.show();    
  }
  
  if (record) videoExport.saveFrame();
  frame = frame + 1;

  if(frame>(60*30)){
     if (record){ videoExport.endMovie();}
   exit();
  }
}

boolean distanceCheck(Circle c1, Circle c2){  
  float distSqr = ((c1.pos.x - c2.pos.x)*(c1.pos.x - c2.pos.x)+
                   (c1.pos.y - c2.pos.y)*(c1.pos.y - c2.pos.y));  
  return distSqr < (c1.r+c2.r)*(c1.r+c2.r);
}

 
void collide(Circle c1, Circle c2){
  //Set both circles as colliding this frame
  c1.colliding = true;
  c2.colliding = true;

  PVector v1 = c1.vel.copy();
  PVector C1 = c1.pos.copy();
  float m1 = c1.r*c1.r;
  PVector v2 = c2.vel.copy();
  PVector C2 = c2.pos.copy();
  float m2 = c2.r*c2.r;
  PVector v1Minusv2 = new PVector(v1.x-v2.x,v1.y-v2.y);
  PVector C1MinusC2 = new PVector(C1.x-C2.x,C1.y-C2.y);
  
  //Static collision
  float distance = C1MinusC2.mag();
  float overlap = distance - c1.r - c2.r;
  c1.pos.x -= overlap*C1MinusC2.x/distance;
  c1.pos.y -= overlap*C1MinusC2.y/distance;
  c2.pos.x += overlap*C1MinusC2.x/distance;
  c2.pos.y += overlap*C1MinusC2.y/distance;
  
  //Dynamic collision
  float coeff = (2*m2)/(m1+m2)*v1Minusv2.dot(C1MinusC2)/C1MinusC2.magSq();
  PVector v1Prime = v1.sub(C1MinusC2.mult(coeff));
  //invert vel/pos difference vectors for v2' coefficient
  v1Minusv2.mult(-1);
  C1MinusC2.mult(-1);
  coeff = (2*m1)/(m1+m2)*v1Minusv2.dot(C1MinusC2)/C1MinusC2.magSq();
  PVector v2Prime = v2.sub(C1MinusC2.mult(coeff));
    
  c1.vel = v1Prime;
  c2.vel = v2Prime;
  //456y7  
}
