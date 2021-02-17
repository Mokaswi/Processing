/*
* This file is a kind of "main" file. 
* This provides GUI and function for Serial communication with arduino
* If you use controlP5 at first time, You should install its library.
* Choose Sketch in the above menu bar and choose Add library in Import library.
* and then processing open a window, and you have to type "controlP5" in search box in the window.
* If you have some questions about processing, you can ask me or Matt.
*/
//
//import
//
import java.util.Map;
import processing.serial.*;
import controlP5.*;
//
//Const for GUI
//
final int TAB_WIDTH = 200;
final int TAB_HEIGHT = 30;
final int BUTTON_WIDTH = 170;
final int BUTTON_HEIGHT = 30;
final int PWM_DUTY_MAX = 255;
final int SLIDER_WIDTH = 200;
final int SLIDER_HEIGHT = 20;
final int TEXT_WIDTH = 350;
final int TEXT_HEIGHT = 20;

Serial arduinoPort;  // Create object from Serial class
String val;     // Data received from the serial port
//
//Declarations concerning GUI
//
//There are two ways(at least) to access class methods or members.
//One is to declare objects as global objects.
//In this case, you can use like  objectName.setColorActive(....);
//
//The other is to use "name".
//Each object which consists of GUI has "name" as different one from objectName
//In this case, you can use like 
//gui.getController("foreSensorCalibration").setBroadcast(false);
//or
//gui.get(Textarea.class, "veragedForwardOffset").setText("Averaged Offset : ")
//
ControlP5 gui;          //
ListBox targetList;     //Pull down list for choice target Id
Slider dutySpringL;     //Slider to arrange duty of springL
Slider dutySpringR;     //Slider to arrange duty of springR
Slider dutySpringB;     //Slider to arrange duty of springB
Textarea forwardDistance;  //Text object(just text)
Textarea backwardDistance;
Textarea forwardOffset;
Textarea backwardOffset;
Textarea monitorTextarea;


String targetNum;                  //Target Id chosed current
String monitorText = "";            //String for serial  Monitor
boolean distanceFlag1 = false;      //Flags
boolean distanceFlag2 = false;      
boolean offsetFlag1 = false;
boolean offsetFlag2 = false;
boolean pushingFlag = false;
boolean calibrationFlag1 = false;
boolean waitingFlag1 = false;
boolean calibrationFlag2 = false;
boolean waitingFlag2 = false;

int calibrationCount;            //Calibration times
int counter;                      //countor for calibration
int calibrationSum;              //summary of offsets, which will be averaged 

