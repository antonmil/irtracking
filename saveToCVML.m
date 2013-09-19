function saveToCVML(X,Y, outfile, isgt, nf)
% convert x,y coordinates to CVML detection file

assert(all(size(X)==size(Y)), ...
    'X Y must be equal size');

% normalization factor
if nargin<5
    nf=1;
end

% figure out how many time steps
[F, N]=size(X);
frameNums=1:F;

% invert for image coordinates
extar=find(X(:));
% X(extar)=7000-X(extar);
% Y(extar)=14000-Y(extar);

%% Create XML file
docNode = com.mathworks.xml.XMLUtils.createDocument('dataset');
docRootNode = docNode.getDocumentElement;
docRootNode.setAttribute('name','PRML');

for t=1:F
    frameNode=docNode.createElement('frame');
    frameNode.setAttribute('number',sprintf('%i',frameNums(t)));
    objListNode=docNode.createElement('objectlist');
    
    exobj=find(X(t,:));
    for id=exobj
        objectNode=docNode.createElement('object');
        if isgt
            objectNode.setAttribute('id',num2str(id));            
        else
            objectNode.setAttribute('confidence',num2str(1));
        end
        
        %         objectNode.setAttribute('id',num2str(id));
        boxNode=docNode.createElement('box');
        
        xc=X(t,id); yc=Y(t,id);
        
        % set width and height to a fixed size of 70cm each
        w=700; h=700;
        
        boxNode.setAttribute('xc',num2str(xc/nf));
        boxNode.setAttribute('yc',num2str(yc/nf));
        boxNode.setAttribute('w',num2str(w/nf));
        boxNode.setAttribute('h',num2str(h/nf));
        
        
        
        objectNode.appendChild(boxNode);
        objListNode.appendChild(objectNode);
    end
    frameNode.appendChild(objListNode);
    docRootNode.appendChild(frameNode);
end
xmlwrite(outfile,docNode);
fprintf('xml written to %s\n',outfile);

% also save to mat
% [~, filename, ~]=fileparts(outfile);
% outfile=[filename '.mat'];
% 
% clear detections
% for t=1:F
%     exobj=find(X(t,:));
%     if isempty(exobj)
%         detections(t).bx=[];detections(t).by=[];
%         detections(t).xp=[];detections(t).yp=[];
%         detections(t).ht=[];detections(t).wd=[];
%         detections(t).xi=[];detections(t).yi=[];detections(t).bx=[];
%         continue;
%     end
%     
%     xc=X(t,exobj); yc=Y(t,exobj);
%     
%     detections(t).xp = X(
%     for id=exobj
%         
%     end
%     
% end

end % function