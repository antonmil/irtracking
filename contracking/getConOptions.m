function opt=getConOptions(w)
% 
% (C) Anton Andriyenko, 2012
%
% The code may be used free of charge for non-commercial and
% educational purposes, the only requirement is that this text is
% preserved within the derivative work. For any other purpose you
% must contact the authors for permission. This code may not be
% redistributed without written permission from the authors.

global scenario;
% tracking on image or on ground plane?
opt.track3d=howToTrack(scenario);

% general
% opt.track3d=1;                  % set to 1 for track estimation on ground plane
opt.verbosity=1;                % 0=silent, 1=short info, 2=long info, 3=all
opt.mex=1;                      % use mex
opt.visOptim=0;                 % visualize optimization
opt.occ=0;                      % compute occlusions [Andriyenko et al. ICCV VS Workshop 2011]
                                % only works for 3d tracking for now!
opt.cutToTA=1;                  % cut detections, ground truth and result to tracking area
opt.remOcc=0;                   % remove occluded GT and result

opt.startsol=6;                 % 1-5 = EKF, 6 = Pirsiavash

% optimization
opt.jumpsOrder=[1 3 4 2 6 5];   % standard: merge grow shrink split add remove
opt.maxEpochs=15;               % max global iterations (rounds)
opt.maxIterCGD=30;              % max iterations for each gradient descent

% appearance options
opt.app.xstrade=2;              % only consider every nth pixel for appearance
opt.app.tstrade=5;              % only consider every nth frame for appearance
opt.app.nbins=16;               % how many bins for histogram
opt.app.filtersigma=1;          % for prefiltering images
opt.app.filtersize=1;           % for prefiltering images
opt.app.ycb=0;                  % ycb or rgb

% how do we scale detections?
opt.detScale.sigA=0; % shift
opt.detScale.sigB=1; % peakiness

% energy weights (default 2d)
opt.wtEdet=1;               % should be kept at 1
opt.wtEdyn=2;
opt.wtEexc=1;
opt.wtEper=1.;
opt.wtEreg=.5;
opt.wtEapp=0;
opt.wtEori=0;
opt.wtEcnt=0;

opt.detThreshold=.0;
opt.detThreshold=.4; % Siyu single TUD
% opt.detThreshold=.7; % Siyu joint TUD
% opt.detThreshold=0.34;
% opt.frames=101:150;
    opt.frames=1:218;
% opt.detThreshold=.4; % Siyu single TUD
opt.frames=1:750;
% opt.frames=1:100;
% opt.frames=250:400;
 
% opt.detThreshold=0.0;
% opt.frames=600:750;
%  opt.detScale.sigA=-1; % shift TUD
% opt.detScale.sigB=1; % peakiness TUD

opt.visOptim=0;
opt.startsol=6;

% PNNL
% opt.wtEdet=1;               % should be kept at 1
% opt.wtEdyn=1;
% opt.wtEexc=.5;
% opt.wtEper=1.5;
% opt.wtEreg=.5;

% PRML
opt.wtEdet=3;               % should be kept at 1
opt.wtEdyn=.2;
opt.wtEexc=2;
opt.wtEper=1;
opt.wtEreg=3;


% PRML Synth
opt.wtEdet=3;               % should be kept at 1
opt.wtEdyn=.2;
opt.wtEexc=2;
opt.wtEper=1;
opt.wtEreg=1;


% energy weights (default 3d)
if opt.track3d
    opt.cutToTA=1;
    
    opt.wtEdet=1;               % should be kept at 1
    opt.wtEdyn=.03;
    opt.wtEexc=.6;
    opt.wtEper=.6;
    opt.wtEreg=.6;
    opt.wtEapp=0;
    opt.wtEori=0.0;
    
    opt.detThreshold=.0;
    opt.detScale.sigA=0; % shift
    opt.detScale.sigB=1; % peakiness
%     opt.frames=219:436;
%     opt=rmfield(opt,'detScale');
%     opt.frames=25:51;
%     opt.startsol=6;
%     opt.jumpsOrder=[6 1 3 4 2 5];   % standard: merge grow shrink split add remove

    % PRML
    opt.wtEdet=5;               % should be kept at 1
    opt.wtEdyn=.01;
    opt.wtEexc=2;
    opt.wtEper=4;
    opt.wtEreg=2;
    opt.lambda=0.25;
    
    opt.wtEdet=1;
    opt.wtEdyn=.2/3;
    opt.wtEexc=2/3;
    opt.wtEper=1/3;
    opt.wtEreg=1;
    
    opt.wtEdet=1;
    opt.wtEdyn=6e-4;
    opt.wtEexc=.8;
    opt.wtEper=0.08;
    opt.wtEreg=.02;   
    opt.lambda=0.004;
    
%     opt.wtEdet=1;
%     opt.wtEdyn=0.0076;
%     opt.wtEexc=9.5871;
%     opt.wtEper=0.7857;
%     opt.wtEreg=0.2363;   
%     opt.lambda=0.0466;    
    
%     opt.frames=100:150;
end

if isdeployed
    if isfield(opt,'frames')
        opt=rmfield(opt,'frames');
    end
end
    

% other parameters
if ~isfield(opt,'lambda')
    opt.lambda=0.1;
end
% opt.lambda=0.075;
% opt.lambda=0.00;

if nargin==1
    opt.wtEdet=w(1);               % should be kept at 1
    opt.wtEdyn=w(2);
    opt.wtEexc=w(3);
    opt.wtEper=w(4);
    opt.wtEreg=w(5);
    opt.wtEapp=w(6);
    opt.wtEori=w(7);
    opt.lambda=w(8);
end


% opt.wtEdet=1;
% opt.wtEdyn=1;
% opt.wtEexc=1;
% opt.wtEper=1;
% opt.wtEreg=1;
% opt.frames=1:50;



end
