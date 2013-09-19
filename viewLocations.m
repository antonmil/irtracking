function [x, y]=viewLocations(indata, ts, fr)

% parse in parameter
readings=parseData(indata);
[x, y]=linLocEst(readings);
[x, y]=linCCLocEst(readings);

[x, y]=sensorLocEst(readings);

% figure out how many time steps
[F, ~]=size(readings);

% get coordinates
[xc, yc]=getSensorCoordinates;
sceneInfo=getSceneInfo(301);

% if time known, try to sync
imgdir1='data/webcams/c1/';
allfiles1=dir(fullfile(imgdir1,'*.jpg'));
alltimestamps1=[allfiles1(:).datenum];

for l=1:length(allfiles1)
    [~,fname,~]=fileparts(allfiles1(l).name);
    alltimestamps1(l)=datenum(fname,'YYYYmmdd-HHMMSS');
end

imgdir2='data/webcams/c2/';
allfiles2=dir(fullfile(imgdir2,'*.jpg'));
alltimestamps2=[allfiles2(:).datenum];

for l=1:length(allfiles2)
    [~,fname,~]=fileparts(allfiles2(l).name);
    alltimestamps2(l)=datenum(fname,'YYYYmmdd-HHMMSS');
end

timeshift=57; % shift images
frRate=2;

h=findobj('type','figure','name','ViewLocs');
if isempty(h)
    figure('name','ViewLocs');
else
    figure(h);
end

showframes=1:F;
if nargin==3
    showframes=fr;
end
for t=showframes
    
    clf;hold on;
    
    if nargin>1
        subplot(2,2,[1 3]);
        hold on;
    end
    
    im=imread([sceneInfo.imgFolder sprintf(sceneInfo.imgFileFormat,sceneInfo.frameNums(1))]);
    xIm=sceneInfo.trackingArea([1 2]); xIm=repmat(xIm,2,1);
    yind=[4 3];
    yIm=sceneInfo.trackingArea(yind); yIm=repmat(yIm,2,1);yIm=yIm';
    zIm=zeros(2,2);
    surf(xIm,yIm,zIm,'CData',im,'FaceColor','texturemap');
    
    plotSensorCoordinates;
    
    
    active=find(readings(t,:));
%     plot(xc(active),yc(active),'r.');
    plot(xc(active),yc(active),'ro','MarkerSize',30);
    plot(x(t,:),y(t,:),'+');
    xlim([0 8000]); ylim([0 14000]);
    
    titlestr=sprintf('fr. %d',t);
    if nargin>1
        meastime = datevec(ts);
        
        meastime(6) = meastime(6) - timeshift;
        meastime(6) = meastime(6) + (t-1)/frRate;
        
        meastime = datenum(meastime);
        
        titlestr=sprintf('fr. %d, %s',t,datestr(meastime));
    end
    title(titlestr);
%     pause(.1);
    

    if nargin>1
        subplot(2,2,2);      cla;
        
        % measurement timestamp
%         datestr(ts)

%         datestr(meastime)
        
        [~, closestIm] = min(abs(alltimestamps1-meastime));
%         datestr(allfiles1(closestIm).date)
        
        im=imread(fullfile(imgdir1,allfiles1(closestIm).name));        
        imagesc(im);
        set(gca,'XTick',[]);set(gca,'YTick',[]);
        titlestr=sprintf('%s',datestr(alltimestamps1(closestIm)));
        
        subplot(2,2,4);      cla;
        
        % measurement timestamp
%         datestr(ts)

%         datestr(meastime)
        
        [~, closestIm] = min(abs(alltimestamps2-meastime));
%         datestr(allfiles2(closestIm).date)
        
        im=imread(fullfile(imgdir2,allfiles2(closestIm).name));        
        imagesc(im);
        set(gca,'XTick',[]);set(gca,'YTick',[]);
        titlestr=sprintf('%s',datestr(alltimestamps2(closestIm)));
        
%         title(titlestr);
%         pause(.1)
    end
    pause(.1);
    
end