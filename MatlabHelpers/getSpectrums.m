function [csMag, csPhase, micMag, micPhase ] = getSpectrums( cs, mic, params, plotSpec )

if nargin < 4
    plotSpec = 1;
end

fftSize = params.winLen;
overLap = params.winLen - params.hopLen; 

sigLen = length(cs);
pad = (params.winLen - overLap) - rem( (sigLen - overLap), (params.winLen - overLap) );

if pad ~= params.winLen
    cs = [cs; zeros(pad,1)];
    mic = [mic; zeros(pad,1)];
end


[CS,f1,t1] = stft( cs, params.fs,"Window",params.window ,"FFTLength",fftSize,"OverlapLength",overLap,"FrequencyRange","onesided"  );
[MIC,f2,t2] = stft( mic, params.fs,"Window",params.window,"FFTLength",fftSize,"OverlapLength",overLap,"FrequencyRange","onesided"  );

csMag = abs(CS);
%csMag = flipud(csMag);
micMag = abs(MIC);
%micMag = flipud(micMag);

csPhase = angle(CS);
micPhase = angle(MIC);

if plotSpec
    figure;
    subplot(211);
    csDb = db( csMag );
    imagesc(t1,f1, csDb);
    set(gca, 'YDir','normal')
    cc = max(csDb(:))+[-100 0];
    ax = gca;
    ax.CLim = cc;
    colorbar
    title('CS Spectrum');
    ylabel('Frequency');
    xlabel('Time (s)');
    zlabel('Amp (dB)');
    %ylim([1, 10e3])
    
    subplot(212);
    micDb = db( micMag );
    imagesc(t2, f2, micDb);
    title('Mic Spectrum');
    colorbar
    set(gca, 'YDir','normal')
    cc = max(micDb(:))+[-100 0];
    ax = gca;
    ax.CLim = cc;
    ylabel('Frequency');
    xlabel('Time (s)');
    zlabel('Magnitude (dB)');
    %ylim([1, 10e3])

end