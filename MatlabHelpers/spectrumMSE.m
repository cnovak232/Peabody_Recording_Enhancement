function [errPlot, sndr, mse ] = spectrumMSE( csMag, micMag, plot )


errPlot = 10.0 * log10( (micMag - csMag).^2 );


sndr = mean( micMag.^2, "all" ) / mean( (micMag - csMag).^2, "all"); 
sndr =  10.0 * log10( sndr );

mse =  mean( (micMag - csMag).^2, "all");

if plot
    figure; 
    imagesc(errPlot);
    title('Square error of CS / Mic Spectrums')
    set(gca, 'YDir','normal')
end
