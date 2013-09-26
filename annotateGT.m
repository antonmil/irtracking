%% annotateGT
id=6;

for t=[40:3:F F]

[X, Y]=viewLocationsAndCams(readings,ts,t);

h=findobj('type','figure','name','Annotate');
if isempty(h)
    figure('name','Annotate');
else
    figure(h);
end

clf;hold on;


im=imread([sceneInfo.imgFolder sprintf(sceneInfo.imgFileFormat,sceneInfo.frameNums(1))]);
xIm=sceneInfo.trackingArea([1 2]); xIm=repmat(xIm,2,1);
yind=[4 3];
yIm=sceneInfo.trackingArea(yind); yIm=repmat(yIm,2,1);yIm=yIm';
zIm=zeros(2,2);
surf(xIm,yIm,zIm,'CData',im,'FaceColor','texturemap');

plotSensorCoordinates;

[xc, yc, bu]=ginput(1);
if bu==1
    Xgt(t,id)=xc;
    Ygt(t,id)=yc;
end
end
% save('r1-medium_gt-raw.mat','Xgt','Ygt');
% [Xgt, Ygt]=interpGT(Xgt,Ygt);
% save('r1-medium_gt.mat','Xgt','Ygt');
% saveToCVML(Xgt,Ygt,'data/r1-medium_gt.xml',1,25);