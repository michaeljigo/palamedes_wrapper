function t2_update
   addpath('../code');

% Here we go over how to update the adaptive procedure on a trial-by-trial basis.

% 1. Create the Palamedes structure as shown in 01_setup
params.whichStair        = 1;
params.alphaRange        = linspace(0,45,1e2);
params.fitBeta           = 2;
params.fitLambda         = 0.01;
params.fitGamma          = 0.5;
params.threshPerformance = 0.75;
params.PF                = @arbWeibull;
adapt                    = usePalamedes(params);


% 2. Update the procedure based on observer responses
response = 1;                             % the response input is a binary variable (0 or 1). 0=incorrect; 1=correct.
adapt    = usePalamedes(adapt,response);  % notice that the inputs are the Palamedes structure and the response


% 3. Track important variables in the Palamedes structure 'adapt'
%
% 'adapt' has many fields, I only highlight two below:
%
%-------------------------------------------------------
%  NAME                 DESCRIPTION
%-------------------------------------------------------
%  .xCurrent            current estimate of stimulus threshold
%  .x                   vector of stimulus values displayed on preceeding trials
%  .pdf                 posterior distribution of stimulus threshold
%  .prior               prior distribution of stimulus threshold
%
% You will use the values in the above fields to assess whether the adaptive procedure appropriately converged.
