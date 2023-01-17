import gab.opencv.*;
import processing.video.*;
import java.awt.Rectangle;

boolean DEBUG = false;

OpenCV opencv;
Capture cam;

Rectangle[] faces;
Rectangle[] noses;

void setup() 
{
  size(10, 10);
  
  initCamera();
  opencv = new OpenCV(this, cam.width, cam.height);
  
  surface.setResizable(true);
  surface.setSize(opencv.width, opencv.height);
}

void draw() 
{
  if(cam.available())
  {    
    cam.read();
    cam.loadPixels();
    opencv.loadImage((PImage)cam);
    image(opencv.getInput(), 0, 0);
    
    fill(255, 50, 50);
    noStroke();
    
    // detect faces
    
    opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
    opencv.setROI(0, 0, opencv.width, opencv.height);
    faces = opencv.detect();
    
    // detect noses in each face
    
    opencv.loadCascade(OpenCV.CASCADE_NOSE);
    
    for (int i = 0; i < faces.length; i++) {
      opencv.setROI(
        faces[i].x + int(faces[i].width * 0.25),
        faces[i].y + int(faces[i].height * 0.25),
        int(faces[i].width * 0.5),
        int(faces[i].height * 0.5)
      );
      noses = opencv.detect();
      
      for (int j = 0; j < noses.length; j++) {
        Rectangle n = noses[j];
        circle(
          faces[i].x + int(faces[i].width * 0.25) + n.x + n.width / 2,
          faces[i].y + int(faces[i].height * 0.25) + n.y + n.height / 2,
          min(n.width, n.height)
        );
      }
    }
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
