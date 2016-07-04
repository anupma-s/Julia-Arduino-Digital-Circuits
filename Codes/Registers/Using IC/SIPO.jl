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

  pinstate=digiRead(ser,inPin)
  println("Input stored")
  sleep(0.75)


  if pinstate==1
    data[1]=1
    #the msb becomes 1 when input is given
    #high which is henceforth shifted
  else
    data[1]=0
  end
  println(data)

  digiWrite(ser,latchPin,0)
  shiftOut(dataPin,clockPin,"LSBFIRST",data)
  digiWrite(ser,latchPin,1)
  println("Give serial input:")
  sleep(0.75)

  for k=1:7
    data[9-k]=data[8-k]
  end
  data[1]=0
  #every element of the matrix is
  #shifted one place to the right
  #so effectively the 8 bit
  #binary number is divided by 2

end
close(ser)
