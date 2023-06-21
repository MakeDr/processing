PImage img;
float xoff = 0.0;
float increment = 0.01;
float yoff = 200.0;
int score = 0; //점수
int r = 255; //Red
int g = 0; //Green
int R = 100; //Blue
int sec = 10; //남은 시간(초)

void setup() {
  size(640, 360);
  background(0);
  noStroke();
  img = loadImage("haha.png"); //이미지 불러오기
  imageMode(CENTER);
  textAlign(CENTER);
}

void draw() {
  // Create an alpha blended background
  if(sec>=0){ //카운트 다운
    if(frameCount%60==0){
      sec--;
    }
  fill(0, 15);
  rect(0,0,width,height);
 
  //float n = random(0,width);  // Try this line instead of noise
 
  // Get a noise value based on xoff and scale it according to the window's width
  float w = noise(xoff)*width; //이미지 위치
  float h = noise(yoff)*height; //이미지 위치
 
  // With each cycle, increment xoff
  xoff += increment;
  yoff += increment;
  // Draw the ellipse at the value produced by perlin noise
  fill(255,50);
  textSize(200);
  text(str(sec),width/2,height/2+80); //남은 시간UI
  fill(r,g,0,100);
  //ellipse(w,h, R, R);
  image(img,w,h,R,R);
  rect(w-R/2-1,h-R/2-1,R+1,R+1);
  fill(255);
  textSize(50);
  text("score:"+str(score),width/2,50); //스코어 UI
  if((w-R/2 < mouseX &&  mouseX < w+R/2) && (h-R/2 < mouseY &&  mouseY < h+R/2)){
    //이미지 위에 마우스 접촉시 점수증가 및 색 바꿈
    r=0;
    g=255;
    score++;
  }else{
    r=255;
    g=0;
  }
  }else{ //시간 오버후 최종 스코어 띄우기
    background(0);
    textSize(100);
    text("score:"+str(score),width/2,height/2+20);
  }
 
}
