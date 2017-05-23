/* Will Richards, collabed in logic with Charlie Martens to make .wav files
 *  MUSC 208
 *  Interactive composition
 */


//Midi event
MidiIn min;
//Midi Message
MidiMsg msg;

//Chuck sound buffers to dac and pan
SndBuf sines => Pan2 p => dac;
SndBuf harmony => p =>  dac;
SndBuf piano => p => dac;
SndBuf metronome => p => dac;

0 => harmony.gain => piano.gain => metronome.gain;

Flute synth;  
1 => synth.gain;
  //Sound that will control the midi keyboard 
int id[100];          // Array to store notes currently being played
int  counter;        // Counter to see how many notes we are currently playing

// Load in sound files
me.dir() + "audio/drum.wav" => metronome.read;
me.dir() + "audio/sine.wav" => sines.read;
me.dir() + "audio/harmony.wav" => harmony.read;
me.dir() + "audio/piano.wav" => piano.read;

//Set head of SndBuf to end of sample
piano.samples() => piano.pos;
sines.samples() => sines.pos;
harmony.samples() => harmony.pos;
metronome.samples() => metronome.pos;

//Midi divice port
0 => int device;

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
                0 => metronome.pos;
            } 

             //pad 8
            else if(msg.data2 == 39) {
             
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
            if( msg.data1 == 128){
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
            0=>synth.noteOn;  
        }
        
