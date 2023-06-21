void setup() {
size(800, 800);
background(255);
fill(0);
textSize(30);
}
float A = radians(-90);//angle
void draw(){
background(255);
stroke(0);
PVector middle = new PVector(width/2,height/2);
PVector Light = new PVector(mouseX,mouseY);
PVector DirLight = PVector.sub(Light,middle);
PVector normalDir = new PVector(DirLight.x*cos(A)-DirLight.y*sin(A),DirLight.x*sin(A)+DirLight.y*cos(A));
strokeWeight(5);
point(mouseX,mouseY);
line(middle.x,middle.y,Light.x,Light.y);
stroke(255,0,0);
line(middle.x,middle.y, middle.x+normalDir.x,middle.x+normalDir.y);
}
