import beads.*;
import org.jaudiolibs.beads.AudioServerIO;

// ratio 600/800 = 0.75
boolean fullScreen = true;
float scaler = 1; // needs to be set to 1 when using 800x600 projectors! Maybe, 1.5 or 2 when testing without external projectors
int projectorWidth = 800/(int)scaler;
int projectorHeight = 600/(int)scaler;
int screenWidth = projectorWidth * 3;
int screenHeight = projectorHeight;
int targetDisplay = 1; // triplehead is the only screen
int alphaFade = 25;
int alphaDuration = 60;
boolean linkImageDurationToSample = true;

int blurCounter = 0;

boolean debugTripleheadScreens = true;

ArrayList<PImage> images1 = new ArrayList<PImage>();
ArrayList<PImage> images2 = new ArrayList<PImage>();
ArrayList<PImage> images3 = new ArrayList<PImage>();

PImage p1Image;
PImage p2Image;
PImage p3Image;

SamplePlayer p1Player;
SamplePlayer p2Player;
SamplePlayer p3Player;

int p1PlayerDuration;
int p2PlayerDuration;
int p3PlayerDuration;
int p1PlayerClearDuration;
int p2PlayerClearDuration;
int p3PlayerClearDuration;

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

  projector1 = new Timeline(Config.timeline1, new TimelineRenderer(0, 0) {
    public void action() {
        int chance = getChance();

        if (chance > (100 - Config.likelihood)) {
          if (debugTimeline) println("!!!! Projector 1 fire");

          p1PlayerClearDuration = calculateClearDuration();
          projector1.keepImageForFramesCount = 0;

          stopSampleFor(p1Player);

          p1Image = images1.get((int)random(images1.size()));
          Sample sample = SampleManager.randomFromGroup("projector-1");
          p1PlayerDuration = calculateDuration(sample);
          p1Player = new SamplePlayer(audioContext, sample);

          // tint(random(255), random(255), random(255), random(255));
          noStroke();
          image(p1Image, this.xpos, this.ypos);

          Gain g = new Gain(audioContext, 2, 0.2);
          g.addInput(p1Player);
          audioContext.out.addInput(0, g, 0); // OUT 1
          audioContext.start();
        }
      }

    public void clear() {
      print(projector1.keepImageForFramesCount+" | "); print(p1PlayerDuration+" | "); print(p1PlayerClearDuration);
      println("");

      if (projector1.keepImageForFramesCount < p1PlayerDuration) {
        // keep visible
      } else {
        if (p1PlayerClearDuration > 0) {
          //stroke(204, 102, 0);
          fill(0, 0, 0, alphaFade);
          rect(this.xpos, this.ypos, projectorWidth, projectorHeight);
          p1PlayerClearDuration--;
        }
      }
    }
  });

  projector2 = new Timeline(Config.timeline2, new TimelineRenderer(projectorWidth, 0) {
    public void action() {
        int chance = getChance();

        if (chance > (100 - Config.likelihood)) {
          if (debugTimeline) println("!!!! Projector 2 fire");

          p2PlayerClearDuration = calculateClearDuration();
          projector2.keepImageForFramesCount = 0;

          stopSampleFor(p1Player);

          p2Image = images2.get((int)random(images2.size()));
          Sample sample = SampleManager.randomFromGroup("projector-2");
          p2PlayerDuration = calculateDuration(sample);
          p2Player = new SamplePlayer(audioContext, sample);

          noStroke();
          image(p2Image, this.xpos, this.ypos);

          Gain g = new Gain(audioContext, 2, 0.2);
          g.addInput(p2Player);
          audioContext.out.addInput(1, g, 0); // OUT 2
          audioContext.start();
        }
      }

    public void clear() {
      if (projector2.keepImageForFramesCount < p2PlayerDuration) {
        // keep visible
      } else {
        if (p2PlayerClearDuration > 0) {
          //stroke(50, 102, 0);
          fill(0, 0, 0, alphaFade);
          rect(this.xpos, this.ypos, projectorWidth, projectorHeight);
          p2PlayerClearDuration--;
        }
      }
    }
  });

  projector3 = new Timeline(Config.timeline3, new TimelineRenderer(projectorWidth*2, 0) {
    public void action() {
        int chance = getChance();

        if (chance > (100 - Config.likelihood)) {
          if (debugTimeline) println("!!!! Projector 3 fire");

          p3PlayerClearDuration = calculateClearDuration();
          projector3.keepImageForFramesCount = 0;

          if (p3Player != null) {
            p3Player.setToEnd(); // stop anything still playing
          }

          p3Image = images3.get((int)random(images3.size()));
          Sample sample = SampleManager.randomFromGroup("projector-3");
          p3PlayerDuration = calculateDuration(sample);
          p3Player = new SamplePlayer(audioContext, sample);

          noStroke();
          image(p3Image, this.xpos, this.ypos);

          Gain g = new Gain(audioContext, 2, 0.2);
          g.addInput(p3Player);
          audioContext.out.addInput(2, g, 0); // OUT 3
          audioContext.start();
        }
      }

    public void clear() {
      //print(projector3.keepImageForFramesCount+" | "); print(p3PlayerDuration+" | "); print(p3PlayerClearDuration);
      //println("");

      if (projector3.keepImageForFramesCount < p3PlayerDuration) {
        // keep visible
      } else {
        if (p3PlayerClearDuration > 0) {
          //stroke(255);
          fill(0, 0, 0, alphaFade);
          rect(this.xpos, this.ypos, projectorWidth, projectorHeight);
          p3PlayerClearDuration--;
        }
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

  if (debugTripleheadScreens) {
    noStroke();
    fill(255, 0, 0);
    rect(0, 0, projectorWidth, projectorHeight);

    fill(0, 255, 0);
    rect(projectorWidth, 0, projectorWidth, projectorHeight);

    fill(0, 0, 255);
    rect(projectorWidth*2, 0, projectorWidth, projectorHeight);

  } else {
    projector1.draw();
    projector2.draw();
    projector3.draw();
  }

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

int calculateDuration(Sample sample) {
  int duration = Config.keepImageForFrames;

  if (linkImageDurationToSample) {
    duration = (int) ((sample.getLength()/1000) * frameRate);
  }

  return duration;
}

int calculateClearDuration() {
  int duration = alphaDuration;

  return duration;
}

void stopSampleFor(SamplePlayer player) {
  if (player != null) {
    player.setToEnd();
  }
}

// INTERACTIONS
void mousePressed() {
}
