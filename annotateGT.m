%% annotateGT
id=8;

for t=[150:5:F F]

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