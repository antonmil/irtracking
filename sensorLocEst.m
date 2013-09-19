function [X, Y]=sensorLocEst(indata)
% sonsor location estimation

readings = parseData(indata);

[F, S] = size(readings);

% get coordinates
[xc, yc]=getSensorCoordinates;



readings = ~~readings;

X=zeros(F,0); Y=X;

for t=1:F    
    active= find(readings(t,:));
    if isempty(active)
        continue;
    end
%     active
%     X(t,1:length(active))
%     xc(active)
    X(t,1:length(active)) = xc(active);
    Y(t,1:length(active)) = yc(active);
end



end