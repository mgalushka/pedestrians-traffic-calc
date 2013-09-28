import processing.core.*;

import java.awt.image.BufferedImage;
import java.awt.image.WritableRaster;
import java.awt.image.Raster;
import java.awt.image.DataBufferByte;

import org.opencv.core.Point;
import org.opencv.core.Point3;
import org.opencv.core.Mat;
import org.opencv.core.CvType;
import org.opencv.core.Scalar;

public class ImageLibrary {

  PApplet parent;

  public ImageLibrary(PApplet parent) {
    this.parent = parent;
    parent.registerMethod("dispose", this);
  }

  public void dispose()
  {
    //nothing yet
  }
  
  public PVector toP5(Point pt) {
    return new PVector( (float) pt.x, (float) pt.y);
  }

  public PVector toP5(Point3 pt) {
    return new PVector( (float) pt.x, (float) pt.y, (float) pt.z);
  }

  /**
   * We support here only 3 bytes BGR images
   */
  public PImage toP5(Mat mat) {
    int cols = mat.cols();
    int rows = mat.rows();
    int elemSize = (int) mat.elemSize();
    byte[] data = new byte[cols * rows * elemSize];
    int type;
    
    //println ("elem size = " + elemSize);
    
    mat.get(0, 0, data);
    

    switch (mat.channels()) {
      case 1:
          type = BufferedImage.TYPE_BYTE_GRAY;
          break;
  
      case 3: 
          byte b;
          for(int i=0; i<data.length; i=i+3) {
              b = data[i];
              data[i] = data[i+2];
              data[i+2] = b;
          }
          
          type = BufferedImage.TYPE_3BYTE_BGR;
          break;
  
      default:
          type = BufferedImage.TYPE_3BYTE_BGR;
          //return null;
    }   
    
    
    BufferedImage image = new BufferedImage(cols, rows, type);
    image.getRaster().setDataElements(0, 0, cols, rows, data);
    
    PImage pimage = new PImage(image.getWidth(), image.getHeight(), PConstants.ARGB);
    // now copy to the image
    image.getRGB(0, 0, pimage.width, pimage.height, pimage.pixels, 0, pimage.width);
    pimage.updatePixels();
    
    return pimage;

  }

////////////////////////////////////////////////////////////////////////////////////////
// toCV
////////////////////////////////////////////////////////////////////////////////////////

  public Mat toCV(PImage image) {


    BufferedImage bm = new BufferedImage(image.width, image.height, BufferedImage.TYPE_4BYTE_ABGR);
    bm.setRGB(0, 0, image.width, image.height, image.pixels, 0, image.width);
    
    Raster rr = bm.getRaster();    
    byte [] pixels = new byte[image.width * image.height * 4];
    rr.getDataElements(0, 0, image.width, image.height, pixels);
    
    /*
    byte[] pixels = ((DataBufferByte) bm.getRaster().getDataBuffer()).getData();
    */
    
    Mat m1 = new Mat(image.height, image.width, CvType.CV_8UC4); // CvType.CV_8UC4
    m1.put(0, 0, pixels);

    return m1;

  }

  public Point toPoint(PVector pt) {
    return new Point(pt.x, pt.y);
  }

  public Point3 toPoint3(PVector pt) {
    return new Point3(pt.x, pt.y, pt.z);
  }

}
