class Camera{
  
  PApplet applet;
  
  Camera(PApplet _applet){
    this.applet = _applet;
  }
  
  public Capture get(){
    String[] cameras = Capture.list();
    int finalCamera = -1;
    for(int i=0; i<10000; i++){
    cameras = Capture.list();
    println("Attempt #" + i + ":" + Arrays.toString(cameras));
    for(int c=0; c<cameras.length; c++){
      if(cameras[c].contains("size=640x480,fps=30")){
        finalCamera = c;
        break;  
      }
    }
    if(finalCamera >= 0){
      break;
    }    
    }
    if(finalCamera == -1){
    throw new RuntimeException("Cannot start camera!");
    }
    
    return new Capture(applet, cameras[finalCamera]); 
  }
}
