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
    //generate random positions for teacups
    ranPosX = (int) random(-100, 500); 
    ranPosY = (int) random(-600, -100);
    
    this.pos = new PVector(ranPosX, ranPosY); 
    
    //generate random speed for teacup drop
    randomSpeed = random(4, 10); 
    speed = new PVector(0, randomSpeed); 
    // Apply transparency to image
    tint(255, 180);  
    
    //load the image
    cup = loadImage("teacup.png");
    
    //generate a random angle for the teacups to start at
    ang = random(0, 360);
  }
  
  void move() {
    //make the teacup move
    pos.add(speed);
    
    //generate another random position 
    ranPosY = (int) random(-600, -100); 
    ranPosX = (int) random(-100, 500);
    
    //move the teacup back to the top when it has left the screen
    if(pos.y > 600) { 
      pos.y = ranPosY;
    }

    //rotate the teacup based on the speed it is falling
    angInc = map(randomSpeed, 4, 10, 0.005, 0.5);

    //add an angle increment to angle to make it rotate
    ang += angInc;

  }
  
  void drawMe() {
    pushMatrix(); 
    //translate origin to center of the image
    translate(pos.x + 100, pos.y + 100);
    //make the image smaller
    scale(0.7);
    rotate(ang);
    image(cup, -70, -70);
    popMatrix();
  }
}
