float angle = 95.04;
float size = 100;
float centerX, centerY;
float i = 0;
float angleA = 0;
void setup() {
  size(1500, 300);
  centerX = width / 2;
  centerY = height / 2;
  rectMode(CENTER);
}


void draw() {
  background(255);
  fill(0);
  strokeWeight(2);
  
  pushMatrix();
  translate(0, centerY+size/2);
  stroke(0); // 그래프 색상 설정
  fill(50,155,0); // 그래프 내부를 채움
  for (int P = 0; P < width; P += 157) {
    beginShape(); // 그래프 시작
    angleA = PI/4;
    for (int x = P; x < width; x++) {
      float y = map(sin(angleA), 1, -1, 0, 160*size/100); // sin 값을 그래프의 y좌표 값으로 변환
      vertex(x, y); // 그래프의 꼭짓점 추가
      angleA += 0.01; // 각도 증가
      if (angleA>3*PI/4) {
        break;
      }
    }
    vertex(width, height);
    vertex(0, height);
    endShape(); // 그래프 끝
  }
  popMatrix();
  
  stroke(0);
  strokeWeight(2);
  float x = mouseX;  //네모 X좌표
  float y = centerY; //네모 Y좌표
  float d = dist(centerX, centerY, x, y);
  stroke(255,0,0);
  line(0, height/2, width, height/2); //가로선 UI
  stroke(0);
  angle += (x - pmouseX) * 0.01;
  
  pushMatrix();  //네모 그리기
  translate(mouseX, centerY);
  rotate(angle);
  fill(#ffda00, 200);
  rect(0, 0, size, size);
  popMatrix();
    
  stroke(0);
  strokeWeight(8);
  point(x, y);
  textSize(20);
  text(mouseX, 10, 30);
}
