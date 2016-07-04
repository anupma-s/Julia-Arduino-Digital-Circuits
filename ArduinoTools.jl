module ArduinoTools

using SerialPorts

function connectBoard(baudrate::Int64)  # Automatically detects SerialPort and opens it
  arr = list_serialports()              # with given baudrate
  port = arr[1]
  ser = SerialPort(port,baudrate)       # Caution: works in most cases... If doesn't,
  sleep(2)                              # Use the openSerial() function
  return ser
end

function openSerial(port::ASCIIString, baudrate::Int64)       # starts serial communication
  ser = SerialPorts.SerialPort(port,baudrate)
  sleep(2)
  return ser
end

function closeSerial(ser::SerialPorts.SerialPort)             # closes serial port
  SerialPorts.close(ser)
end

function Write(ser::SerialPorts.SerialPort, str::ASCIIString) # writes a string to connected serial device
  SerialPorts.write(ser,str)
end

function Write(ser::SerialPorts.SerialPort, str::UTF8String)  # writes a string to connected serial device
  SerialPorts.write(ser,str)
end

function Read(ser::SerialPorts.SerialPort, bytes::Int64)      # reads 'bytes' number of bytes from serial port
  SerialPorts.read(ser,bytes)
end

function ReadAvailable(ser::SerialPorts.SerialPort)           # reads all available bytes from serial port
  SerialPorts.readavailable(ser)
end

function nbAvailable(ser::SerialPorts.SerialPort)             # returns number of bytes available for reading
  SerialPorts.nb_available(ser)
end

function listSerialPorts()                                    # returns array of serial port names on computer
  SerialPorts.list_serialports()
end

function pinMode(file_des::SerialPorts.SerialPort , pin_no::Int64 , mode::ASCIIString)
  m = uppercase(mode)                                             # Prevent errors due to case differences
  if m == "INPUT"  str = "Da"*string(Char(48+pin_no))*"0"  end    # Dan0 for INPUT
  if m == "OUTPUT"  str = "Da"*string(Char(48+pin_no))*"1"  end   # Dan1 for OUTPUT
  str = ascii(str)                                                # Converts UTF8String to ASCIIString
  write(file_des,str)
end

function digiWrite(file_des::SerialPorts.SerialPort , pin_no::Int64 , val::Int64)
  if val > 0 str = "Dw"*string(Char(48+pin_no))*"1" end    # Dwn1 for HIGH
  if val == 0 str = "Dw"*string(Char(48+pin_no))*"0" end   # Dwn0 for LOW
  str = ascii(str)                                         # Converts UTF8String to ASCIIString
  write(file_des,str)
end

function digiRead(file_des::SerialPorts.SerialPort , pin_no::Int64)
  str = "Dr"*string(Char(48+pin_no))  # Drn to read digital pin n
  str = ascii(str)                    # Convert UTF8String to ASCIIString
  write(file_des,str)
  sleep(0.01)                         # Delay the next step by 10 milliseconds
  c = read(file_des,1)                # Read one byte from SerialPort
  n = parse(Int,c)                    # Convert the received string into integer
  return n                            # Return the integer
end

function analogWrite(file_des::SerialPorts.SerialPort , pin_no::Int64 , val::Int64)
  if val > 255 val = 255 end          # Make sure val isn't beyond limits
  if val < 0 val = 0 end
  c = Char(val)                       # Conversion of val into character
  d = string(c)                       # Converting character to string
  s = "W"*string(Char(48+pin_no))*d   # Wnm for analog value m on pin n
  write(file_des,s)
end

function analogRead(file_des::SerialPorts.SerialPort , pin_no::Int64)
  str = "A"*string(Char(48+pin_no))   #"An" for analog value on pin n
  write(file_des,str)
  sleep(0.1)                          # Delay next step by 100 milliseconds
  n = nb_available(file_des)          # Get number of bytes in input buffer
  s = read(file_des,n)                # Read n bytes from SerialPort
  k = parse(Int,s)                    # Convert String to integer
  return k                            # Return the integer
end

