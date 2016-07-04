using SerialPorts
using ArduinoTools

ser = connectBoard(115200) #detects the serial port to which arduino is connected

diffPin=9 #sum
boutPin=10 #Carry out

aPin=5 #input A
bPin=6 #input B
binPin=3 #input Bin (Borrow in)

pinMode(ser,diffPin,"OUTPUT") #declares pin as output
pinMode(ser,boutPin,"OUTPUT")

pinMode(ser,aPin,"INPUT") #declares pin as input
pinMode(ser,bPin,"INPUT")
pinMode(ser,binPin,"INPUT")

for i=1:300 #loops 100 times
  a=digiRead(ser,aPin)
  b=digiRead(ser,bPin)
  bin=digiRead(ser,binPin)

  #As acoording to the logic circuit of full subtracter

  #First half subtracter

  #Difference
  #A XOR B
  if (a==0 && b==0) || (a==1 && b==1)
    fsdiff=0
  else
    fsdiff=1
  end

  #Borrow out
  #A NOT
  if a==0
    fsnot=1
  else
    fsnot=0
  end

  #B AND fsnot
  if b==1 && fsnot==1
    fsb=1
  else
    fsb=0
  end

  #Second half subtracter

  #Difference
  #fsdiff XOR Bin
  if (fsdiff==0 && bin==0) || (fsdiff==1 && bin==1)
    digiWrite(ser,diffPin,0)
    sleep(0.1)
  else
    digiWrite(ser,diffPin,1)
    sleep(0.1)
  end

  #Borrow out
  #fsdiff NOT
  if fsdiff==0
    ssnot=1
  else
    ssnot=0
  end

  #Bin AND ssnot
  if bin==1 && ssnot==1
    ssand=1
  else
    ssand=0
  end

  #ssand OR fsb
  if ssand==0 && fsb==0
    digiWrite(ser,boutPin,0)
  else
    digiWrite(ser,boutPin,1)
  end

println("$a $b $bin $fsdiff $fsnot $fsb $ssnot $ssand")
end
close(ser)
