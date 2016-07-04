using SerialPorts
using ArduinoTools

ser = connectBoard(115200) #detects the serial port to which arduino is connected

pinstate0=0 #input, clock pulse to FF1
lastpinstate0=0

pinstate1=0 #output of FF1 (LSB), clock pulse to FF2
lastpinstate1=0

pinstate2=0 #output of FF2 (middle bit)), clock pulse to FF3
lastpinstate2=0

pinstate3=0 #output of FF3 (MSB)
lastpinstate3=0

#Outputs
Pin1=9 #LSB
Pin2=10 #middle bit
Pin3=11 #MSB

clockPin=2 #external clock

pinMode(ser,clockPin,"INPUT")

pinMode(ser,Pin1,"OUTPUT")
pinMode(ser,Pin2,"OUTPUT")
pinMode(ser,Pin3,"OUTPUT")

for i=1:300

  #LSB
  if pinstate1==0
    digiWrite(ser,Pin1,0)
    sleep(0.05)
  else
    digiWrite(ser,Pin1,1)
    sleep(0.05)
  end

  #middle bit
  if pinstate2==0
    digiWrite(ser,Pin2,0)
    sleep(0.05)
  else
    digiWrite(ser,Pin2,1)
    sleep(0.05)
  end
  #MSB
  if pinstate3==0
    digiWrite(ser,Pin3,0)
    sleep(0.05)
  else
    digiWrite(ser,Pin3,1)
    sleep(0.05)
  end

  pinstate0=digiRead(ser,clockPin) #Reads the clock pulse to be counted

  #negative edge of clock pulse to FF1
  if pinstate0!=lastpinstate0
    if pinstate0==0
      #toggle i.e. if output is 0, change it to 1 & vice versa
      if pinstate1==0
        pinstate1=1
      else
        pinstate1=0
      end
    end
    sleep(0.05)
  end
  lastpinstate0=pinstate0

  #negative edge of clock pulse to FF2
  if pinstate1!=lastpinstate1
    if pinstate1==0
      #toggle i.e. if output is 0, change it to 1 & vice versa
      if pinstate2==0
        pinstate2=1
      else
        pinstate2=0
      end
    end
    sleep(0.05)
  end
  lastpinstate1=pinstate1

  #negative edge of clock pulse to FF3
  if pinstate2!=lastpinstate2
    if pinstate2==0
      #toggle i.e. if output is 0, change it to 1 & vice versa
      if pinstate3==0
        pinstate3=1
      else
        pinstate3=0
      end
    end
    sleep(0.05)
  end
  lastpinstate2=pinstate2

end
close(ser)
