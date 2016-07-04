using SerialPorts
using ArduinoTools

ser = connectBoard(115200) #detects the serial port to which arduino is connected

pinstate=0
lastpinstate=0

clockPin=5 # Pulse to be counted

#outputs
Pin1=9 #LSB
Pin2=10 #middle bit
Pin3=11 #MSB

pinMode(ser,clockPin,"INPUT")

pinMode(ser,Pin1,"OUTPUT")
pinMode(ser,Pin2,"OUTPUT")
pinMode(ser,Pin3,"OUTPUT")

i=0
a=0
b=0
c=0


for j=1:500

  pinstate=digiRead(ser,clockPin)

  #negative edge of clock pulse to FF1
  if pinstate!=lastpinstate
    if pinstate==0
      i+=1
    end
    sleep(0.05)
  end
  lastpinstate=pinstate

  a=i%2
  b=int((i/2)%2)
  c=int(((i/4)-0.25)%2)

  digiWrite(ser,Pin1,a) #LSB
  digiWrite(ser,Pin2,b) #middle bit
  digiWrite(ser,Pin3,c) #MSB
  sleep(0.1)

  if i>7
    i=0
  end

end
close(ser)
