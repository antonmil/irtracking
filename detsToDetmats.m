function detMat=detsToDetmats(X,Y,scale)
% create detection matricex from X,Y

tarinds=find(X);

detMat.Xd=X;

detMat.Xd=X;
detMat.Yd=Y;
detMat.Sd=zeros(size(X)); detMat.Sd(tarinds)=1;

detMat.Xi = X / scale;
detMat.Yi = Y / scale;
detMat.W = zeros(size(X)); detMat.W(tarinds)=700/scale;
detMat.H = zeros(size(X)); detMat.H(tarinds)=700/scale;

end