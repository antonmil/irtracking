function [X, Y]=linCCLocEst(indata)
% linear location estimation with connected components

% x = (x1*1/D1 + ... + xn*1/Dn) / (1/D1 + ... + 1/Dn)
readings = parseData(indata);

[F, S] = size(readings);

% get coordinates
[xc, yc]=getSensorCoordinates;



% make boolean
readings = ~~readings;

% Neighborhood
Nhood=getSensorNeighborhood(1500);

X=zeros(F,0); Y=X;

%% build D (all)
D=zeros(F,S);
D(1,:)=readings(1,:);
for t=2:F
    active= readings(t,:);        
    D(t,active)=D(t-1,active)+1;
    D(t,~active)=0;
end

% Tao's modified (CC)
for t=1:F
    active= find(readings(t,:));
    id=0;
%     t
    used=false(1,S);
    for a = active
        if ~used(a)
            id=id+1;
            neighb = find(Nhood(a,:)); % all neighbors of active sensor
            neighb_active = setdiff(neighb,find(~D(t,:)));

%             neighb_active = neighb(find(D(t,neighb)));

            coeffs=1./D(t,neighb_active);
            used(neighb_active)=1;
%             [a id]
%             neighb
%             neighb_active
%             coeffs
%             pause

            X(t,id) = (xc(neighb_active) * coeffs') / sum(coeffs);
            Y(t,id) = (yc(neighb_active) * coeffs') / sum(coeffs);
        end
    end
end

% also split fragmented trajectories
[F, N]=size(X);
for i=1:N
    frags=~~X(:,i);
    starts=find(frags(1:end-1)==frags(2:end)-1)+1;
    ends=find(frags(1:end-1)==frags(2:end)+1);
    if frags(1), starts=[1; starts]; end
    if frags(end), ends=[ends; numel(frags)]; end
    for s=2:numel(starts)
        X(starts(s):ends(s),end+1)=X(starts(s):ends(s),i);X(starts(s):ends(s),i)=0;
        Y(starts(s):ends(s),end+1)=Y(starts(s):ends(s),i);Y(starts(s):ends(s),i)=0;
    end
end

