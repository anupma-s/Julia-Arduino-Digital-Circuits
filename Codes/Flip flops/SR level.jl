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

pinMode(ser,sPin,"INPUT")
pinMode(ser,rPin,"INPUT")
pinMode(ser,clockPin,"INPUT")

pinMode(ser,qPin,"OUTPUT")
pinMode(ser,qbarPin,"OUTPUT")


for i=1:200

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

  s=digiRead(ser,sPin) #Reads the input S
  r=digiRead(ser,rPin) #Reads the input R

  cl=digiRead(ser,clockPin) #Reads clockPin
print("$cl $s $r")
  if cl==1 #if clockPin is high

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

end
close(ser)
