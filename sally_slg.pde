import processing.sound.*;
import java.util.Date;

//// SALLY CAN EDIT ///////////////////////////

// timeline(s)
int[] timeline1 = { 1, 200, 400, 600, 680, 860, 900, 910, 920, 925, 1000, 1100, 1200 };
int event1 = 0;

int[] timeline2 = { 1, 100, 300, 500, 510, 520, 530, 540, 600 };
int event2 = 0;

int[] timeline3 = { 1, 275, 375, 575, 700, 800, 810, 850, 880, 881, 882, 883, 887, 888 };
int event3 = 0;

// probability
boolean enableProbability = true;
int chance = 100;
int threshold = 25; // bigger number means a/v is LESS likely to trigger

// Image visible for
int keepImageForFrames = 200;

//// END OF SALLY CAN EDIT ///////////////////

// dimensions 768/1024 = 0.75
int screenWidth = 450 * 3;
int screenHeight = 338;

// misc
int localFrameRate1 = 1;
int localFrameRate2 = 1;
int localFrameRate3 = 1;
int keepImageForFramesCounter = 0;
int total_projectors = 3;

ArrayList<PImage> images1 = new ArrayList<PImage>();
ArrayList<PImage> images2 = new ArrayList<PImage>();
ArrayList<PImage> images3 = new ArrayList<PImage>();

ArrayList<SoundFile> sounds1 = new ArrayList<SoundFile>();
ArrayList<SoundFile> sounds2 = new ArrayList<SoundFile>();
ArrayList<SoundFile> sounds3 = new ArrayList<SoundFile>();

PImage p1Image;
PImage p2Image;
PImage p3Image;

SoundFile p1Sound;
SoundFile p2Sound;
SoundFile p3Sound;

PImage img = new PImage();
int r;

// audio
TriOsc triOsc;
Env env;
float attackTime = 0.001;
float sustainTime = 0.004;
float sustainLevel = 0.3;
float releaseTime = 0.1;
 
void settings() {
  size(screenWidth, screenHeight);
}

void setup() {
  //frameRate(60);
        
  FileUtils.loadImagesInto(images1, sketchPath()+"/data/projector-1/images", this, screenWidth/3, screenHeight);
  FileUtils.loadImagesInto(images2, sketchPath()+"/data/projector-2/images", this, screenWidth/3, screenHeight);
  FileUtils.loadImagesInto(images3, sketchPath()+"/data/projector-3/images", this, screenWidth/3, screenHeight);
  
  FileUtils.loadSoundsInto(sounds1, sketchPath()+"/data/projector-1/sounds", this);
  FileUtils.loadSoundsInto(sounds2, sketchPath()+"/data/projector-2/sounds", this);
  FileUtils.loadSoundsInto(sounds3, sketchPath()+"/data/projector-3/sounds", this);
  
  background(0);
   
  triOsc = new TriOsc(this);
  env  = new Env(this); 
}

void draw() {
  print(localFrameRate1+ " : "+event1+ " | ");
  print(localFrameRate2+ " : "+event2+ " | ");
  print(localFrameRate3+ " : "+event3+ " | ");
  println("");
  
  if (localFrameRate1 == timeline1[event1]) {        
    displayImage(1);
    if (event1 < timeline1.length - 1) {
      event1++;
    } else {
      localFrameRate1 = 0;
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
     // keep visible
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

void displayImage(int projector) {
  //println("["+projector+"]"+localFrameRate+": fire frame");
      
  if (enableProbability) {
    chance = (int) random(1, 100);
  } else {
    chance = 100;
  }
  
  int xpos = 0;
  int ypos = 0;
  
  if (projector == 1) {        
    if (chance > threshold) {
      xpos = 0;
      
      p1Image = images1.get((int)random(images1.size()));
      p1Sound = sounds1.get((int)random(sounds1.size()));
      
      // tint(random(255), random(255), random(255), random(255));
      image(p1Image,xpos,ypos);
            
      p1Sound.rate((int)random(0.5, 20));
      p1Sound.play();
    }
  } else if (projector == 2) {    
    if (chance > threshold) {
      xpos = screenWidth/3;

      p2Image = images2.get((int)random(images2.size()));
      
      image(p2Image,xpos,ypos);
      //file2.play();
      
      triOsc.freq(random(50,10000));
      triOsc.play();
      env.play(triOsc, attackTime, sustainTime, sustainLevel, releaseTime);
      
    }
  } else if (projector == 3) {
    if (chance > threshold) {
      xpos = (screenWidth/3) * 2;

      p3Image = images3.get((int)random(images3.size()));
      p3Sound = sounds3.get((int)random(sounds3.size()));

      image(p3Image,xpos,ypos);
      p3Sound.play();
      p3Sound.rate((int)random(0.5, 20));
    }
  }  
}

void mousePressed() {       
}