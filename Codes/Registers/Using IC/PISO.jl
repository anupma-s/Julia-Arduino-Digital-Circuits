using SerialPorts
using ArduinoTools

ser = connectBoard(115200) #detects the serial port to which arduino is connecte

dataPin=9
clockPin=10
latchPin=11

ledPin=5 #LED that shows serial output
clockLed=6 #LED that shows clock pulses

pinMode(ser,dataPin,"INPUT")
pinMode(ser,clockPin,"OUTPUT")
pinMode(ser,latchPin,"OUTPUT")
pinMode(ser,ledPin,"OUTPUT")
pinMode(ser,clockLed,"OUTPUT")

digiWrite(ser,latchPin,1) #parallel load mode

for i=1:50
  print("Give input, Parallel load mode: ")
  sleep(2)
  digiWrite(ser,clockPin,1)#positive edge occurs
                         #parallel load is stored
  print("Inputs stored, Serial shift mode: ")
  sleep(0.5)

  digiWrite(ser,clockPin,0)
  digiWrite(ser,latchPin,0) #serial out mode
  shiftIn(dataPin,clockPin,ledPin,clockLed)
  digiWrite(ser,latchPin,1)
  digiWrite(ser,ledPin,0)
end
close(ser)
