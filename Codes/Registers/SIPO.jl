#3 bit SIPO shift register using D FFs
#input by user is given to FF2 (MSB FF).
#It then shifts rightwards serially and is eventually lost through
#FF0 (LSB FF) after 3 clock pulses
#outputs of all FFs (all bits) are obtained at all instances

using SerialPorts

using ArduinoTools

#ser = connectBoard(115200) #detects the serial port to which arduino is connected
ser=connectBoard(115200)

pinstate=0
lastpinstate=0

D2=0 #serial data input, input by user is given to FF2 (MSB FF)
                #output of FF2=input of FF1
D1=0 #D1=Q2, FF1 (middle bit FF), output of FF1=input of FF0
D0=0 #D0=Q1, FF0 (LSB FF), output of FF0 = Q0

Q=0 #serial data out, output of FF0

#Serial input
inPin=5

#Parallel output
outPin1=9 #LSB = Q
outPin2=10 #middle bit
outPin3=11 #MSB

#external clock pulse
clockPin=2

pinMode(ser,clockPin,"INPUT")
pinMode(ser,inPin,"INPUT")

pinMode(ser,outPin1,"OUTPUT")
pinMode(ser,outPin2,"OUTPUT")
pinMode(ser,outPin3,"OUTPUT")

for j=1:500

  #pin 9=Q=LSB
  if D0==0
    digiWrite(ser,outPin1,0)
    sleep(0.05)
  else
    digiWrite(ser,outPin1,1)
    sleep(0.05)
  end

  #pin 10=Q1=D0=middle bit
  if D1==0
    digiWrite(ser,outPin2,0)
    sleep(0.05)
  else
    digiWrite(ser,outPin2,1)
    sleep(0.05)
  end

  #pin 11=Q2=D1=MSB
  if D2==0
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
