// Jacob Malin <malin146@umn.edu>
// Rope animation
//
// Adapted from Stephen J. Guy <sjguy@umn.edu>
// Triple Spring (damped)

class Rope {
  Vec3 gravity, start, end, center;
  float radius, restLen;
  int numPoints, numSprings;
  Point points[];
  Spring springs[];

  float stayAway = 1.0001;
  float bounce = 0.1;
  float mass = 0.06;
  float k = 2200;
  float kv = 60;
  float maxForce = MAX_FLOAT; //5000;
  
  public Rope(Vec3 gravity, Vec3 start, Vec3 end, float restLen, int numPoints, Vec3 center, float radius) {
    this.gravity = gravity;
    this.start = start;
    this.end = end;
    this.center = center;
    this.radius = radius;
    this.restLen = restLen;
    this.numPoints = numPoints;
    
    numSprings = numPoints-1;
    points = new Point[numPoints];
    springs = new Spring[numSprings];
    
    for (int i = 0; i < numPoints; i++) {
        Vec3 lerp = interpolate(start, end, i/float(numPoints-1));
        points[i] = new Point(lerp, new Vec3(0, 0, 0), mass);
    }
    
    for (int i = 0; i < numSprings; i++)
       springs[i] = new Spring(points[i], points[i+1], restLen, k, kv);
  }
  
  Point getPoint(int idx) {
    return points[idx];
  }
  
  void Update(float dt) {
    for (Point p : points) p.velNew = p.vel;
    
    for (Spring s : springs) {
      if (s.alive) {
        Vec3 diff = s.right.pos.minus(s.left.pos);
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
    for (Point p : points) p.velNew.add(gravity.times(dt));
    
    // Hold left and right in place
    points[0].velNew = new Vec3(0, 0, 0);
    points[numPoints-1].velNew = new Vec3(0, 0, 0);
    
    // Move points and collision
    for (Point p : points) {
      p.vel = p.velNew;
      p.pos.add(p.vel.times(dt));
      
      // Points collide
      if (p.pos.distanceTo(center) <= radius*stayAway) {
        Vec3 dir = p.pos.minus(center);
        Vec3 vel_norm = projAB(p.vel, dir.normalized());
        p.vel.subtract(vel_norm.times(1 + bounce));
        p.pos = center.plus(dir.normalized().times(radius*stayAway));
      }
    }
    
    // Collision along springs
    for (Spring s : springs) {
      hitInfo hit = lineCircleIntesect(center, radius, s.left.pos, s.right.pos);
      if (hit.hit) {
        Vec3 middleDir = s.right.pos.minus(s.left.pos);
        middleDir.setToLength((hit.t2+hit.t1)/2);
        Vec3 middleHit = s.left.pos.plus(middleDir);
        Vec3 dir = middleHit.minus(center);
        
        Vec3 velNormLeft = projAB(s.left.vel, dir.normalized());
        s.left.vel.subtract(velNormLeft.times(1 + bounce));
        float moveAwayLeft = (radius - middleHit.minus(center).length()) * stayAway;
        s.left.pos.add(dir.normalized().times(moveAwayLeft));
        
        Vec3 velNormRight = projAB(s.right.vel, dir.normalized());
        s.right.vel.subtract(velNormRight.times(1 + bounce));
        float moveAwayRight = (radius - middleHit.minus(center).length()) * stayAway;
        s.right.pos.add(dir.normalized().times(moveAwayRight));
      }
    }
  }
  
  void Draw() {
    for (Spring s : springs)
      if (s.alive) line(s.left.pos.x, s.left.pos.y, s.left.pos.z, s.right.pos.x, s.right.pos.y, s.right.pos.z);
  }
  
  void HandleKeyPressed() {
    if ( key == 'c' || key == 'C' ) {
      for (int i = 0; i < numPoints; i++) {
        Vec3 lerp = interpolate(start, end, i/float(numPoints-1));
        points[i].pos = lerp;
        points[i].vel = new Vec3(0, 0, 0);
      }
      
      for (Spring s : springs) s.alive = true;
    }
  }
}



// ------------------------------------------
// Point and Spring classes
// ------------------------------------------



class Point {
  Vec3 pos, posNew, vel, velNew;
  float mass;
  
  public Point(Vec3 pos, Vec3 vel, float mass) {
    this.pos = pos;
    this.vel = vel;
    this.velNew = vel;
    this.mass = mass;
  }
}

class Spring {
  Point left, right;
  float restLen, k, kv;
  boolean alive = true;
  
  public Spring(Point left, Point right, float restLen, float k, float kv) {
    this.left = left;
    this.right = right;
    this.restLen = restLen;
    this.k = k;
    this.kv = kv;
  }
}
