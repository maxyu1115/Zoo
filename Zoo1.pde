import processing.sound.*;

PImage img[] = new PImage[9];

float ratioArr[] = new float[120];

int accumulatedTime=0;
int deltaTime=0;
int prevMilli=0;
int interval=500;
int i=0;

boolean lock = false;

float angularV = 0.0006;
float prevRad = 0;

AudioIn input;
Amplitude loudness;

void setup(){
  size(1024, 720);
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
  
  for (int k=0;k<120;k++){
    ratioArr[k] = random(0.7,1.3);
  }
  
  // Create an Audio input and grab the 1st channel
  input = new AudioIn(this, 0);

  // Begin capturing the audio input
  input.start();
  
  // Create a new Amplitude analyzer
  loudness = new Amplitude(this);

  // Patch the input to the volume analyzer
  loudness.input(input);
  
}

void draw() {
  deltaTime = millis() - prevMilli;
  accumulatedTime += deltaTime;
  print(accumulatedTime + "\n");
  prevMilli = millis();
  
  if (accumulatedTime >= interval){
    accumulatedTime -= interval;
    i = (i+1)%9;
  }

  float volume = loudness.analyze();
  
  //if (accumulatedTime)
  
  /*if (volume >= 0.4 && lock == false){
    i = (i+1)%9;
    lock = true;
  }*/
  
  background(volume*150);
  
  int r = 100 + int(volume * 50);
  int centerX=width/2;
  int centerY=height/2;
  float rad = 0;
  for (int c=0;c<360;c+=3){
    stroke(255);
    strokeWeight(3);
    //rad = radians(c) + angularV * millis();
    //print(rad+"\n");
    rad = radians(c) + getAngle(deltaTime,volume);
    //print(rad+"\n");

    line(centerX + cos(rad) * r, centerY + sin(rad) * r, centerX + cos(rad) * r*2*ratioArr[c/3], centerY + sin(rad) * r * 2*ratioArr[c/3]);
  }
  float imgRatio = 0.7+volume*0.3;
  float[] pos = getCenter(img[i], centerX, centerY, imgRatio);
  image(img[i], pos[0], pos[1], img[i].width * imgRatio, img[i].height * imgRatio);
  
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
