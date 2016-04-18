import processing.sound.*;

// timeline(s)
// make sure this one has the highest maximum frame value!
int[] timeline1 = { 1, 200, 400, 600, 680, 760 }; 
int event1 = 0;

int[] timeline2 = {    100, 300, 500 };
int event2 = 0;

int[] timeline3 = {    275, 375, 575 };
int event3 = 0;

// dimensions
int screenWidth = 900;
int screenHeight = 300;

// misc
int localFrameRate1 = 1;
int localFrameRate2 = 1;
int localFrameRate3 = 1;
int keepImageForFrames = 60;
int keepImageForFramesCounter = 0;
int total_projectors = 3;
int total_images = 6;
PImage[] images1 = new PImage[total_images];
PImage[] images2 = new PImage[total_images];
PImage[] images3 = new PImage[total_images];
PImage img = new PImage();
int r;

// audio
TriOsc triOsc;
Env env;
float attackTime = 0.001;
float sustainTime = 0.004;
float sustainLevel = 0.3;
float releaseTime = 0.1;

SoundFile file1;
SoundFile file2;
SoundFile file3;
 
 
void settings() {
  size(screenWidth, screenHeight);
}

void setup() {
  //frameRate(30);
     
  for (int j = 0; j < total_images; j++) {
    images1[j] = loadImage( "1-"+j+".jpg");
    images1[j].resize(screenHeight, screenHeight);

    images2[j] = loadImage( "2-"+j+".jpg");
    images2[j].resize(screenHeight, screenHeight);
    
    images3[j] = loadImage( "3-"+j+".jpg");
    images3[j].resize(screenHeight, screenHeight);   
  }
  
  file1 = new SoundFile(this, "1.wav");
  file2 = new SoundFile(this, "2.wav");
  file3 = new SoundFile(this, "3.wav");

  background(0);
   
  triOsc = new TriOsc(this);
  env  = new Env(this); 
}

void draw() {
  print(localFrameRate1+ " : "+event1+ " ");
  print(localFrameRate2+ " : "+event2+ " ");
  print(localFrameRate3+ " : "+event3+ " ");
  
  if (localFrameRate1 == timeline1[event1]) {        
    displayImage(1);
    if (event1 < timeline1.length - 1) {
      event1++;
    } else {
      localFrameRate1 = 1;
      event1 = 0;
    }        
  }

  if (localFrameRate2 == timeline2[event2]) {        
    displayImage(2);
    if (event2 < timeline2.length - 1) {
      event2++;
    } else {
      localFrameRate2 = 1;
      event2 = 0;
    }     
  } 

  if (localFrameRate3 == timeline3[event3]) {        
    displayImage(3);
    if (event3 < timeline3.length - 1) {
      event3++;
    } else {
      localFrameRate3 = 1;
      event3 = 0;
    }    
  } 

  if (localFrameRate1 != timeline1[event1] && 
      localFrameRate2 != timeline2[event2] &&
      localFrameRate3 != timeline3[event3]) {
   if (keepImageForFramesCounter < keepImageForFrames) {
     //background(0);
   } else {
     keepImageForFramesCounter = 0;
     background(0);
   }
  }

  keepImageForFramesCounter++;
  localFrameRate1++;
  localFrameRate2++;
  localFrameRate3++;
}

void mousePressed() {       
}

void displayImage(int timeline) {
  //println("["+timeline+"]"+localFrameRate+": fire frame");
  //triOsc.freq(random(300,500));
  //triOsc.play();
  //env.play(triOsc, attackTime, sustainTime, sustainLevel, releaseTime);
      
  r=int(random(total_images));
  
  
  int xpos = 0;
  int ypos = 0;
  
  if (timeline == 1) {
    xpos = 0;
    println("displaying random image1: "+r);
    image(images1[r],xpos,ypos);
    file1.play();
  } else if (timeline == 2) {
    xpos = 300;
    println("displaying random image2: "+r);
    image(images2[r],xpos,ypos);
    file2.play();
  } else if (timeline == 3) {
    xpos = 600;
    println("displaying random image3: "+r);
    image(images3[r],xpos,ypos);
    file3.play();
  }  
}