%%
allscen=[301:303 311:313];
readfiles={'s1-easy.txt','s1-medium.txt','s1-hard.txt','r1-easy.txt','r1-medium.txt','r1-hard.txt'};
scenario=301;
[xc, yc]=getSensorCoordinates;

    
for scenario=allscen
    scnt=find(allscen==scenario);
    [readings, ts]=readData(['data/' char(readfiles{scnt}) ]);

    stateInfo=infos(scenario,1).stateInfo; sceneInfo=getSceneInfo(scenario);
    
    for t=1:length(sceneInfo.frameNums)
%     for t=15
        
%         t=35;
        options.traceLength=20;
        options.traceWidth=2;
        
        reopenFig('pp');
        clf;hold on; axis equal
%         subplot(1,2,1);
%         cla; hold on;
        set(gca,'XTick',[]);set(gca,'YTick',[]);
        
        
        im=imread(sprintf('d:/prml/irtracking/data/img/frame_%05d.jpg',t));
        xIm=[0 8000]; xIm=repmat(xIm,2,1);
        yIm=[14000 0]; yIm=repmat(yIm,2,1);yIm=yIm';
        zIm=zeros(2,2);
        surf(xIm,yIm,zIm,'CData',im,'FaceColor','texturemap');
        xlim([0 8000]);
        ylim([0 14000]);
        
        plotSensorCoordinates;
        
        X=gtInfo.Xgp; Y=gtInfo.Ygp;
        [F, N]=size(X);
        extar=find(X(t,:));
        
        for id=extar            
            plot3(X(t,id),Y(t,id),1,'o','color',getColorFromID(id));
        end
        
        %trace
        for tracet=max(1,t-options.traceLength):max(1,t-1)
            extarpast=find(X(tracet,:));
            ipolpar=(t-tracet)/options.traceLength;
            % foot position
            for id=extarpast
                if X(tracet+1,id)
                    
                    trCol=getColorFromID(id);
                    endcol=trCol;
                    
                    line(X(tracet:tracet+1,id) ,Y(tracet:tracet+1,id),'linestyle','--', ...
                        'color',ipolpar*endcol + (1-ipolpar)*trCol,'linewidth',(1-ipolpar)*options.traceWidth+1);
                end
                
            end
            
        end
        
        
        %%
        % reopenFig('state');
        % clf;hold on;
%         subplot(1,2,2); cla; hold on;
%         set(gca,'XTick',[]);set(gca,'YTick',[]);
        
        im=imread(sprintf('d:/prml/irtracking/data/img/frame_%05d.jpg',t));
        xIm=[0 8000]; xIm=repmat(xIm,2,1);
        yIm=[14000 0]; yIm=repmat(yIm,2,1);yIm=yIm';
        zIm=zeros(2,2);
        surf(xIm,yIm,zIm,'CData',im,'FaceColor','texturemap');
        
        plotSensorCoordinates;
        
        X=stateInfo.Xgp; Y=stateInfo.Ygp;
        [F, N]=size(X);
        
        
        [metr,metrInfo,addInf]=CLEAR_MOT(gtInfo,stateInfo,struct('eval3d',1));
        newColors=[];
        for id=1:N
            % which gt tracks are covered by id
            [u, v]=find(addInf.alltracked==id);
            uniquev = unique(v');
            
            % which one is the dominant one?
            maxfr=0;
            domid=id;
            for id2=uniquev
                if numel(find(v==id2)') > maxfr
                    domid=id2;
                end
            end
            newColors(id,:)=getColorFromID(domid);
            
        end
        
        
        
        for id=1:N
            if X(t,id)
                plot3(X(t,id),Y(t,id),1,'o','color',newColors(id,:));
            end
        end
        
        
        %trace
        for tracet=max(1,t-options.traceLength):max(1,t-1)
            extarpast=find(X(tracet,:));
            ipolpar=(t-tracet)/options.traceLength;
            % foot position
            for id=extarpast
                if X(tracet+1,id)
                    
                    trCol=newColors(id,:);
                    endcol=trCol;
                    
                    line(X(tracet:tracet+1,id) ,Y(tracet:tracet+1,id), ...
                        'color',ipolpar*endcol + (1-ipolpar)*trCol,'linewidth',(1-ipolpar)*options.traceWidth+1);
                end
            end
        end
        
        
        % active sensors
        active=find(readings(t,:));
%         plot(xc(active),yc(active),'o');
        r=750;
        rads=linspace(0,2*pi,100);
        allpx=r*cos(rads);
        allpy=r*sin(rads);
        for as=active
%             rectangle('Position',[xc(as)-r,yc(as)-r,2*r,2*r],'Curvature',[1,1],'FaceColor',[1 0 0],'Transparency',0.5);
            px=allpx+xc(as);py=allpy+yc(as);
            patch(px,py,ones(1,length(px)),'r','FaceAlpha',0.1);
        end
        
%         for s=1:43
            plot3(xc,yc,ones(1,43),'k.');
%         end

        % save output
        outfile=sprintf('vis/s%04d/f_%04d.jpg',scenario,t);
%         saveas(gcf,outfile);
        im2cap=getframe(gcf);        im2cap=im2cap.cdata;        imwrite(im2cap,outfile);
        
    end
end