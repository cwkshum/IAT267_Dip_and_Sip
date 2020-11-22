import processing.serial.*;
Serial port;
PFont font;

int valD_sensor;

byte[] inBuffer = new byte[255]; //size of the serial buffer to allow for end of data characters and all chars (see arduino code)

void setup(){
  size(600, 600); //size of window
  
  noStroke();
  frameRate(10); // Run 10 frames per second
  
  // Open the port that the board is connected to and use the same speed (9600 bps)
  port = new Serial(this, Serial.list()[2], 9600);
  
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
      
      String[] distance_sensor = splitTokens(p[0], "a");  //get distance sensor reading 
      if (distance_sensor.length != 3) return;  //exit this function if packet is broken
      //println(light_sensor[1]);
      valD_sensor = int(distance_sensor[1]);
      
      print("light sensor:");
      print(valD_sensor);
      println(" ");  
      
      //display square and circle with text above, to illustrate functionality of code
      background(245);
      fill(0);
      stroke(0);

      textFont(font); 
      text("light sensor: ", 210, 170);
      text(valD_sensor, 340, 170);
      
      
      
      if(valD_sensor < 5){
        fill(153);
        rect(width/2 - 75, 450, 150, 50, 7);
        fill(0);
        text("Start", width/2 - 25, 485);
        //port.write("notInProgress");
        port.write('H');
      } 
      else {
        fill(153);
        rect(width/2 - 75, 450, 150, 50, 7);
        fill(0);
        text("Start", width/2 - 25, 485);
        //port.write("notInProgress");
        port.write('L');
      }
      
       //port.write('H');
      
      //if (mouseX > (width/2) && mouseX < (width/2) +150 && mouseY > 450 && mouseY < 450 +50){
      //  fill(0);
      //  text("clicked!", 0, 485);
      //}

    }
  } 
}

void mouseClicked() {
  if (mouseX > (width/2 - 75) && mouseX < (width/2 - 75) +150 && mouseY > 450 && mouseY < 450 +50){
    fill(0);
    text("clicked!", 0, 485);
  }
}
