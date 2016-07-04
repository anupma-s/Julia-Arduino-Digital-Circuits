using SerialPorts
using ArduinoTools

ser = connectBoard(115200) #detects the serial port to which arduino is connected

pinstate=0
lastpinstate=0

D2=0 #serial data input to FF2 (MSB FF)
D1=0 #D1=Q2, output of FF2=input of FF1 (middle bit FF)
D0=0 #D0=Q1, output of FF1=input of FF0 (LSB FF)

Q=0 #serial data out, output of FF0

#Serial input
inPin=5

#Serial output
outPin=9

#external clock pulse
clockPin=2



pinMode(ser,clockPin,"INPUT")
pinMode(ser,inPin,"INPUT")

pinMode(ser,outPin,"OUTPUT")

for j=1:500

  if D0==0
    digiWrite(ser,outPin,0)
    sleep(0.05)
  else
    digiWrite(ser,outPin,1)
    sleep(0.05)
  end

  pinstate=digiRead(ser,clockPin) #reads the state of clock

  #clock is common for all FFs
  #thus only 1 if statement for detecting positive edge of clock

  if pinstate!=lastpinstate
      if pinstate==1 #positive edge

          #order of FFs: FF2-FF1-FF0-serial output

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

          D2=digiRead(ser,inPin) #input is given to D of FF2 (MSB FF)
        end
        sleep(0.05)
      end
      lastpinstate=pinstate



end
close(ser)
