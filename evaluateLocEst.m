%%
allscen=[301 302 303 311 312 313];

readfiles={'s1-easy.txt','s1-medium.txt','s1-hard.txt','r1-easy.txt','r1-medium.txt','r1-hard.txt'};
gtfiles={'s1-easy_gt.mat','s1-medium_gt.mat','s1-hard_gt.mat','r1-easy_gt.mat','r1-medium_gt.mat','r1-hard_gt.mat'};
allmets3d=zeros(0,14);
infos=[];

% scenario=allscen(1);
scnt=0;
for scenario=allscen
% sceneInfo=getSceneInfo(scenario);
scnt=scnt+1;
gtInfo=load(gtfiles{scnt});
gtInfo=gtInfo.gtInfo;
[X, Y]=linCCLocEst(['data/' char(readfiles{scnt})]);

clear stInf
stInf.frameNums=gtInfo.frameNums;
stInf.X=X;stInf.Y=Y;stInf.Xgp=X;stInf.Ygp=Y;
stInf.Xi=X;stInf.Yi=Y;stInf.W=X;stInf.H=Y;
[metrics2d, metrics3d, addInfo2d, addInfo3d]=printFinalEvaluation(stInf, gtInfo, sceneInfo, stateInfo.opt);
allmets3d(scenario,:)=metrics3d;
infos(scenario).stateInfo=stInf;
end

%%
% meanmets=mean(allmets3d(allscen,:));
% meanmets([8 9 10 5 7 11])=round(meanmets([8 9 10 5 7 11]));
% cd ../milan-icpr/code
% writeICPR2014Metrics(meanmets,'linear \\cite{Tao:2012:PPB}','cc-lin-mean.tex')
% cd ../../irtracking