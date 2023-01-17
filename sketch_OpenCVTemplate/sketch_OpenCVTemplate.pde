import gab.opencv.*;
import processing.video.*;
import java.awt.Rectangle;

boolean DEBUG = false;

OpenCV opencv;
Capture cam;

String[] instructions = {"left", "right", "up", "down"};
int currentInstruction;

void setup() 
{
  size(10, 10);
  
  initCamera();
  opencv = new OpenCV(this, cam.width, cam.height);
  
  surface.setResizable(true);
  surface.setSize(opencv.width, opencv.height);
  
  currentInstruction = (int)random(4);
}

void draw() 
{
  if(cam.available())
  {    
    cam.read();
    cam.loadPixels();
    opencv.loadImage((PImage)cam);
    image(opencv.getInput(), 0, 0);
    
    opencv.calculateOpticalFlow();
    PVector af = opencv.getAverageFlow();
    println(af);
    opencv.drawOpticalFlow();
    
  }
}

void initCamera()
{
  String[] cameras = Capture.list();
  if (cameras.length != 0) 
  {
    println("Using camera: " + cameras[0]); 
    cam = new Capture(this, cameras[0]);
    cam.start();    
    
    while(!cam.available()) print();
    
    cam.read();
    cam.loadPixels();
  }
  else
  {
    println("There are no cameras available for capture.");
    exit();
  }
}
