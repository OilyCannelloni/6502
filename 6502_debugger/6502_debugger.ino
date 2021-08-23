/* Debugger for 6502-based computer
 * Connections:
 * Clock - pin 2
 * Reset - pin 3
 * Read/Write - pin 4
 * A0-A7 - Port B of expander on address 0x20
 * A8-A15 - Port A of expander on address 0x20
 * D0-D7 - Port B of expander on address 0x21
 * 6522 Interface Adapter - Port A of expander on address 0x21
 */

#include <Wire.h>

#define RX 1
#define TX 0

#define CLK 2
#define RST 3
#define RWB 4

#define EXP1 0x20
#define EXP2 0x21
#define IODIRA 0x00
#define IODIRB 0x01
#define GPIOA 0x12
#define GPIOB 0x13
#define GPPUA 0x0c
#define GPPUB 0x0d


void setRegister(byte board, byte reg, byte data){
  /* Transmits data via I2C
   *  Board - slave address
   *  Reg - target register
   *  Data - value to be sent
   */
  Wire.beginTransmission(board);
  Wire.write(reg);
  Wire.write(data);
  Wire.endTransmission();
}


byte readRegister(byte board, byte reg){
  /* Reads data from I2C
   * Board - slave address
   * Reg - target register
   */
  Wire.beginTransmission(board);
  Wire.write(reg);
  Wire.requestFrom((int) board, 1);
  byte res = (byte) Wire.read();
  Wire.endTransmission();
  return res;
}


void onClock(){
  /* 
   *  Reads data from both expanders and prints it to Serial 
   */
  byte addrMS = readRegister(EXP1, GPIOA);
  byte addrLS = readRegister(EXP1, GPIOB);
  byte data = readRegister(EXP2, GPIOB);
  byte VIA = readRegister(EXP2, GPIOA);
  int rwb = digitalRead(RWB);

  char buf[30] = {0};
  sprintf(buf, "%02x%02x  %c %02x  VIA_B=%02x", addrMS, addrLS, rwb==HIGH?'r':'w', data, VIA);
  Serial.print(buf);
  Serial.println();
}


void onReset(){
  Serial.print("---------- RESET ----------");
  Serial.println();
}


void setup()
{
 Serial.begin(9600);
 Wire.begin();
 Serial.print("Serial initialized.");
 Serial.println();
 
 setRegister(EXP1, IODIRA, 0xFF);
 setRegister(EXP1, IODIRB, 0xFF);
 setRegister(EXP2, IODIRA, 0xFF);
 setRegister(EXP2, IODIRB, 0xFF);

 pinMode(CLK, INPUT);
 pinMode(RST, INPUT);
 pinMode(RWB, INPUT);
}

int old_clk = LOW;
int old_rst = LOW;

void loop(){   
  int rst = digitalRead(RST);
  if (rst == LOW && old_rst == HIGH) {
    onReset();
  }
  old_rst = rst;
  
  int clk = digitalRead(CLK);
  if (clk == HIGH && old_clk == LOW) {
      onClock();
  }
  old_clk = clk;
  delay(50);
}
