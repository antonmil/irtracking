function removeFigureBorders()
% get rid of the white margin in MATLAB's saveas or print outputs
% taken from http://tipstrickshowtos.blogspot.jp/2010/08/how-to-get-rid-of-white-margin-in.html
% 
% Make your figure boundaries tight:
ti = get(gca,'TightInset');
set(gca,'Position',[ti(1) ti(2) 1-ti(3)-ti(1) 1-ti(4)-ti(2)]);

% Now you have a tight figure on the screen but if you directly 
% do saveas (or print), MATLAB will still add the annoying white space. 
% To get rid of them, we need to adjust the ``paper size":
set(gca,'units','centimeters')
pos = get(gca,'Position');
ti = get(gca,'TightInset');

set(gcf, 'PaperUnits','centimeters');
set(gcf, 'PaperSize', [pos(3)+ti(1)+ti(3) pos(4)+ti(2)+ti(4)]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperPosition',[0 0 pos(3)+ti(1)+ti(3) pos(4)+ti(2)+ti(4)]);