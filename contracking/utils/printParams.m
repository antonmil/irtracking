function printParams(opt)
% 
% (C) Anton Andriyenko, 2012
%
% The code may be used free of charge for non-commercial and
% educational purposes, the only requirement is that this text is
% preserved within the derivative work. For any other purpose you
% must contact the authors for permission. This code may not be
% redistributed without written permission from the authors.



trackon='image plane (2D)';
if opt.track3d, trackon='ground plane (3D)'; end
printMessage(2,'Tracking on %s\n',trackon);

%  unaryFactor=opt.unaryFactor;
%  outlierCost=opt.outlierCost;
%  labelCost = opt.labelCost;
%  smoothFac=opt.pairwiseFactor;
%  exclFac=opt.exclusionFactor;
%  nSupFac=opt.totalSupFactor;
%  mdpfFac = opt.meanDPFFactor;
%  mdpfeFac= opt.meanDPFeFactor;
%  curvatureFac = opt.curvatureFactor;
%  minCPs=opt.minCPs;
%  ncpsPerFrame = opt.ncpsPerFrame;
%  nInitModels = opt.nInitModels;
%  goodnessFactor = opt.goodnessFactor;
%  fidFac = opt.fidelityFactor;
%  proxcostFactor = opt.proxcostFactor;
%  persFac=opt.persistenceFactor;
%  curvFac=opt.curvatureFactor;
%  lengthFac=opt.lengthFactor;
%  occ=opt.occ;

if opt.verbosity>=2
disp(datestr(now));
end

% vertical
% printMessage(2,' -- Parameters  ---\n');
% printMessage(2,'Unary Factor: ........ %g\n',unaryFactor);
% printMessage(2,'Smoothness Factor: ... %g\n',smoothFac);
% printMessage(2,'Label Cost: .......... %g\n',labelCost);
% printMessage(2,'Outlier Cost: ........ %g\n',outlierCost);
% printMessage(2,'Goodness Factor: ..... %g\n',goodnessFactor);
% printMessage(2,'Fidelity Factor: ..... %g\n',fidFac);
% printMessage(2,'Proxcost Factor: ..... %g\n',proxcostFactor);
% printMessage(3,'Min CPs: ............. %g\n',minCPs);
% printMessage(3,'Frames per CP: ....... %g\n',1/ncpsPerFrame);

% horizontal
printMessage(2,' --------------------------- Parameters  ----------------------------\n');
% printMessage(2,'%10s%10s%10s%10s%10s%10s%10s%10s%10s%10s%5s\n','label','outlier','unary','smooth','exclus','goodn','fidel','pers','curv','length','occ');
% printMessage(2,'%10g%10g%10g%10g%10g%10g%10g%10g%10g%10g%5i\n',labelCost,outlierCost,unaryFactor,smoothFac,exclFac,goodnessFactor,fidFac,persFac,curvFac,lengthFac,occ);

%%
% opt
optsPerLine=13;
allfields=fieldnames(opt);

%% look for app struct
nfields=length(allfields);
appstruct=0;
if isfield(opt,'app')    
    appstruct=1;
    for n=1:nfields
        if strcmp(char(allfields(n)),'app')
            stind=n;
        end
    end
    allfields=allfields(setdiff(1:nfields,stind));
    printMessage(2,'appparam  xst: %i,  tst: %i, nbins: %i, filsig: %.2f, filsiz: %.2f, ycb: %d\n', ...
       opt.app.xstrade, opt.app.tstrade,opt.app.nbins, opt.app.filtersigma, opt.app.filtersize, opt.app.ycb)
end

%% detscale struct
nfields=length(allfields);
if isfield(opt,'detScale')    
    for n=1:nfields
        if strcmp(char(allfields(n)),'detScale'), stind=n; end
    end
    allfields=allfields(setdiff(1:nfields,stind));
    printMessage(2,'detconf  shift: %.2f,  scale: %.2f\n', opt.detScale.sigA,opt.detScale.sigB)    
end

%% sw struct
nfields=length(allfields);
if isfield(opt,'sw')    
    for n=1:nfields
        if strcmp(char(allfields(n)),'sw'), stind=n; end
    end
    allfields=allfields(setdiff(1:nfields,stind));
end

%% disOpt struct
nfields=length(allfields);
if isfield(opt,'disOpt')    
    printMessage(2,'Discrete Optimization settings:\n');
    disp(opt.disOpt);

    for n=1:nfields
        if strcmp(char(allfields(n)),'disOpt'), stind=n; end
    end
    allfields=allfields(setdiff(1:nfields,stind));
end

%% conOpt struct
nfields=length(allfields);
if isfield(opt,'conOpt') 
    printMessage(2,'Continuous Optimization settings:\n');
    disp(opt.conOpt);
    disp([opt.conOpt.enParEdat(3) opt.conOpt.enParElin(2) opt.conOpt.enParEexc(1) opt.conOpt.enParEfid(1) opt.conOpt.enParEfid(3) opt.conOpt.enParEseg]);
    for n=1:nfields
        if strcmp(char(allfields(n)),'conOpt'), stind=n; end
    end
    allfields=allfields(setdiff(1:nfields,stind));
end


nfields=length(allfields);
nn=0;
for n=1:nfields
    tmp=getfield(opt,char(allfields(n)));    
%     char(allfields(n))
    
        
        optstr=char(allfields(n)); if length(optstr)>10, optstr=optstr(1:10); end
        printMessage(2,'%11s',optstr);
        if ~mod(n,optsPerLine) || n==nfields
            printMessage(1,'\n');
            fleft=min(nfields-n+optsPerLine-1,optsPerLine);
            for a=1:fleft
                nn=nn+1;
                if nn<=nfields
                    tmp=getfield(opt,char(allfields(nn)));
%                     if isequal(char(allfields(nn)),'frames')
                    if length(tmp)>1
                        tmp=length(tmp);
                    end
                    
                    printMessage(2,'%11G',tmp);
                end
            end
            printMessage(1,'\n\n');

        end
    
end

    

end
