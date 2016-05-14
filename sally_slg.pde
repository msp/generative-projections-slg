import processing.sound.*;
import java.util.Date;

// ratio 768/1024 = 0.75
float scaler = 2; // needs to be set to 1 when using 1025x768 projectors! Maybe, 1.5 or 2 when testing without external projectors
int screenWidth = (int)(1024/scaler) * 3;
int screenHeight = (int)(768/scaler);
int targetDisplay = 2; // it's likely that 1 is your main screen and 2 will be the triplehead

int keepImageForFramesCounter = 0;

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

Timeline projector1;
Timeline projector2;
Timeline projector3;

// PROCESSING
void settings() {
  //size(screenWidth, screenHeight);
  fullScreen(targetDisplay); // needs to be set to the correct display!
}

void setup() {
  //frameRate(60);
  background(0);

  FileUtils.loadImagesInto(images1, sketchPath()+"/data/projector-1/images", this, screenWidth/3, screenHeight);
  FileUtils.loadImagesInto(images2, sketchPath()+"/data/projector-2/images", this, screenWidth/3, screenHeight);
  FileUtils.loadImagesInto(images3, sketchPath()+"/data/projector-3/images", this, screenWidth/3, screenHeight);
  FileUtils.loadSoundsInto(sounds1, sketchPath()+"/data/projector-1/sounds", this);
  FileUtils.loadSoundsInto(sounds2, sketchPath()+"/data/projector-2/sounds", this);
  FileUtils.loadSoundsInto(sounds3, sketchPath()+"/data/projector-3/sounds", this);

  projector1 = new Timeline(Config.timeline1, new TimelineRenderer() {
    public void action() {
        int chance = getChance();
        int xpos = 0;
        int ypos = 0;

        if (chance > (100 - Config.likelihood)) {
          p1Image = images1.get((int)random(images1.size()));
          p1Sound = sounds1.get((int)random(sounds1.size()));

          // tint(random(255), random(255), random(255), random(255));
          image(p1Image,xpos,ypos);

          //p1Sound.rate((int)random(0.5, 20));
          p1Sound.play();
        }
      }
  });

  projector2 = new Timeline(Config.timeline2, new TimelineRenderer() {
    public void action() {
        int chance = getChance();
        int xpos = 0;
        int ypos = 0;

        if (chance > (100 - Config.likelihood)) {
          xpos = screenWidth/3;
          p2Image = images2.get((int)random(images2.size()));
          p2Sound = sounds2.get((int)random(sounds2.size()));

          image(p2Image,xpos,ypos);

          //p2Sound.rate((int)random(0.5, 20));
          p2Sound.play();
        }
      }
  });

  projector3 = new Timeline(Config.timeline3, new TimelineRenderer() {
    public void action() {
        int chance = getChance();
        int xpos = 0;
        int ypos = 0;

        if (chance > (100 - Config.likelihood)) {
          xpos = (screenWidth/3) * 2;

          p3Image = images3.get((int)random(images3.size()));
          p3Sound = sounds3.get((int)random(sounds3.size()));

          image(p3Image,xpos,ypos);

          //p3Sound.rate((int)random(0.5, 20));
          p3Sound.play();
        }
      }
  });
}

void draw() {
  print(projector1); print(projector2); print(projector3);
  println("");

  projector1.draw();
  projector2.draw();
  projector3.draw();

  checkWhetherToHideImages();
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

// INTERACTIONS
void mousePressed() {
}