float edgeLength = 50;
PVector trans;
PVector[] corners;
PVector Light;


void setup() {
size(800, 800);
background(255);
trans = new PVector(width/2,height/2);
corners = CornerVertex(trans, edgeLength);
// 코너를 출력해봅니다.
fill(0);
textSize(30);
for (int i = 0; i < corners.length; i++) {
text("Corner " + i + ": " + corners[i].x + ", " + corners[i].y,30,30*i+30);
}
}
// 코너를 계산하는 메서드입니다.
// 매개변수로 받은 vertex를 기준으로 edgeLength만큼 떨어진 위치에 있는 4개의 코너를 계산하여 PVector 배열로 반환합니다.



PVector[] CornerVertex(PVector vertex, float edgeLength) {
PVector corner1 = new PVector(vertex.x - edgeLength, vertex.y - edgeLength);
PVector corner2 = new PVector(vertex.x + edgeLength, vertex.y - edgeLength);
PVector corner3 = new PVector(vertex.x + edgeLength, vertex.y + edgeLength);
PVector corner4 = new PVector(vertex.x - edgeLength, vertex.y + edgeLength);
// 4개의 코너를 PVector 배열로 반환합니다.
return new PVector[] {corner1, corner2, corner3, corner4};
}
// 벡터를 생성하고 해당 벡터에 대한 배열을 만드는 메서드입니다.
// 매개변수로 받은 vec을 중심으로 x와 y에 대한 두 개의 벡터를 만듭니다.


public PVector XYMvec(int corindex,String select) { //select=> X or Y or M
PVector corner = corners[corindex];
PVector vectors = null;
PVector[][] info= {
    {corners[1],corners[3]}, //corner1 x y
    {corners[0],corners[2]}, //corner2 x y
    {corners[3],corners[1]}, //corner3 x y
    {corners[2],corners[0]}
    }; //corner4 x y
if(select=="X"){
    vectors = PVector.sub(corner,info[corindex][0]);
}
else if(select=="Y"){
    vectors= PVector.sub(corner,info[corindex][1]);
}
else if(select=="M"){
    vectors = PVector.sub(Light,corner);
}
else{
    print("XYMvec's select don't exist");
}
/*
// x축에 대한 벡터를 생성합니다.
vectors[0] = new PVector(1, 0);
// y축에 대한 벡터를 생성합니다.
vectors[1] = new PVector(0, 1);
*/

// Light에 대한 벡터를 생성합니다.
//vectors[2] = PVector.sub(Light,corner);
//단위벡터화
vectors.normalize();
return vectors;
}


public PVector shadow_casting(int a, String select){
   PVector vec1 = corners[a]; //코너 값
   PVector vec3 = PVector.sub(Light,corners[a]); //코너-빛
   PVector vec2 = PVector.mult(vec3, -1).normalize(); //코너-빛 단위벡터
   PVector vec4 = PVector.add(vec1, vec2); //코너에서 나오는 코너-빛 단위벡터
   float x = vec3.x;
   float y = vec3.y;
   if(select == "X"){
    while (vec4.x >= 0 && vec4.x <= width){
    vec2.mult(1.01);
    vec4 = PVector.add(vec1, vec2);
    x = vec4.x;
    y = vec4.y;
    }
   }else if(select == "Y"){
    while (vec4.y >= 0 && vec4.y <= height){
    vec2.mult(1.01);
    vec4 = PVector.add(vec1, vec2);
    x = vec4.x;
    y = vec4.y;
    }
   }else{
   print("error");
   }
  line(vec1.x,vec1.y,vec1.x+vec2.x,vec1.y+vec2.y);
  return vec4;
}

void hexagon(int a){
    if(XYMvec(a,"X").dot(XYMvec(a,"M")) >= 0){
      vertex(corners[a].x,corners[a].y);
  } else{
      vertex(shadow_casting(a,"X").x,shadow_casting(a,"X").y);
  }
    if(XYMvec(a,"Y").dot(XYMvec(a,"M")) >= 0){
      vertex(corners[a].x,corners[a].y);
  } else{
      vertex(shadow_casting(a,"Y").x,shadow_casting(a,"Y").y);
  }

}

void draw(){
background(255);
stroke(0);
Light = new PVector(mouseX,mouseY);
strokeWeight(5);
point(Light.x,Light.y);
point(trans.x, trans.y);
strokeWeight(1);
line(corners[0].x, corners[0].y, corners[1].x, corners[1].y);
line(corners[1].x, corners[1].y, corners[2].x, corners[2].y);
line(corners[2].x, corners[2].y, corners[3].x, corners[3].y);
line(corners[3].x, corners[3].y, corners[0].x, corners[0].y);
/*for (int i = 0; i < corners.length; i++) {
  line(corners[i].x, corners[i].y, corners[(i + 1) % corners.length].x, corners[(i + 1) % corners.length].y);
}
*/
textSize(10);
strokeWeight(0);
fill(0);
beginShape();
hexagon(0);
hexagon(1);
hexagon(2);
hexagon(3);
endShape();
}
