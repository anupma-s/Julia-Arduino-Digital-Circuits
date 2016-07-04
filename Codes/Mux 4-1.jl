using SerialPorts
using ArduinoTools

ser = connectBoard(115200) #detects the serial port to which arduino is connected

#Output
ledPin=9

#Select lines
aPin=6 #input A (MSB)
bPin=7 #input B (LSB)

#Inputs
Pin4=5 #input 4 (MSB)
Pin3=4 #input 3
Pin2=3 #input 2
Pin1=2 #input 1 (LSB)

pinMode(ser,ledPin,"OUTPUT") #declares pin as output

pinMode(ser,Pin4,"INPUT") #declares pin as input
pinMode(ser,Pin3,"INPUT")
pinMode(ser,Pin2,"INPUT")
pinMode(ser,Pin1,"INPUT")

pinMode(ser,aPin,"INPUT")
pinMode(ser,bPin,"INPUT")


for i=1:200 #loops 100 times
  i4=digiRead(ser,Pin4)
  i3=digiRead(ser,Pin3)
  i2=digiRead(ser,Pin2)
  i1=digiRead(ser,Pin1)

  a=digiRead(ser,aPin)
  b=digiRead(ser,bPin)

  if a==0 && b==0
    #input i1 is selected, output is same as i1
    if i1==0
      digiWrite(ser,ledPin,0)
      sleep(0.1)
    else
      digiWrite(ser,ledPin,1)
      sleep(0.1)
    end

  elseif a==0 && b==1
    #input i2 is selected, output is same as i2
    if i2==0
      digiWrite(ser,ledPin,0)
      sleep(0.1)
    else
      digiWrite(ser,ledPin,1)
      sleep(0.1)
    end

  elseif a==1 && b==0
    #input i3 is selected, output is same as i3
    if i3==0
      digiWrite(ser,ledPin,0)
      sleep(0.1)
    else
      digiWrite(ser,ledPin,1)
      sleep(0.1)
    end

  elseif a==1 && b==1
    #input i4 is selected, output is same as i4
    if i4==0
      digiWrite(ser,ledPin,0)
      sleep(0.1)
    else
      digiWrite(ser,ledPin,1)
      sleep(0.1)
    end

  end

end
close(ser)
