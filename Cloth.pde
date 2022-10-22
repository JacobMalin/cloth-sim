// Jacob Malin <malin146@umn.edu>
// Cloth animation
//
// Adapted from Stephen J. Guy <sjguy@umn.edu>
// Triple Spring (damped)

class Cloth {
  Vec3 gravity, center;
  Point start, end;
  float radius, restLen;
  int rows, cols, numSprings;
  Point points[][];
  Spring springs[];

  float stayAway = 0.05;
  float bounce = 0.6;
  float mass = 0.03;
  float k = 2000;
  float kv = 40;
  float kAero = 1000;
  float maxForce = MAX_FLOAT; //5000;
  
  public Cloth(Vec3 gravity, Vec3 air, Point start, Point end, float restLen, int rows, int cols, Vec3 center, float radius) {
    this.gravity = gravity;
    this.start = start;
    this.end = end;
    this.center = center;
    this.radius = radius;
    this.restLen = restLen;
    this.rows = rows;
    this.cols = cols;
    
    numSprings = rows * (cols-1) + cols * (rows-1); //<>//
    points = new Point[rows][cols];
    springs = new Spring[numSprings];
    
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        Vec3 lerp = interpolate(start.pos, end.pos, j/float(rows-1)).plus(new Vec3(0, i*restLen, 0));
        if (i == 0 && j == 0) points[i][j] = start;
        else if (i == 0 && j == cols-1) points[i][j] = end;
        else points[i][j] = new Point(lerp, new Vec3(0, 0, 0), mass);
      }
    }
    
    int springIdx = 0;
    for (int i = 0; i < rows - 1; i++) {
      for (int j = 0; j < cols; j++)
        springs[springIdx++] = new Spring(points[i][j], points[i+1][j], restLen, k, kv);
    }
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols - 1; j++)
        springs[springIdx++] = new Spring(points[i][j], points[i][j+1], restLen, k, kv);
    }
  }
  
  int springBetween(int i1, int j1, int i2, int j2) {
    if (i1+1 == i2) return j1 + i1 * cols;
    else if (j1+1 == j2) return ((rows-1) * cols) + j1 + i1 * (cols-1);
    else return -1;
  }
  
  Vec3 normPoint(int i, int j) {
    int i2, j2;
    int polarity = 1;
    if (i > 0 && springs[springBetween(i-1, j, i, j)].alive) i2 = i-1;
    else {
      i2 = i+1;
      polarity *= -1;
    }
    
    if (j > 0 && springs[springBetween(i, j-1, i, j)].alive) j2 = j-1;
    else {
      j2 = j+1;
      polarity *= -1;
    }
    
    return cross(points[i][j].pos.minus(points[i2][j].pos), points[i][j].pos.minus(points[i][j2].pos)).times(polarity);
  }
  
  void updateVel(float dt) {
    for (Spring s : springs) {
      if (s.alive) {
        Vec3 diff = s.right.posNew.minus(s.left.posNew);
        float stringF = -s.k*(diff.length() - s.restLen);
        
        Vec3 stringDir = diff.normalized();
        float projVleft = dot(s.left.vel, stringDir);
        float projVright = dot(s.right.vel, stringDir);
        float dampF = -kv*(projVright - projVleft);
        
        Vec3 force = stringDir.times(stringF + dampF);
        if (force.length() > maxForce)
          s.alive = false;
       
        s.left.velNew.add(force.times(-dt/mass));
        s.right.velNew.add(force.times(dt/mass));
      }
    }
    
    // Gravity
    for (Point[] row : points) {
      for (Point p : row)
        p.velNew.add(gravity.times(dt));
    }
    
    // Drag
    Vec3 norm;
    for (int i = 1; i < rows; i++) {
      for (int j = 1; j < cols; j++) {
        if (springs[springBetween(i-1, j, i, j)].alive && springs[springBetween(i-1, j-1, i-1, j)].alive && springs[springBetween(i-1, j-1, i, j-1)].alive && springs[springBetween(i, j-1, i, j)].alive) {
          norm = normPoint(i, j);
          
          Vec3 v = points[i][j].vel.plus(points[i-1][j].vel).plus(points[i][j-1].vel).times(1/3);
          v.subtract(air);
          
          float a0 = norm.length();
          float a;
          if (v.length() == 0) a = 0;
          else a = a0 * dot(v, norm) / v.length();
          
          Vec3 aero = norm.normalized().times(-kAero * v.length() * v.length() * a);
          points[i][j].velNew.add(aero.times(dt/3));
          points[i-1][j].velNew.add(aero.times(dt/3));
          points[i][j-1].velNew.add(aero.times(dt/3));
        }
      }
    }
  }
  
  void Update(float dt) {
    for (Point[] row : points) {
      for (Point p : row) {
        p.velNew = p.vel;
        p.posNew = p.pos;
      }
    }
    
    updateVel(dt);
    
    for (Point[] row : points) {
      for (Point p : row) {
        p.posNew = p.pos.plus(p.velNew.times(dt/2));
        p.velNew = p.vel;
      }
    }
    
    updateVel(dt/2);
    
    // Move points and collision
    for (Point[] row : points) {
      for (Point p : row) {
        p.vel = p.velNew;
        p.pos.add(p.vel.times(dt));
        
        // Points collide
        if (p.pos.distanceTo(center) <= radius) {
          Vec3 dir = p.pos.minus(center);
          Vec3 vel_norm = projAB(p.vel, dir.normalized());
          p.vel.subtract(vel_norm.times(1 + bounce));
          p.pos = center.plus(dir.normalized().times(radius+stayAway*2));
        }
      }
    }
    
    // Complex collision, not nessesary for such a large object
    
    //// Collision along diagonals
    //for (int i = 0; i < rows-1; i++) {
    //  for (int j = 0; j < cols-1; j++) {
    //    Point topLeft = points[i][j];
    //    Point bottomRight = points[i+1][j+1];
    //    hitInfo hit = lineCircleIntesect(center, radius, topLeft.pos, bottomRight.pos);
    //    if (hit.hit) {
    //      Vec3 middleDir = bottomRight.pos.minus(topLeft.pos);
    //      middleDir.setToLength((hit.t2+hit.t1)/2);
    //      Vec3 middleHit = topLeft.pos.plus(middleDir);
    //      Vec3 dir = middleHit.minus(center);
          
    //      Vec3 velNormLeft = projAB(topLeft.vel, dir.normalized());
    //      topLeft.vel.subtract(velNormLeft.times(1 + bounce));
    //      float moveAwayLeft = (radius - middleHit.minus(center).length()) + stayAway;
    //      topLeft.pos.add(dir.normalized().times(moveAwayLeft));
          
    //      Vec3 velNormRight = projAB(bottomRight.vel, dir.normalized());
    //      bottomRight.vel.subtract(velNormRight.times(1 + bounce));
    //      float moveAwayRight = (radius - middleHit.minus(center).length()) + stayAway;
    //      bottomRight.pos.add(dir.normalized().times(moveAwayRight));
    //    }
    //  }
    //}
    
    //// Collision along opposite diagonals
    //for (int i = 0; i < rows-1; i++) {
    //  for (int j = 1; j < cols; j++) {
    //    Point topRight = points[i][j];
    //    Point bottomLeft = points[i+1][j-1];
    //    hitInfo hit = lineCircleIntesect(center, radius, topRight.pos, bottomLeft.pos);
    //    if (hit.hit) {
    //      Vec3 middleDir = bottomLeft.pos.minus(topRight.pos);
    //      middleDir.setToLength((hit.t2+hit.t1)/2);
    //      Vec3 middleHit = topRight.pos.plus(middleDir);
    //      Vec3 dir = middleHit.minus(center);
          
    //      Vec3 velNormLeft = projAB(topRight.vel, dir.normalized());
    //      topRight.vel.subtract(velNormLeft.times(1 + bounce));
    //      float moveAwayLeft = (radius - middleHit.minus(center).length()) + stayAway;
    //      topRight.pos.add(dir.normalized().times(moveAwayLeft));
          
    //      Vec3 velNormRight = projAB(bottomLeft.vel, dir.normalized());
    //      bottomLeft.vel.subtract(velNormRight.times(1 + bounce));
    //      float moveAwayRight = (radius - middleHit.minus(center).length()) + stayAway;
    //      bottomLeft.pos.add(dir.normalized().times(moveAwayRight));
    //    }
    //  }
    //}
    
    //// Collision along springs
    //for (Spring s : springs) {
    //  hitInfo hit = lineCircleIntesect(center, radius, s.left.pos, s.right.pos);
    //  if (hit.hit) {
    //    Vec3 middleDir = s.right.pos.minus(s.left.pos);
    //    middleDir.setToLength((hit.t2+hit.t1)/2);
    //    Vec3 middleHit = s.left.pos.plus(middleDir);
    //    Vec3 dir = middleHit.minus(center);
        
    //    Vec3 velNormLeft = projAB(s.left.vel, dir.normalized());
    //    s.left.vel.subtract(velNormLeft.times(1 + bounce));
    //    float moveAwayLeft = (radius - middleHit.minus(center).length()) + stayAway;
    //    s.left.pos.add(dir.normalized().times(moveAwayLeft));
        
    //    Vec3 velNormRight = projAB(s.right.vel, dir.normalized());
    //    s.right.vel.subtract(velNormRight.times(1 + bounce));
    //    float moveAwayRight = (radius - middleHit.minus(center).length()) + stayAway;
    //    s.right.pos.add(dir.normalized().times(moveAwayRight));
    //  }
    //}
  }
  
  void Draw() {
    for (Spring s : springs) {
      if (s.alive) line(s.left.pos.x, s.left.pos.y, s.left.pos.z, s.right.pos.x, s.right.pos.y, s.right.pos.z);
    }
    //for (Point[] row : points) {
    //  for (Point p : row) {
    //    pushMatrix();
    //    translate(p.pos.x, p.pos.y, p.pos.z);
    //    sphere(radius);
    //    popMatrix();
    //  }
    //}
    
    Vec3 norm;
    for (int i = 0; i < rows-1; i++) {
      for (int j = 0; j < cols-1; j++) {
        if (springs[springBetween(i, j, i+1, j)].alive && springs[springBetween(i+1, j, i+1, j+1)].alive && springs[springBetween(i, j+1, i+1, j+1)].alive && springs[springBetween(i, j, i, j+1)].alive) {
          beginShape();
          norm = normPoint(i, j);
          normal(norm.x, norm.y, norm.z);
          vertex(points[i][j].pos.x, points[i][j].pos.y, points[i][j].pos.z);
          
          norm = normPoint(i+1, j);
          normal(norm.x, norm.y, norm.z);
          vertex(points[i+1][j].pos.x, points[i+1][j].pos.y, points[i+1][j].pos.z);
          
          norm = normPoint(i+1, j+1);
          normal(norm.x, norm.y, norm.z);
          vertex(points[i+1][j+1].pos.x, points[i+1][j+1].pos.y, points[i+1][j+1].pos.z);
          
          //norm = normPoint(i, j+1);
          //normal(norm.x, norm.y, norm.z);
          //vertex(points[i][j+1].pos.x, points[i][j+1].pos.y, points[i][j+1].pos.z);
          
          endShape(CLOSE);
          
          beginShape();
          norm = normPoint(i, j);
          normal(norm.x, norm.y, norm.z);
          vertex(points[i][j].pos.x, points[i][j].pos.y, points[i][j].pos.z);
          
          //norm = normPoint(i+1, j);
          //normal(norm.x, norm.y, norm.z);
          //vertex(points[i+1][j].pos.x, points[i+1][j].pos.y, points[i+1][j].pos.z);
          
          norm = normPoint(i+1, j+1);
          normal(norm.x, norm.y, norm.z);
          vertex(points[i+1][j+1].pos.x, points[i+1][j+1].pos.y, points[i+1][j+1].pos.z);
          
          norm = normPoint(i, j+1);
          normal(norm.x, norm.y, norm.z);
          vertex(points[i][j+1].pos.x, points[i][j+1].pos.y, points[i][j+1].pos.z);
          
          endShape(CLOSE);
        }
      }
    }
  }
  
  void HandleKeyPressed() {
    if ( key == 'c' || key == 'C' ){
      for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
          if (!(i == 0 && j == 0 || i == 0 && j == cols-1)) {
            Vec3 lerp = interpolate(start.pos, end.pos, j/float(rows-1)).plus(new Vec3(0, i*restLen, 0));
            points[i][j].pos = lerp;
            points[i][j].vel = new Vec3(0, 0, 0);
          }
        }
      }
      
      for (Spring s : springs)
        s.alive = true;
    }
  }
}
