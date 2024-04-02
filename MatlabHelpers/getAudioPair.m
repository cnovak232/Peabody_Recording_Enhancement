function [cs, mic, fs] = getAudioPair( csName, micName, track, params, desFs  )

dir1 = [ './CS_Audio/', csName, filesep, track, '.wav' ];
dir2 = [ './Mic_Audio/', csName, filesep, micName, filesep, track, '.wav' ];

[ cs, ~ ] = audioread( dir1 );
[mic, fs ] = audioread( dir2 );

if params.mono
    cs = mean( cs, 2 );
    mic = mean( mic, 2 );
end

if fs ~= desFs
    fac = fs / desFs;
    cs = resample(cs,1,fac);
    mic = resample(mic,1,fac);
    params.fs = desFs;
end