ArrayList<Box> boxes = new ArrayList<Box>(); //총알 객체 관리 배열 //<>//
PImage[] idleanim = new PImage[2]; //애니메이션-정지
PImage[] runanim = new PImage[11]; //애니메이션-달리기
PImage creepanim; //애니메이션-숙이기
PVector vec1, g, a;
int imgsize = 80; //이미지 사이즈
int lastTime = 0; //프레임관리(안중요)
int delta = 0; //프레임관리(안중요)
String stat = ""; //현재 상태 관리(isrunning,isidle,iscreeping)

void setup() {
  size(560, 480);
  imageMode(CENTER);
  vec1 = new PVector(width/2, height/2); //캐릭터 위치 백터(중심위치)
  for (int i = 0; i < 2; i++) {
    idleanim[i] = loadImage("konomi(" + (i+1) + ").png"); //서있는 애니메이션 파일 로드
  }
  for (int i = 0; i < 11; i++) {
    runanim[i] = loadImage("konomi(" + (i+3) + ").png"); //달리는 애니메이션 파일 로드
  }
  creepanim =  loadImage("konomi(14).png"); //기어다니는 애니메이션 파일 로드
  g = new PVector(0, 0.098*4); //중력 벡터
  a = new PVector(0, 0); //가속도 벡터
}

void draw() {
  delta = millis() - lastTime;
  background(255);
  line(0, 300, width, 300);
  noStroke();
  anim(vec1.x, vec1.y, stat); //캐릭터 이미지 그리기
  PlayerMove(vec1); //플레이어 움직임
  rigidbody(vec1); //물리엔진 
  Playerjump(vec1); //플레이어 점프 감지
  shot(vec1); //총알 쏘기 감지
  for (int i = boxes.size() - 1; i >= 0; i--) { //총알 객체 배열 관리
    Box b = boxes.get(i);
    b.display();
    b.update();
    if (b.position.x > width+b.w || b.position.x < 0-b.w || b.position.y < 0-b.h || b.position.y > height+b.h) { // 화면을 벗어난 Box 객체는 리스트에서 제거
      b.velocity.mult(-1);
      //Boxes.remove(i);
    }
  }
  lastTime = millis();
}
//물리엔진
void rigidbody(PVector loc) {
  if (loc.y < height-imgsize/2) {
    a = a.add(g);
  } else if (loc.y > height-imgsize/2) {
    a.y = 0;
    loc.y = height-imgsize/2;
  }
  loc = loc.add(a);
}

//애니메이션
//parameter
int runframeDelay = 5;
int idleframeDelay = 20;
int current_img = 0;
int frameCounter = 0;
int flip = 1;
//************
void anim(float x, float y, String ing) {
  switch(ing) {
  case "isrunning":
    pushMatrix();
    translate(x, y);
    scale(flip, 1);
    image(runanim[current_img], 0, 0, imgsize, imgsize);
    popMatrix();
    frameCounter++;
    if (frameCounter >= runframeDelay) {
      current_img++;
      if (current_img >= runanim.length) {
        current_img = 0;
      }
      frameCounter = 0;
    }
    break;
  case "iscreeping":
    pushMatrix();
    translate(x, y);
    scale(flip, 1);
    image(creepanim, 0, 0, imgsize, imgsize);
    popMatrix();
    break;
  default:
    int idleFrame = frameCount / idleframeDelay % idleanim.length;
    pushMatrix();
    translate(x, y);
    scale(flip, 1);
    image(idleanim[idleFrame], 0, 0, imgsize, imgsize);
    popMatrix();
    break;
  }
}

//플레이어 조작감지
//parameter
float movePower = 0.2;
PVector moveVelo = new PVector(0, 0);
boolean leftpress = false;
boolean rightpress = false;
float creepPower = 0.4; //깎일 movePower%
int horizontal = 0;
//*************
void PlayerMove(PVector loc) {
  if (downpress && loc.y >= height-imgsize/2) {
    if (leftpress&&rightpress) {
      stat = "iscreeping";
      flip = horizontal;
      moveVelo.x = horizontal*creepPower;
    } else if (rightpress) {
      stat = "iscreeping";
      flip = 1;
      moveVelo.x = 1*creepPower;
    } else if (leftpress) {
      stat = "iscreeping";
      flip = -1;
      moveVelo.x = -1*creepPower;
    } else {
      stat = "iscreeping";
    }
  } else if (loc.y < height-imgsize/2) {
      if (leftpress&&rightpress) {
      stat = "isrunning";
      moveVelo.x = horizontal;
    } else if (rightpress) {
      stat = "isrunning";
      moveVelo.x = 1;
    } else if (leftpress) {
      stat = "isrunning";
      moveVelo.x = -1;
    }
  } else if (leftpress&&rightpress) {
    stat = "isrunning";
    flip = horizontal;
    moveVelo.x = horizontal;
  } else if (rightpress) {
    stat = "isrunning";
    flip = 1;
    moveVelo.x = 1;
  } else if (leftpress) {
    stat = "isrunning";
    flip = -1;
    moveVelo.x = -1;
  } else {
    current_img = 0;
    stat = "idle";
  }
  loc.x += moveVelo.x * movePower * delta;
  moveVelo.x = 0;
}

