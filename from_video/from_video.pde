import processing.video.*;

import org.opencv.video.*;
import org.opencv.core.*;
import org.opencv.calib3d.*;
import org.opencv.contrib.*;
import org.opencv.objdetect.*;
import org.opencv.imgproc.*;
import org.opencv.utils.*;
import org.opencv.features2d.*;
import org.opencv.highgui.*;
import org.opencv.ml.*;
import org.opencv.photo.*;

import java.util.*;

boolean face_detect = false;

//Capture capture;
CascadeClassifier classifier;
ArrayList<Rect> faceRects;

ImageLibrary imageLibrary;

Mat resulted_x;
Mat resulted_y;

BackgroundSubtractorMOG background;

int w = 640*2;
int h = 480*2;

int videoW = w/2;
int videoH = h/2;

Slider history;

Movie video;
PImage frame;

void setup()
{
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);  
  classifier = new CascadeClassifier(dataPath("haarcascade_upperbody.xml"));
  faceRects = new ArrayList();
  
  imageLibrary = new ImageLibrary(this);

  /*
  Camera camera = new Camera(this);
  capture = camera.get();
  capture.start();
  */
  
  flipMap(videoW, videoH);
  
  video = new Movie(this, "sample-cafe_x264.mov");
  video.loop();
  
  
  size(w, h);
  frameRate(30);
  
  history = new Slider("History", 3, 0, 25, 150, videoH + 50, 300, 15, HORIZONTAL);
  
  background = new BackgroundSubtractorMOG(15, 3, 0);
}

void draw(){
  
  imageMode(CORNER);
  
  //image(video, 0, 0);
  
  if (video.available()) {
    video.read();
    frame = video;
  }
  
  image(frame, 0, 0);

  if (frame != null) 
  {
    
    //frame = video;
    
    //PImage pimg = frame;
    
    Mat camMat = imageLibrary.toCV(frame);
    if(camMat == null){
      println("error");
    }
    /*
    Mat realCamFlipped = new Mat(videoW, videoH, CvType.CV_8UC4);
    Imgproc.remap(camMat, realCamFlipped, resulted_x, resulted_y, 0, 0, new Scalar(0, 0, 0));
    */
    
    Mat camFinal = new Mat(videoW, videoH, CvType.CV_8UC4);
    Imgproc.cvtColor(camMat, camFinal, Imgproc.COLOR_BGR2RGB, 0);
    
    image(imageLibrary.toP5(camFinal), 0, 0, videoW, videoH);
    
    Mat back = new Mat(videoW, videoH, CvType.CV_8UC1);
    background.apply(camFinal, back);
    
    // erosion/dillation element
    Mat element = Imgproc.getStructuringElement(Imgproc.MORPH_ELLIPSE, new Size(5, 5));
    
    Mat eroded = new Mat(videoW, videoH, CvType.CV_8UC1);
    Imgproc.erode(back, eroded, element);
    
    Mat dilated = new Mat(videoW, videoH, CvType.CV_8UC1);
    Imgproc.dilate(eroded, dilated, element);
    
    // apply gaussian blur
    Mat blured = new Mat(videoW, videoH, CvType.CV_8UC4);
    Imgproc.GaussianBlur(dilated, blured, new Size(11, 11), 11, 11);
    
    image(imageLibrary.toP5(blured), width/2, 0, videoW, videoH);
    
    if(face_detect){
      Size minSize = new Size(150, 150);
      Size maxSize = new Size(450, 450);
      MatOfRect objects = new MatOfRect();
        
      Mat gray = new Mat(videoW, videoH, CvType.CV_8U);
      Imgproc.cvtColor(camMat, gray, Imgproc.COLOR_BGRA2GRAY);
      classifier.detectMultiScale(gray, objects, 1.1, 3, Objdetect.CASCADE_DO_CANNY_PRUNING | Objdetect.CASCADE_DO_ROUGH_SEARCH, minSize, maxSize);
      
      if(objects.toArray() != null && objects.toArray().length > 0){
        for( int j = 0; j < objects.toArray().length; j++ ){ 
          Rect current = objects.toArray()[j];
          imageMode(CORNER); 
          stroke(0);
          noFill();
          rect(current.x, current.y, current.width, current.height);
        }     
      }
    }
  }
  
  if (mousePressed) {
      history.mouseDragged();
  }
  
  fill(25);
  rect(0, videoH, w, videoH);
  history.display();
  fill(0, 102, 153);
  text((int)history.get(), 480, videoH + 60);
}

// Called every time a new frame is available to read
void movieEvent(Movie m) {
  m.read();
  frame = m;
}

void mousePressed() {
  history.mousePressed();
  background = new BackgroundSubtractorMOG((int)history.get(), 3, 0);
}

void mouseDragged(){
  history.mouseDragged();
  background = new BackgroundSubtractorMOG((int)history.get(), 3, 0);
}

void keyPressed(){
  if(key == ' '){
    println("Refresh static background");
    background = new BackgroundSubtractorMOG((int)history.get(), 3, 0);
  }
}

void flipMap(int w, int h)
{   
   resulted_x = new Mat(h, w, CvType.CV_32FC1);
   resulted_y = new Mat(h, w, CvType.CV_32FC1);
   for( int j = 0; j < h; j++ ){ 
     for( int i = 0; i < w; i++ ){        
           resulted_x.put(j, i, w - i);
           resulted_y.put(j, i, j);  
       }
    }
}

