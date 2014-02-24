function r=Practical9b
% Part b: Condensation
%
% Now, we will track a given shape (template) as it moves in a sequence of
% frames. Our shape/appearance model is trivial: just a template, given.
% We will only explore simple motion models. Such models may
% contain a variable that switches between cars and pedestrians, or traffic
% in different directions, or accelerating etc.
% 
% Note: depending on the motion model, the state w will have different
% numbers of dimensions (not just 2, though that's the default). 
%
% Most of this algorithm should be copied from Part a. An important
% difference is that now we'll actually compute the likelihood using the
% (provided) MeasurePatchSimilarityHere() function.
%
%
% Complete reamining TO DO parts you didn't answer in Part a, run the code 
% over the sequence, and observe the results. 
%
% Then TO DO:
% - Try varying the number of particles: 2000, 500, 100,...
% - Change the state to have 2 more degrees of freedom: velX and velY.
%   (This will require you to change how state-predictions are made, and 
%   how they are converted to measurement-space)
% - Visualize the top-scoring particles (more than just 1!)


% Load template and starting position ('pos'), which come from frame 871.
clc
close all
load Template
pedestrian = imread('pedestrian.png');
pedestrian = double(pedestrian);

% Load images from the rest of the sequence
% Warning: this is VERY memory-wasteful! Would normally load-as-we-go.
Imgs = cell(22,1);
iFrame = 0;
for (frameNum = 872:894)
    sImName = sprintf( 'HillsRdSkipFrames_%.7d.png', frameNum );
    iFrame = iFrame + 1;
    Imgs{iFrame} = imread( sImName );
end;
imgWidth = size(Imgs{1}, 2);
imgHeight = size(Imgs{1}, 1);


numParticles = 500;
weight_of_samples1 = ones(numParticles,1);
weight_of_samples2 = ones(numParticles,1);

% TO DO: normalize the weights (may be trivial this time)
weight_of_samples1 = weight_of_samples1./sum(weight_of_samples1);
weight_of_samples2 = weight_of_samples2./sum(weight_of_samples2);

% Initialize which samples from "last time" we want to propagate: all of
% them!:
samples_to_propagate1 = [1:numParticles]';
samples_to_propagate2 = [1:numParticles]';

% ============================
% NOT A TO DO: You don't need to change the code below, but eventually you may
% want to vary the number of Dims.
numDims_w = 4;
% Here we randomly initialize some particles throughout the space of w:
particles_old = rand( numParticles, 4);
particles_old(:,1) = particles_old(:,1) * imgHeight;
particles_old(:,2) = particles_old(:,2) * imgWidth;
particles_old(:,3) = particles_old(:,3) * imgHeight;
particles_old(:,4) = particles_old(:,4) * imgWidth;
% ============================


hImg = figure;
hSamps = figure;

% $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
% $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
% Was our "Loop from here" point in Part a.

for( iTime = 1:22 )

    % TO DO: compute the cumulative sume of the weights. You could refer to
    % the MATLAB built-in function 'cumsum'.
    cum_hist_of_weights1 = cumsum(weight_of_samples1);
    cum_hist_of_weights2 = cumsum(weight_of_samples2);

    % ==============================================================
    % Resample the old distribution at time t-1, and select samples, favoring
    % those that had a higher posterior probability.
    % ==============================================================
    samples_to_propagate1 = zeros(numParticles,1);
    samples_to_propagate2 = zeros(numParticles,1);
    % Pick random thresholds (numParticles X 1 matrix) in the cumulative
    % probability's range [0,1]:
    some_threshes = rand(numParticles,1);


    % For each random threshold, find which sample in the ordered set is
    % the first one to push the cumulative probability above that
    % threshold, e.g. if the cumulative histogram goes from 0.23 to 0.26
    % between the 17th and 18th samples in the old distribution, and the
    % threshold is 0.234, then we'll want to propagate the 18th sample's w
    % (i.e. particle #18).
    
    for (sampNum = 1:numParticles) 
        thresh = some_threshes(sampNum);
        for (index = 1:numParticles)
            if( cum_hist_of_weights1(index) > thresh )
                break;
            end;
        end;
        samples_to_propagate1(sampNum) = index;
    end;
    for (sampNum = 1:numParticles) 
        thresh = some_threshes(sampNum);
        for (index = 1:numParticles)
            if( cum_hist_of_weights2(index) > thresh )
                break;
            end;
        end;
        samples_to_propagate2(sampNum) = index;
    end;
    % Note: it's ok if some of the old particles get picked repeatedly, while
    % others don't get picked at all.


    % =================================================
    % Visualize
    % =================================================
    set(0,'CurrentFigure',hSamps)
    set(gcf,'Position',[23 125 640 480]);
    set(gcf,'Color',[1 1 1]);
    set(gca,'Box','Off');
    title('Cumulative histogram of probabilities for sorted list of particles');
    plot(zeros(numParticles,1), some_threshes,'b.','MarkerSize',15);
    hold on;
    plot([1:numParticles], cum_hist_of_weights1, 'ro-', 'MarkerSize',3);
    plot([1:numParticles], cum_hist_of_weights2, 'bo-', 'MarkerSize',3);
    which_sample_ids1 = unique(samples_to_propagate1);
    how_many_of_each1 = histc(samples_to_propagate1, unique(samples_to_propagate1));
    for( k=1:size(which_sample_ids1,1) )
        plot( which_sample_ids1(k), 0, 'bo-', 'MarkerSize', 3 * how_many_of_each1(k) )
    end;
    which_sample_ids2 = unique(samples_to_propagate2);
    how_many_of_each2 = histc(samples_to_propagate2, unique(samples_to_propagate2));
    for( k=1:size(which_sample_ids2,1) )
        plot( which_sample_ids2(k), 0, 'go-', 'MarkerSize', 3 * how_many_of_each2(k) )
    end;
    xlabel(sprintf( 'Indeces of all available samples, with larger blue circles for frequently re-sampled particles\n(Iteration %d)', iTime));
    ylabel('Cumulative probability');
    hold off
    xlim([0 numParticles]);ylim([0 1]);
    drawnow
    % =================================================
    % =================================================


    % Predict where the particles we plucked from the old distribution of 
    % state-space will go in the next time-step. This means we have to apply 
    % the motion model to each old sample.

    particles_new = zeros( size(particles_old) );
    col = size(particles_old,2);
    for (particleNum = 1:numParticles)
        
        % TO DO: Incorporate some noise, e.g. Gaussian noise with std 10,
        % into the current location (particles_old), to give a Brownian
        % motion model.
        noise = normrnd(0,10,[1 col]);
        particles_new(particleNum,:) = particles_old( samples_to_propagate1(particleNum),: ) + noise;
        particles_new(particleNum,:) = round(  particles_new(particleNum,:)  ); % Round the particles_new to simplify Likelihood evaluation.
    end;
    % TO DO: Not initially, but change the motion model above to have
    % different degrees of freedom, and optionally completely different
    % motion models.

    
    Im2 = double( Imgs{iTime} );
    
    set(0,'CurrentFigure',hImg)
    imagesc(Im2/255)
    colormap(gray);
    set(gcf,'Position',[23 125 640 480]);
    set(gcf,'Color',[1 1 1]);
    title(sprintf( 'Particles projected to measurement-space\n(Time %d)', iTime));
    hold on
    plot(particles_new(:,2), particles_new(:,1), 'rx')
    plot(particles_new(:,4), particles_new(:,3), 'bx')
    hold off
    drawnow

    % Optional code to save out figure:
        pngFileName = sprintf( '%s_%.5d.png', 'myOutput', iTime );
        saveas(gcf, pngFileName, 'png');

    
    % From here we incorporate the data for the new state (time t):
    % The new particles accompanying predicted locations in state-space
    % for time t, are missing their weights: how well does each particle
    % explain the observations x_t?
    for (particleNum = 1:numParticles)

        % Convert the particle from state-space w to measurement-space x:
        % Note: that step is trivial here since both are in 2D space of image
        % coordinates

        %particle1: car wheel
        particle1 = particles_new(particleNum,1:2);
        s1 = size(pixelsTemplate);
        inFrame1 = particle1(1) >= 1.0   &&  particle1(1)+ s1(1) <= imgHeight && ...
                particle1(2) >= 1.0   &&  particle1(2) + s1(2) <= imgWidth;
        if( inFrame1 )
            minX = particles_new(particleNum,2);
            minY = particles_new(particleNum,1);
    
            weight_of_samples1(particleNum) = ...
                MeasurePatchSimilarityHere( Im2, pixelsTemplate, minY, minX );
        else
            weight_of_samples1(particleNum) = 0.0;
        end;
        
        %particle2: pedestrian
        particle2 = particles_new(particleNum,3:4);
        s2 = size(pedestrian);
        inFrame2 = particle2(1) >= 1.0   &&  particle2(1)+ s2(1) <= imgHeight && ...
                particle2(2) >= 1.0   &&  particle2(2) + s2(2) <= imgWidth;
        if( inFrame2 )
            velX = particles_new(particleNum,4);
            velY = particles_new(particleNum,3);
    
            weight_of_samples2(particleNum) = ...
                MeasurePatchSimilarityHere( Im2, pedestrian, velY, velX );
        else
            weight_of_samples2(particleNum) = 0.0;
        end;
        
      
    end;

    % TO DO: normalize the weights 
    weight_of_samples1 = weight_of_samples1./(sum(weight_of_samples1));
    weight_of_samples2 = weight_of_samples2./(sum(weight_of_samples2));

    % Now we're done updating the state for time t. 
    % For Condensation, just clean up and prepare for the next round of 
    % predictions and measurements:
    particles_old = particles_new;
    clear particles_new;

end; % End of for loop over each frame in the sequence
