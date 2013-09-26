function plotGT
% plot ground truth tracks
% 
% (C) Anton Andriyenko, 2012
%
% The code may be used free of charge for non-commercial and
% educational purposes, the only requirement is that this text is
% preserved within the derivative work. For any other purpose you
% must contact the authors for permission. This code may not be
% redistributed without written permission from the authors.
global gtInfo opt

lw=3;
Xgt=gtInfo.Xi;Ygt=gtInfo.Yi;
if opt.track3d
    Xgt=gtInfo.Xgp;Ygt=gtInfo.Ygp;
end
[~, Ngt]=size(Xgt);
for id=1:Ngt
    exframes=find(Xgt(:,id));
    plot3(Xgt(exframes,id),Ygt(exframes,id),exframes,'--','color',[0.6 0.6 0.9],'linewidth',lw);
end

end