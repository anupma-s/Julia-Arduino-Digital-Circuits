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
s=0
r=1

qPin=9
qbarPin=10

clockPin=2 #external clock

pinstate=0
lastpinstate=0

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
    s=1
    r=0
    Q=1
  elseif pre==1 && clr==0
    s=0
    r=1
    Q=0
  #Normal functioning when both are HIGH
  elseif pre==1 && clr==1

    pinstate=digiRead(ser,clockPin)

    if pinstate!=lastpinstate #edge detection
      if pinstate==1 #positive edge

        #MASTER
        #JK FF Code
        j=digiRead(ser,jPin)
        k=digiRead(ser,kPin)

        if j==0 && k==1
          s=0
          r=1
        elseif j==1 && k==0
          s=1
          r=0
        elseif j==1 && k==1 #Toggle
          temp=s
          s=r
          r=temp
        end
      end

      if pinstate==0 #negative edge

        #SLAVE
        #JK FF code only for state 01 and 10
        if s==0 && r==1
          Q=0
        elseif s==1 && r==0
          Q=1
        end
      end
      sleep(0.05)
    end
    lastpinstate=pinstate
  end

end

close(ser)
