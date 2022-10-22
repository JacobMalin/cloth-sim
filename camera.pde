// Created for CSCI 5611 by Liam Tyler
// Modified so that holding shift wont go zoooom
// Also added position recall when numkeys 1, 2, 3, etc are pressed
// Prevents going under sea level

// WASD keys move the camera relative to its current orientation
// Arrow keys rotate the camera's orientation
// Holding shift boosts the move speed

// Recall 1 -- default, centered
PVector pos1 = new PVector( 0, -190, 2521 );
float theta1 = 0;
float phi1 = 0.098;
float speed1 = 50;

// Recall 2 -- movie scene w/ speed to match
PVector pos2 = new PVector( 248, -190, 2521 );
float theta2 = 0;
float phi2 = 0.098;
float speed2 = 300;

// Recall 3 -- show off the cloth
PVector pos3 = new PVector( 418.1, -121.5, 51.1 );
float theta3 = 1.259;
float phi3 = 0.0416;
float speed3 = 50;

int state = '1';

class Camera
{
  Camera()
  {
    position      = new PVector( pos1.x, pos1.y, pos1.z ); // initial position
    theta         = theta1; // rotation around Y axis. Starts with forward direction as ( 0, 0, -1 )
    phi           = phi1; // rotation around X axis. Starts with up direction as ( 0, 1, 0 )
    moveSpeed     = speed1;
    turnSpeed     = 1.57; // radians/sec
    boostSpeed    = 10;  // extra speed boost for when you press shift
    
    // dont need to change these
    shiftPressed = false;
    negativeMovement = new PVector( 0, 0, 0 );
    positiveMovement = new PVector( 0, 0, 0 );
    negativeTurn     = new PVector( 0, 0 ); // .x for theta, .y for phi
    positiveTurn     = new PVector( 0, 0 );
    fovy             = PI / 4;
    aspectRatio      = width / (float) height;
    nearPlane        = 0.1;
    farPlane         = 10000;
  }
  
  void Update(float dt)
  {
    theta += turnSpeed * ( negativeTurn.x + positiveTurn.x)*dt;
    
    // cap the rotation about the X axis to be less than 90 degrees to avoid gimble lock
    float maxAngleInRadians = 85 * PI / 180;
    phi = min( maxAngleInRadians, max( -maxAngleInRadians, phi + turnSpeed * ( negativeTurn.y + positiveTurn.y ) * dt ) );
    
    // re-orienting the angles to match the wikipedia formulas: https://en.wikipedia.org/wiki/Spherical_coordinate_system
    // except that their theta and phi are named opposite
    float t = theta + PI / 2;
    float p = phi + PI / 2;
    PVector forwardDir = new PVector( sin( p ) * cos( t ),   cos( p ),   -sin( p ) * sin ( t ) );
    PVector upDir      = new PVector( sin( phi ) * cos( t ), cos( phi ), -sin( t ) * sin( phi ) );
    PVector rightDir   = new PVector( cos( theta ), 0, -sin( theta ) );
    PVector velocity   = new PVector( negativeMovement.x + positiveMovement.x, negativeMovement.y + positiveMovement.y, negativeMovement.z + positiveMovement.z );
    if (shiftPressed) moveSpeed *= boostSpeed;
    position.add( PVector.mult( forwardDir, moveSpeed * velocity.z * dt ) );
    position.add( PVector.mult( upDir,      moveSpeed * velocity.y * dt ) );
    position.add( PVector.mult( rightDir,   moveSpeed * velocity.x * dt ) );
    if (shiftPressed) moveSpeed /= boostSpeed;
    
    // Prevent from going underwater
    if (position.y > -0.2) position.y = -0.2;
    
    aspectRatio = width / (float) height;
    perspective( fovy, aspectRatio, nearPlane, farPlane );
    camera( position.x, position.y, position.z,
            position.x + forwardDir.x, position.y + forwardDir.y, position.z + forwardDir.z,
            upDir.x, upDir.y, upDir.z );
  }
  
  // only need to change if you want difrent keys for the controls
  void HandleKeyPressed()
  {
    if ( key == 'w' || key == 'W' ) positiveMovement.z = 1;
    if ( key == 's' || key == 'S' ) negativeMovement.z = -1;
    if ( key == 'a' || key == 'A' ) negativeMovement.x = -1;
    if ( key == 'd' || key == 'D' ) positiveMovement.x = 1;
    if ( key == 'q' || key == 'Q' ) positiveMovement.y = 1;
    if ( key == 'e' || key == 'E' ) negativeMovement.y = -1;
    
    if ( keyCode == LEFT )  negativeTurn.x = 1;
    if ( keyCode == RIGHT ) positiveTurn.x = -0.5;
    if ( keyCode == UP )    positiveTurn.y = 0.5;
    if ( keyCode == DOWN )  negativeTurn.y = -1;
    
    if ( keyCode == SHIFT ) shiftPressed = true;
    
    if ( key == 'p' || key == 'P' ) println(position, theta, phi);
    
    
    // States
    int newState = '0';
    if ( key == '1' || key == '2' || key == '3' || key == '!' || key == '@' || key == '#' ) newState = key;
    if ( key == 'r' || key == 'R' ) newState = state;
    
    if ( newState == '1' || newState == '!' ) {
      position = new PVector( pos1.x, pos1.y, pos1.z );
      theta = theta1;
      phi = phi1;
      moveSpeed = speed1;
    }
    if ( newState == '2' || newState == '@' ) {
      position = new PVector( pos2.x, pos2.y, pos2.z );
      theta = theta2;
      phi = phi2;
      moveSpeed = speed2;
    }
    if ( newState == '3' || newState == '#' ) {
      position = new PVector( pos3.x, pos3.y, pos3.z );
      theta = theta3;
      phi = phi3;
      moveSpeed = speed3;
    }
    if ( newState != '0' ) state = newState;
  }
  
  // only need to change if you want difrent keys for the controls
  void HandleKeyReleased()
  {
    if ( key == 'w' || key == 'W' ) positiveMovement.z = 0;
    if ( key == 'q' || key == 'Q' ) positiveMovement.y = 0;
    if ( key == 'd' || key == 'D' ) positiveMovement.x = 0;
    if ( key == 'a' || key == 'A' ) negativeMovement.x = 0;
    if ( key == 's' || key == 'S' ) negativeMovement.z = 0;
    if ( key == 'e' || key == 'E' ) negativeMovement.y = 0;
    
    if ( keyCode == LEFT  ) negativeTurn.x = 0;
    if ( keyCode == RIGHT ) positiveTurn.x = 0;
    if ( keyCode == UP    ) positiveTurn.y = 0;
    if ( keyCode == DOWN  ) negativeTurn.y = 0;
    
    if ( keyCode == SHIFT ) shiftPressed = false;
  }
  
  // only necessary to change if you want different start position, orientation, or speeds
  PVector position;
  float theta;
  float phi;
  float moveSpeed;
  float turnSpeed;
  float boostSpeed;
  
  // probably don't need / want to change any of the below variables
  float fovy;
  float aspectRatio;
  float nearPlane;
  float farPlane;  
  PVector negativeMovement;
  PVector positiveMovement;
  PVector negativeTurn;
  PVector positiveTurn;
  boolean shiftPressed;
};
