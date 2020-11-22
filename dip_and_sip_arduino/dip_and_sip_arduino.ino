  #include <Servo.h> //import servo library 

  boolean inPlace; 
  Servo myservo; //create the servo object 
 
  int redLED = 5;
  int greenLED = 3;

  //ultrasonic distance sensor 
  int TRIG_PIN = 13;
  int ECHO_PIN = 12; 

  int sensor = 0; 
  int val_distance;

  int incomingByte; 
 

void setup() {
  Serial.begin(9600); 

  inPlace = false; 

  //LED lights
  pinMode(redLED, OUTPUT); 
  pinMode(greenLED, OUTPUT); 

  //utrasonic distance sensor
  pinMode(TRIG_PIN, OUTPUT);
  pinMode(ECHO_PIN, INPUT);

  //servo 
  myservo.attach(6); //attach the servo onto pin 6 to the servo object

}

void loop() {

  // ----- ultrasonic distance sensor input ------------
  digitalWrite(TRIG_PIN, LOW);
  delayMicroseconds(2);
  digitalWrite(TRIG_PIN, HIGH);
  delayMicroseconds(2);
  digitalWrite(TRIG_PIN, LOW);  

  long duration = pulseIn (ECHO_PIN, HIGH);
  int val_distance = duration/29/2;
//  if (duration == 0) {
//   Serial.println("Warning: no pulse from sensor");
//   } else {
//      Serial.print("distance to nearest object:");
//      Serial.println(distance);
//      Serial.println(" cm");
//  }

  //  if the cup has been placed, send the information to processing

    //val_distance = analogRead(sensor)/4; 
    
    inPlace = true;

    if (val_distance < 10) {
    //'a' packet starts 
      Serial.print("a");
      Serial.print(val_distance); 
      Serial.print("a"); 
      Serial.println(); 
      //'a' packet ends  
  
      Serial.print("&"); //denotes end of readings from both sensors
      Serial.println(); 
  
      delay(100); //Wait 100ms for next reading
    
    }
    


  //check if the information has been sent from processing 
  if (Serial.available() > 0) {

    //read the most recent byte that is a boolean
    Serial.println("hello"); 
    incomingByte = Serial.read(); 

    // if the user has not placed a cup/triggered the button, show the machine in a ready state   
    if (incomingByte == 'H') { 
      digitalWrite(greenLED, HIGH);
      digitalWrite(redLED, LOW);
      myservo.write(0); 

    //if the user has triggered the button, show the machine in a busy state
    }

    if (incomingByte == 'L') {
      digitalWrite(greenLED, LOW); 
      digitalWrite(redLED, HIGH);
      
      //when the steeping process has started, move the servo up and down to steep the tea       
      myservo.write(180);
    }
  }


}
