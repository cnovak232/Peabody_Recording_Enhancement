wavNames = {'Acoustical_Piece','Chr_Arco','Chr_Pizz', 'Pickup_Processed', 'Walking_Bass' };

params = struct;
params.fs = 48e3;
params.mono = true;

params.sampleLen = 16384; 
params.fs = fs;


csName = 'KNA_PU_P2';
testAudio1 = 'Chr_Arco';

trainFolder = './Train';
testFolder = './Test';


for n = 1:length(wavNames)
    name = wavNames{n};

    [csAudio, micAudio, fs] = getAudioPair(csName,'M149',name, params);

    csAudioSplit = splitIntoChunks( csAudio, params.sampleLen , params.sampleLen / 2, true  );
    micAudioSplit = splitIntoChunks( micAudio, params.sampleLen , params.sampleLen / 2, true  );

    for i = 1:size(csAudioSplit,1)

        csWav = csAudioSplit(i,:);
        micWav = csAudioSplit(i,:);
        
        csFile = ['CS/', csName,'_', name(1:5), '_s',num2str(i),'.wav'];
        micFile = ['MIC/', csName,'_', name(1:5), '_s',num2str(i),'.wav'];
       
        if strcmp( name, testAudio1 )
            csPath = [ testFolder filesep csFile ];
            micPath = [ testFolder filesep micFile];
        else
            csPath = [ trainFolder filesep csFile ];
            micPath = [ trainFolder filesep micFile];
        end

        audiowrite( csPath, csWav, params.fs );
        audiowrite( micPath, micWav, params.fs);
    end

end