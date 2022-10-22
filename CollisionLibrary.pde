// Taken from CCD, with minor modifications

//Find the intersections on a circle hit when starting at l_start and ending at l_end
hitInfo lineCircleIntesect(Vec3 center, float r, Vec3 l_start, Vec3 l_end){
  hitInfo hit = new hitInfo();
  
  // Compute l_dir and l_len
  Vec3 l_dir = l_end.minus(l_start).normalized();
  float l_len = l_end.minus(l_start).length();
  
  //Step 2: Compute W - a displacement vector pointing from the start of the line segment to the center of the circle
    Vec3 toCircle = center.minus(l_start);
    
    //Step 3: Solve quadratic equation for intersection point (in terms of l_dir and toCircle)
    float a = 1;  //Lenght of l_dir (we noramlized it)
    float b = -2*dot(l_dir,toCircle); //-2*dot(l_dir,toCircle)
    float c = toCircle.lengthSqr() - r*r; //different of squared distances
    
    float d = b*b - 4*a*c; //discriminant 
    
    if (d >=0 ){ 
      //If d is positive we know the line is colliding, but we need to check if the collision line within the line segment
      //  ... this means t will be between 0 and the lenth of the line segment
      float t1 = (-b - sqrt(d))/(2*a);
      float t2 = (-b + sqrt(d))/(2*a);
      if (t1 > 0 && t1 < l_len){
        hit.hit = true;
        hit.t1 = t1;
        hit.t2 = t2;
      } 
    }
    
  return hit;
}

class hitInfo{
  public boolean hit = false;
  public float t1 = MAX_FLOAT, t2 = MAX_FLOAT;
}
