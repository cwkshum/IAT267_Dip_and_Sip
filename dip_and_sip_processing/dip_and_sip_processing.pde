import processing.serial.*;
Serial port;
PFont font;

int valL_sensor;

int buttonX;
int buttonY = 450;
int buttonWidth = 150;
int buttonHeight = 50;

boolean startTimer = false;
int timer = 7200;

byte[] inBuffer = new byte[255]; //size of the serial buffer to allow for end of data characters and all chars (see arduino code)

void setup(){
  size(600, 600); //size of window
  
  buttonX = (width/2 - 75);
  
  noStroke();
  //frameRate(10); // Run 10 frames per second
  
  // Open the port that the board is connected to and use the same speed (9600 bps)
  port = new Serial(this, Serial.list()[4], 9600);
  
  font = loadFont("ArialMT-24.vlw"); 
}

void draw(){
  if (0 < port.available()) { // If data is available to read,
    println(" ");
    port.readBytesUntil('&', inBuffer);  //read in all data until '&' is encountered
    
    if (inBuffer != null) {
      String myString = new String(inBuffer);
      //println(myString);  //for testing only
      
      
      //p is all sensor data (with a's and b's) ('&' is eliminated) ///////////////
      
      String[] p = splitTokens(myString, "&");  
      if (p.length < 2) return;  //exit this function if packet is broken
      //println(p[0]);   //for testing only
      
      
      //get distance sensor reading //////////////////////////////////////////////////
      
      String[] light_sensor = splitTokens(p[0], "a");  //get distance sensor reading 
      if (light_sensor.length != 3) return;  //exit this function if packet is broken
      //println(light_sensor[1]);
      valL_sensor = int(light_sensor[1]);
      
      print("light sensor:");
      print(valL_sensor);
      println(" ");  
      
      //display square and circle with text above, to illustrate functionality of code
      background(245);
      fill(0);
      stroke(0);
      textFont(font); 
      
      if (startTimer){
        text(timer/60, 210, 170);
        timer--;
        if(timer < 0){
          timer = 7200;
          startTimer = false;
        }
      }
      
      
      
      if(valL_sensor < 15){
        fill(153);
        rect(buttonX, buttonY, buttonWidth, buttonHeight, 7);
        fill(0);
        text("Start", width/2 - 25, 485);
        port.write('H');
      } 
      else {
        //fill(153);
        //rect(buttonX, buttonY, buttonWidth, buttonHeight, 7);
        //fill(0);
        //text("Start", width/2 - 25, 485);
        port.write('L');
      }

    }
  } 
}

void mouseClicked() {
  if (mouseX > buttonX && mouseX < buttonX + buttonWidth && mouseY > buttonY && mouseY < buttonY + buttonHeight){
    fill(0);
    text("clicked!", 0, 485);
    startTimer = true;
  }
}
