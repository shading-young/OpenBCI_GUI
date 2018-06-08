
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

class W_ssvep extends Widget {

  //to see all core variables/methods of the Widget class, refer to Widget.pde
  //put your custom variables here...

  int selectedSpeed = 0;
  int[] lastFrameCount = {0, 0, 0, 0};
  int[] colorIndex = {0, 0, 0, 0};
  int[][] cycle = {{5, 3, 3, 2},
                   {5, 3, 2, 2}};
  int[][] blinkFreq = {{6, 10, 12, 15},
                       {10, 15, 20, 30}};

  W_ssvep(PApplet _parent){
    super(_parent); //calls the parent CONSTRUCTOR method of Widget (DON'T REMOVE)

    //This is the protocol for setting up dropdowns.
    //Note that these 3 dropdowns correspond to the 3 global functions below
    //You just need to make sure the "id" (the 1st String) has the same name as the corresponding function
    addDropdown("BlinkSpeed", "blink speed", Arrays.asList("slow", "fast"), 0);

  }

  void update(){
    super.update(); //calls the parent update() method of Widget (DON'T REMOVE)

    //put your code here...
    int totalCycle = 0;
    for (int i = 0; i < 4; i++) {
            totalCycle = (int)frameRate / blinkFreq[selectedSpeed][i];
            if (totalCycle % 2 == 0) {
                    cycle[0][i] = totalCycle / 2;
                    cycle[1][i] = totalCycle / 2;
            } else {
                    cycle[0][i] = totalCycle / 2 + 1;
                    cycle[1][i] = totalCycle / 2;
            }
    }


  }

  void draw(){
    super.draw(); //calls the parent draw() method of Widget (DON'T REMOVE)

    //put your code here... //remember to refer to x,y,w,h which are the positioning variables of the Widget class
    pushStyle();
    fill(0,0,0);
    rect(x,y,w,h);

    for (int i = 0; i < 4; i++) {
            if (frameCount - lastFrameCount[i] >= cycle[colorIndex[i]][i]) {
                    lastFrameCount[i] = frameCount;
                    colorIndex[i] = (colorIndex[i]==1) ? 0 : 1;
            }
            blinkRect(i);
    }

    popStyle();

  }

  void screenResized(){
    super.screenResized(); //calls the parent screenResized() method of Widget (DON'T REMOVE)

    //put your code here...


  }

  void mousePressed(){
    super.mousePressed(); //calls the parent mousePressed() method of Widget (DON'T REMOVE)

    //put your code here...

  }

  void mouseReleased(){
    super.mouseReleased(); //calls the parent mouseReleased() method of Widget (DON'T REMOVE)

    //put your code here...

  }

  //add custom functions here
  void blinkRect(int n){
          if (colorIndex[n] == 0) {
                  fill(0,0,0);
          } else {
                  fill(255,255,255);
          }
          switch(n) {
          case 0:
                  rect(x + w*9/20, y, w/10, h/10);
                  break;
          case 1:
                  rect(x, y + h*9/20, w/10, h/10);
                  break;
          case 2:
                  rect(x + w*9/10, y + h*9/20, w/10, h/10);
                  break;
          case 3:
                  rect(x + w*9/20, y + h*9/10, w/10, h/10);
                  break;
          default:
          }
  }

};

//These functions need to be global! These functions are activated when an item from the corresponding dropdown is selected
void BlinkSpeed(int n){
  if(n==0){
    println("slow mode selected from blink speed.");
    w_ssvep.selectedSpeed = 0;
    //do this
  } else if(n==1){
    println("fast mode selected from blink speed.");
    w_ssvep.selectedSpeed = 1;
    //do this instead
  }

  closeAllDropdowns(); // do this at the end of all widget-activated functions to ensure proper widget interactivity ... we want to make sure a click makes the menu close
}
