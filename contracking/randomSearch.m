%%
% defaults
%     opt.wtEdet=5;               % should be kept at 1
%     opt.wtEdyn=.01;
%     opt.wtEexc=2;
%     opt.wtEper=4;
%     opt.wtEreg=2;
%     opt.lambda=0.25;
    
    
global detections gtInfo scenario stateInfo

rnmeansstart=[5 5 .1 .1 18];
% rnmeansstart=[5 .01 2 4 2 .25]; % PRML
% rnmeansstart=[0.1 0.001 0.01]; 



allscen=[42 23 25 27 71 72];
allscen=[301:303 311:313];

rnmeans=rnmeansstart;
% allscen=[71 42 ];

% addpath('D:/visinf/projects/ongoing/contracking');
% addpath(genpath('D:/visinf/projects/ongoing/contracking/utils'));

clear alla allb allcemopts infos
itcnt=0;
while 1
    itcnt=itcnt+1;
    
    % rnmeans=[4.8669 7.43825 0.137917 0.0267995 0.0797967];
    
    popt=getPirOptions(popt);

    
    maxexpruns=20;
    
    mets2d=zeros(max(allscen),14,maxexpruns);
    mets3d=zeros(max(allscen),14,maxexpruns);
    allm3d=[];
    
    expruns=0:maxexpruns-1;
    for exprun=expruns
        exprun
        
        rmvars=rnmeans/10;
        if exprun<maxexpruns/2
            randopts=abs(rnmeans + rmvars.*randn(1,length(rnmeans))); % normal
        else
            randopts=2*rand(1,length(rnmeans)).*rnmeans; % uniform [0 2*max], works better
        end
        if exprun==0
            randopts=rnmeans;
        end
        
popt.c_en      = randopts(1);     %% birth cost
popt.c_ex      = randopts(2);     %% death cost
popt.c_ij      = randopts(3);      %% transition cost
popt.betta     = randopts(4);    %% betta
popt.max_it    = Inf;    %% max number of iterations (max number of tracks)
popt.thr_cost  = randopts(5);     %% max acceptable cost for a track (increase it to have more tracks.)
        
        for scen=allscen
            scenario=scen
            randopts
%             [metrics2d metrics3d stateInfo] = swDCTrackerMHT( scenario, opt );
%             [metrics2d metrics3d stateInfo] = run_mytracker( scenario, opt );
%             [metrics2d, metrics3d, allens, stateInfo]=swCEMTracker(scenario,opt);
            [metrics2d, metrics3d, allens, stateInfo]=runDP(scenario,popt,myopt);
            mets2d(scen,:,exprun+1)=metrics2d;
            mets3d(scen,:,exprun+1)=metrics3d;
            infos(scen,exprun+1).stateInfo=stateInfo;
        end
        %     allm3d(exprun+1,:)=metrics3d;
        allm3d(exprun+1,:)=mean(mets3d(allscen,:,exprun+1),1);
        allcemopts(exprun+1)=opt;
    end
    itcnt
    allm3d
    [a, b]=max(allm3d), bestexp=b(12);
    bestexp
    alla(itcnt,:)=a;allb(itcnt,:)=b;
    
    alla
    allb
    
    if bestexp==1
        fprintf('done!\n');
        break
    end
popt.c_en      = randopts(1);     %% birth cost
popt.c_ex      = randopts(2);     %% death cost
popt.c_ij      = randopts(3);      %% transition cost
popt.betta     = randopts(4);    %% betta
popt.max_it    = Inf;    %% max number of iterations (max number of tracks)
popt.thr_cost  = randopts(5);     %% max acceptable cost for a track (increase it to have more tracks.)
    
    rvec=(sprintf('%.15f ', ...
        allcemopts(bestexp).wtEdet,allcemopts(bestexp).wtEdyn,allcemopts(bestexp).wtEexc, ...
        allcemopts(bestexp).wtEper,allcemopts(bestexp).wtEreg,allcemopts(bestexp).lambda));
    evalstr=sprintf('rnmeans=[%s];',rvec);
    eval(evalstr)
    pause(1)
end

