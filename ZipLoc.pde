public class ZipLoc {
  public int zip;
  public int x, y;
  public String name;
  public PVector loc;
  public ArrayList campers;
  
  public float locSize = 1;
  public color locColor = #dddddd;
  
 public ZipLoc(int _zip, String _name, float _x, float _y) {
  this.zip = _zip;
  this.name = _name;
  this.loc = new PVector(_x, _y); //LonToX(lon);
  //this.loc.y = _y; //LatToY(lat);
  campers = new ArrayList();
 }
 
 public void draw() {
   //x = (int) TX(loc.x);
   //y = (int) TY(loc.y);
   PVector m = globalToLocal();
   if(m.x > loc.x -2 &&
      m.x < loc.x +2 &&
      m.y > loc.y -2 &&
      m.y < loc.y +2){
      fill(#ff0000);
      ellipse(m.x, m.y, 10, 10);
      showInfo(this.name+", "+this.zip + "   campers - " + this.campers.size());
   } else {
     fill(locColor);
   }
   ellipse(loc.x, loc.y, locSize, locSize);
   
   //PVector m = localToGlobal();
   //if(m.x > x-2 && m.x < x + 2 && m.y > y-2 && m.y < y+2 ){
   //}
 }
 public void addCamper(Camper c) {
   locColor = #000000;
   locSize ++;
   campers.add(c);
 }
 public void mapSizes(int largest) {
   locSize = map(locSize, 1, largest, 1, 5);
   //map locations
   loc.x = (int) TX(loc.x);
   loc.y = (int) TY(loc.y);
 }
  
}
