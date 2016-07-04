using SerialPorts
using ArduinoTools

ser = connectBoard(115200) #detects the serial port to which arduino is connected

pinstate=0
data=zeros(8) #a 1x8 array representing an 8 bit binary number

dataPin=11
clockPin=9
latchPin=10
inPin=5

pinMode(ser,dataPin,"OUTPUT")
pinMode(ser,clockPin,"OUTPUT")
pinMode(ser,latchPin,"OUTPUT")
pinMode(ser,inPin,"INPUT")

for i=1:100

  digiWrite(ser,latchPin,0) #So that the data is stored and not passed on to the output LEDs
  print("Give Input:")
  sleep(0.25)
  shiftOut_(dataPin,clockPin,inPin)
  digiWrite(ser,latchPin,1) #So that the stored data is now passed on to the output LEDs
                                                            #and the output is obtained
  sleep(0.25)
end
close(ser)