//플레이어 점프 감지
//parameter
float jumpPower = 10;
boolean jumppress = false;
int defaultjump = 5;
int jumpCount = defaultjump;
boolean doublejump = false;
//*************
void Playerjump(PVector loc) {
  if (loc.y > height-imgsize/2) {
    jumpCount = defaultjump;
  } else if (loc.y == height-imgsize/2) {
    if (jumppress) {
      if (jumpCount>0) {
        a.y = -jumpPower;
        jumpCount--;
        doublejump = false;
      }
    }
  } else { //공중에 떠있을 때
    if (doublejump && 0<jumpCount && jumpCount<defaultjump && jumppress) { //점프를 또 누르면 //점프횟수가 남았을 때
      a.y = -jumpPower;
      jumpCount--;
      doublejump = false;
    }
  }
  fill(0);
  textSize(40);
  textAlign(CENTER);
  text(jumpCount, loc.x, loc.y-imgsize/2);
}

//총알쏘기 감지
//parameter
boolean isshoting = false;
float bulletspeed = 3;
long lastShootTime = 0;
int shootCooldown = 10; // 쿨타임(ms)
boolean downpress = false;
boolean uppress = false;
//*************
void shot(PVector loc) {
  if (isshoting &&  millis() - lastShootTime >= shootCooldown) {
    if (downpress && loc.y < height-imgsize/2) {
      Box b = new Box(loc.x, loc.y + imgsize/4);
      b.velocity.set(new PVector(0, bulletspeed ));
      boxes.add(b);
    } else if (downpress) {
      Box b = new Box(loc.x+ flip*20, loc.y + imgsize/3);
      b.velocity.set(new PVector(flip * bulletspeed, 0));
      boxes.add(b);
    } else if (uppress) {
      Box b = new Box(loc.x, loc.y - imgsize/4);
      b.velocity.set(new PVector(0, -bulletspeed ));
      boxes.add(b);
    } else {
      Box b = new Box(loc.x + flip*20, loc.y + imgsize/4);
      b.velocity.set(new PVector(flip * bulletspeed, 0));
      boxes.add(b);
    }
    lastShootTime = millis();
  }
}
//키감지
void keyPressed() {
  if (keyCode == LEFT) {
    leftpress = true;
    horizontal = -1;
  }
  if (keyCode == RIGHT) {
    rightpress = true;
    horizontal = 1;
  }
  if (key == 'z' || key == 'Z') {
    jumppress = true;
  }
  if (key == 'x' || key == 'X') {
    isshoting = true;
  }
  if (keyCode == UP) {
    uppress = true;
  }
  if (keyCode == DOWN) {
    downpress = true;
  }
}
void keyReleased() {
  if (keyCode == LEFT) {
    leftpress = false;
    horizontal = 0;
  }
  if (keyCode == RIGHT) {
    rightpress = false;
    horizontal = 0;
  }
  if (key == 'z' || key == 'Z') {
    jumppress = false;
    doublejump = true;
  }
  if (key == 'x' || key == 'X') {
    isshoting = false;
  }
  if (keyCode == UP) {
    uppress = false;
  }
  if (keyCode == DOWN) {
    downpress = false;
  }
}

//총알 객체
class Box {
  PVector position, velocity;
  int w = 100;
  int h = 100;
  Box(float x, float y) {
    position = new PVector(x, y);
    velocity = new PVector(0, 0);
  }

  void update() {
    position.add(velocity);
  }

  void display() {
    fill(map(position.x,0,width,0,255),map(position.y,0,height,0,255),124);
    rectMode(CENTER);
    rect(position.x, position.y, w, h);
  }
}
