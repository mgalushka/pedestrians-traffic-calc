class Tracked{

  // test and check - in frame count
  int deltaT_x = 15;
  int deltaT_y = 45;
  
  // stale time ~2sec
  int staleT = 120;
  
  int MAX_STALE_T = 120;
  int MIN_STALE_T = 30;
  
  // pixels
  int deltaX = 100;
  int deltaY = 30;
  
  Scalar draw;
  
  // trajectory of an object
  public Map<Integer, Point> trajectory = new TreeMap();
   
  // last time object tracked - number of screen
  public Integer T;
  public Point last;
  
  // 0 - right
  // 1 - left
  public Integer direction = -1;
  
  String id;
 
 Tracked(Integer t, Point p){
   this.T = t;
   this.last = p;
   this.trajectory.put(t, p);
   id = UUID.randomUUID().toString();
   draw = new Scalar(0, (int) random(255), (int) random(255));
 } 
 
 // method determines if we need to stop tracking current object 
 // as this has disappeared from the screen forever
 public boolean isStale(Integer time){
   return (Math.abs(this.T - time) > staleT);
 }
 
 public boolean checkSameAndAdd(Integer time, Point b){
   if(Math.abs(last.x - b.x) <= deltaX && Math.abs(time - T) <= deltaT_x) {
     return addPoint(time, b);
   }   
   if(Math.abs(last.y - b.y) <= deltaY && Math.abs(time - T) <= deltaT_y) {
     return addPoint(time, b);
   }
   else{
     return false;
   }
 }
 
 // checks if next point has adjusted direction with current
 private boolean adjusted(Point p){
   if(direction < 0) return true;
   if(p.x > last.x && direction == 0) return true;
   if(p.x < last.x && direction == 1) return true;
   
   // if change is really small - allow to add wrong directed points
   // TODO: this is real hack - remove by proper object tracking
   if(Math.abs(p.x - last.x) < 10) return true;
   return false;
 }
 
 private void direction(){
   if(direction >= 0) return;  
   
   if(trajectory.size() >= 10){
     int right = 0;
     int left = 0;
     println("Calculating direction");
     
     Point prev = ((TreeMap<Integer, Point>) trajectory).firstEntry().getValue();
     for(Integer t : trajectory.keySet()){
       Point next = (Point) trajectory.get(t);
       if(next.x > prev.x) right ++;
       if(next.x < prev.x) left ++;
       prev = next;
     }
     if(right > left) direction = 0;
     else direction = 1;  
     println("Direction = " + direction); 
   }
 }
 
 // adds point to object trajectory
 private boolean addPoint(Integer time, Point b){
   direction();
   if(adjusted(b)){
     trajectory.put(time, b);
     T = time;
     last = b;
     return true;
   } else{
     println("Point not same direction");
     return false;
   }  
 }
 
 public boolean equals(Tracked tr){
   if(tr == null) return false;
   return (id.equals(tr.id)); 
 }
 
 public boolean equals(Object tr0){
   if(tr0 == null) return false;
   if (!(tr0 instanceof Tracked)) return false;
   Tracked tr = (Tracked) tr0;
   return (id.equals(tr.id)); 
 }
  
 public int hashCode(){
   return id.hashCode(); 
 }
 
 public String toString(){
   return "(" + T + ", " + last + "); direction = " + (direction == 0 ? "right" : "left") + "\n";
 }
  
}
