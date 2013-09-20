function plotSensorCoordinates
%%
[xc, yc]=getSensorCoordinates;
% clf;
% hold on
% r=300;
for s=1:43
    plot(xc(s),yc(s),'k.');
%     plot(xc(s),yc(s),'o');
%     rectangle('Position',[xc(s),yc(s),150,150],'Curvature',[1,1]);
%     text(xc(s)+50,yc(s)+100,sprintf('%i',s));
end