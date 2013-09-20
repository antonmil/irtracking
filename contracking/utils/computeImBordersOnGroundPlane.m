function computeImBordersOnGroundPlane
% compute image borders on ground plane
% 
% (C) Anton Andriyenko, 2012
%
% The code may be used free of charge for non-commercial and
% educational purposes, the only requirement is that this text is
% preserved within the derivative work. For any other purpose you
% must contact the authors for permission. This code may not be
% redistributed without written permission from the authors.


global opt sceneInfo detections


% determin detection that is highest in image as top border
imtoplimit=min([detections(:).xi]);

% for 2D tracking, image border = 'ground plane'
if ~opt.track3d
	sceneInfo.imOnGP= [...
		1 sceneInfo.imgHeight ...
		1 imtoplimit ...
		sceneInfo.imgWidth,imtoplimit ...
		sceneInfo.imgWidth,sceneInfo.imgHeight];

else

	

	[x1, y1]=imageToWorld(1,sceneInfo.imgHeight,sceneInfo.camPar);
	[x2, y2]=imageToWorld(1,imtoplimit,sceneInfo.camPar);
	[x3, y3]=imageToWorld(sceneInfo.imgWidth,imtoplimit,sceneInfo.camPar);
	[x4, y4]=imageToWorld(sceneInfo.imgWidth,sceneInfo.imgHeight,sceneInfo.camPar);
		
	sceneInfo.imOnGP=[x1 y1 x2 y2 x3 y3 x4 y4];
    end
end