/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/38104*@* */
/* !do not delete the line above, required for linking your tweak if you re-upload */

int guys = 10;
int circlediameter = 20;

  int NCircles = 101;
  int NPotentialCircles = 20;
  int drawnCircles = 0;
  
  float Radius = 300.0;
  float angle = 360.0/NCircles;
  int clickX;
  int clickY;

int SZ = 50;
PImage spriteSheet;
PImage sprite[];
guy g[];
circle c[];

//===============================================================================

void setup() {
  size(1200,750);
  smooth();
  imageMode(CENTER);
  fill(255,180);
  
  //load sheet
  spriteSheet = loadImage("spriteSheetTest.png");
  
  //divy up sheet into sprite frames
  sprite = new PImage[30];
  int cnt = 0;
  for (int y = 0; y < 5; y++)
    for (int x = 0; x < 6; x++)
      sprite[cnt++] = spriteSheet.get(x*SZ, y*SZ, SZ, SZ);
      
  //setup guy objects
  g = new guy[guys];
  for(int i = 0; i < guys; i++)
    g[i] = new guy();
    
  //setup circle objects
  c = new circle[NCircles + NPotentialCircles];
  for(int i = 0; i < NCircles; i++) {
    c[i] = new circle(i);
  } 
    for(int i = 0; i < NPotentialCircles; i++) {
    c[NCircles + i] = new circle(-20,-20);
  } 
  
}

//===============================================================================

void draw() {
  background(64);
  
     for(int i = 0; i < (NCircles + NPotentialCircles); i++){
      ellipse(c[i].pos.x ,c[i].pos.y,circlediameter,circlediameter);
   }
  
 for(int i = 0; i < guys; i++){   
 g[i].check();
 }
    
 
  
}

void mouseClicked(MouseEvent e){
   if(drawnCircles < NPotentialCircles){
 c[NCircles + drawnCircles].pos.x = mouseX;
 c[NCircles + drawnCircles].pos.y = mouseY;
   }
}

void mouseReleased(){
    drawnCircles++;
}  

class circle {
  PVector pos;
  //---------------------  
  circle(int N) {
   // x & y
  pos = new PVector(width/2 + cos(N*angle)*Radius, height/2 + sin(N*angle)*Radius);
  }
  
  circle(int X, int Y) {
   // x & y
  pos = new PVector(X, Y);
  }
  
}

//===============================================================================

class guy {
  PVector pos, dir;
  int heartbeat;
  float spd;
  //---------------------
  guy() {
    pos = new PVector(width/2, height/2);
    dir = new PVector(random(2), random(2));
    heartbeat = int(random(30));
    spd = random(2) + 1.0;
  }
  //---------------------
  void check() {
    
    //check other guys
    for (int i=0; i<guys; i++)
      if (g[i] != this)
        if (pos.dist(g[i].pos) < 100) {
          PVector dir2 = PVector.sub(pos, g[i].pos);
          dir2.normalize();
          dir2.mult(spd);
          dir2.div(8);
          dir.add(dir2);
        }
       
      for (int i=0; i<(NCircles + NPotentialCircles); i++)
        if (pos.dist(c[i].pos) < 51) {
          PVector dir2 = PVector.sub(pos, c[i].pos);
          dir2.normalize();
          dir2.mult(spd);
          dir2.div(8);
          dir.add(dir2);
        }
            
    //check mouse
    PVector m = new PVector(mouseX, mouseY);
    if (pos.dist(m) > 20) {
      PVector dir2 = PVector.sub(m, pos);
      dir2.normalize();
      dir2.mult(spd);
      dir2.div(20);
      dir.add(dir2);
    }
    
    //draw guy
    dir.normalize();
    dir.mult(spd);
    pos.add(dir);
    pushMatrix();
      translate(pos.x, pos.y);
      rotate(atan2(dir.y, dir.x) - HALF_PI);
      image(sprite[heartbeat++], 0, 0);
    popMatrix();
    if (heartbeat >= 30) heartbeat = 0;
  }
}
