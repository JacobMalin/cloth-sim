// Jacob Malin <malin146@umn.edu>
// A clothesline

class Clothesline {
  int numCloths = 7;
  Rope rope;
  Cloth cloths[] = new Cloth[numCloths];
  color colors[] = {
    #bda55c,
    #d0c3b7,
    #c7c3c1,
    #cab5a1,
    #9a7c73,
    #c8bcb0,
    #b7aaa2,
  };
  
  PShape pole;
  
  public Clothesline(PShape pole, Vec3 gravity, Vec3 air, Vec3 center, float radius) {
    this.pole = pole;
    
    rope = new Rope(gravity, new Vec3(-260.5, -140, -100.2), new Vec3(-49.4, -123, -500.3), 0.25, 32, center, radius);
    
    for (int i = 0; i < numCloths; i++) {
      cloths[i] = new Cloth(gravity, air, rope.getPoint(1+i*4), rope.getPoint(4+i*4), 4, 8+int(random(6)), 10, center, radius);
    }
  }
  
  void Update(float dt) {
    int split = 60;
    for (int i = 0; i < split; i++) {
      rope.Update(dt/split);
      
      for (Cloth c : cloths) c.Update(dt/split);
    }
  }
  
  void Draw() {
    // Left Pole
    pole.setFill(purpleGray);
    noStroke();
    pushMatrix();
    translate(-260, -142, -100);
    rotateX(-0.03);
    rotateZ(-0.08);
    scale(2);
    shape(pole);
    popMatrix();
    
    // Right Pole
    pushMatrix();
    translate(-50, -125, -500);
    rotateX(0.1);
    rotateZ(0.075);
    scale(2);
    shape(pole);
    popMatrix();
    
    stroke(200);
    rope.Draw();
    
    noStroke();
    for (int i = 0; i < numCloths; i++) {
      fill(colors[i]);
      cloths[i].Draw();
    }
  }
  
  void HandleKeyPressed() {
    rope.HandleKeyPressed();
    
    for (Cloth c : cloths) c.HandleKeyPressed();
  }
}