function DCMotorSetup(file_des::SerialPorts.SerialPort, driver_type::Int64, motor_no::Int64, pin1::Int64, pin2::Int64)
  println("Initializing motor")
  if (driver_type == 1)               # adafruit
      code_sent = "C"*string(motor_no)*string(Char(48+pin1))*string(Char(48+pin2))*"1"
  elseif (driver_type == 2)           # L298
      code_sent = "C"*string(motor_no)*string(Char(48+pin1))*string(Char(48+pin2))*"1"
  elseif (driver_type == 3)           # L293
      code_sent = "C"*string(motor_no)*string(Char(48+pin1))*string(Char(48+pin2))*"0"
  end
  write(file_des,code_sent)
  sleep(0.1)                          # sleep for a tenth of a second
  s = readavailable(file_des)         # read all available bytes from input buffer
  if s == "OK"
    println("Motor Setup Successful")
  else
    println("Motor Setup unsuccessful")
  end
end                                   # end function

function DCMotorRun(file_des::SerialPorts.SerialPort, motor_no::Int64, speed::Int64)
  sgn = sign(speed)                   # Checking sign of speed to set direction
  if sgn >= 0
    direction = "1"
  else
    direction = "0"
  end
  speed = abs(speed)                  # Dropping the sign
  if speed > 255 speed = 255  end     # Make sure speed is not beyond limit
  code_sent = "M"*string(motor_no)*direction*string(Char(speed))
  write(file_des,code_sent)
end                                   # end function

function DCMotorRelease(file_des::SerialPorts.SerialPort, motor_no::Int64)
  code_sent = "M"*string(motor_no)*"1"string(Char(0))
  write(file_des,code_sent)           # Stops the motor first
  sleep(0.1)                          # Delay of 0.1 second
  code_sent = "M"*string(motor_no)*"r"
  write(file_des,code_sent)           # Releases the motor
end

function ServoAttach(file_des::SerialPorts.SerialPort, servo_no::Int64)
  println("Initializing servo")
  if servo_no == 1
    pin = "Sa1"
    write(file_des,pin)
  elseif servo_no == 2
    pin = "Sa2"
    write(file_des,pin)
  else
    println("Error")
  end
end

function ServoMove(file_des::SerialPorts.SerialPort, servo_no::Int64, val::Int64)
  if val < 0 val = 0 end
  if val >180 val = 180 end
  pin = "Sw"*string(servo_no)*string(Char(val))
  write(file_des,pin)
end

function ServoDetach(file_des::SerialPorts.SerialPort, servo_no::Int64)
  if servo_no == 1
    pin = "Sa1"
    write(file_des,pin)
  elseif servo_no == 2
    pin = "Sa2"
    write(file_des,pin)
  else
    println("Error")
  end
end


#For SIPO shift register
function shiftOut(dataPin::Integer, clockPin::Integer, bitOrder::ASCIIString, val::Array)
  val2=0
  if bitOrder=="MSBFIRST"
    #8x8 identity matrix
    mat=eye(8,8)
  else
    #horizontally flipped 8x8 identity matrix
    mat=flipdim(eye(8,8),1)
  end
  for i=1:8
    #performs & operation on corresponding elements of matrix
    for j=1:8
      if val[j]==1 && mat[i,j]==1
        val2=1
        break
      else
        val2=0
      end
    end
    #print(val2)
    digiWrite(ser,dataPin,val2)
    digiWrite(ser,clockPin,1)
    digiWrite(ser,clockPin,0)
  end
end #end of function

#For SIPO shift register
function shiftOut_(dataPin::Integer, clockPin::Integer, inPin::Integer)
  inp=digiRead(ser,inPin)#if inPin is HIGH,
        #i.e. if input is given, write HIGH on Serial In Pin of IC
  sleep(0.5)
  print("Input stored")
  digiWrite(ser,dataPin,inp)
  digiWrite(ser,clockPin,1)
  digiWrite(ser,clockPin,0) #One clock pulse
  sleep(0.5)
end

