addpath src;
Baa;
a=baa;clear baa;
a=a(10000:45000);
global baa;
baa=a;clear a;
midi = readmidi('bad apple-¶«·½.mid')
%----- converting MIDI to audio ----------
% (Fs = sample rate. here, uses default 44.1k.)
[y1,Fs] = midi2audio(midi,44100,'sine',2); 
y1 = y1 ./ max(abs(y1));
audiowrite('BadAppleBaa.wav',y1,Fs);