function I_rec = notSoBaselineAnymoreFast(I, mask)
%set not set pixel to zero, just to be sure
    I(~mask) = 0;

% calculate inpainting with a 3x3 kernel    
    souroundedPatchCount3 =  imfilter(double(mask),ones(3));
    I_rec = imfilter(I,ones(3)) ./ souroundedPatchCount3;
% calculate inpainting with a 5x5 kernel    
    souroundedPatchCount5 = imfilter(double(mask),ones(5));
    I_rec5 = imfilter(I,ones(5)) ./ souroundedPatchCount5;
% remove dev by zero by overwriting it with a overall mean, just in case. 
    I_rec5(souroundedPatchCount5 <= 0) = mean( I(mask == 1) );

% set in the missing pixel in the smaller aproximation
    I_rec(souroundedPatchCount3 <= 0) = I_rec5(souroundedPatchCount3 <= 0);
    
%%% post processing
    I_rec(mask) = I(mask);
    h = [0.01, 0.08, 0.01; 0.08, 0.64, 0.08; 0.01, 0.08, 0.01]; 
    I_rec = imfilter(I_rec,h,'symmetric');     

    %smoothing with box filter
    I_rec(mask) = I(mask);
    h = [0, 0.125, 0; 0.125, 0.5000, 0.1250; 0, 0.125, 0];
    I_rec = imfilter(I_rec,h,'symmetric');

    I_rec(mask) = I(mask);
end
