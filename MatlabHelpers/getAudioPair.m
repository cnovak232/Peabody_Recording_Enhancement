function [cs, mic, fs] = getAudioPair( csName, micName, track, params  )

dir1 = [ './CS_Audio/', csName, filesep, track, '.wav' ];
dir2 = [ './Mic_Audio/', csName, filesep, micName, filesep, track, '.wav' ];

[ cs, ~ ] = audioread( dir1 );
[mic, fs ] = audioread( dir2 );

if params.mono
    cs = mean( cs, 2 );
    mic = mean( mic, 2 );
end

if params.fs ~= fs
    fac = fs / params.fs;
    cs = resample(cs,1,fac);
    mic = resample(mic,1,fac);
    fs = params.fs;

end