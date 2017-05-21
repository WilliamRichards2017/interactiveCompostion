 Shakers s => JCRev r => dac;


SinOsc sin => dac;
Flute flute => dac;
SndBuf be1 => dac;
SndBuf be2 => dac;
SndBuf be3 => dac;
SndBuf be4 => dac;
SndBuf be5 => dac;

0.0 => sin.gain;
0.2 => flute.gain;



0.8 => be1.gain => be2.gain => be3.gain => be4.gain => be5.gain;


me.dir() + "wavDir3/be_1.wav" => be1.read;
me.dir() + "wavDir3/be_2.wav" => be2.read;
me.dir() + "wavDir3/be_3.wav" => be3.read;
me.dir() + "wavDir3/be_4.wav" => be4.read;
me.dir() + "wavDir3/be_5.wav" => be5.read;

be1.samples() => be1.pos;
be2.samples() => be2.pos;
be3.samples() => be3.pos;
be4.samples() => be4.pos;
be5.samples() => be5.pos;



Hid button;
HidMsg msg;

Hid gcc;
HidMsg msg2;

// which joystick
0 => int device;

0.5 => float vol;
// get from command line
if( me.args() ) me.arg(0) => Std.atoi => device;

// open joystick 0, exit on fail
if( !gcc.openJoystick( device ) ) me.exit();
if( !button.openJoystick( device ) ) me.exit();

500.0 => float pitch;


fun void joyStickListener() {
    while( true )
    {
        // wait on HidIn as event
        gcc => now;
        
        // messages received
        while( gcc.recv( msg2 ) )
        {
            // joystick axis motion
            if( msg.isAxisMotion() )
            {
                if ( msg.which == 2 ) {
                    5 + (msg.axisPosition+1) * 300 => flute.vibratoFreq;
                }
                //<<< "freq:", s.freq(), "objects:", s.objects(), "energy:", s.energy(), "decay:", s.decay(), "preset:", s.preset() >>>;
            }         
            
            1::ms => now;
            
            
        }
    }
}
        

fun void buttonListener() {
    
    while( true )
    {
        // wait on HidIn as event
        button => now;
        
        // messages received
        while( button.recv( msg ) )
        {
            // joystick button down
            if( msg.isButtonDown() ) {
                  //  <<< "joystick button", msg.which, "down" >>>;
                    if (msg.which==0) {
                        0 =>  be1.pos;
                        .25::second => now;
                    }
                    
                    else if (msg.which==1) {
                        0 =>  be2.pos;
                        .5::second => now;
                    }
                    else if (msg.which==2) {
                        0 =>  be3.pos;
                       .5::second => now;
                    }
                    else if (msg.which==3) {
                        0 =>  be4.pos;
                        .5::second => now;
                    }
                    else if (msg.which==6) {
                        0 =>  be5.pos;
                        .5::second => now;
                    }
                    //L trigger, set pan to left
                    else if (msg.which==4) {
                        sin =< dac.left;
                        sin =< dac.right;                       
                        sin => dac.left;
                    }
                    else if (msg.which==5) {
                        sin =< dac.left;
                        sin =< dac.right;

                        sin => dac.right;
                    }
                    else if (msg.which==9) {
                        sin =< dac.left;
                        sin =< dac.right;
                        
                        sin => dac;
                    }
                    
                    
                }
                
                // joystick button up
                else if( msg.isButtonUp() )
                {
                    <<< "joystick button", msg2.which, "up" >>>;
                }
                
                // joystick hat/POV switch/d-pad motion
                else if( msg.isHatMotion() )
                {
                    <<< "joystick hat", msg2.which, ":", msg2.idata >>>;
                    if (msg2.idata == 0) {
                        
                        0.1 +=> vol;
                        vol => sin.gain;                        
                        }
                        
                    if (msg2.idata == 4) {
                                      
                        0.1 -=> vol;
                        vol => sin.gain; 
                        }
                     if (msg2.idata == 2) {
                            
                            20 +=> pitch;
                            pitch => sin.freq; 
                        }
                        if (msg2.idata == 6) {
                            
                            20 -=> pitch;
                            pitch => sin.freq; 
                        } 

                } 
            }    
        }
}

    
    
spork ~ buttonListener();    
spork ~ joyStickListener();

1::day => now;
    
