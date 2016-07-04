using SerialPorts
using ArduinoTools

ser = connectBoard(115200) #detects the serial port to which arduino is connected

#Outputs
ledPin4=11 #ouput 4 (MSB)
ledPin3=10 #ouput 3
ledPin2=9 #ouput 2
ledPin1=8 #ouput 1 (LSB)

#Select lines
aPin=6 #input A (MSB)
bPin=7 #input B (LSB)

#Input
inPin=5

pinMode(ser,ledPin4,"OUTPUT") #declares pin as output
pinMode(ser,ledPin3,"OUTPUT")
pinMode(ser,ledPin2,"OUTPUT")
pinMode(ser,ledPin1,"OUTPUT")

pinMode(ser,inPin,"INPUT") #declares pin as input

pinMode(ser,aPin,"INPUT")
pinMode(ser,bPin,"INPUT")

for i=1:200
  i=digiRead(ser,inPin) #input

  a=digiRead(ser,aPin) #MSB select line input
  b=digiRead(ser,bPin) #LSB select line input

  print ("A= $a, B= $b, i= $i")

  if i==0 #all outputs will be zero irrespective of which one is selected
    digiWrite(ser,ledPin4,0)
    digiWrite(ser,ledPin3,0)
    digiWrite(ser,ledPin2,0)
    digiWrite(ser,ledPin1,0)
    sleep(0.1)

  elseif i==1
    if a==0 && b==0 #input i is seen at first output pin (LSB)
      digiWrite(ser,ledPin4,0)
      digiWrite(ser,ledPin3,0)
      digiWrite(ser,ledPin2,0)
      digiWrite(ser,ledPin1,1)
      sleep(0.1)
    elseif a==0 && b==1 #input i is seen at second output pin
      digiWrite(ser,ledPin4,0)
      digiWrite(ser,ledPin3,0)
      digiWrite(ser,ledPin2,1)
      digiWrite(ser,ledPin1,0)
      sleep(0.1)
    elseif a==1 && b==0 #input i is seen at third output pin
      digiWrite(ser,ledPin4,0)
      digiWrite(ser,ledPin3,1)
      digiWrite(ser,ledPin2,0)
      digiWrite(ser,ledPin1,0)
      sleep(0.1)
    elseif a==1 && b==1 #input i is seen at fourth or last output pin (MSB)
      digiWrite(ser,ledPin4,1)
      digiWrite(ser,ledPin3,0)
      digiWrite(ser,ledPin2,0)
      digiWrite(ser,ledPin1,0)
      sleep(0.1)
    end
  end

end

  close(ser)
