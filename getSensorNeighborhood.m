function Nhood=getSensorNeighborhood(tau)

if nargin<1
    tau=1500;
end

[xc, yc]=getSensorCoordinates;
nS=length(xc);
Nhood=sparse(nS);

for s1=1:nS
    for s2=1:nS
        d=norm([xc(s1) yc(s1)] - [xc(s2) yc(s2)]);
        if d < tau
            Nhood(s1,s2)=1;
        end
    end
end