#For SIPO shift register
#shiftOut For n bits
function shiftOutn(dataPin::Integer,clockPin::Integer,bitOrder::ASCIIString,val::Array,numBits::Integer)
  n=numBits #number of bits
  #To calculate total number of pins, i.e. the total no. of clock cycles required.
  if (n%8)==0
    p=n
  #elseif (n%8)<4
  #  p=(8*(int(n/8)))+8
  else
  #  p=(8*(int((n/8)-0.5)))+8
    p=(8*(div(n,8)))+8
  end
  #println("Total loops= $p")
  #println("No. of bits= $n")
  #println("Empty loops= $(p-n)")

  println()
  val1=zeros(n) #output matrix.
            #If all elements of the matrix are 0,
            #output pinstate will be 0 (i.e LOW).
            #If 1 or more elements of the matrix is 1,
            #output pinstate will be 1 (i.e HIGH)
  val2=0
  if bitOrder=="MSBFIRST"
    mat=eye(n,n)
  else
    mat=flipdim(eye(n,n),1)
  end
  for j=1:(p-n) #do nothing for the first (p-n) clock  pulses
    digiWrite(ser,dataPin,0)
    digiWrite(ser,clockPin,1)
    digiWrite(ser,clockPin,0)
  end
  for k=1:n #shift for last n clock pulses
    for l=1:n
      if val[l]==1 && mat[k,l]==1
        val2=1
        break
      else
        val2=0
      end
    end
    digiWrite(ser,dataPin,val2)
    digiWrite(ser,clockPin,1)
    digiWrite(ser,clockPin,0)
  end
end


#For PISO shift register
function shiftIn(dataPin::Integer, clockPin::Integer, ledPin::Integer, clockLed::Integer)
  value=zeros(8)
  value2=zeros(8,8)
  for i=1:8
    so=digiRead(ser,dataPin) #Reads serial out of IC
    print(so)
    if so==1
      digiWrite(ser,ledPin,1)
      sleep(0.1)
    else
      digiWrite(ser,ledPin,0)
      sleep(0.1)
    end
    value2[i,i]=so
    #to perform value=value|value2[i]
    for j=1:8
      if value[j]==1 || value2[i,j]==1
        value[j]=1
      else
        value[j]=0
      end
    end
    digiWrite(ser,clockPin,1)
    digiWrite(ser,clockLed,1)
    sleep(0.5)
    digiWrite(ser,clockPin,0)
    digiWrite(ser,clockLed,0) #clockLED: Led indicating clock pulses
    sleep(0.4)
    #after every clock pulse, 1 right shift occurs for every bit
    #thus after 8 clock pulses, the entire parallel input is shifted out,
    #and obtained at the dataPin, one bit per clock pulse
    #Thus we get the bit by bit serial output of the Parallel Load
  end
  print(value)
end


#For PISO shift register
#shiftIn for n bits
function shiftInn(dataPin::Integer,clockPin::Integer,ledPin::Integer,clockLed::Integer,numBits::Integer)
  n=numBits #no. of bits
  value=zeros(n)
  value2=zeros(n,n)
  so=0
  for i=1:n
    so=digiRead(ser,dataPin)
    if so==1
      digiWrite(ser,ledPin,1)
      sleep(0.1)
    else
      digiWrite(ser,ledPin,0)
      sleep(0.1)
    end
    value2[i,i]=so
    #to perform value=value|value2[i]
    for j=1:n
      if value[j]==1 || value2[i,j]==1
        value[j]=1
      else
        value[j]=0
      end
    end
    digiWrite(ser,clockPin,1)
    digiWrite(ser,clockLed,1)
    sleep(0.5)
    digiWrite(ser,clockPin,0)
    digiWrite(ser,clockLed,0)
    sleep(0.4)
  end
  println(value)
end

function raw_input(prompt::ASCIIString="")
  print(prompt)
  return chomp(readline())
end

export connectBoard,openSerial,closeSerial,Write,Read,ReadAvailable,nbAvailable,listSerialPorts,pinMode,digiWrite,digiRead,analogWrite,analogRead,DCMotorSetup,DCMotorRun,DCMotorRelease,ServoAttach,ServoMove,ServoDetach,shiftOut,shiftOut_,shiftOutn,shiftIn,shiftInn,raw_input
end # module
