% ----------------------------------------------------------------------
% out =  simPalamedes(stairParams,obsParams,simParams)
% ----------------------------------------------------------------------
%
% Purpose:  Simulate (modified) Palamedes titration procedures.
%           All three inputs are required to run a simulation.
%
% ----------------------------------------------------------------------
% Input
% stairParams           : structure containing parameters (listed below) to control ADAPTIVE METHOD
%     whichStair        : 1=best PEST; 2=QUEST     (default=1)
%     alphaRange        : vector of possible threshold stimulus values  (default=0.01:0.01:1)
%     fitBeta           : slope of underlying psychometric function     (default=2)
%     fitLambda         : lapse rate (i.e., 1-upper asymptote) of psychometric function (default=0.01)
%     fitGamma          : guess rate (i.e., lower asymptote) of psychometric function   (default=0.5)
%     threshPerformance : target threhsold performance (must be specified if using arbWeibull, see PF)
%     lastPosterior     : posterior distribution from earlier run. when inputted, adaptive method will continue where previous run stopped (default=[])
%     PF                : shape of underlying psychometric function. can be: PAL_Weibull, PAL_Quick, PAL_Gumbel, PAL_HyperbolicSecant, PAL_Logistic, or arbWeibull(default)
%     updateAfterTrial  : if >0, the adaptive method will not use posterior-based estimates until the trial number matches the input for this variable (default=0)
%     preUpdateLevels   : these are the stimulus levels that will be tested before the adaptive method is updated (only works if updateAfterTrial>1)
%     questMean         : center of prior distribution for QUEST procedure
%     questSD           : standard deviation of prior distribution for QUEST procedure
%
% obsParams             : structure with parameters (listed below) to control OBSERVER
%     fitBeta           : slope of underlying psychometric function     (default=2)
%     fitLambda         : lapse rate (i.e., 1-upper asymptote) of psychometric function (default=0.01)
%     fitGamma          : guess rate (i.e., lower asymptote) of psychometric function   (default=0.5)
%     fitAlpha          : obsever's threshold (default=0.1);
%     threshPerformance : target performance (must be specified if using arbWeibull, see PF)
%     PF                : psychometric function (e.g., @arbWeibull)
%
% simParams             : structure with parameters (listed below) to control SIMULATION
%     nTrials           : number of simulated trials
%     nRuns             : number of titration runs to simulate
% ----------------------------------------------------------------------
%
% Output(s)
%                       UPDATE THIS
%                       WHEN CODE I KNOW
%                       WHAT I'M DOING
%
% ----------------------------------------------------------------------
% Function created by Michael Jigo
% Last update : August 16, 2021
% ----------------------------------------------------------------------

function out = simPalamedes(stairParams,obsParams,simParams)

   %% Initialize titration procedure

   %% Initialize observer 
      % format parameters
         params = [obsParams.fitAlpha, obsParams.fitBeta obsParams.fitGamma obsParams.fitLambda];

      % set observer function
      if isequal(obsParams.PF,@arbWeibull) || isequal(obsParams.PF,@arbLogistic)
         obs   = @(stimVal,params) obsParams.PF(params,stimVal,obsParams.threshPerformance);
      else
         obs   = @(stimVal,params) obsParams.PF(params,stimVal);
      end

   %% Simulate runs
      for r = 1:simParams.nRuns
         % initialize titration procedure
            titr(r)  = usePalamedes(stairParams);

         % loop through trials
         for t = 1:simParams.nTrials
            % current stimulus value
               stimVal  = titr(r).xCurrent;

            % observer response
               pCorr    = obs(stimVal,params);
               crit     = rand(1);
               %noise    = randn(1)*obsParams.noiseScale;
               noise    = 0;
               resp     = pCorr+noise>=crit;

            % update titration
               titr(r)  = usePalamedes(titr(r),resp);
         end
      end


   %% Summarize runs
      for r = 1:simParams.nRuns
         propEst        = 0.4; % proportion of data included in summary estimates 
         propIdx        = round(simParams.nTrials*(1-propEst)):simParams.nTrials;
         xCurrent(r)    = titr(r).xCurrent;
         pCorr(r)       = mean(titr(r).response(propIdx));
         threshEst(r)   = mean(titr(r).x(propIdx));
         runCourse(r,:) = titr(r).x;
      end


   %% Format output
      % run data
         out.runs.xCurrent    = xCurrent;
         out.runs.threshEst   = threshEst;
         out.runs.pCorr       = pCorr;
         out.runs.propEst     = propEst;
         out.runs.trialsEst   = propEst*simParams.nTrials;
         out.runs.runCourse   = runCourse;

      % 95% confidence intervals & median
         fields = fieldnames(out.runs);
         for f = 1:numel(fields)
            out.(fields{f})   = quantile(out.runs.(fields{f}),[0.025 0.5 1-0.025]);
         end
