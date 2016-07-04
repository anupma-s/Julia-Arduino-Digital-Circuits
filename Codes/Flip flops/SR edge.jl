using SerialPorts
using ArduinoTools

ser = connectBoard(115200) #detects the serial port to which arduino is connected
#s=0
#r=0
sPin=5 #Input S is given to Pin 5
rPin=6 #Input R is given to Pin 6

#assuming initial state:
Q=0
Qbar=1

qPin=9
qbarPin=10

clockPin=2 #external clock

pinstate=0
lastpinstate=0

pinMode(ser,sPin,"INPUT")
pinMode(ser,rPin,"INPUT")
pinMode(ser,clockPin,"INPUT")

pinMode(ser,qPin,"OUTPUT")
pinMode(ser,qbarPin,"OUTPUT")


for i=1:300

  if Q==0
    digiWrite(ser,qPin,0) #Gives low output at Q
  elseif Q==1
    digiWrite(ser,qPin,1) #Gives high output at Q
    sleep(0.1)
  end

  if Qbar==0
    digiWrite(ser,qbarPin,0) #Gives low output at Qbar
  elseif Qbar==1
    digiWrite(ser,qbarPin,1) #Gives high output at Qbar
    sleep(0.1)
  end

  pinstate=digiRead(ser,clockPin)

  if pinstate!=lastpinstate #edge detection
    if pinstate==0 #negative edge
      s=digiRead(ser,sPin) #Reads the input S
      r=digiRead(ser,rPin) #Reads the input R

      if s==0 && r==1
        Q=0
        Qbar=1
      elseif s==1 && r==0
        Q=1
        Qbar=0
      elseif s==1 && r==1 #we assume this case doesn't occur
        Q=0
        Qbar=0
      end
    end
    sleep(0.05)
  end
  lastpinstate=pinstate

end
close(ser)
