function [metrics2d, metrics3d, addInfo2d, addInfo3d]= ...
    printFinalEvaluation(stateInfo, gtInfo, sceneInfo, opt)
% 
% (C) Anton Andriyenko, 2012
%
% The code may be used free of charge for non-commercial and
% educational purposes, the only requirement is that this text is
% preserved within the derivative work. For any other purpose you
% must contact the authors for permission. This code may not be
% redistributed without written permission from the authors.

% zero metrics
[metrics2d, metrics3d, addInfo2d, addInfo3d]=getMetricsForEmptySolution();
% global do2d

if sceneInfo.gtAvailable
%     if do2d
    printMessage(1,'\nEvaluation 2D:\n');
    [metrics2d, metricsInfo2d, addInfo2d]=CLEAR_MOT(gtInfo,stateInfo);
    printMetrics(metrics2d,metricsInfo2d,1);
%     end
    
    metrics3d=zeros(size(metrics2d));
    if opt.track3d
        printMessage(1,'\nEvaluation 3D:\n');
        evopt.eval3d=1;
        [metrics3d, metricsInfo3d, addInfo3d]=CLEAR_MOT(gtInfo,stateInfo,evopt);
        printMetrics(metrics3d,metricsInfo3d,1);
        
    end    
end

%     [MOTA MOTP ma fpa mmea idsw missed falsepos idsw alltracked allfalsepos ...
%         MT PT ML recall precision fafrm FRA MOTAL alld]=CLEAR_MOT_mex(gtInfo.Xi, gtInfo.Yi,
