function stInfo = detmatToState(detMat)
% fill stateInfo struct

stInfo=detMat;

stInfo.X=detMat.Xd;stInfo.Y=detMat.Yd;
stInfo.Xgp=detMat.Xd;stInfo.Ygp=detMat.Yd;
stInfo.frameNums=1:size(stInfo.X,1);

end