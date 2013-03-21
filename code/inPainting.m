function I_rec = inPainting(I, mask)
%calculate overall mean 
overallmean = mean( I(mask == 1) );

%set not set pixel to zero, just to be sure
I(mask == 0) = 0;

%%% calculate inpainting with a 3x3 kernel
    %create count matrix
    x = size(I,1);
    xm = x - 1;
    countM3 = diag(ones(xm,1),-1) + eye(x) + diag(ones(xm,1),1);

    % "count" how many pixel are around a matrix
    souroundedPatchCount = (countM3 * mask * countM3);

    % sum over "patch" and build a mean
    I_rec = (countM3 * I * countM3) ./ souroundedPatchCount;

%%% calculate inpainting with a 5x5 kernel
    %create count matrix
    xm2 = x - 2;
    countM5 = diag(ones(xm2,1),-2) + countM3 + diag(ones(xm2,1),2);
    
    % "count" how many pixel are around a matrix
    souroundedPatchCount2 = (countM5 * mask * countM5);

    % sum over kernel and build a mean
    I_rec5 = (countM5 * I * countM5) ./ souroundedPatchCount2;

    % remove dev by zero by overwriting it with a overall mean, just in
    % case. 
    I_rec5(souroundedPatchCount2 <= 0) = overallmean;
    

%%% set in the missing pixel in the smaller aproximation
    I_rec(souroundedPatchCount <= 0) = I_rec5(souroundedPatchCount <= 0);
    
%%% post processing
    I_rec(mask == 1) = I(mask == 1);
    %smoothing
    smooth = [zeros(1,x) ; eye(xm), zeros(xm,1)] * 0.1;
    smooth = smooth + eye(x) * 0.80;
    smooth = smooth + [zeros(xm,1), eye(xm) ; zeros(1,x)] * 0.1;
    smooth(1,1) = smooth(1,1) + 0.1;
    smooth(x,x) = smooth(x,x) + 0.1;
    I_rec = smooth * I_rec * smooth;
    
    I_rec(mask == 1) = I(mask == 1);
    %smoothing with box filter
    h = [0 1 0; 1 4 1; 0 1 0];
    h = h / sum(sum(h));
    filtered=imfilter(I_rec,h);
    I_rec(2:x-2,2:x-2)=filtered(2:x-2,2:x-2);

    I_rec(mask == 1) = I(mask == 1);
end

