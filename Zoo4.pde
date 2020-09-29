
PImage img[] = new PImage[9];

int accumulatedTime=0;
int deltaTime=0;
int prevMilli=0;
int initialCD = 3000;
int countdown1 = initialCD;
int interval=60000 / 120;
float volume = 1;
int i=0;
int j=0;
int k=6;

int phase = 2;
int phaseCount = -1;

float x1,x2,y1,y2=0;


color[] bColors=new color[9];

boolean lock = false;

float angularV = 0.0006;
float prevRad = 0;

void setup(){
  size(1280, 720);
  frameRate(60);
  background(255);
  
  img[0] = loadImage("bear.png");  // Load the image into the program
  img[1] = loadImage("cat.png");  // Load the image into the program
  img[2] = loadImage("cow.png");  // Load the image into the program
  img[3] = loadImage("dog.png");  // Load the image into the program
  img[4] = loadImage("monkey.png");  // Load the image into the program
  img[5] = loadImage("mouse.png");  // Load the image into the program
  img[6] = loadImage("panda.png");  // Load the image into the program
  img[7] = loadImage("pig.png");  // Load the image into the program
  img[8] = loadImage("rabbit.png");  // Load the image into the program
  
  bColors[0] = color(117,72,9);
  bColors[1] = color(255,211,56);
  bColors[2] = color(255,201,201);
  bColors[3] = color(255,231,196);
  bColors[4] = color(193,133,36);
  bColors[5] = color(124,120, 114);
  bColors[6] = color(255,255,255);
  bColors[7] = color(255,145,145);
  bColors[8] = color(168,168,168);
  
  delay(13000);

}

void draw() {
  if (prevMilli == 0){
    prevMilli = millis()-16;
  }
  deltaTime = millis() - prevMilli;
  accumulatedTime += deltaTime;
  //print(accumulatedTime + "\n");
  prevMilli = millis();
  
  if (i!=8){
    if (accumulatedTime >= interval){
      accumulatedTime -= interval;
      i = i+1;
      volume = 1;
    }else{
      println(deltaTime);
      volume *= 0.8;
    }
    defaultFlash(i);
  }else if (i==8 && countdown1 > 0){
    defaultFlash(k);
    countdown1 -= deltaTime;
    if (accumulatedTime >= interval){
      accumulatedTime -= interval;
      volume = 3 - countdown1/0.5/initialCD;
    }else{
      println(deltaTime);
      volume *= 0.8;
    }
    if (countdown1<0){
      background(0);
    }
  }else{
    if (accumulatedTime >= interval){
      accumulatedTime -= interval;
      j = (j+1)%9;
      volume = 1;
      phaseCount += 1;
      if (phase == 2 && phaseCount == 4){
        background(0);
        phase = 3;
        phaseCount =0;
      }
      if (phase == 3 && phaseCount == 12){
        phase = 4;
      }
    }else{
      println(deltaTime);
      volume *= 0.8;
    }
    
    if (phase == 2){
      stroke(lerpColor(color(0), bColors[j], volume * 0.2 + 0.8));
      fill(lerpColor(color(0), bColors[j], volume * 0.2 + 0.8));
      x1=(phaseCount)%2 * 0.5 * width;
      y1=(phaseCount)/2 * 0.5 * height;
      x2=((phaseCount)%2*0.5 + 0.5 ) * width;
      y2=((phaseCount)/2*0.5 + 0.5 ) * height;
      rect(x1,y1,x2,y2);
      flash((x1+x2)/2,(y1+y2)/2,0.5);
    }else if (phase == 3){
      stroke(lerpColor(color(0), bColors[j], volume * 0.2 + 0.8));
      fill(lerpColor(color(0), bColors[j], volume * 0.2 + 0.8));
      x1=(phaseCount)%4 / 4.0 * width;
      y1=(phaseCount)/4 / 3.0 * height;
      x2=((phaseCount)%4 /4.0 + 0.25 ) * width;
      y2=((phaseCount)/4 / 3.0 + 1.0/3.0 ) * height;
      rect(x1,y1,x2-x1,y2-y1);
      flash((x1+x2)/2,(y1+y2)/2,0.25);
    }else if (phase == 4){
      for (int pC = 0; pC < 12; pC++){
        k = (j+pC)%9;
        stroke(lerpColor(color(0), bColors[k], volume * 0.2 + 0.8));
        fill(lerpColor(color(0), bColors[k], volume * 0.2 + 0.8));
        x1=(pC)%4 / 4.0 * width;
        y1=(pC)/4 / 3.0 * height;
        x2=((pC)%4 /4.0 + 0.25 ) * width;
        y2=((pC)/4 / 3.0 + 1.0/3.0 ) * height;
        rect(x1,y1,x2-x1,y2-y1);
        flash((x1+x2)/2,(y1+y2)/2,0.25,k);
      }
    }
      
  }
}

private void flash(float centerX, float centerY, float ratio){
  float imgRatio = 0.8*ratio+volume*0.2;
  float[] pos = getCenter(img[j], centerX, centerY, imgRatio);
  image(img[j], pos[0], pos[1], img[j].width * imgRatio, img[j].height * imgRatio);
}

private void flash(float centerX, float centerY, float ratio, int index){
  float imgRatio = 0.8*ratio+volume*0.2;
  float[] pos = getCenter(img[index], centerX, centerY, imgRatio);
  image(img[index], pos[0], pos[1], img[index].width * imgRatio, img[index].height * imgRatio);
}

private void defaultFlash(int index){
  background(lerpColor(color(0), bColors[i], volume / 2 + 0.5));
  
  int r = 100 + int(volume * 30);
  int centerX=width/2;
  int centerY=height/2;
  float rad = 0;

  float imgRatio = 0.8+volume*0.2;
  float[] pos = getCenter(img[index], centerX, centerY, imgRatio);
  image(img[index], pos[0], pos[1], img[index].width * imgRatio, img[index].height * imgRatio);
  
}

float getAngle(float dTime, float volume){
  prevRad += angularV * (dTime / 100.0) * (1+volume);
  if (prevRad >= TWO_PI){
    prevRad -= TWO_PI;
  }
  return prevRad;
}

public float[] getCenter(PImage p, float centerX, float centerY){
  return getCenter(p, centerX, centerY, 1.0f);
}
public float[] getCenter(PImage p, float centerX, float centerY, float ratio){
  float x = centerX - p.width/2 * ratio;
  float y = centerY - p.height/2 * ratio;
  return new float[]{x,y};
}
