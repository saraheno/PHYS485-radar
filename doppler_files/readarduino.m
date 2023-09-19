arduinoObj = serialport("COM3",9600);
configureTerminator(arduinoObj,"CR/LF");
flush(arduinoObj);
arduinoObj.UserData = struct("Data",[],"Count",1);
configureCallback(arduinoObj,"terminator",@readSineWaveData);

