
////////////////////////////////////////////////////
//
//    W_template.pde (ie "Widget Template")
//
//    This is a Template Widget, intended to be used as a starting point for OpenBCI Community members that want to develop their own custom widgets!
//    Good luck! If you embark on this journey, please let us know. Your contributions are valuable to everyone!
//
//    Created by: Conor Russomanno, November 2016
//
///////////////////////////////////////////////////,

class W_ssvep_analyzer extends Widget {

  //to see all core variables/methods of the Widget class, refer to Widget.pde
  //put your custom variables here...
        Button startButton;
        Boolean analyzeActive;

        Boolean[] ssvepResult = {false, false, false, false};

        ControlP5 cp5_threshold;
        float[] threshold = {0.6, 1.0, 2.0, 1.0};

  W_ssvep_analyzer(PApplet _parent){
    super(_parent); //calls the parent CONSTRUCTOR method of Widget (DON'T REMOVE)

    analyzeActive = false;

    cp5_threshold = new ControlP5(pApplet);
    createTextFields("threshold1", "0.6");
    createTextFields("threshold2", "1.0");
    createTextFields("threshold3", "2.0");
    createTextFields("threshold4", "1.0");
    cp5_threshold.setAutoDraw(false);

    startButton = new Button(x + w - 100, y, 100, 20, "Start", 14);
    startButton.setFont(p4, 14);
    startButton.setColorNotPressed(color(184, 220, 105));
  }

  void update(){
    super.update(); //calls the parent update() method of Widget (DON'T REMOVE)

    //put your code here...

    int freqIndex = 0;
    float freqAm = 0.0;
    float freqAmOffset = 0.0;
    float offset = 0.0;
    float leftFreqAm = 0.0, rightFreqAm = 0.0;
    int maxIndex = 0;
    float maxOffset = 0.0;
    for (int i = 0; i < ssvepResult.length; i++) {
            freqIndex = int(getNfftSafe() / getSampleRateSafe() * w_ssvep.blinkFreq[w_ssvep.selectedSpeed][i]);
            freqAm = (fftBuff[6].getBand(freqIndex) + fftBuff[7].getBand(freqIndex)) / 2;

            leftFreqAm = (fftBuff[6].getBand(freqIndex - 1) + fftBuff[7].getBand(freqIndex - 1)) / 2;
            rightFreqAm = (fftBuff[6].getBand(freqIndex + 1) + fftBuff[7].getBand(freqIndex + 1)) / 2;
            freqAmOffset = freqAm * 2 - leftFreqAm - rightFreqAm;
            println("result"+i+" index="+freqIndex+" Am="+freqAm+","+leftFreqAm+","+rightFreqAm+" offset="+freqAmOffset);

            if (freqAmOffset > threshold[i]) {
                    offset = freqAmOffset - threshold[i];
                    if (maxOffset < offset) {
                            ssvepResult[maxIndex] = false;
                            maxIndex = i;
                            ssvepResult[maxIndex] = true;
                            maxOffset = offset;
                    }
            } else {
                    ssvepResult[i] = false;
            }
    }


  }

  void draw(){
    super.draw(); //calls the parent draw() method of Widget (DON'T REMOVE)

    //put your code here... //remember to refer to x,y,w,h which are the positioning variables of the Widget class
    pushStyle();

    fill(0,0,0);// Background fill: white
    textFont(h1,20);
    text("threshold1(uv)", x, y);
    cp5_threshold.draw();
    startButton.draw();

    if (analyzeActive) {
            showResult();
    }

    popStyle();

  }

  void screenResized(){
    super.screenResized(); //calls the parent screenResized() method of Widget (DON'T REMOVE)

    //put your code here...
    startButton.setPos(x + w - 100, y);
    cp5_threshold.get(Textfield.class, "threshold1").setPosition(x, y);
    cp5_threshold.get(Textfield.class, "threshold2").setPosition(x + 60, y);
    cp5_threshold.get(Textfield.class, "threshold3").setPosition(x + 120, y);
    cp5_threshold.get(Textfield.class, "threshold4").setPosition(x + 180, y);


  }

  void mousePressed(){
    super.mousePressed(); //calls the parent mousePressed() method of Widget (DON'T REMOVE)

    //put your code here...
    if(startButton.isMouseHere()){
            startButton.setIsActive(true);
    }

  }

  void mouseReleased(){
    super.mouseReleased(); //calls the parent mouseReleased() method of Widget (DON'T REMOVE)

    //put your code here...
    if(startButton.isActive && startButton.isMouseHere()){
            if(!analyzeActive){
                    turnOnButton();         // Change appearance of button
                    initializeAnalysis();    // initialize param
                    analyzeActive = true;         // Begin analyze
            }else{
                    turnOffButton();        // Change apppearance of button
                    analyzeActive = false;          // Stop analyze
            }
    }
    startButton.setIsActive(false);

  }

  //add custom functions here
        void createTextFields(String name, String default_text){
                cp5_threshold.addTextfield(name)
                        .align(10,100,10,100)                   // Alignment
                        .setSize(50,20)                         // Size of textfield
                        .setFont(f2)
                        .setFocus(false)                        // Deselects textfield
                        .setColor(color(26,26,26))
                        .setColorBackground(color(255,255,255)) // text field bg color
                        .setColorValueLabel(color(0,0,0))       // text color
                        .setColorForeground(color(26,26,26))    // border color when not selected
                        .setColorActive(isSelected_color)       // border color when selected
                        .setColorCursor(color(26,26,26))
                        .setText(default_text)                  // Default text in the field
                        .setCaptionLabel("")                    // Remove caption label
                        .setVisible(true)                      // Initially hidden
                        .setAutoClear(true)                     // Autoclear
                        ;
        }

        /* Change appearance of Button to off */
        void turnOffButton(){
                startButton.setColorNotPressed(color(184,220,105));
                startButton.setString("Start");
        }

        void turnOnButton(){
                startButton.setColorNotPressed(color(224, 56, 45));
                startButton.setString("Stop");
        }

        void initializeAnalysis() {
                threshold[0] = Float.parseFloat(cp5_threshold.get(Textfield.class, "threshold1").getText());
                threshold[1] = Float.parseFloat(cp5_threshold.get(Textfield.class, "threshold2").getText());
                threshold[2] = Float.parseFloat(cp5_threshold.get(Textfield.class, "threshold3").getText());
                threshold[3] = Float.parseFloat(cp5_threshold.get(Textfield.class, "threshold4").getText());
        }

        void showResult() {
                fill(255, 255, 255);
                if (ssvepResult[0] == true) {
                        fill(0, 0, 0);
                        triangle(x + w/2, y + h/10, x + w/5*2 , y + h/10*9, x + w/5*3, y + h/10*9);
                } else if (ssvepResult[1] == true) {
                        fill(0, 0, 0);
                        triangle(x + w/10, y + h/2, x + w/10*9 , y + h/5*2, x + w/10*9, y + h/5*3);
                } else if (ssvepResult[2] == true) {
                        fill(0, 0, 0);
                        triangle(x + w/10*9, y + h/2, x + w/10 , y + h/5*2, x + w/10, y + h/5*3);
                } else if (ssvepResult[3] == true) {
                        fill(0, 0, 0);
                        triangle(x + w/2, y + h/10*9, x + w/5*2 , y + h/10, x + w/5*3, y + h/10);
                } else {
                        rect(x + w/10, y + h/10, w/5*4, h/5*4);
                }
        }

};

//These functions need to be global! These functions are activated when an item from the corresponding dropdown is selected
