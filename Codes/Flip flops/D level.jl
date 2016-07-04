using SerialPorts
using ArduinoTools

ser = connectBoard(115200) #detects the serial port to which arduino is connected

dPin=5 #Input D is given to Pin 5

#assuming initial state:
Q=0
Qbar=1

qPin=9
qbarPin=10

clockPin=2 #external clock

pinMode(ser,dPin,"INPUT")
pinMode(ser,clockPin,"INPUT")

pinMode(ser,qPin,"OUTPUT")
pinMode(ser,qbarPin,"OUTPUT")


for i=1:300

  if Q==0
    digiWrite(ser,qPin,0) #Gives low output at Q
    digiWrite(ser,qbarPin,1) #Gives high output at Qbar
    sleep(0.1)
  else
    digiWrite(ser,qPin,1) #Gives high output at Q
    digiWrite(ser,qbarPin,0) #Gives low output at Qbar
    sleep(0.1)
  end

  cl=digiRead(ser,clockPin) #Reads clock

  if cl==1 #Positive level of clock
    d=digiRead(ser,dPin)

    if d==0
      Q=0
    else
      Q=1
    end
  end
end
close(ser)
