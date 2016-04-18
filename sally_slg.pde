import processing.sound.*;

// timeline
int[] timeline = { 1, 100, 200, 300 };
int event = 0;

// dimensions
int screenWidth = 640;
int screenHeight = 480;

// misc
int localFrameRate = 1;
int keepImageForFrames = 60;
int keepImageForFramesCounter = 0;
int total_images = 6;
PImage[] images = new PImage[total_images];
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
  //frameRate(30);
    
  for (int i = 0; i < images.length; i ++) {
    images[i] = loadImage( i +".jpg");
    images[i].resize(screenWidth, screenHeight);
  }
  
  background(0);
   
  triOsc = new TriOsc(this);
  env  = new Env(this); 
}

void draw() {
  println(localFrameRate+ " : "+event);
  
  if (localFrameRate == timeline[event]) {
    println(localFrameRate+": fire frame");
    
    triOsc.freq(random(300,500));
    triOsc.play();
    env.play(triOsc, attackTime, sustainTime, sustainLevel, releaseTime);
        
    r=int(random(total_images));
    image(images[r],0,0);
    
    if (event < timeline.length - 1) {
      event++;
    } else {
      localFrameRate = 0;
      event = 0;      
    }    
  } else {
    if (keepImageForFramesCounter < keepImageForFrames) {
      //background(0);
    } else {
      keepImageForFramesCounter = 0;
      background(0);
    }
  }
  
  keepImageForFramesCounter++;
  localFrameRate++;
}

void mousePressed() {       
}