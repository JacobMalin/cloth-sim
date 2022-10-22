// Jacob Malin <malin146@umn.edu>
// Project 2

Vec3 gravity = new Vec3(0, 400, 0);
float windSpeed = 0.0013;
Vec3 air = new Vec3(-10*windSpeed, 0*windSpeed, -1*windSpeed);
Vec3 floorCenter = new Vec3(0, 9930, 0);
float floorRadius = 10000;
Vec3 sunCenter = new Vec3(2600, -1900, -100);
int sizeUp = 500;

color grayBlue = #627981;
color blue = #3b82a7;
color lightBlue = #819cb7;
color tanBrown = #ce9f6e;
color tan = #e2bfa9;
color cream = #f0ded1;
color purpleGray = #8e7778;
color indigo = #655e6e;
color lightGreen = #afa351;
color green = #918f45;

Camera camera;
Clothesline clothesline;
PImage sky;
PShape pole, tree, bench, house;

void settings() {
  size(int(1.85*sizeUp), 1*sizeUp, P3D); // 1.85 to 1
  smooth(8);
}

void setup() {
  surface.setTitle("Cloth");
  sphereDetail(80);
  
  camera = new Camera();
  
  // Sky
  sky = loadImage("assets/sky.png");
  
  // Pole
  pole = loadShape("assets/pole/pole.obj");
  
  // Clothesline
  clothesline = new Clothesline(pole, gravity, air, floorCenter, floorRadius);
  
  // Tree
  PShape trunk, leaves;
  tree = createShape(GROUP);
  trunk = loadShape("assets/tree/oak_trunk.obj");
  leaves = loadShape("assets/tree/oak_leaves.obj");
  trunk.setFill(tanBrown);
  leaves.setFill(green);
  tree.addChild(trunk);
  tree.addChild(leaves);
  
  // Bench
  PShape rail, seat;
  bench = createShape(GROUP);
  rail = loadShape("assets/bench/rail.obj");
  seat = loadShape("assets/bench/seat.obj");
  rail.setFill(grayBlue);
  seat.setFill(tanBrown);
  bench.addChild(rail);
  bench.addChild(seat);
  
  // House
  PShape body, chimney, door, roof, window;
  house = createShape(GROUP);
  body = loadShape("assets/house/body.obj");
  chimney = loadShape("assets/house/chimney.obj");
  door = loadShape("assets/house/door.obj");
  roof = loadShape("assets/house/roof.obj");
  window = loadShape("assets/house/window.obj");
  body.setFill(tan);
  chimney.setFill(purpleGray);
  door.setFill(tanBrown);
  roof.setFill(tanBrown);
  window.setFill(cream);
  house.addChild(body);
  house.addChild(chimney);
  house.addChild(door);
  house.addChild(roof);
  house.addChild(window);
}

void update(float dt) {
  camera.Update(dt);
  
  clothesline.Update(dt);
}

void draw() {
  //lights();
  background(blue);
  
  float dt = 1.0/frameRate;
  update(dt);
  
  // Sky gradient
  PShape skyBall = createShape(SPHERE, 5000);
  skyBall.setTexture(sky);
  noStroke();
  pushMatrix();
  translate(0, -300, 0);
  shape(skyBall);
  popMatrix();
  
  // Sun
  pointLight(255, 219, 189, sunCenter.x, sunCenter.y, sunCenter.z);
  float ambientDiv = 0.96;
  ambientLight(74/ambientDiv, 80/ambientDiv, 72/ambientDiv);
  fill(200, 200, 0);
  pushMatrix();
  translate(sunCenter.x, sunCenter.y, sunCenter.z);
  sphere(100);
  popMatrix();
  
  // Clothesline
  clothesline.Draw();

  // Land
  fill(lightGreen);
  noStroke();
  pushMatrix();
  translate(floorCenter.x, floorCenter.y, floorCenter.z);
  sphere(floorRadius);
  popMatrix();
  
  // Ocean
  fill(lightBlue);
  noStroke();
  pushMatrix();
  translate(0, 0, 0);
  box(10000, 0, 10000);
  popMatrix();
  
  // Tree
  pushMatrix();
  translate(500, -45, 0);
  rotateX(-0.2);
  rotateY(4.1);
  rotateZ(-0.4);
  scale(270);
  shape(tree);
  popMatrix();
  
  // Bench
  pushMatrix();
  translate(385, -62, 0);
  rotateX(0);
  rotateY(1.85);
  rotateZ(0);
  scale(0.5);
  shape(bench);
  popMatrix();
  
  // House
  pushMatrix();
  translate(-600, -34, 0);
  rotateX(3.15);
  rotateY(0.66);
  rotateZ(0.03);
  scale(90);
  shape(house);
  popMatrix();
}

void keyPressed() {
  camera.HandleKeyPressed();
  clothesline.HandleKeyPressed();
}

void keyReleased() {
  camera.HandleKeyReleased();
}
