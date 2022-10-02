import processing.serial.*;

int sensorVal;
int servoAngle;

String[] sensorReadings = new String[3];

float radius = 0;
float theta = 0;

PVector depth;
PVector origin;

//int originX;
//int originY;

int minDist;
int maxDist;

color bgColor = color(200, 200, 200);

Serial myPort;

void setup() {
  size(800, 800, P3D);
  background(bgColor);
  strokeWeight(5);

  // List all the available serial ports:
  printArray(Serial.list());
  
  myPort = new Serial(this, Serial.list()[0], 9600);
  myPort.clear();
  delay(100);
  myPort.readStringUntil('\n');
  //myPort.bufferUntil('\n'); 

  origin = new PVector(0, 0, 0);

  depth = new PVector(0, 0, 0);

  origin.x = width/2;
  origin.y = height/2;
}

void draw() {

  //generate random vector data as placeholder data
  depth.x = int(random(origin.x, 400));
  depth.y = int(random(origin.y, 400));

  depth.x = radius * cos(theta);
  depth.y = radius * sin(theta);


  stroke(255, 0, 0);
  point(origin.x + depth.x, origin.y + depth.y);

  // increment the angle
  // right now, increasing this number will increase the speed
  // eventually, this value should be coming from the servo's angle
  theta += 0.05;

  // increment the radius
  // eventually, this should match the sensor's min and max
  radius = random(0, 400);

  // start over if we have gone a full rotation
  if (theta >= 6.5) {
    //println("done"); 
    background(bgColor);
    theta = 0;
  }
}

// Function for handling incoming serial data
void serialEvent(Serial myPort){
  
  // move the visualization from draw loop into here
  
  String inputString = myPort.readString();
  if (inputString != null) {
    // when you know you've got a good string, split it into arrays
    sensorReadings = split(inputString, ",");
  }
  
  if (sensorReadings.length > 2) {  // check that the array has at least three elements
    depth.x = int(sensorReadings[0]);  // copy the first element into xPosition
    depth.y = int(sensorReadings[1]);  // copy the second element  into yPosition
    depth.z = int(sensorReadings[2]);  // copy the third element into zPosition
    //accel = int(sensorReadings[3]); // get the accelerometer data
    
    //xPos3D = int(sensorReadings[3]);
    //yPos3D = int(sensorReadings[4]);
    //zPos3D = int(sensorReadings[5]);
    
    println(sensorReadings[0]);
    println(sensorReadings[1]);
    println(sensorReadings[2]);
    println("---------");
  }
}
