class Teacup {
  PImage cup; 
  
  PVector pos;  
  PVector speed;
  float ang;
  float angInc;
  float randomSpeed; 
  float ranPosX; 
  float ranPosY;
  
  Teacup() {
    ranPosX = (int) random(-100, 570); 
    ranPosY = (int) random(-500, -100); 
    this.pos = new PVector(ranPosX, ranPosY); 
    randomSpeed = random(4, 10); 
    speed = new PVector(0, randomSpeed); 
    cup = loadImage("data/teacup.png");
    ang = random(0, 360);
    angInc = random(0.005, 1);
  }
  
  void move() {
    pos.add(speed);
    ranPosY = (int) random(-500, 0); 

    if(pos.y > 600) { 
      pos.y = ranPosY;
    }
    ang += angInc;

  }
  
  void drawMe() {
    pushMatrix(); 
    translate(pos.x + 100, pos.y + 100); 
    scale(0.25);
    rotate(ang);
    image(cup, -70, -70);
    fill(255, 0 , 0);
    ellipse(0, 0, 10, 10);
    popMatrix();
  }
}
