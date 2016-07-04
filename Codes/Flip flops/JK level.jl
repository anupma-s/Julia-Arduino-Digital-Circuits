using SerialPorts
using ArduinoTools

ser = connectBoard(115200) #detects the serial port to which arduino is connected

jPin=5 #Input J is given to Pin 5
kPin=6 #Input K is given to Pin 6
prePin=3 #Input Preset
clrPin=4 #Input clear

#assuming initial state:
Q=0
Qbar=1

qPin=9
qbarPin=10

clockPin=2 #external clock

pinMode(ser,jPin,"INPUT")
pinMode(ser,kPin,"INPUT")
pinMode(ser,prePin,"INPUT")
pinMode(ser,clrPin,"INPUT")
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

  pre=digiRead(ser,prePin) #Reads preset input
  clr=digiRead(ser,clrPin) #Reads clear input

  if pre==0 && clr==1
    Q=1
    Qbar=0
  elseif pre==1 && clr==0
    Q=0
    Qbar=1
  #Preset and clear are active low inputs, thus normal functioning of flip flop happens when both are HIGH
  elseif pre==1 && clr==1

    cl=digiRead(ser,clockPin)
    if cl==1 #positive level
      j=digiRead(ser,jPin)
      k=digiRead(ser,kPin)

      if j==0 && k==1
        Q=0
        Qbar=1
      elseif j==1 && k==0
          Q=1
          Qbar=0
      elseif j==1 && k==1 #Toggle
          temp=Q
          Q=Qbar
          Qbar=temp
      end
    end
  end
end
close(ser)
