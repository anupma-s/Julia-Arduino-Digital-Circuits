using SerialPorts
using ArduinoTools

#ser = SerialPorts.SerialPort("COM2",115200)
#sleep(2) #detects the serial port to which arduino is connected

ser=connectBoard(115200) #detects the serial port to which arduino is connected

pinstate=0
lastpinstate=0

sl=0 #shift/!load

D2=0 #MSB input
D1=0 #middle bit input=MSB output
D0=0 #LSB input=middle bit output
Q=0 #LSB output

#Parallel inputs
inPin1=5 #LSB input
inPin2=6 #middle bit
inPin3=7 #MSB

#Serial output
outPin=9 #LSB = Q

#external clock pulse
clockPin=2

#Shift/!Load input
slPin=3

pinMode(ser,inPin1,"INPUT")
pinMode(ser,inPin2,"INPUT")
pinMode(ser,inPin3,"INPUT")
pinMode(ser,clockPin,"INPUT")
pinMode(ser,slPin,"INPUT")

pinMode(ser,outPin,"OUTPUT")

for i=1:500

#pin 9=Q=LSB output
  if D0==0
    digiWrite(ser,outPin,0)
    sleep(0.05)
  else
    digiWrite(ser,outPin,1)
    sleep(0.05)
  end

  #reads the state of Shift/!Load
  print("executed 1")
  sl=digiRead(ser,slPin)
  print(sl)
  print("executed 2")
  #reads the state of clock
  pinstate=digiRead(ser,clockPin)
  print(pinstate)
  print("executed 3")
  #clock is common for all FFs
  #thus only 1 if statement for detecting positive edge of clock

  if pinstate!=lastpinstate
    if pinstate==1 #positive edge

          #order of FFs: serial input-FF2-FF1-FF0

        if sl==0 #parallel load mode
          D0=digiRead(ser,inPin1)
          D1=digiRead(ser,inPin2)
          D2=digiRead(ser,inPin3)

        else #sl==1 i.e. serial shift mode
          #FF0 (LSB FF, i.e. third FF)
          if D0==0
            Q=0
          else
            Q=1
          end

          #FF1 (middle bit FF i.e. second FF)
          if D1==0
            D0=0
          else
            D0=1
          end

          #FF2 (MSB FF i.e first FF)
          if D2==0
            D1=0
          else
            D1=1
          end
          D2=0
        end

      end
      sleep(0.05)
    end
    lastpinstate=pinstate
end
close(ser)
