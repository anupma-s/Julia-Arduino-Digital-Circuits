using SerialPorts
using ArduinoTools

ser = connectBoard(115200) #detects the serial port to which arduino is connected

#Binary Outputs
led1=10 #LSB
led2=11 #middle bit
led3=12 #MSB

#Decimal inputs
Pin1=2 #decimal input 1 (LSB)
Pin2=3 #decimal input 2
Pin3=4 #decimal input 3
Pin4=5 #decimal input 4
Pin5=6 #decimal input 5
Pin6=7 #decimal input 6
Pin7=8 #decimal input 7 (MSB)

pinMode(ser,led1,"OUTPUT") #declares pin as output
pinMode(ser,led2,"OUTPUT")
pinMode(ser,led3,"OUTPUT")

pinMode(ser,Pin1,"INPUT") #declares pin as input
pinMode(ser,Pin2,"INPUT")
pinMode(ser,Pin3,"INPUT")
pinMode(ser,Pin4,"INPUT")
pinMode(ser,Pin5,"INPUT")
pinMode(ser,Pin6,"INPUT")
pinMode(ser,Pin7,"INPUT")

for i=1:200

  d1=digiRead(ser,Pin1)
  d2=digiRead(ser,Pin2)
  d3=digiRead(ser,Pin3)
  d4=digiRead(ser,Pin4)
  d5=digiRead(ser,Pin5)
  d6=digiRead(ser,Pin6)
  d7=digiRead(ser,Pin7)

  print ("$d1 $d2 $d3 $d4 $d5 $d6 $d7")

  #decimal input 0, binary output 000
  if d1==0 && d2==0 && d3==0 && d4==0 && d5==0 && d6==0 && d7==0
    digiWrite(ser,led3,0) #MSB
    digiWrite(ser,led2,0)
    digiWrite(ser,led1,0) #LSB
    sleep(0.1)

  #decimal input 1, binary output 001
  elseif d1==1 && d2==0 && d3==0 && d4==0 && d5==0 && d6==0 && d7==0
    digiWrite(ser,led3,0) #MSB
    digiWrite(ser,led2,0)
    digiWrite(ser,led1,1) #LSB
    sleep(0.1)

  #decimal input 2, binary output 010
  elseif d2==1 && d3==0 && d4==0 && d5==0 && d6==0 && d7==0
    digiWrite(ser,led3,0) #MSB
    digiWrite(ser,led2,1)
    digiWrite(ser,led1,0) #LSB
    sleep(0.1)

  #decimal input 3, binary output 011
  elseif d3==1 && d4==0 && d5==0 && d6==0 && d7==0
    digiWrite(ser,led3,0) #MSB
    digiWrite(ser,led2,1)
    digiWrite(ser,led1,1) #LSB
    sleep(0.1)

  #decimal input 4, binary output 100
  elseif d4==1 && d5==0 && d6==0 && d7==0
    digiWrite(ser,led3,1) #MSB
    digiWrite(ser,led2,0)
    digiWrite(ser,led1,0) #LSB
    sleep(0.1)

  #decimal input 5, binary output 101
  elseif d5==1 && d6==0 && d7==0
    digiWrite(ser,led3,1) #MSB
    digiWrite(ser,led2,0)
    digiWrite(ser,led1,1) #LSB
    sleep(0.1)

  #decimal input 6, binary output 110
  elseif d6==1 && d7==0
    digiWrite(ser,led3,1) #MSB
    digiWrite(ser,led2,1)
    digiWrite(ser,led1,0) #LSB
    sleep(0.1)

  #decimal input 7, binary output 111
  elseif d7==1
    digiWrite(ser,led3,1) #MSB
    digiWrite(ser,led2,1)
    digiWrite(ser,led1,1) #LSB
    sleep(0.1)

  end

end
close(ser)
