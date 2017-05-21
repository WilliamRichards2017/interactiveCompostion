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

SndBuf sines => dac;
SndBuf harmony => dac;
SndBuf piano => dac;
SndBuf metronome => dac;



// Load in sound files
me.dir() + "audio/wavDir/dj_scratch.wav" => scratch.read;
me.dir() + "audio/wgf.aiff" => wgf.read;
me.dir() + "audio/high.wav" => high.read;
me.dir() + "audio/high2.aiff" => high2.read;
me.dir() + "bass.wav" => metronome.read;


me.dir() + "sines.wav" => sines.read;
me.dir() + "harmony.wav" => harmony.read;
me.dir() + "piano.wav" => piano.read;

piano.samples() => piano.pos;
sines.samples() => sines.pos;
harmony.samples() => harmony.pos;
scratch.samples() => scratch.pos;
wgf.samples() => wgf.pos;
high.samples() => high.pos;
high2.samples() => high2.pos;
metronome.samples() => metronome.pos;


fun void metro() {
    metronome => dac;
    0.2 => metronome.gain;

    while(true) {
   
        0 => metronome.pos;
        .5::second => now;
        }
        
    }

//this is the device number for your midi controller
0 => int device;



// a MidiIn event!	
MidiIn min;
// the message for retrieving data
MidiMsg msg;

Rhodey synth;    //an array of synths for up to 10 tones... 
int id[100];          //an array to hold the note numbers so that we can match them up with the off signal
int  counter;        //this is to cycle through the arrays looking for a position where a key isn't pressed

min.open( device );  // open your midi keyboard...

while( true ){
    // wait on your midi event
    min => now;
    
    //this processes the keypresses
    while( min.recv( msg ) ){
        
        
        if (msg.data1 == 224) {
            <<< msg.data2 >>>;
            
        }
        
        //touch pad press down
       else if( msg.data1 == 153) {
            //<<< msg.data2 >>>;

            if(msg.data2 == 49) {
                0 => sines.pos;
            }
            
            else if(msg.data2 == 41) {
                0 => harmony.pos;
            } 
            else if(msg.data2 == 42) {
                0 => piano.pos;
            } 
            
            else if(msg.data2 == 46) {
                spork ~ metro();
            } 
            else if(msg.data2 == 42) {
                0 => high2.pos;
            } 
            else if(msg.data2 == 39) {
                metronome =< dac;
            } 
            else if(msg.data2 == 41) {
                0 => guitar2.pos;
            } 
            else if(msg.data2 == 36) {
                0 => guitar3.pos;
            } 
        }
       
       
       else if( msg.data1 == 145 || msg.data1 == 144){ //note on?
           <<< "swag" >>>; 
            0=> counter;         //initialize the counter
            
            while(id[counter]!=0) //this looks for an empty position in the array
                counter++;
            
            msg.data2=>id[counter]; //puts the midi key number into the id array
            
            ON(id[counter],
            msg.data3);  }// ON!
            
            if( msg.data1 == 128){//note off?
                0=>counter;
                
                
                OFF();        //OFF!!!!!
                0=>id[counter];   }  //changes the id of the note just turned off to zero for re-use
                
            }	
        }
    
        
        public void ON(int note, int velocity){
            synth=>dac;                       
            Std.mtof( note ) => synth.freq;    //changes the midi note to a frequency
            velocity / 128.0 => synth.noteOn;	//put some fancy velocity algorithms here
        }
        
        public void OFF(){
            0=>synth.noteOn;  //noteOff doesn't appear to do anything
            //Put some fancy envelopes here
        }