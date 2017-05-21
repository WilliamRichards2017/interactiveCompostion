[0,1,2,3,4,5,5,4,3,2,1] @=> int mel[];


fun void notes() {
    for(0 => int i; i < 100; i++ ) {
        Std.mtof( 48 + mel[i%mel.cap()] ) => inst.freq;
        inst.noteOn( 0.5 );
        300::ms => now;
        
    }
}