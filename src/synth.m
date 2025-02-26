function y=synth(freq,dur,amp,Fs,type)
    global baa;
% y=synth(freq,dur,amp,Fs,type)
%
% Synthesize a single note
%
% Inputs:
%  freq - frequency in Hz
%  dur - duration in seconds
%  amp - Amplitude in range [0,1]
%  Fs -  sampling frequency in Hz
%  type - string to select synthesis type
%         current options: 'fm', 'sine', or 'saw'

% Copyright (c) 2009 Ken Schutte
% more info at: http://www.kenschutte.com/midi

if nargin<5
  error('Five arguments required for synth()');
end

N = floor(dur*Fs);

if N == 0
  warning('Note with zero duration.');
  y = [];
  return;

elseif N < 0
  warning('Note with negative duration. Skipping.');
  y = [];
  return;
end

n=0:N-1;
if (strcmp(type,'sine'))
%       temp = ceil(N/length(baa));
%       temp = repmat(baa,temp,1)';
%       y=0.7*amp*temp( n+1) .* hanning(N)';
if(freq<1600)
    freq2 = 1600;
elseif(freq<1800)
    freq2 = freq;
else
    freq2 = 1800;
end
    resample_baa = interp1(baa,linspace(1,length(baa),length(baa) * freq2/1700));
    temp = ceil(N/length(resample_baa));
    temp = repmat(resample_baa,1,temp);
    y=amp*temp( n+1) .* hanning(N)';

    y = 0.9*y+0.1*amp.*sin(2*pi*n*freq/Fs);
    
%     
%     if(freq>1500 && freq<2700)
%         %   temp = ceil(N/length(baa));
%         %   temp = repmat(baa,temp,1)';
%         %  y=amp*temp( n+1) .* hanning(N)';
%           resample_baa = interp1(baa,linspace(1,length(baa),length(baa) * freq/1700));
%           temp = ceil(N/length(resample_baa));
%           temp = repmat(resample_baa,1,temp);
%           y=amp*temp( n+1) .* hanning(N)';
%     else
%         y = amp.*sin(2*pi*n*freq/Fs);
%     end
  %

 
   assert(size(y,1)==1);
%  
elseif (strcmp(type,'saw'))

  T = (1/freq)*Fs;     % period in fractional samples
  ramp = (0:(N-1))/T;
  y = ramp-fix(ramp);
  y = amp.*y;
  y = y - mean(y);

elseif (strcmp(type,'fm'))

  t = 0:(1/Fs):dur;
  envel = interp1([0 dur/6 dur/3 dur/5 dur], [0 1 .75 .6 0], 0:(1/Fs):dur);
  I_env = 5.*envel;
  y = envel.*sin(2.*pi.*freq.*t + I_env.*sin(2.*pi.*freq.*t));
  
else
  error('Unknown synthesis type');
end

% smooth edges w/ 10ms ramp
if (dur > .02)
  L = 2*fix(.01*Fs)+1;  % L odd
  ramp = bartlett(L)';  % odd length
  L = ceil(L/2);
  y(1:L) = y(1:L) .* ramp(1:L);
  y(end-L+1:end) = y(end-L+1:end) .* ramp(end-L+1:end);
     assert(size(y,1)==1);
end
