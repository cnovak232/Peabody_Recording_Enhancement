function chunks = splitIntoChunks( x, winLen, hopLen, win )

if nargin < 4
    win = false;
end

sigLen = length(x);
overLap = winLen - hopLen;
pad = (winLen - overLap) - rem( (sigLen - overLap), (winLen - overLap) );

if pad ~= winLen
    x = [x; zeros(pad,1)];
    sigLen = length(x);
end

numFrames = 1 + ( sigLen - winLen ) / hopLen;

chunks = zeros( numFrames, winLen );

if win
    window = hann(winLen);
end

for frame = 0:numFrames-1

    inds = 1+frame*hopLen:winLen+frame*hopLen;
    y = x(inds);

    if win
        y = window .* x(inds);
    end

    chunks(frame+1,:) = y;

end



