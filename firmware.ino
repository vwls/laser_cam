/**
   http://static.garmin.com/pumac/LIDAR_Lite_v3_Operation_Manual_and_Technical_Specifications.pdf

   TODO: add IMU sensing and send pitch, roll, and yaw data over serial
*/

#include <Wire.h>
#include <LIDARLite.h>
#include <Servo.h>

// Globals
LIDARLite lidarLite;
int cal_cnt = 0;

Servo myservo;

int servoAngle = 0;

void setup() {
  Serial.begin(9600); // Initialize serial connection to display distance readings

  myservo.attach(9);  // attaches the servo on pin 9 to the servo object


  lidarLite.begin(0, true); // Set configuration to default and I2C to 400 kHz
  lidarLite.configure(0); // Change this number to try out alternate configurations
}

void loop() {

  for (pos = 0; pos <= 180; pos += 1) { // goes from 0 degrees to 180 degrees
    // in steps of 1 degree
    myservo.write(pos);              // tell servo to go to position in variable 'pos'
    delay(10);                       // waits 15 ms for the servo to reach the position

    int dist;

    // At the beginning of every 100 readings,
    // take a measurement with receiver bias correction
    if ( cal_cnt == 0 ) {
      dist = lidarLite.distance();      // With bias correction
    } else {
      dist = lidarLite.distance(false); // Without bias correction
    }

    // Increment reading counter
    cal_cnt++;
    cal_cnt = cal_cnt % 100;

    // Transmit distance
    Serial.print('a');
    Serial.println(dist);

    // Transmit angle
    Serial.print('b');
    Serial.println(servoAngle);
  }

  delay(10);
}
