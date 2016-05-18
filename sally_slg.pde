import beads.*;
import org.jaudiolibs.beads.AudioServerIO;

// ratio 600/800 = 0.75
int projectorWidth = 800;
int projectorHeight = 600;
boolean fullScreen = true;
float scaler = 1; // needs to be set to 1 when using 800x600 projectors! Maybe, 1.5 or 2 when testing without external projectors
int screenWidth = (int)(projectorWidth/scaler) * 3;
int screenHeight = (int)(projectorHeight/scaler);
int targetDisplay = 1; // triplehead is the only screen

int keepImageForFramesCounter = 0;
int blurCounter = 0;

ArrayList<PImage> images1 = new ArrayList<PImage>();
ArrayList<PImage> images2 = new ArrayList<PImage>();
ArrayList<PImage> images3 = new ArrayList<PImage>();

PImage p1Image;
PImage p2Image;
PImage p3Image;

SamplePlayer p1Player;
SamplePlayer p2Player;
SamplePlayer p3Player;

Timeline projector1;
Timeline projector2;
Timeline projector3;

AudioContext audioContext;
IOAudioFormat audioFormat;
float sampleRate = 44100;
int buffer = 512;
int bitDepth = 16;
int inputs = 2;
int outputs = 4;

boolean debugTimeline = true;

// PROCESSING
void settings() {
  if (fullScreen) {
    fullScreen(targetDisplay);
  } else {
    size(screenWidth, screenHeight);
  }
}

void setup() {
  background(0);

  audioFormat = new IOAudioFormat(sampleRate, bitDepth, inputs, outputs);
  audioContext = new AudioContext(new AudioServerIO.Jack(), buffer, audioFormat);

  FileUtils.loadImagesInto(images1, sketchPath()+"/data/projector-1/images", this, screenWidth/3, screenHeight);
  FileUtils.loadImagesInto(images2, sketchPath()+"/data/projector-2/images", this, screenWidth/3, screenHeight);
  FileUtils.loadImagesInto(images3, sketchPath()+"/data/projector-3/images", this, screenWidth/3, screenHeight);
  SampleManager.group("projector-1", FileUtils.loadSounds(sketchPath()+"/data/projector-1/sounds"));
  SampleManager.group("projector-2", FileUtils.loadSounds(sketchPath()+"/data/projector-2/sounds"));
  SampleManager.group("projector-3", FileUtils.loadSounds(sketchPath()+"/data/projector-3/sounds"));
  
  projector1 = new Timeline(Config.timeline1, new TimelineRenderer() {
    public void action() {
        int chance = getChance();
        int xpos = 0;
        int ypos = 0;

        if (chance > (100 - Config.likelihood)) {
          if (debugTimeline) println("!!!! Projector 1 fire");
          p1Image = images1.get((int)random(images1.size()));
          p1Player = new SamplePlayer(audioContext, SampleManager.randomFromGroup("projector-1"));

          // tint(random(255), random(255), random(255), random(255));
          image(p1Image,xpos,ypos);

          Gain g = new Gain(audioContext, 2, 0.2);
          g.addInput(p1Player);
          audioContext.out.addInput(0, g, 0); // OUT 1
          audioContext.start();
        }
      }
  });

  projector2 = new Timeline(Config.timeline2, new TimelineRenderer() {
    public void action() {
        int chance = getChance();
        int xpos = 0;
        int ypos = 0;

        if (chance > (100 - Config.likelihood)) {
          if (debugTimeline) println("!!!! Projector 2 fire");
          xpos = screenWidth/3;
          p2Image = images2.get((int)random(images2.size()));
          p2Player = new SamplePlayer(audioContext, SampleManager.randomFromGroup("projector-2"));

          image(p2Image,xpos,ypos);

          Gain g = new Gain(audioContext, 2, 0.2);
          g.addInput(p2Player);
          audioContext.out.addInput(1, g, 0); // OUT 2
          audioContext.start();
        }
      }
  });

  projector3 = new Timeline(Config.timeline3, new TimelineRenderer() {
    public void action() {
        int chance = getChance();
        int xpos = 0;
        int ypos = 0;

        if (chance > (100 - Config.likelihood)) {
          if (debugTimeline) println("!!!! Projector 3 fire");
          xpos = (screenWidth/3) * 2;

          p3Image = images3.get((int)random(images3.size()));
          p3Player = new SamplePlayer(audioContext, SampleManager.randomFromGroup("projector-3"));

          image(p3Image,xpos,ypos);

          Gain g = new Gain(audioContext, 2, 0.2);
          g.addInput(p3Player);
          audioContext.out.addInput(2, g, 0); // OUT 3
          audioContext.start();
        }
      }
  });
}

void draw() {
  if (debugTimeline) {
    print((int)frameRate+"\t"); print(projector1); print(projector2); print(projector3);
    print("\t\t"+blurCounter+"\t >"+Config.blurFromFrame+"<"+Config.blurUntilFrame);
    println("");
  }

  projector1.draw();
  projector2.draw();
  projector3.draw();

  checkWhetherToHideImages();
  checkWhetherToBlurImages();
}

// UTILS
int getChance() {
  int chance = 100;

  if (Config.enableProbability) {
    chance = (int) random(1, 100);
  }
  return chance;
}

void checkWhetherToHideImages() {
  if (!projector1.eventFired() &&
      !projector2.eventFired() &&
      !projector3.eventFired()) {
   if (keepImageForFramesCounter < Config.keepImageForFrames) {
     // keep visible
   } else {
     keepImageForFramesCounter = 0;
     background(0);
   }
  }

  keepImageForFramesCounter++;
}

void checkWhetherToBlurImages() {
    if (blurCounter >= Config.blurUntilFrame) {
    blurCounter = 0;
  } else if (blurCounter >= Config.blurFromFrame) {
    if (debugTimeline) println("############### BLURING! ");
    filter(BLUR, 2);
    blurCounter++;
  } else {
    blurCounter++;
  }
}

// INTERACTIONS
void mousePressed() {
}