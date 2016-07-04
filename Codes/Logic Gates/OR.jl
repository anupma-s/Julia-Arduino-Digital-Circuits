using SerialPorts
using ArduinoTools

ser = connectBoard(115200) #detects the serial port to which arduino is connected

pinMode(ser,9,"OUTPUT") #declares pin 9 of Arduino as output
pinMode(ser,5,"INPUT") #declares pin 5 of Arduino as input
pinMode(ser,6,"INPUT")

for i=1:100 #loops 100 times

  a=digiRead(ser,5) #reads the digital input given to pin 5
  b=digiRead(ser,6)

  if a==0 && b==0
    digiWrite(ser,9,0) #gives LOW output at pin 9
    sleep(0.1) #provides a 100 msec delay
  else
    digiWrite(ser,9,1) #gives HIGH output at pin 9
    sleep(0.1)
  end

end
close(ser) #closes the serial port
