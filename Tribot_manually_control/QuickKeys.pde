public enum QuickKeys {
  SPRING_L_ON('1', "7", "dutySpringL"),
  SPRING_L_OFF('2', "7", "0"),
  SPRING_R_ON('3', "12", "dutySpringR"),
  SPRING_R_OFF('4', "12", "0"),
  SPRING_B_ON('5', "11", "dutySpringB"),
  SPRING_B_OFF('6', "11", "0"),
  SPRING_LandR_ON('7', "7", "dutySpringL", "12", "dutySpringR"),
  SPRING_LandR_OFF('8',"7", "0", "12", "0"),
  SPRING_LandB_ON('9', "7", "dutySpringL", "11", "dutySpringB"),
  SPRING_LandB_OFF('0', "7", "0", "11", "0"),
  SPRING_BandR_ON('-', "12", "dutySpringR", "11", "dutySpringB"),
  SPRING_BandR_OFF('=', "12", "0", "11", "0"),
  NOT_MATCH('\0', "");
  
  private char num;
  private String pins[];
  private QuickKeys(final char num, String... pins) {
    this.num = num;
    this.pins = pins; 
  }
  public char getNum() {
    return this.num;
  }
  public String[] getPins() {
    return this.pins;
  }
  public static QuickKeys valueOf(char num) {
    for (QuickKeys tmp: values()) {
      if(tmp.getNum() == num){
        return tmp;
      }
    }
    //throw new IllegalArgumentException("no such enum object for the key: " + num);
    return NOT_MATCH;
  }
}
  