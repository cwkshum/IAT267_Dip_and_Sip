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
    // Apply transparency to image
    tint(255, 180);  
    cup = loadImage("teacup.png");
    ang = random(0, 360);
  }
  
  void move() {
    pos.add(speed);
    ranPosY = (int) random(-500, -100); 
    ranPosX = (int) random(-100, 570);
    
    if(pos.y > 600) { 
      pos.y = ranPosY;
    }

    //rotate the teacup based on the speed it is falling
    angInc = map(randomSpeed, 4, 10, 0.005, 0.5);

    ang += angInc;

  }
  
  void drawMe() {
    pushMatrix(); 
    translate(pos.x + 100, pos.y + 100); 
    scale(0.25);
    rotate(ang);
    image(cup, -70, -70);
    fill(255, 0 , 0);
    popMatrix();
  }
}
