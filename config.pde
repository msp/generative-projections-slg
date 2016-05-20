static class Config {
  //// SALLY CAN EDIT ///////////////////////////

  // timeline(s)
  static int[] timeline1 = { 1, 200, 400, 600, 680, 860, 900, 910, 920, 925, 1000, 1100, 1200 };
  static int[] timeline2 = { 1, 100, 300, 500, 510, 520, 530, 540, 600 };
  static int[] timeline3 = { 1, 275, 375, 575, 700, 800, 810, 850, 880, 881, 882, 883, 887, 888 };

  // event probability
  static boolean enableProbability = true;
  static int likelihood = 75; // how likely is the event to fire? e.g. 75 is 75% of the time

  // Image visible for
  static int keepImageForFrames = 100;

  // Bluring
  // 3600 frames per minute at normal framerate 60fps
  static int blurFromFrame = 600; // 30 seconds START
  // When bluring runs at approx 7fps e.g. 30 seconds would be 7 * 30 = 210 frames
  static int blurUntilFrame = 605; // 60 seconds STOP

  // Audio
  static int reverbLikelihood = 50;
  static float globalGain = 0.5; // range of 0 (min) to 1 (max)

  //// END OF SALLY CAN EDIT ///////////////////
}
