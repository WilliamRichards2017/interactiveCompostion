SndBuf wgf => Pan2 p=> dac;
SndBuf high => dac;
SndBuf high2 => dac;
SndBuf scratch => dac;
SndBuf hit2 => p => dac;
SndBuf gucci => p => dac;
SndBuf dustysines=> dac;
SndBuf belt => dac;
SndBuf yeah => p => dac;
SndBuf brooklyn => dac;
SndBuf guitar1 => dac;
SndBuf guitar2 => dac;
SndBuf guitar3 => dac;

SndBuf sines => p => dac;
SndBuf harmony => p =>  dac;
SndBuf piano => p => dac;
SndBuf metronome => p => dac;



// Load in sound files

me.dir() + "beat.wav" => metronome.read;
me.dir() + "sine.wav" => sines.read;
me.dir() + "harmony.wav" => harmony.read;
me.dir() + "piano.wav" => piano.read;

piano.samples() => piano.pos;
sines.samples() => sines.pos;
harmony.samples() => harmony.pos;
metronome.samples() => metronome.pos;

//Midi divice number
0 => int device;



// a MidiIn event!	
MidiIn min;
// the message for retrieving data
MidiMsg msg;

PercFlut synth;    //Sound that will control the midi keyboard 
int id[100];          // Array to store notes currently being played
int  counter;        // Counter to see how many notes we are currently playing

min.open( device );  // opens midi device

while( true ){
    // Listens for midi event
    min => now;
    
    //Process midi data 
    while( min.recv( msg ) ){
        
        //Debug statements, uncomment ot print out device input data
        //<<<msg.data1, msg.data2, msg.data3>>>;
        
        //left wheel
        if (msg.data1 == 224) {
            msg.data3/127.0 => p.pan;           
        }
        
        //right wheel and nobs
        if (msg.data1 == 176) {
            //right wheel
            if(msg.data2 == 1) {
                msg.data3/127.0 => p.gain;
                }
                
                //Top nob 1
                if(msg.data2 == 20) {
                    msg.data3/127.0 => sines.gain;
                }
                
                //Top nob 2
                if(msg.data2 == 21) {
                    msg.data3/127.0 => harmony.gain;
                }
                
                if(msg.data2 == 22) {
                    msg.data3/127.0 => piano.gain;
                }
                if(msg.data2 == 23) {
                    msg.data3/127.0 => metronome.gain;
                }


        }
        
       //Touch pad area
       else if( msg.data1 == 153) {
           //pad 1
            if(msg.data2 == 49) {
                0 => sines.pos;
            }
            //pad 2
            else if(msg.data2 == 41) {
                0 => harmony.pos;
            } 
            //pad 3
            else if(msg.data2 == 42) {
                0 => piano.pos;
            } 
            
            //pad 4
            else if(msg.data2 == 46) {
                spork ~ metro();
            } 

             //pad 8
            else if(msg.data2 == 39) {
                metronome =< dac;
            } 
            
        }
       
       //Check if midi key is pressed, 
       //idk why key press is inconsitently 145 or 144
       else if( msg.data1 == 145 || msg.data1 == 144)
       {  
           0=> counter;          
            
            //Looks for empty space to store midi key note
            while(id[counter]!=0) 
                counter++;
            
            //store midi note in array
            msg.data2=>id[counter]; 
            //turn note on on key press
            ON(id[counter],
            msg.data3);  }
            
            //turn note off on key release
            if( msg.data1 == 128){//note off?
                0=>counter;  
                OFF();       
                0=>id[counter];   }                  
            }	
        }
    
        //helper function to turn note on
        public void ON(int note, int velocity){
            synth=>dac;                       
            Std.mtof( note ) => synth.freq;    
            velocity / 128.0 => synth.noteOn;	
        }
        
        //helper function to turn not off
        public void OFF(){
            synth =< dac;
            0=>synth.noteOn;  //noteOff doesn't appear to do anything
            //Put some fancy envelopes here
        }