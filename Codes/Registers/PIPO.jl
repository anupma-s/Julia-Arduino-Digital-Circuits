#3 bit SIPO shift register using D FFs
#input by user is given to FF2 (MSB FF).
#It then shifts rightwards serially and is eventually lost through
#FF0 (LSB FF) after 3 clock pulses
#outputs of all FFs (all bits) are obtained at all instances

using SerialPorts
using ArduinoTools

ser = connectBoard(115200) #detects the serial port to which arduino is connected
#ser=SerialPorts.SerialPort("COM2",115200)
#sleep(2)

pinstate=0
lastpinstate=0

D2=0 #MSB input
D1=0 #middle bit input=MSB output
D0=0 #LSB input=middle bit output
Q=0 #LSB output

#Parallel inputs
inPin1=5 #LSB input
inPin2=6 #middle bit
inPin3=7 #MSB

#Parallel output
outPin1=9 #LSB = Q
outPin2=10 #middle bit = D0
outPin3=11 #MSB = D1

#external clock pulse
clockPin=2

pinMode(ser,clockPin,"INPUT")
pinMode(ser,inPin1,"INPUT")
pinMode(ser,inPin2,"INPUT")
pinMode(ser,inPin3,"INPUT")

pinMode(ser,outPin1,"OUTPUT")
pinMode(ser,outPin2,"OUTPUT")
pinMode(ser,outPin3,"OUTPUT")

for j=1:500

  #pin 9=Q=LSB
  if Q==0
    digiWrite(ser,outPin1,0)
    sleep(0.05)
  else
    digiWrite(ser,outPin1,1)
    sleep(0.05)
  end

  #pin 10=Q1=D0=middle bit
  if D0==0
    digiWrite(ser,outPin2,0)
    sleep(0.05)
  else
    digiWrite(ser,outPin2,1)
    sleep(0.05)
  end

  #pin 11=Q2=D1=MSB
  if D1==0
    digiWrite(ser,outPin3,0)
    sleep(0.05)
  else
    digiWrite(ser,outPin3,1)
    sleep(0.05)
  end

  pinstate=digiRead(ser,clockPin) #reads the state of clock

  #clock is common for all FFs
  #thus only 1 if statement for detecting positive edge of clock

  if pinstate!=lastpinstate
      if pinstate==1 #positive edge

          #order of FFs: serial input-FF2-FF1-FF0

          D0=digiRead(ser,inPin1)
          D1=digiRead(ser,inPin2)
          D2=digiRead(ser,inPin3)

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
        end
        sleep(0.05)
      end
      lastpinstate=pinstate
end
close(ser)
