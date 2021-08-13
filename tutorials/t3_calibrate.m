function t3_calibrate
   addpath('../code');

% Here we go over how to calibrate the adaptive procedure to obtain consistently reliable thresholds.
%
% This is a bit of a hack that I've worked on through trial and error across 3 published psychophysics experiments
% and across too many pilot sessions to count. It works by broadly surveying the space of stimulus values and building up the 
% posterior distribution based on the observer's responses. In this way, the adaptive procedure has an idea (albeit vague) of 
% the observer's threshold before taking control of stimulus presentation.
%
% NOTE: This hack only works for the arbitrary psychometric functions (e.g., @arbWeibull)
%
% If you have any suggestions for how to improve this
% please let me know (jigomich@gmail.com).



% 1. Create the Palamedes structure as shown in 01_setup
params.whichStair        = 1;
params.alphaRange        = linspace(0.5,45,1e2);
params.fitBeta           = 2;
params.fitLambda         = 0.01;
params.fitGamma          = 0.5;
params.threshPerformance = 0.75;
params.PF                = @arbWeibull;
   % ..but this time we use the options that allow for calibration
   params.updateAfterTrial = 10;                                    % stimulus values on these trials will be experimenter-controlled
   params.preUpdateLevels  = randi(45,1,params.updateAfterTrial);   % these are the stimulus values we choose to show the observer
% create the Palamedes structure
adapt                    = usePalamedes(params);


% 2. When the Palamedes structure is updated, the stimulus values shown to the obeserver will adhere to the preUpdateLevels until after the 10th trial
for trial = 1:20
   response = rand>0.5;
   adapt    = usePalamedes(adapt,response); 
end

% 3. Look at the 'adapt.x' field and notice that the first 10 trials follow exactly the order specified in 'preUpdateLevels'.
%    The choice of 'preUpdateLevels' is completely arbitrary and does not need to be in a sequential order. It can be random.
%    After the specified # of trials, the adaptive procedure then takes over and displays stimulus values corresponding to the
%    expected value of the posterior distribution.
