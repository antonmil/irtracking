function prepFigure()
% prepare figure for showing state
% 
% (C) Anton Andriyenko, 2012
%
% The code may be used free of charge for non-commercial and
% educational purposes, the only requirement is that this text is
% preserved within the derivative work. For any other purpose you
% must contact the authors for permission. This code may not be
% redistributed without written permission from the authors.

global sceneInfo opt scenario;

% figh=findobj('type','figure','name','optimization');

% if isempty(figh), figh=figure('name','optimization'); end
% set(figh);

clf;
hold on;
box on

if ~opt.track3d
    set(gca,'Ydir','reverse');
end
xlim(sceneInfo.trackingArea(1:2))
ylim(sceneInfo.trackingArea(3:4))
if ~opt.track3d
    ylim([sceneInfo.imTopLimit sceneInfo.trackingArea(4)]);
end

zlim([0 length(sceneInfo.frameNums)])

view(-78,4)
if ~opt.track3d
    view(8,12);
end

% PRML
if scenario>300 && scenario<400
    im=imread([sceneInfo.imgFolder sprintf(sceneInfo.imgFileFormat,sceneInfo.frameNums(1))]);
    xIm=sceneInfo.trackingArea([1 2]); xIm=repmat(xIm,2,1);
    yind=[3 4]; if opt.track3d, yind=[4 3]; end
    yIm=sceneInfo.trackingArea(yind); yIm=repmat(yIm,2,1);yIm=yIm';
    zIm=zeros(2,2);
    surf(xIm,yIm,zIm,'CData',im,'FaceColor','texturemap');
end

end