function [chunks, inds ] = splitIntoChunks( x, params, removeSilence )
% 
% if nargin < 4
%     win = false;
% end

sigLen = length(x);
overLap = params.frameLen - params.hopLen;
pad = (params.frameLen - overLap) - rem( (sigLen - overLap), (params.frameLen - overLap) );

if pad ~= params.frameLen
    x = [x; zeros(pad,1)];
    sigLen = length(x);
end

numFrames = 1 + ( sigLen - params.frameLen ) / params.hopLen;

chunks = zeros( numFrames, params.frameLen );

if isempty(params.window)
    window = hann(winLen,"periodic");
else
    window = params.window;
end

powers = zeros(1,numFrames);

for frame = 0:numFrames-1

    inds = 1+frame*params.hopLen:params.frameLen+frame*params.hopLen;

    xFrame = x(inds);

    powers(frame+1) = pow2db(sum( abs( xFrame ).^2 ));

    y = window .* xFrame;

    chunks(frame+1,:) = y;

end

thresh = -25; %dB
inds =[];
if removeSilence
    inds = powers > thresh;
    %figure;hist(powers);
end



