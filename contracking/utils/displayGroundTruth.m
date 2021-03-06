function displayGroundTruth(sceneInfo, gtInfo)
% Display Ground Truth
%
% Take scene information sceneInfo and
% the ground truth from gtInfo
% 
% (C) Anton Andriyenko, 2012
%
% The code may be used free of charge for non-commercial and
% educational purposes, the only requirement is that this text is
% preserved within the derivative work. For any other purpose you
% must contact the authors for permission. This code may not be
% redistributed without written permission from the authors.

if nargin==1 && ~isstruct(sceneInfo)
    global gtInfo opt;
    sceneInfo=getSceneInfo(sceneInfo);
    opt.track3d
    opt.cutToTA
    
end
W=gtInfo.W;
H=gtInfo.H;


options.defaultColor=[.1 .2 .9];
options.grey=.7*ones(1,3);
options.framePause=0.1/sceneInfo.frameRate; % pause between frames

options.traceLength=10; % overlay data from past 10 frames
options.predTraceLength=0;
options.dotSize=20;
options.boxLineWidth=2;
options.traceWidth=2;
options.predTraceWidth=1;

options.hideBG=0;

% what to display
options.displayDots=0;
options.displayBoxes=1;
options.displayID=1;
options.displayCropouts=0;
options.displayConnections=0;
options.displayIDSwitches=0;
options.displayFP=0;
options.displayFN=0;
options.displayMetrics=0;
options.displayDets=0;

Xi=gtInfo.Xi; Yi=588-gtInfo.Yi;

% save?
%  options.outFolder='tmp/gt';
% options.outFolder=sprintf('tmp/gt/s%d',sceneInfo.scenario);
if isfield(options,'outFolder') && ~exist(options.outFolder,'dir')
    mkdir(options.outFolder)
end

reopenFig('Ground Truth');
displayBBoxes(sceneInfo,gtInfo.frameNums,Xi,Yi,W,H,options)

end