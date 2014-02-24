function [TPR, FPR] = my_roc( targets,outputs )
% MY_ROC this function returns the true positive rate (TPR) and false positive rate (FPR)
% by calculating the input target image and output image
%   true positive (TP): a pixel of target image is 1, a pixel of output image is 1
%   false positive (FP): a pixel of target image is 0, a pixel of output image is 1
%   true positive rate: TPR = TP/P
%   false positive rate: FPR = FP/N

targets = double(targets);
outputs = double(outputs);
[m n] = size(targets);

% P positive instances 
P = sum(sum(targets));
% N negative instances
N = m*n - sum(sum(targets));

%TP fraction (sensitivity) / true positive rate (TPR) is:
%The number of 1 in the matrix of targets(BW) matrix .* outputs(T) matrix
%Example: targets(x) = 1; outputs(x) = 1, targets(x) .* outputs(x) = 1, it is a True Positive point
TP_matrix = targets .* outputs;
TP = sum(sum(TP_matrix));
TPR = TP/P;

%FP fraction (1-specicity)/ false positive rate (FPR) is: 
%The number of -1 in the matrix of targets(BW) matrix - outputs(T) matrix
%Example: targets(x) = 0; outputs(x) = 1, targets(x) - outputs(x) = -1, it is a False Positive point
FP_matrix = targets - outputs;
FP = length(find(FP_matrix == -1));
FPR = FP/N;

%figure,plot(FPR,TPR)

end

