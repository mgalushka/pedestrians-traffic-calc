import processing.core.*;

import org.opencv.core.Point;
import org.opencv.core.Point3;
import org.opencv.core.Mat;
import org.opencv.core.CvType;
import org.opencv.core.Scalar;

class TrackedObj {
  Mat hsv, hue, mask, prob;
  Rect prev_rect;
  RotatedRect  curr_box;

  Mat hist;
  List<Mat> hsvarray, huearray;

  public TrackedObj()
  {
    this.hist = new Mat();
    prev_rect=new Rect();
    curr_box=new RotatedRect();
    hsvarray=new Vector<Mat>();
    huearray=new Vector<Mat>();  
  }
}

