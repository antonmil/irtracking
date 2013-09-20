function h=reopenFig(figname)
% 
% (C) Anton Andriyenko, 2012
%
% The code may be used free of charge for non-commercial and
% educational purposes, the only requirement is that this text is
% preserved within the derivative work. For any other purpose you
% must contact the authors for permission. This code may not be
% redistributed without written permission from the authors.


% close(findobj('type','figure','name',figname))

h=findobj('type','figure','name',figname);
if isempty(h)
    figure('name',figname);
else
    figure(h);
end
pause(.1);


end