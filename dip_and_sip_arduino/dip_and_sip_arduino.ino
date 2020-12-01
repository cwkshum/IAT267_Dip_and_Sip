  #include <Servo.h> //import servo library 

  boolean inPlace; 
  Servo myservo; //create the servo object 
 
  int redLED = 5;
  int greenLED = 3;

  int sensor = 0; 
  int val_light;

  int incomingByte; 
 

void setup() {
  Serial.begin(9600); 

  inPlace = false; 

  //LED lights
  pinMode(redLED, OUTPUT); 
  pinMode(greenLED, OUTPUT); 

  //servo 
  myservo.attach(6); //attach the servo onto pin 6 to the servo object

}

void loop() {
  //  if the cup has been placed, send the information to processing

    val_light = analogRead(sensor)/4; 
    
    inPlace = true;

    //'a' packet starts 
      Serial.print("a");
      Serial.print(val_light); 
      Serial.print("a"); 
      Serial.println(); 
      //'a' packet ends

      //'b' packet starts 
      Serial.print("b");
      Serial.print(myservo.read()); 
      Serial.print("b"); 
      Serial.println(); 
      //'b' packet ends
  
      Serial.print("&"); //denotes end of readings from both sensors
      Serial.println(); 
  
      delay(100); //Wait 100ms for next reading


  //check if the information has been sent from processing 
  if (Serial.available() > 0) {

    //read the most recent byte that is a boolean
    Serial.println("hello"); 
    incomingByte = Serial.read(); 

    // if the user has not placed a cup/triggered the button, show the machine in a ready state   
    if (incomingByte == 'H') { 
      digitalWrite(greenLED, HIGH);
      digitalWrite(redLED, LOW);
      myservo.write(90); 

    //if the user has triggered the button, show the machine in a busy state
    }

    if (incomingByte == 'L') {
      digitalWrite(greenLED, LOW); 
      digitalWrite(redLED, HIGH);
      
      //when the steeping process has started, move the servo up and down to steep the tea       
      myservo.write(180);
    }

    if (incomingByte == 'U') {
        myservo.write(120);
    }

    if (incomingByte == 'D') {
        myservo.write(180);
    }
  }


}
