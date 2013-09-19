function [Xgt, Ygt]=interpGT(Xgt,Ygt)

[~, N]=size(Xgt);
ipolmethod='spline';

for id=1:N
    exfr=find(Xgt(:,id),1,'first'):find(Xgt(:,id),1,'last');  
    Xgt(exfr,id)=interp1(find(Xgt(:,id)),Xgt(find(Xgt(:,id)),id),exfr,ipolmethod);
    Ygt(exfr,id)=interp1(find(Ygt(:,id)),Ygt(find(Ygt(:,id)),id),exfr,ipolmethod);
end