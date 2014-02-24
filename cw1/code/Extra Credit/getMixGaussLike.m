function like = getMixGaussLike(data,MoGEst)
%the goal of this routine is to calculate the log likelihood for the whole
%data set under a mixture of Gaussians model. We calculate the log as the
%likelihood will probably be a very small number that Matlab may not be
%able to represent.


%find total number of data items
nData = size(data,2);

%run through each data item
    for(cData = 1:nData)
        thisData = data(:,cData);    
        %calculate likelihood of this data point under mixture of Gaussians model
        like = 0;
        for i = 1:MoGEst.k
            normal = getGaussProb(thisData,MoGEst.mean(:,i),MoGEst.cov(:,:,i));
            like = like+(MoGEst.weight(i)).*normal;
        end
    end
end


%==========================================================================
%==========================================================================
function prob = getGaussProb(x,mean,var)
    %return gaussian probabilities
    x_length = length(x);
    prob = 1./((2*pi)^x_length*det(var))^0.5*exp(-0.5*(x-mean)'*(var^(-1))*(x-mean));
end