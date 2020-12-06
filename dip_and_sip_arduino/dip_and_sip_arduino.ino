  //import servo library
  #include <Servo.h>  

  //create the servo object
  Servo myservo;  
 
  int redLED = 5;
  int greenLED = 3;

  int sensor = 0; 
  int val_light;

  int incomingByte; 
 
void setup() {
  Serial.begin(9600); 

  //setting LEDs as outputs
  pinMode(redLED, OUTPUT); 
  pinMode(greenLED, OUTPUT); 

  //attach the servo onto pin 6 to the servo object 
  myservo.attach(6); 

}

void loop() {

    // read light sensor value
    val_light = analogRead(sensor)/4; 
    
    //'a' packet starts for light sensor value
    Serial.print("a");
    Serial.print(val_light); 
    Serial.print("a"); 
    Serial.println(); 
    //'a' packet ends

    //'b' packet starts to send servo reading   
    Serial.print("b");
    Serial.print(myservo.read()); 
    Serial.print("b"); 
    Serial.println(); 
    //'b' packet ends

    //denotes end of readings from light sensor and servo
    Serial.print("&"); 
    Serial.println(); 

    //Wait 100ms for next reading
    delay(100); 


  //check if the information has been sent from processing 
  if (Serial.available() > 0) {

    //read the most recent byte that is a boolean
    incomingByte = Serial.read(); 

    // if the user has not placed a cup/triggered the button, show the machine in a ready state   
    if (incomingByte == 'H') { 
      //turn on green LED
      digitalWrite(greenLED, HIGH);
      //turn off red LED
      digitalWrite(redLED, LOW);
      //raise the teabag out of the cup
      myservo.write(90); 
    }

    //if the user has triggered the button, show the machine in a busy state
    if (incomingByte == 'L') {
      // turn off greed LED
      digitalWrite(greenLED, LOW);
      // turn on red LED 
      digitalWrite(redLED, HIGH);
      // lower the teabag into the cup       
      myservo.write(180);
    }

    //lift the teabag up for a bobbing motion
    if (incomingByte == 'U') {
        myservo.write(140);
    }

    //lower the teabag down for a bobbing motion
    if (incomingByte == 'D') {
        myservo.write(180);
    }
  }
}
