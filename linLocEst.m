function [X, Y]=linLocEst(indata)
% linear location estimation

% x = (x1*1/D1 + ... + xn*1/Dn) / (1/D1 + ... + 1/Dn)
readings = parseData(indata);

[F, S] = size(readings);

% get coordinates
[xc, yc]=getSensorCoordinates;



% make boolean
readings = ~~readings;



X=zeros(F,1); Y=X;

%% build D (all)
D=zeros(F,S);
D(1,:)=readings(1,:);
for t=2:F
    active= readings(t,:);        
    D(t,active)=D(t-1,active)+1;
    D(t,~active)=0;
end

%% Tao's alg.
for t=1:F
    active= readings(t,:);
    if ~isempty(find(active, 1))
        coeffs=1./D(t,active);

        X(t) = (xc(active) * coeffs') / sum(coeffs);
        Y(t) = (yc(active) * coeffs') / sum(coeffs);
    end
end


%% active decay

% build D
% D=Inf*ones(F,S);
% 
% D(1,readings(1,:))=0;
% for t=2:F
%     active= readings(t,:);
%     D(t,:)=D(t-1,:)+1;
%     D(t,active)=1;
% end
% 
% D=1./D;
% sumsD=sum(D,2);
% 
% X=repmat(xc,F,1);
% Y=repmat(yc,F,1);
% 
% X = X .* D; X = sum(X,2) + 1;
% Y = Y .* D; Y = sum(Y,2) + 1;
% 
% X = X ./ (sumsD + 1);
% Y = Y ./ (sumsD + 1);




end