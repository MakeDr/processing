float StX,StY,EnX,EnY; //마우스를 누른 좌표(St), 마우스를 땐 좌표(En)
PVector temp; //좌표를 저장한값을 임시로 저장하는 함수
float Cor; //색깔 값
float wheel = 0; //마우스 휠값
void setup(){
  size(500,500);
  background(255);
  fill(0);
}
void draw(){
  ellipseMode(TOP);
  Cor = map(wheel,-20,20,0,255);
  fill(Cor);
  rectMode(CENTER);
  noStroke();
  rect(width/2,30,width,30); //현재 색 표시 UI
}

PVector mouse(){
  PVector mouseloc = new PVector(mouseX,mouseY);
  println(mouseloc);
  return mouseloc;
}

void mouseWheel(MouseEvent event) //휠 감지해서 색 바꿈 
{
  wheel += event.getCount();
  if(wheel<-20){
    wheel = -20;
  }
  else if(wheel>20){
    wheel = 20;
  }
}

void mousePressed(){//마우스 누른 좌표 감지
  temp = mouse();
  StX = temp.x;
  StY = temp.y;
}
void mouseReleased(){//마우스 땐 좌표 감지
  temp = mouse();
  EnX = temp.x;
  EnY = temp.y;
  ellipse(StX,StY,EnX-StX,EnY-StY);
  StX = 0;
  StY = 0;
  EnX = 0;
  EnY = 0;
}
