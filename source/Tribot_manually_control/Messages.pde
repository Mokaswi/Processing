public enum Messages {
  CHANGE_TARGET_ID("changetargetid"),
  CHANGE_DUTY("changeduty"),
  
  AHEAD_FORWARD("aheadforward"),
  AHEAD_BACKWARD("aheadbackward"),
  DONE_TASK("donetask"),
  CHANGE_ROLE("changerole"),
  ACK("ack"),
  
  LED_G_ON("ledgon"),
  LED_G_OFF("ledgoff"),
  LED_R_ON("ledron"),
  LED_R_OFF("ledroff"),
  SPRING_L_ON("springlon"),
  SPRING_L_OFF("springloff"),
  SPRING_R_ON("springron"),
  SPRING_R_OFF("springroff"),
  SPRING_B_ON("springbon"),
  SPRING_B_OFF("springboff"),
  OMEGA_L_ON("omegalon"),
  OMEGA_L_OFF("omegaloff"),
  OMEGA_R_ON("omegaron"),
  OMEGA_R_OFF("omegaroff"),
  WRITE_ONE_PIN("writeonepin"),
  WRITE_TWO_PINS("writetwopin"), 
  
  GET_DISTANCE_FORWARD("getdistanceforward"),
  GET_DISTANCE_BACKWARD("getdistancebackward"),
  GET_OFFSET_FORE_SENSOR("getoffsetforesensor"),
  GET_OFFSET_BACK_SENSOR("getoffsetbacksensor"),
  SET_OFFSET_FORE_SENSOR("setoffsetforesensor"),
  SET_OFFSET_BACK_SENSOR("setoffsetbacksensor"),
  SCAN_FORWARD("scanforward"),
  SCAN_BACKWARD("scanbackward"),
  RECEIVE_DISTANCE("receivedistance"),
  RECEIVE_OFFSET1("receiveoffset1"),
  RECEIVE_OFFSET2("receiveoffset2"),
  SET_NEUTRAL("setneutral"),
  
  CRAWL_FORWARD_AUTO("crawlforwardauto"),
  CRAWL_FORWARD_MANUAL("crawlforwardmanual"),
  CRAWL_BACKWARD_AUTO("crawlbackwardauto"),
  CRAWL_BACKWARD_MANUAL("crawlbackwardmanual"),
  
  VERTICAL_JUMP_AUTO("verticaljumpauto"),
  VERTICAL_JUMP1_MANUAL("verticaljump1manual"),
  VERTICAL_JUMP2_MANUAL("verticaljump2manual"),
  JUMP_FORWARD_AUTO("jumpforwardauto"),
  JUMP_FORWARD_MANUAL("jumpforwardmanual"),
  JUMP_BACKWARD_AUTO("jumpbackwardauto"),
  JUMP_BACKWARD_MANUAL("jumpbackwardmanual"),
  
  ROLL_FORWARD1_AUTO("rollforward1auto"),
  ROLL_FORWARD1_MANUAL("rollforward1manual"),
  ROLL_BACKWARD_AUTO("rollbackwardauto"),
  ROLL_BACKWARD_MANUAL("rollbackwardmanual"),
  
  FOLLOW("follow"),
  ESCAPE("escape"),
  PUSH("push"),
  STOP("stop"),
  
  CHECK_DISTANCE("checkdistance"),
  FINISH_DISTANCE("finishdistance");
  
  private String command;
  private Messages(String command) {
    this.command = command;
  }
  public String getCommand(){
    return this.command;
  }
}