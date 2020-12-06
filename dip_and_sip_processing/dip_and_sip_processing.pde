import processing.serial.*;
Serial port;
PFont font;

int valL_sensor;
int valS_position;

//array list for teacups
ArrayList<Teacup> teacups = new ArrayList<Teacup>();

// Hide Completed message
boolean doneMessage = false;


// Initialize Start buttons
boolean showButton = true;
int buttonX;
int buttonY = 420;
int buttonWidth = 200;
int buttonHeight = 80;

// Initialize timers
boolean startTimer = false;
int timer = 1200;
int minuteTimer = 2;
int secTimer = 600;

/* size of the serial buffer to allow for end of 
data characters and all chars (see arduino code) */
byte[] inBuffer = new byte[255]; 

void setup(){
  //size of window
  size(600, 600); 
  
  buttonX = (width/2 - 100);
  background(176, 176, 234);
  noStroke();
  
  // Run 10 frames per second
  frameRate(10); 
  
  // Open the port that the board is connected to and use the same speed (9600 bps)
  port = new Serial(this, Serial.list()[2], 9600);
  
  // Load Futura font
  font = loadFont("Futura-Medium-120.vlw"); 
  
  
  //populate arrayList with 7 teacups
  for (int i = 0; i < 7; i++) {
    teacups.add(new Teacup());
  }      
}

void draw(){
  
  // Run if data is available to read
  if (0 < port.available()) { 
    println(" ");
    port.readBytesUntil('&', inBuffer);  //read in all data until '&' is encountered
    
    if (inBuffer != null) {
      String myString = new String(inBuffer);
      
      // p is all sensor data (with a's and b's) ('&' is eliminated)
      String[] p = splitTokens(myString, "&");  
      if (p.length < 2) { 
        //exit this function if packet is broken
        return;  
      }
      
      // Get light sensor reading 
      String[] light_sensor = splitTokens(p[0], "a");   
      if (light_sensor.length != 3) { 
         //exit this function if packet is broken
        return; 
      }
      valL_sensor = int(light_sensor[1]);
      
      // Get Servo Position reading 
      String[] servo_position = splitTokens(p[0], "b");   
      if (servo_position.length != 3){ 
        return;  //exit this function if packet is broken
      }
      valS_position = int(servo_position[1]);
      
      //set background colour and text settings
      background(176, 176, 234);
      textFont(font); 
      textAlign(CENTER);
      
      
      // Timer Display
      if (startTimer){
        
        //draw and move all the teacups when the timer has started
        for(int i = 0; i < teacups.size(); i++) {
          Teacup t = teacups.get(i);
          t.drawMe(); 
          t.move();
        }
        
        //message
        fill(255, 255, 255);
        textSize(40);
        text("Your tea will be ready in:", width/2, height/2 - 80);
        textSize(120);
        timer--;
        
        // Decreasing the Timer
        if (timer > 1190){
          // Timer at 2min
          text(minuteTimer+":00", width/2, height/2 + 50);
        } else if (timer == 1190){
          // Timer at 1:59min
          minuteTimer--;
          secTimer--;
          text(minuteTimer+":"+(secTimer/10), width/2, height/2 + 50);
        } else if (timer == 600){
          // Timer at 1min
          minuteTimer--;
          secTimer = 600;
          text(minuteTimer+":00", width/2, height/2 + 50);
        } else{
          secTimer--;
          if((secTimer)% 20 == 0){
            println("UP/DOWN");
            if(valS_position == 140){
              port.write('D');
            } else if(valS_position == 180){
              port.write('U');
            }
          }
          if(secTimer < 100){
            // When seconds timer is below 10
            text(minuteTimer+":0"+(secTimer/10), width/2, height/2 + 50);
          } else{
            text(minuteTimer+":"+(secTimer/10), width/2, height/2 + 50);
          }
        }
        // Reset Timer
        if(timer < 0){
          timer = 1200;
          minuteTimer = 2;
          secTimer = 600;
          startTimer = false;
          showButton = true;
          // Display Completed Message
          doneMessage = true;
        }
      }
      
      // Display Project Name
      fill(255, 255, 255);
      textSize(60);
      text("Dip & Sip", width/2, 130);
      
      
      // Display Completed Message
      if(doneMessage){
          textSize(40);
          text("Your tea is ready!", width/2, height/2);
      }
      
      if(showButton){
        // Determine if cup has been placed to show button
        if(valL_sensor < 30){
            // display 'Start' button
            fill(225, 212, 255);
            rect(buttonX, buttonY, buttonWidth, buttonHeight, 7);
            fill(176, 176, 234);
            textSize(48);
            text("Start", width/2, 478);
            // turn on green LED and turn off red LED
            port.write('H');
        } 
        else {
          // turn off green LED and turn on red LED
          port.write('H');
        }
      }

    }
  } 
}

void mouseClicked() {
  if (mouseX > buttonX && mouseX < buttonX + buttonWidth && mouseY > buttonY && mouseY < buttonY + buttonHeight){
    // Start Timer and Hide Button
    startTimer = true;
    showButton = false;

    // turn on red LED and turn off green LED
    port.write('L');

    // hide done message
    doneMessage = false;
  }
}
