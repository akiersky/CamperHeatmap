import controlP5.*;
ControlP5 controlP5;

// column numbers in data
static final int CODE = 0;
static final int X = 1;
static final int Y = 2;
static final int NAME = 3;

Boolean pressed= false;
float mX, mY;

int totalCount;
ZipLoc[] places;
Camper[] campers;
HashMap placesHash = new HashMap();
int placeCount = 0;

float minX, maxX, mapX1, mapX2;
float minY, maxY, mapY1, mapY2;
float mapScale, xOff, yOff;

int mostCampers;

void setup() {
  size(1200, 800, P2D);
  ellipseMode(CENTER);
  smooth();

  mapX1 = 0;
  mapX2 = width - mapX1;
  mapY1 = 0;
  mapY2 = height - mapY1;
  mapScale = 1;
  xOff = yOff = 0;

  controlP5 = new ControlP5(this);
  controlP5.addSlider("mapScale", 0, 10, mapScale, 10, 10, 10, 100);

  findZips();
  mapCampers();
  refineData();
}
void draw () {
  background(255);
  pushMatrix();
  //translate((width/2)-xOff, (height/2)-yOff);//scale from center (needs work) maybe should go int scale function
  scale(mapScale);
  translate(xOff , yOff);
  //translate(-(width/2)-xOff, -(height/2)-yOff);
  for (int i = 0; i< totalCount; i++) {
    places[i].draw();
  }
  popMatrix();
  
  if (pressed) {
    println(mX +" " +mY);
    xOff = mouseX -mX;
    yOff = mouseY -mY;
  }
}

PVector globalToLocal() {
  float gX = mouseX/mapScale-xOff;
  float gY = mouseY/mapScale-yOff;
  
  return new PVector(gX, gY);
}

//helper functions
float TX(float x) {
  return map(x, minX, maxX, mapX1, mapX2);
}
float TY(float y) {
  return map(y, minY, maxY, mapY2, mapY1);
}

//interactinon
void mousePressed() {
  //if (mouseX > 50) {
    setMouse();
    pressed = true;
  //}
  println(globalToLocal());
}
void mouseReleased() {
  pressed = false;
}
void setMouse () {
  mX = mouseX - xOff;
  mY = mouseY - yOff;
}
void mapScale (float value) {
  println(value);
  mapScale = value;
  xOff = mapScale/2*xOff;
  yOff = mapScale/2*yOff;
}
void showInfo(String info) {
  PVector m = globalToLocal();
  fill(#ffffff);
  rect(m.x, m.y-20, 250, 20);
  fill(#000000);
  text(info, m.x+3, m.y-3);
}

//setup and parsing
void mapCampers() {
  String[] campData = loadStrings("campersMin.csv");

  campers = new Camper[campData.length];
  for (int i = 0; i < campData.length; i++) {
    campers[i] = parseCamper(campData[i]);
  }
}
Camper parseCamper(String _line) {
  String campInfo[] = split(_line, ",");

  int campYear = int(campInfo[0]);
  String name = campInfo[1];
  String gender = campInfo[3];
  int age = int(campInfo[6]);
  String campName = campInfo[8];
  int yearsAtCamp = int(campInfo[10]);

  int zip;
  String t = campInfo[4];
  String tmpZ[] = split(t, '"');
  if (tmpZ.length > 2 ) {
    zip = int(tmpZ[1]);
  }
  else {
    zip = 0;
  }
  Camper c = new Camper(campYear, name, gender, age, zip, campName, yearsAtCamp);

  ZipLoc z = (ZipLoc) placesHash.get(zip);
  if (z != null) { 
    z.addCamper(c);
  }
  return c;
}
void findZips() {
  String[] lines = loadStrings("zips.tsv");
  parseInfo(lines[0]);

  places = new ZipLoc[totalCount];
  for (int i = 1; i < lines.length; i++) {
    places[i-1] = parsePlace(lines[i], i-1);
  }
}
void parseInfo(String _line) {
  String infoString = _line.substring(2);
  String[] infoPieces = split(infoString, ",");
  totalCount = int(infoPieces[0]);
  minX = float(infoPieces[1]);
  maxX = float(infoPieces[2]);
  minY = float(infoPieces[3]);
  maxY = float(infoPieces[4]);
}
ZipLoc parsePlace(String _line, int _i) {
  String pieces[] = split(_line, TAB);

  int zip = int(pieces[CODE]);
  float x = float(pieces[X]);
  float y = float(pieces[Y]);
  String name = pieces[NAME];

  ZipLoc z =  new ZipLoc(zip, name, x, y);

  placesHash.put(zip, z);

  return z;
}
void refineData() {
  mostCampers = 0;
  for (int j = 0; j < places.length; j++) {
    if (places[j].campers.size() > mostCampers) {
      mostCampers = places[j].campers.size();
    }
  }
  for (int i = 0; i < places.length; i++) {
    places[i].mapSizes(mostCampers);
  }
  //println("most campers : " + mostCampers);
}
