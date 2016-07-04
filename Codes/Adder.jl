using SerialPorts
using ArduinoTools

ser = connectBoard(115200) #detects the serial port to which arduino is connected

sumPin=9 #sum
coutPin=10 #Carry out

aPin=5 #input A
bPin=6 #input B
cPin=3 #input Cin (Carry in)

pinMode(ser,sumPin,"OUTPUT") #declares pin as output
pinMode(ser,coutPin,"OUTPUT")

pinMode(ser,aPin,"INPUT") #declares pin as input
pinMode(ser,bPin,"INPUT")
pinMode(ser,cPin,"INPUT")

for i=1:300 #loops 100 times
  a=digiRead(ser,aPin)
  b=digiRead(ser,bPin)
  c=digiRead(ser,cPin)

  #As acoording to the logic circuit of full adder

  #to get Pi: A XOR B
  if (a==0 && b==0) || (a==1 && b==1)
    p=0
  else
    p=1
  end

  #to get Gi: A AND B
  if a==1 && b==1
    g=1
  else
    g=0
  end

  #to get Sum: Pi XOR Cin
  if (p==0 && c==0) || (p==1 && c==1)
    digiWrite(ser,sumPin,0)
    sleep(0.1)
  else
    digiWrite(ser,sumPin,1)
    sleep(0.1)
  end

  #To get Carry Out

  #Pi AND Cin
  if p==1 && c==1
    temp=1
  else
    temp=0
  end

  #Gi OR temp
  if g==0 && temp==0
    digiWrite(ser,coutPin,0)
    sleep(0.1)
  else
    digiWrite(ser,coutPin,1)
    sleep(0.1)
  end

end
close(ser)
