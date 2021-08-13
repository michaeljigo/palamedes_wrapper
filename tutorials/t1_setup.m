function t1_setup
   addpath('../code');

% Here we go over how to set up the Palamedes structure and also highlight
% the parameters that control the adaptive procedure's behavior during your experiment.


%%%%%%%%%%%%%%%%%%%%
%%%%%% SETUP  %%%%%%
%%%%%%%%%%%%%%%%%%%%

% 1. Create the 'params' structure. If a parameter is not set, as shown below, a default value will be used.
params.whichStair        = 1;
params.alphaRange        = linspace(0,1,1e2);
params.fitBeta           = 2;
params.fitLambda         = 0.01;
params.fitGamma          = 0.5;
params.threshPerformance = 0.75;
params.PF                = @arbWeibull;

% 2. Input the structure into usePalamedes
adapt = usePalamedes(params);

% 3. The output, 'adapt', is a Palamedes structure initialized to control an adaptive procedure.


%%%%%%%%%%%%%%%%%%%%
%%%% PARAMETERS %%%%
%%%%%%%%%%%%%%%%%%%%

% 'params' is a structure. Each field is a separate parameter that controls the adaptive procedure.
% Available fields are:
%-------------------------------------------------------
%  NAME                    INPUT             DESCRIPTION
%-------------------------------------------------------
%  .whichStair             1 or 2            1 = best PEST; 2 = QUEST
%  .alphaRange             nx1 vector        range of possible threshold stimulus values
%  .fitBeta                scalar            slope of psychometric function
%  .fitLambda              scalar            lapse rate 
%  .fitGamma               scalar            chance level (guess rate) 
%  .threshPerformance      scalar            target performance level (must be specified if using arbWeibull, see PF)
%  .lastPosterior          nx1 vector        posterior probability distribution from an earlier run of the procedure
%  .PF                     string            shape of underlying psychometric function. can be: PAL_Weibull, PAL_Quick, PAL_Gumbel, PAL_HyperbolicSecant, PAL_Logistic, or arbWeibull(default)
%  .updateAfterTrial       integer           if >0, the adaptive method will not use posterior-based estimates until the trial number matches the input for this variable 
%  .preUpdateLevels        nx1 vector        stimulus levels tested before adaptive procedure is updated
%  .questMean              scalar            average stimulus value of prior distribution (only for QUEST)
%  .questSD                scalar            standard deviation of prior distribution (only for QUEST)


% Done.
