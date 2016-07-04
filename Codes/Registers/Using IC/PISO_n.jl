using SerialPorts
#require("ArduinoTools.jl")
using ArduinoTools

#ser = SerialPorts.SerialPort("COM2",115200) #detects the serial port to which arduino is connected
#sleep(2)

ser=connectBoard(115200)

dataPin=9
clockPin=10
latchPin=11

ledPin=5 #LED that shows serial output
clockLed=6 #LED that shows clock pulses

#No. of times parallel load is to be given
print("Enter no. of times parallel load is to be given: ")
p=parse(Int,input())

#No. of bits
print("Enter no. of bits: ")
n=parse(Int,input())

println("No. of times parallel load is given= $p")
println("No. of bits= $n")


pinMode(ser,dataPin,"INPUT")
pinMode(ser,clockPin,"OUTPUT")
pinMode(ser,latchPin,"OUTPUT")
pinMode(ser,ledPin,"OUTPUT")
pinMode(ser,clockLed,"OUTPUT")

digiWrite(ser,latchPin,1) #parallel load mode

for i=1:p
  print("Give input, Parallel load mode: ")
  sleep(2)
  digiWrite(ser,clockPin,1)#positive edge occurs
                         #parallel load is stored
  print("Inputs stored, Serial shift mode: ")
  sleep(0.5)

  digiWrite(ser,clockPin,0)
  digiWrite(ser,latchPin,0) #serial out mode
  shiftInn(dataPin,clockPin,ledPin,clockLed,n)
  digiWrite(ser,latchPin,1)
  digiWrite(ser,ledPin,0)
end
close(ser)
