% function [X,Y]=createPaths

clf;
xlim([0 8000]);
ylim([0 14000]);
hold on;
im=imread('D:\prml\irtracking\data\img\frame_00001.jpg');
    xIm=[1 8000]; xIm=repmat(xIm,2,1);
    yIm=[14000 1]; yIm=repmat(yIm,2,1);yIm=yIm';
    zIm=zeros(2,2);
    
    plotSensorCoordinates;

    drawnow;
    surf(xIm,yIm,zIm,'CData',im,'FaceColor','texturemap');
    

button=0;
id=0;
X=[];Y=[];
while button~=3
    id=id+1;
    % tracks
%     while button~=3
    randnum=randi(20)+10
        [x, y, button]=ginput(randnum);
%     end
    nPts=length(x);
    X(1:nPts,id)=x;
    Y(1:nPts,id)=y;
    plot(x,y);
end

%%
N=size(X,2);
maxlength=0;
lengths=zeros(1,N);
for id=1:N
    exfr=find(X(:,id));
    l=0;
    for t=exfr(1):exfr(end-1)
        l=l+sqrt((X(t,id)-X(t+1,id))^2+(Y(t,id)-Y(t+1,id))^2);
    end
    lengths(id)=l;
    
end

maxlength=max(lengths); % max length of a path in mm
maxt=ceil(maxlength/1000); % max duration is sec.

F=0;
frameRate=2;
Xipol=[]; Yipol=[];
for id=1:N
    exfr=find(X(:,id)); % find existing frames
    speed=500+randn*100;
    tSteps=ceil(frameRate*(lengths(id)/speed)); % how many time steps
    tr=1:tSteps;
    % snap to start or end of sequence
%     if rand>.5
%     end
%     tr=tr + randi(max(1,ceil(maxt*frameRate)-tSteps)); % move randomly in time
    Xipol(tr,id)=interp1(linspace(1,tSteps,length(exfr)),X(exfr,id),1:tSteps,'cubic')';
    Yipol(tr,id)=interp1(linspace(1,tSteps,length(exfr)),Y(exfr,id),1:tSteps,'cubic')';
end

% remove zero rows
keeprows=~~sum(Xipol,2);
Xipol=Xipol(keeprows,:);Yipol=Yipol(keeprows,:);
plot(Xipol,Yipol,'.')

% fill in readings
[xc, yc]=getSensorCoordinates;

nS=length(xc);
[F, N]=size(Xipol);
readings=zeros(F,50);
for t=1:F
    extar=find(Xipol(t,:));
    for s=1:nS
        for id=extar
            d=norm([Xipol(t,id)-xc(s) Yipol(t,id)-yc(s)]);
            if d<750
                readings(t,s)=s;
            end
        end
    end
end
size(readings)
seq_data_file='s1-easy';
data_output_file=sprintf('d:/prml/irtracking/data/%s.txt',seq_data_file);

% date
fid=fopen(data_output_file,'w');
fprintf(fid,'%d-%d-%d %0d:%0d:%0d',round(dv));
fclose(fid);
dlmwrite(data_output_file,readings,'-append','delimiter',' ');
fprintf('synthetic data saved to %s\n',data_output_file);

%%
% [X, Y]=linLocEst(readings);
% [X, Y]=linCCLocEst(readings);
[X, Y]=sensorLocEst(readings);
detMat=detsToDetmats(X,Y,25);
detState=detmatToState(detMat);
saveToCVML(X,Y,sprintf('d:/prml/irtracking/data/%s.xml',seq_data_file),0,25);
saveToCVML(Xipol,Yipol, sprintf('d:/prml/irtracking/data/%s_gt.xml',seq_data_file),1,25);
delete(sprintf('d:/prml/irtracking/data/%s.mat',seq_data_file));
delete(sprintf('d:/prml/irtracking/data/%s_gt.mat',seq_data_file));
