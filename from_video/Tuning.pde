class Tuning{
  public int history;
  public int mixtures;
  public float backgroundRatio;
  public float noiseSigma;
  
  public int erode;
  
  BufferedReader reader;

  Tuning(){
    println("Tuning loading started");
    reader = createReader(dataPath("tuning.txt"));    
    
    
    try{
      String all = reader.readLine();
      if(all == null) return;
      
      String [] values = all.split(",");
      history = Integer.parseInt(values[0]); 
      mixtures = Integer.parseInt(values[1]);
      
      backgroundRatio = Float.parseFloat(values[2]);
      noiseSigma = Float.parseFloat(values[3]);
      
      erode = Integer.parseInt(values[4]); 
      
    } catch (IOException ex){
      println("Error: cannot find tuning file");
    } finally {
      try{
        reader.close();
      } catch (IOException ex){
        println("Error: cannot close reader.");
      }
    }

    printData();    
    
  }
  
  void save(int history, int mixtures, double backgroundRatio, double noiseSigma, int erode){
    try{
      PrintWriter writer = createWriter(dataPath("tuning.txt"));
      println("Saving: " + history + "," + mixtures + "," + backgroundRatio + "," + noiseSigma + "," + erode);  
      writer.println(history + "," + mixtures + "," + backgroundRatio + "," + noiseSigma + "," + erode);  
      writer.flush();
      writer.close();
    } catch (Exception e){
      println("Cannot close writer");
    }
  }
  
  void printData(){
    println(history + "," + mixtures + "," + backgroundRatio + "," + noiseSigma + "," + erode);
  }
}
