%%
opt=getConOptions;
matlabpool(6);
pfm2d=[];pfm3d=[];pfinf=[];
parfor scencnt=1:length(allscen)
    scen=allscen(scencnt);
    scenario=scen
    
    [metrics2d, metrics3d, allens, stateInfo]=cemTracker(scenario,opt);
    pfm2d(scencnt,:)=metrics2d;
    pfm3d(scencnt,:)=metrics3d;
    pfinf(scencnt).stateInfo=stateInfo;
end
delete(gcp)


%%
for scencnt=1:length(allscen)
    scen=allscen(scencnt);
    mets2d(scen,:,exprun+1)=pfm2d(scencnt,:);
    mets3d(scen,:,exprun+1)=pfm3d(scencnt,:);
    infos(scen,exprun+1).stateInfo=pfinf(scencnt).stateInfo;
end