void setup()
{
  //set window's size
  size(1000, 600);
  gui = new ControlP5(this);//Create the new GUI
  initGui();                //Initialize GUI
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.
  //When you connect just one arduino, you should choose Serial.list()[0]
  String portName = Serial.list()[0]; //change the 0 to a 1 or 2 etc. to match your port
  arduinoPort = new Serial(this, portName, 9600);//Third argument is Baud rate which is usually 9600
}
void draw() {
  background(128);    //Set background
}
void serialEvent( Serial arduinoPort ) {
  val = arduinoPort.readStringUntil('\n');         // read it and store it in val until '\n'
  if(val != null) {
    print(val); //print it out in the console
    printToMonitor(val);  //print it out in the monitor in GUI 
    
    if( val.startsWith("Serial:") ) {
    }
    else if( val.startsWith("Distance:") ) {  
      String tmp = val.substring("Distance:".length(), val.length()-2);
      if(distanceFlag1) {
        forwardDistance.setText("Distance: " + tmp + "mm");
        distanceFlag1 = false;
        activeButtonsInTab1();
      }
      else if(distanceFlag2) {
        backwardDistance.setText("Distance: " + tmp + "mm");
        distanceFlag2 = false;
        activeButtonsInTab1();
      }
    }
    else if( val.startsWith("Offset:") ) {
      String tmp = val.substring("Offset:".length(), val.length()-2);
      if(offsetFlag1) {
        forwardOffset.setText("Offset: " + tmp);
        offsetFlag1 = false;
        //activeButtonsInTab1();
      }
      else if(offsetFlag2) {
        backwardOffset.setText("Offset: " + tmp);
        offsetFlag2 = false;
        //activeButtonsInTab1();
      }
      else if(calibrationFlag1) {
        if(counter == calibrationCount) {
          calibrationFlag1 = false;
          gui.get(Textarea.class, "averagedForwardOffset").setText("Averaged Offset : " +  (int)calibrationSum/calibrationCount);
          //activeButtonsInTab3();
        }
        else{
          calibrationSum += Integer.parseInt(tmp);
          counter++;
          println("counter:" + counter);
          printlnToMonitor("counter:" + counter);
          sendMessage(targetNum, "0", Messages.SET_OFFSET_FORE_SENSOR.getCommand());
        }
      }
      else if(calibrationFlag2) {
        if(counter == calibrationCount) {
          calibrationFlag2 = false;
          gui.get(Textarea.class, "averagedBackwardOffset").setText("Averaged Offset : " +  (int)calibrationSum/calibrationCount);
          //activeButtonsInTab3();
        }
        else{
          calibrationSum += Integer.parseInt(tmp);
          counter++;
          println("counter:" + counter);
          printlnToMonitor("counter:" + counter);
          sendMessage(targetNum, "0", Messages.SET_OFFSET_BACK_SENSOR.getCommand());
        }
      }
    }
    else if( val.startsWith("Time:") ) {
    }
    else {
      if(distanceFlag1) {
        forwardDistance.setText("Distance: " + "error");
        distanceFlag1 = false;
        //activeButtonsInTab1();
      }
      else if(distanceFlag2) {
        backwardDistance.setText("Distance: " + "error");
        distanceFlag2 = false;
        //activeButtonsInTab1();
      }
      else if(offsetFlag1) {
        forwardOffset.setText("Offset: " + "error");
        offsetFlag1 = false;
        //activeButtonsInTab1();
      }
      else if(offsetFlag2) {
        forwardOffset.setText("Offset: " + "error");
        offsetFlag1 = false;
        //activeButtonsInTab1();
      }
    }
  }
}
void keyReleased() {//Function which is called detect key releasing 
  QuickKeys tmp = QuickKeys.valueOf(key);//If relesed key is contained in quickkeys, return object 
  if(tmp == QuickKeys.NOT_MATCH){//If the key is not setted 
    return;
  }
  else {
    String duty1 = "0";
    String duty2 = "0";
    if(tmp.getPins().length == 2) {//When activate one pin
      if(!(tmp.getPins()[1].equals("0"))) {
        duty1 = String.valueOf((int)gui.getController(tmp.getPins()[1]).getValue());
      }
      sendMessage(targetNum, "0", Messages.WRITE_ONE_PIN.getCommand(), tmp.getPins()[0], duty1);
    }
    else if(tmp.getPins().length == 4) {//When activate two pins at same time
      if(!(tmp.getPins()[1].equals("0"))) {
        duty1 = String.valueOf((int)gui.getController(tmp.getPins()[1]).getValue());
      }
      if(!(tmp.getPins()[3].equals("0"))) {
        duty2 = String.valueOf((int)gui.getController(tmp.getPins()[3]).getValue());
      }
      sendMessage(targetNum, "0", Messages.WRITE_TWO_PINS.getCommand(), tmp.getPins()[0], duty1, tmp.getPins()[2], duty2);
    }
  }
}
void turnRedLedOn() {
  sendMessage(targetNum, "0", Messages.WRITE_ONE_PIN.getCommand(), "2", "1");//"2" is pin number of RED LED, second "1" means HIGH
}
void turnRedLedOff() {
  sendMessage(targetNum, "0", Messages.WRITE_ONE_PIN.getCommand(), "2", "0");//2" is pin number of RED LED, second "0" means LOW
}
void crawlForward() {
  sendMessage(targetNum, "0", Messages.CRAWL_FORWARD_AUTO.getCommand());
}
void crawlBackward() {
  sendMessage(targetNum, "0", Messages.CRAWL_BACKWARD_AUTO.getCommand());
}
void measureForwardDistance() {
  //deactiveButtonsInTab1();//deactive some buttons
  distanceFlag1 = true;  
  sendMessage(targetNum, "0", Messages.GET_DISTANCE_FORWARD.getCommand());
}
void measureBackwardDistance() {
  distanceFlag2 = true;
  sendMessage(targetNum, "0", Messages.GET_DISTANCE_BACKWARD.getCommand());
}
void setForwardOffset() {
  offsetFlag1 = true;
  sendMessage(targetNum, "0", Messages.SET_OFFSET_FORE_SENSOR.getCommand());
}
void setBackwardOffset() {
  offsetFlag2 = true;
  sendMessage(targetNum, "0", Messages.SET_OFFSET_BACK_SENSOR.getCommand());
}
void startPushingExperiment(){
  pushingFlag = true;
  sendMessage(targetNum, "0", Messages.PUSH.getCommand(), gui.get(Textfield.class, "pushingThreshold").getText());
}
void crawlForwardManually() {
  sendMessage(targetNum, "0", Messages.CRAWL_FORWARD_MANUAL.getCommand(), 
  gui.get(Textfield.class, "duty11").getText(), gui.get(Textfield.class, "delay11").getText(),
  gui.get(Textfield.class, "duty12").getText(), gui.get(Textfield.class, "delay12").getText(),
  gui.get(Textfield.class, "duty13").getText(), gui.get(Textfield.class, "delay13").getText(),
  gui.get(Textfield.class, "duty14").getText(), gui.get(Textfield.class, "delay14").getText(),
  gui.get(Textfield.class, "duty15").getText(), gui.get(Textfield.class, "delay15").getText(),
  gui.get(Textfield.class, "duty16").getText(), gui.get(Textfield.class, "delay16").getText(),
  gui.get(Textfield.class, "duty17").getText(), gui.get(Textfield.class, "delay17").getText(),
  gui.get(Textfield.class, "duty18").getText(), gui.get(Textfield.class, "delay18").getText()
  );
}
void crawlBackwardManually() {
  sendMessage(targetNum, "0", Messages.CRAWL_BACKWARD_MANUAL.getCommand(), 
  gui.get(Textfield.class, "duty21").getText(), gui.get(Textfield.class, "delay21").getText(),
  gui.get(Textfield.class, "duty22").getText(), gui.get(Textfield.class, "delay22").getText(),
  gui.get(Textfield.class, "duty23").getText(), gui.get(Textfield.class, "delay23").getText(),
  gui.get(Textfield.class, "duty24").getText(), gui.get(Textfield.class, "delay24").getText(),
  gui.get(Textfield.class, "duty25").getText(), gui.get(Textfield.class, "delay25").getText(),
  gui.get(Textfield.class, "duty26").getText(), gui.get(Textfield.class, "delay26").getText(),
  gui.get(Textfield.class, "duty27").getText(), gui.get(Textfield.class, "delay27").getText(),
  gui.get(Textfield.class, "duty28").getText(), gui.get(Textfield.class, "delay28").getText()
  );
}
void foreSensorCalibration() {
  //deactiveButtonsInTab3();
  calibrationFlag1 = true;
  calibrationSum = 0;
  counter = 0;
  calibrationCount = Integer.parseInt(gui.get(Textfield.class, "averageTimes").getText());
  gui.get(Textarea.class, "averagedForwardOffset").setText("Averaged Offset : " + "Measuring");
  sendMessage(targetNum, "0", Messages.SET_OFFSET_FORE_SENSOR.getCommand());
}
void backSensorCalibration() {
  //deactiveButtonsInTab3();
  calibrationFlag2 = true;
  calibrationSum = 0;
  counter = 0;
  calibrationCount = Integer.parseInt(gui.get(Textfield.class, "averageTimes").getText());
  gui.get(Textarea.class, "averagedBackwardOffset").setText("Averaged Offset : " + "Measuring");
  sendMessage(targetNum, "0", Messages.SET_OFFSET_BACK_SENSOR.getCommand());
}
void controlEvent(ControlEvent theEvent) {
  
  if(theEvent.isController()){
    if(theEvent.getController().getName().equals("targetList") ) {
      int index = (int)theEvent.getController().getValue();
      Map<String, Object> item = targetList.getItem(index);
      targetNum = item.get("value").toString();
    }
  }
}
void deactiveButtonsInTab1() {
  gui.getController("measureForwardDistance").setBroadcast(false);
  gui.getController("measureBackwardDistance").setBroadcast(false);
  gui.getController("setForwardOffset").setBroadcast(false);
  gui.getController("setBackwardOffset").setBroadcast(false);
}
void activeButtonsInTab1() {
  gui.getController("measureForwardDistance").setBroadcast(true);
  gui.getController("measureBackwardDistance").setBroadcast(true);
  gui.getController("setForwardOffset").setBroadcast(true);
  gui.getController("setBackwardOffset").setBroadcast(true);
}
void deactiveButtonsInTab3() {
  gui.getController("foreSensorCalibration").setBroadcast(false);
  gui.getController("backSensorCalibration").setBroadcast(false);
}
void activeButtonsInTab3() {
  gui.getController("foreSensorCalibration").setBroadcast(true);
  gui.getController("backSensorCalibration").setBroadcast(true);
}
void sendMessage(String... messages) {
  int i = 0;
  String dstMessage = ""; 
  
  for(String str : messages) {
    dstMessage = dstMessage + str + " ";
  }
  dstMessage = dstMessage.substring(0, dstMessage.length()-1);
  dstMessage = dstMessage + "\n";
  
  //println(dstMessage);
  //printlnToMonitor(dstMessage);
  arduinoPort.write(dstMessage);
}
void printToMonitor(String str) {//print for the Monitor
  monitorText = monitorText + str;
  monitorTextarea.setText(monitorText);
}
void printlnToMonitor(String str) {//println for the Monitor
  monitorText = monitorText + str + "\n";
  monitorTextarea.setText(monitorText);
}
void initGui(){
  //
  //Tab section
  //
  gui.getTab("default")
      .setWidth(TAB_WIDTH)
      .setHeight(TAB_HEIGHT)
      .activateEvent(true)
      .setLabel("Main Control")
      .setId(1)
      .getCaptionLabel()
      .setFont(createFont("", 15))
      ;
  gui.addTab("manuallyLocomotion");
  gui.getTab("manuallyLocomotion")
      .setWidth(TAB_WIDTH)
      .setHeight(TAB_HEIGHT)
      .activateEvent(true)
      .setLabel("Manually locomotion")
      .setId(2)
      .getCaptionLabel()
      .setFont(createFont("", 15))
      ; 
  gui.addTab("sensorCalibration");
  gui.getTab("sensorCalibration")
      .setWidth(TAB_WIDTH)
      .setHeight(TAB_HEIGHT)
      .activateEvent(true)
      .setLabel("Sensor Calibration")
      .setId(3)
      .getCaptionLabel()
      .setFont(createFont("", 15))
      ;
  gui.addTab("serialMonitor");
  gui.getTab("serialMonitor")
      .setWidth(TAB_WIDTH)
      .setHeight(TAB_HEIGHT)
      .activateEvent(true)
      .setLabel("Serial monitor")
      .setId(4)
      .getCaptionLabel()
      .setFont(createFont("", 15))
      ;
  //
  //End of tab section
  //
  Group window1 = gui.addGroup("window1");
  //
  //Global items section
  //
  targetList = gui.addListBox("targetList")
      .setPosition(50, 50)
      .setSize(100, 100)
      .setLabel("Target List")
      .setGroup(window1)
      ;
  setTargetList(targetList);
  
  dutySpringL = gui.addSlider("dutySpringL")
      .setBroadcast(false)
      .setRange(0, 255)//range
      .setValue(50)//initial value
      .setPosition(50, 150)
      .setSize(SLIDER_WIDTH, SLIDER_HEIGHT)
      .setLabel("Duty of Spring L")
      .setNumberOfTickMarks(52)
      .setGroup(window1)
      .setBroadcast(true)
      ;
  dutySpringR = gui.addSlider("dutySpringR")
      .setBroadcast(false)
      .setRange(0, 255)//range
      .setValue(50)//initial value
      .setPosition(50, 200)
      .setSize(SLIDER_WIDTH, SLIDER_HEIGHT)
      .setLabel("Duty of Spring R")
      .setNumberOfTickMarks(52)
      .setGroup(window1)
      .setBroadcast(true)
      ;
  dutySpringB = gui.addSlider("dutySpringB")
      .setBroadcast(false)
      .setRange(0, 255)//range
      .setValue(50)//initial value
      .setPosition(50, 250)
      .setSize(SLIDER_WIDTH, SLIDER_HEIGHT)
      .setLabel("Duty of Spring B")
      .setNumberOfTickMarks(52)
      .setGroup(window1)
      .setBroadcast(true)
      ;
   gui.addTextarea("press1")
       .setPosition(50, 300)
       .setSize(TEXT_WIDTH, TEXT_HEIGHT)
       .setText("Press 1: activate spring L")
       .hideScrollbar()
       .setFont(createFont("", 13))
       ;
   gui.addTextarea("press2")
       .setPosition(50, 320)
       .setSize(TEXT_WIDTH, TEXT_HEIGHT)
       .setText("Press 2: deactivate spring L")
       .hideScrollbar()
       .setFont(createFont("", 13))
       ;
   gui.addTextarea("press3")
       .setPosition(50, 340)
       .setSize(TEXT_WIDTH, TEXT_HEIGHT)
       .setText("Press 3: activate spring R")
       .hideScrollbar()
       .setFont(createFont("", 13))
       ;
   gui.addTextarea("press4")
       .setPosition(50, 360)
       .setSize(TEXT_WIDTH, TEXT_HEIGHT)
       .setText("Press 4: deactivate spring R")
       .hideScrollbar()
       .setFont(createFont("", 13))
       ;
   gui.addTextarea("press5")
       .setPosition(50, 380)
       .setSize(TEXT_WIDTH, TEXT_HEIGHT)
       .setText("Press 5: activate spring B")
       .hideScrollbar()
       .setFont(createFont("", 13))
       ;
   gui.addTextarea("press6")
       .setPosition(50, 400)
       .setSize(TEXT_WIDTH, TEXT_HEIGHT)
       .setText("Press 6: deactivate spring B")
       .hideScrollbar()
       .setFont(createFont("", 13))
       ;
   gui.addTextarea("press7")
       .setPosition(50, 420)
       .setSize(TEXT_WIDTH, TEXT_HEIGHT)
       .setText("Press 7: activate spring L and R")
       .hideScrollbar()
       .setFont(createFont("", 13))
       ;
   gui.addTextarea("press8")
       .setPosition(50, 440)
       .setSize(TEXT_WIDTH, TEXT_HEIGHT)
       .setText("Press 8: deactivate spring L and R")
       .hideScrollbar()
       .setFont(createFont("", 13))
       ;
   gui.addTextarea("press9")
       .setPosition(50, 460)
       .setSize(TEXT_WIDTH, TEXT_HEIGHT)
       .setText("Press 9: activate spring L and B")
       .hideScrollbar()
       .setFont(createFont("", 13))
       ;
   gui.addTextarea("press10")
       .setPosition(50, 480)
       .setSize(TEXT_WIDTH, TEXT_HEIGHT)
       .setText("Press 0: deactivate spring L and B")
       .hideScrollbar()
       .setFont(createFont("", 13))
       ;
   gui.addTextarea("press11")
       .setPosition(50, 500)
       .setSize(TEXT_WIDTH, TEXT_HEIGHT)
       .setText("Press -: activate spring R and B")
       .hideScrollbar()
       .setFont(createFont("", 13))
       ;
   gui.addTextarea("press12")
       .setPosition(50, 520)
       .setSize(TEXT_WIDTH, TEXT_HEIGHT)
       .setText("Press =: deactivate spring R and B")
       .hideScrollbar()
       .setFont(createFont("", 13))
       ;
   //
   //End of global items section
   //
   //
   //Main controle tab section
   // 
  gui.addButton("turnRedLedOn")
      .setBroadcast(false)
      .setValue(0)
      .setPosition(400, 150)
      .setSize(BUTTON_WIDTH, BUTTON_HEIGHT)
      .setLabel("Turn red LED on")
      .setFont(createFont("", 10))
      .setGroup(window1)
      .setBroadcast(true)
      ; 
  gui.addButton("turnRedLedOff")
      .setBroadcast(false)
      .setValue(0)
      .setPosition(400, 200)
      .setSize(BUTTON_WIDTH, BUTTON_HEIGHT)
      .setLabel("Turn red LED off")
      .setFont(createFont("", 10))
      .setGroup(window1)
      .setBroadcast(true)
      ; 
  gui.addButton("crawlForward")
      .setBroadcast(false)
      .setValue(0)
      .setPosition(400, 250)
      .setSize(BUTTON_WIDTH, BUTTON_HEIGHT)
      .setLabel("Crawl forward preset")
      .setFont(createFont("", 10))
      .setGroup(window1)
      .setBroadcast(true)
      ;
  gui.addButton("crawlBackward")
      .setBroadcast(false)
      .setValue(0)
      .setPosition(400, 300)
      .setSize(BUTTON_WIDTH, BUTTON_HEIGHT)
      .setLabel("Crawl backward preset")
      .setFont(createFont("", 10))
      .setGroup(window1)
      .setBroadcast(true)
      ;    
  gui.addButton("measureForwardDistance")
      .setBroadcast(false)
      .setValue(0)
      .setPosition(600, 150)
      .setSize(BUTTON_WIDTH, BUTTON_HEIGHT)
      .setLabel("Measure forward distance")
      .setFont(createFont("", 10))
      .setGroup(window1)
      .setBroadcast(true)
      ;
  gui.addButton("measureBackwardDistance")
      .setBroadcast(false)
      .setValue(0)
      .setPosition(600, 200)
      .setSize(BUTTON_WIDTH, BUTTON_HEIGHT)
      .setLabel("Measure backward distance")
      .setFont(createFont("", 10))
      .setGroup(window1)
      .setBroadcast(true)
      ;   
  gui.addButton("setForwardOffset")
      .setBroadcast(false)
      .setValue(0)
      .setPosition(600, 250)
      .setSize(BUTTON_WIDTH, BUTTON_HEIGHT)
      .setLabel("Set forward offset")
      .setFont(createFont("", 10))
      .setGroup(window1)
      .setBroadcast(true)
      ;
  gui.addButton("setBackwardOffset")
      .setBroadcast(false)
      .setValue(0)
      .setPosition(600, 300)
      .setSize(BUTTON_WIDTH, BUTTON_HEIGHT)
      .setLabel("Set backward offset")
      .setFont(createFont("", 10))
      .setGroup(window1)
      .setBroadcast(true)
      ;
  forwardDistance = gui.addTextarea("forwardDistance")
       .setPosition(800, 150)
       .setSize(BUTTON_WIDTH, BUTTON_HEIGHT)
       .setText("Distance: " + "Not yet Measured")
       .hideScrollbar()
       .setFont(createFont("arial", 13))
       ;
  backwardDistance = gui.addTextarea("backwardDistance")
       .setPosition(800, 200)
       .setSize(BUTTON_WIDTH, BUTTON_HEIGHT)
       .setText("Distance: " + "Not yet Measured")
       .hideScrollbar()
       .setFont(createFont("arial", 13))
       ;
  forwardOffset = gui.addTextarea("forwardOffset")
       .setPosition(800, 250)
       .setSize(BUTTON_WIDTH, BUTTON_HEIGHT)
       .setText("Offset : " + "Initial value")
       .hideScrollbar()
       .setFont(createFont("arial", 13))
       ;
  backwardOffset = gui.addTextarea("backwardOffset")
       .setPosition(800, 300)
       .setSize(BUTTON_WIDTH, BUTTON_HEIGHT)
       .setText("Offset : " + "Initial value")
       .hideScrollbar()
       .setFont(createFont("arial",13))
       ;
  gui.addTextfield("pushingThreshold")
     .setPosition(400, 500)
     .setSize(100,40)
     .setLabel("Pushig Threshold(cm)")
     .setText("10")
     .setFocus(true)
     .setFont(createFont("", 10))
     ;
  gui.addButton("startPushingExperiment")
      .setBroadcast(false)
      .setValue(0)
      .setPosition(600, 500)
      .setSize(BUTTON_WIDTH, BUTTON_HEIGHT)
      .setLabel("Start Pushing Experiment")
      .setFont(createFont("", 10))
      .setGroup(window1)
      .setBroadcast(true)
      ; 
  //
  //End of Main control Tab section
  //
  //
  //Manually locomotion tab section
  //
  String[] smas1 = {
    "TorsionalR",
    "SpringB",
    "TorsionalR",
    "SpringB",
    "TorsionalL",
    "SpringL",
    "SpringR",
    "TorsionalL"
  };
  String[] duty1 = {
    "4",
    "33",
    "0",
    "0",
    "4",
    "29",
    "13",
    "0"
  };
  String[] delay1 = {
    "50",
    "10",
    "25",
    "30",
    "50",
    "0",
    "10",
    "25"
  };
  int Xposition = 400;
  int Yposition = 130;
  for(int i=0;i<8;i++) {
    if(i == 5) {
      Xposition = -200;
      Yposition = 220;
    }
    gui.addTextarea("sma1"+(i+1))
      .setPosition(Xposition+i*120, Yposition)
      .setSize(100, 20)
      .setText(smas1[i])
      .hideScrollbar()
      .setFont(createFont("", 10))
      ;
    gui.addTextfield("duty1"+(i+1))
        .setBroadcast(false)
       .setPosition(Xposition+i*120, Yposition+20)
       .setSize(40,30)
       .setLabel("Duty")
       .setText(duty1[i])
       .setFocus(true)
       .setFont(createFont("", 9))
       ;
    gui.addTextfield("delay1"+(i+1))
        .setBroadcast(false)
       .setPosition(Xposition+50+i*120, Yposition+20)
       .setSize(40,30)
       .setLabel("Delay(100ms)")
       .setText(delay1[i])
       .setFocus(true)
       .setFont(createFont("", 9))
       ;
  }
  gui.addButton("crawlForwardManually")
      .setBroadcast(false)
      .setValue(0)
      .setPosition(800, 250)
      .setSize(BUTTON_WIDTH, BUTTON_HEIGHT)
      .setLabel("Crawl forward")
      .setFont(createFont("", 10))
      .setGroup(window1)
      .setBroadcast(true)
      ;
  String[] smas2 = {
    "TorsionalL",
    "SpringB",
    "TorsionalL",
    "SpringB",
    "TorsionalR",
    "SpringL",
    "SpringR",
    "TorsionalR"
  };
  String[] duty2 = {
    "4",
    "33",
    "0",
    "0",
    "4",
    "29",
    "13",
    "0"
  };
  String[] delay2 = {
    "50",
    "10",
    "25",
    "30",
    "50",
    "0",
    "10",
    "25"
  };
  Xposition = 400;
  Yposition = 380;
  for(int i=0;i<8;i++) {
    if(i == 5) {
      Xposition = -200;
      Yposition = 470;
    }
    gui.addTextarea("sma2"+(i+1))
      .setPosition(Xposition+i*120, Yposition)
      .setSize(100, 20)
      .setText(smas2[i])
      .hideScrollbar()
      .setFont(createFont("", 10))
      ;
    gui.addTextfield("duty2"+(i+1))
        .setBroadcast(false)
       .setPosition(Xposition+i*120, Yposition+20)
       .setSize(40,30)
       .setLabel("Duty")
       .setText(duty2[i])
       .setFocus(true)
       .setFont(createFont("", 9))
       ;
    gui.addTextfield("delay2"+(i+1))
        .setBroadcast(false)
       .setPosition(Xposition+50+i*120, Yposition+20)
       .setSize(40,30)
       .setLabel("Delay(100ms)")
       .setText(delay2[i])
       .setFocus(true)
       .setFont(createFont("", 9))
       ;
  }
  gui.addButton("crawlBackwardManually")
      .setBroadcast(false)
      .setValue(0)
      .setPosition(800, 500)
      .setSize(BUTTON_WIDTH, BUTTON_HEIGHT)
      .setLabel("Crawl backward")
      .setFont(createFont("", 10))
      .setGroup(window1)
      .setBroadcast(true)
      ;
  //
  //End of manually locomotion tab section
  //
  //
  //Sensor calibration tab section
  //
  gui.addTextfield("averageTimes")
       .setBroadcast(false)
       .setPosition(400, 150)
       .setSize(40,30)
       .setLabel("Average times")
       .setText("100")
       .setFocus(true)
       .setFont(createFont("", 9))
       ;
  gui.addButton("foreSensorCalibration")
      .setBroadcast(false)
      .setValue(0)
      .setPosition(500, 150)
      .setSize(BUTTON_WIDTH, BUTTON_HEIGHT)
      .setLabel("Fore sensor")
      .setFont(createFont("", 10))
      .setGroup(window1)
      .setBroadcast(true)
      ;
  gui.addButton("backSensorCalibration")
      .setBroadcast(false)
      .setValue(0)
      .setPosition(500, 200)
      .setSize(BUTTON_WIDTH, BUTTON_HEIGHT)
      .setLabel("Back sensor")
      .setFont(createFont("", 10))
      .setGroup(window1)
      .setBroadcast(true)
      ;
  gui.addTextarea("averagedForwardOffset")
      .setPosition(700, 150)
      .setSize(300, 20)
      .setText("Averaged offset")
      .hideScrollbar()
      .setFont(createFont("", 13))
      ;
  gui.addTextarea("averagedBackwardOffset")
      .setPosition(700, 200)
      .setSize(300, 20)
      .setText("Averaged offset")
      .hideScrollbar()
      .setFont(createFont("", 13))
      ;
  //
  //End of sensor calibration tab section
  //
  //
  //Cosole tab section
  //
  monitorTextarea = gui.addTextarea("serialText")
      .setPosition(400, 150)
      .setSize(500, 400)
      .setColor(color(200))
      .setColorBackground(color(0,255))
      .setColorForeground(color(0,255))
      .setText("")
      .setFont(createFont("", 12))
      ;
  //
  //End of console tab section
  //
  //
  // arrange controller in separate tabs
  //
  gui.getController("targetList").moveTo("global");
  gui.getController("dutySpringL").moveTo("global");
  gui.getController("dutySpringR").moveTo("global");
  gui.getController("dutySpringB").moveTo("global");
  gui.getGroup("press1").moveTo("global");
  gui.getGroup("press2").moveTo("global");
  gui.getGroup("press3").moveTo("global");
  gui.getGroup("press4").moveTo("global");
  gui.getGroup("press5").moveTo("global");
  gui.getGroup("press6").moveTo("global");
  gui.getGroup("press7").moveTo("global");
  gui.getGroup("press8").moveTo("global");
  gui.getGroup("press9").moveTo("global");
  gui.getGroup("press10").moveTo("global");
  gui.getGroup("press11").moveTo("global");
  gui.getGroup("press12").moveTo("global");
  
  gui.getController("turnRedLedOn").moveTo("default");
  gui.getController("turnRedLedOff").moveTo("default");
  gui.getController("crawlForward").moveTo("default");
  gui.getController("crawlBackward").moveTo("default");
  gui.getController("measureForwardDistance").moveTo("default");
  gui.getController("measureBackwardDistance").moveTo("default");
  gui.getController("setForwardOffset").moveTo("default");
  gui.getController("setBackwardOffset").moveTo("default");
  gui.getController("startPushingExperiment").moveTo("default");
  gui.getController("pushingThreshold").moveTo("default");
  gui.getGroup("forwardDistance").moveTo("default");
  gui.getGroup("backwardDistance").moveTo("default");
  gui.getGroup("forwardOffset").moveTo("default");
  gui.getGroup("backwardOffset").moveTo("default");
  
  for(int i=0;i<8;i++) {
    gui.getController("duty1"+(i+1)).moveTo("manuallyLocomotion");
    gui.getController("delay1"+(i+1)).moveTo("manuallyLocomotion");
    gui.getGroup("sma1"+String.valueOf(i+1)).moveTo("manuallyLocomotion");
    gui.getController("duty2"+(i+1)).moveTo("manuallyLocomotion");
    gui.getController("delay2"+(i+1)).moveTo("manuallyLocomotion");
    gui.getGroup("sma2"+String.valueOf(i+1)).moveTo("manuallyLocomotion");
  }
  gui.getController("crawlForwardManually").moveTo("manuallyLocomotion");
  gui.getController("crawlBackwardManually").moveTo("manuallyLocomotion");
  
  gui.getController("averageTimes").moveTo("sensorCalibration");
  gui.getController("foreSensorCalibration").moveTo("sensorCalibration");
  gui.getController("backSensorCalibration").moveTo("sensorCalibration");
  gui.getGroup("averagedForwardOffset").moveTo("sensorCalibration");
  gui.getGroup("averagedBackwardOffset").moveTo("sensorCalibration");
  
  gui.getGroup("serialText").moveTo("serialMonitor");
  // Tab 'global' is a tab that lies on top of any 
  // other tab and is always visible
  
}
void setTargetList(ListBox lb) {
  // a convenience function to customize a ListBox
  lb.setBackgroundColor(color(190));
  lb.setItemHeight(20);
  lb.setBarHeight(15);

  lb.addItem("ID 001", "001");
  lb.addItem("ID 002", "002");
  lb.addItem("ID 003", "003");
  lb.addItem("ID 004", "004");
  lb.addItem("ID 005", "005");
  lb.addItem("Leader", "101");
  lb.addItem("Pushing Robot", "103");
  lb.addItem("Measuring Robot", "102");
  lb.addItem("All", "105");
  lb.setColorBackground(color(60));
  lb.setColorActive(color(255, 128));
  
  Map<String, Object> item = lb.getItem(0);
  targetNum = item.get("value").toString();
}