/**
 * Constrain. 
 * 
 * Move the mouse across the screen to move the circle. 
 * The program constrains the circle to its box. 
 */
PVector locL = new PVector(295,258);
PVector locR = new PVector(426,258);
PVector ML = new PVector(0,0);
PVector MR = new PVector(0,0);
float easing = 0.05;
PImage img1,img2;

void setup() {
  size(500, 500);
  noStroke(); 
  ellipseMode(RADIUS);
  rectMode(CORNERS);
  img1 = loadImage("paymon1.jpeg");
  img2 = loadImage("paymon2.jpeg");
}
void draw() { 
  background(51);
  ML = new PVector(mouseX-locL.x,mouseY-locL.y);
  MR = new PVector(mouseX-locR.x,mouseY-locR.y);
  fill(#FFF6F5);
  if(frameCount%16<8){
  image(img1,0,0,width,height);
}else{
  image(img2,0,0,width,height);
}
  fill(0);
  text(mouseX+","+mouseY,50,50);
  fill(255);
  text("L:"+ML.x+","+ML.y,50,30);
  text("R:"+MR.x+","+MR.y,50,50);
  ML.limit(15);
  MR.limit(15);
  fill(0);
  ellipse(locL.x+ML.x,locL.y+ML.y,40,40);
  fill(255);
  ellipse(locL.x+ML.x-10,locL.y+ML.y-20,10,10);
  fill(0);
  ellipse(locR.x+MR.x,locR.y+MR.y,40,40);
  fill(255);
  ellipse(locR.x+MR.x-10,locR.y+MR.y-20,10,10);
}  
