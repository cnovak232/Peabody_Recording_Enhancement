
params = struct;
params.fs = 48e3;
params.mono = true;


[csAudio, micAudio, fs] = getAudioPair('KNA_PU_P1','M149','Chr_Arco', params);


params.sampleLen = 16384; 
params.fs = fs;

csAudioSplit = splitIntoChunks( csAudio, params.sampleLen , params.sampleLen / 2, true  );
micAudioSplit = splitIntoChunks( micAudio, params.sampleLen , params.sampleLen / 2, true  );

params.winLen = 512;
params.hopLen = params.winLen / 2;
params.window = hann( params.winLen );

%% 

%[csMag, csPhase, micMag, micPhase ] = getSpectrums(csAudioSplit(10,:)', micAudioSplit(10,:)', params, true );

%% 
[errorPlot, mse ] = spectrumMSE( csMag, micMag, true );


%% 

[csMag, csPhase, micMag, micPhase ] = getSpectrums(csAudio, micAudio, params, true );

numChunks = size(csAudioSplit,1);

csFull = [];
micFull = [];

for i = 1:numChunks

    csSeg = csAudioSplit(i,:);
    micSeg = micAudioSplit(i, :);

    [csSegMag, ~, micSegMag, ~ ] = getSpectrums(csSeg', micSeg', params, false );

    csFull = [csFull, csSegMag ];
    micFull = [micFull, micSegMag ];

end

    figure;
    subplot(211);
    csDb = db( csMag );
    imagesc(csDb);
    set(gca, 'YDir','normal')
    colorbar
    title('CS Regular');
    ylabel('Frequency');
    xlabel('Time (s)');
    zlabel('Amp (dB)');
    
    subplot(212);
    csFullDb = db( csFull );
    imagesc( csFullDb);
    title('CS Appended');
    colorbar
    set(gca, 'YDir','normal')
    ylabel('Frequency');
    xlabel('Time (s)');
    zlabel('Magnitude (dB)');

sizeFix = size(csMag,2);

csFullFix = csFull(:, 1:sizeFix );

error = abs( csFullFix - csMag );


figure;
imagesc(error);
title('Error between the spectrograms');





