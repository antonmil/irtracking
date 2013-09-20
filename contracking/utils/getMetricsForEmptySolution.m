function [metrics2d metrics3d m2i m3i addInfo2d addInfo3d]=getMetricsForEmptySolution()
% 
% (C) Anton Andriyenko, 2012
%
% The code may be used free of charge for non-commercial and
% educational purposes, the only requirement is that this text is
% preserved within the derivative work. For any other purpose you
% must contact the authors for permission. This code may not be
% redistributed without written permission from the authors.

% zero metrics
zerosol=struct('frameNums',zeros(0,1),'X',[],'Y',[],'Xi',[],'Yi',[],'Xgp',[],'Ygp',[],'W',[],'H',[]);
[metrics2d m2i addInfo2d]= CLEAR_MOT(zerosol,zerosol);
[metrics3d m3i addInfo3d]= CLEAR_MOT(zerosol,zerosol);