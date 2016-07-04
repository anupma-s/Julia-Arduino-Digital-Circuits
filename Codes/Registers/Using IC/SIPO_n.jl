using SerialPorts
using ArduinoTools

ser = connectBoard(115200)
#ser=SerialPorts.SerialPort("COM2",115200) #detects the serial port to which arduino is connected
#sleep(2)

pinstate=0

#No. of bits
print("Enter no. of bits: ")
n=parse(Int,input())

data=zeros(n) #a 1x8 array representing an 8 bit binary number

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

  if pinstate==1
    data[1]=1
    #the msb becomes 1 when input is given
    #high which is henceforth shifted
  else
    data[1]=0
  end
  print(data)

  digiWrite(ser,latchPin,0)
  shiftOutn(dataPin,clockPin,"LSBFIRST",data,n)
  digiWrite(ser,latchPin,1)
  sleep(0.5)

  for k=1:(n-1)
    data[n+1-k]=data[n-k]
  end
  data[1]=0
  #every element of the matrix is
  #shifted one place to the right
  #so effectively the 8 bit
  #binary number is divided by 2
end
close(ser)
