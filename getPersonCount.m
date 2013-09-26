function [mcnt, sdtcnt, bd]=getPersonCount(stateInfo, gtInfo)

[F,N]=size(stateInfo.X);
[Fgt,Ngt]=size(gtInfo.X);

assert(F==Fgt,'getPersonCount: Number of frames must be equal');

bd=zeros(F,1);
for t=1:F
    bd(t)=abs(numel(find(stateInfo.X(t,:))) - numel(find(gtInfo.X(t,:))));
end

mcnt=abs(mean(bd));
sdtcnt=std(bd);