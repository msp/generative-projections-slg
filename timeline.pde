class TimelineRenderer {
  public void action() { }
}

class Timeline {
  int[] events;
  TimelineRenderer renderer;
  int localFrameCount = 1;
  int eventCount = 0;

  Timeline (int[] _events, TimelineRenderer _renderer ) {
    events = _events;
    renderer = _renderer;
  }

  void draw() {
    if (eventFired()) {              
      renderer.action();

      if (eventCount < events.length - 1) {
        eventCount++;
      } else {
        localFrameCount = 0;
        eventCount = 0;
      }
    }

    localFrameCount++;
  }

  Boolean eventFired() {
    return localFrameCount == events[eventCount];
  }

  String toString() {
    return localFrameCount + " : "+eventCount+ " | ";
  }
}
