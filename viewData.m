function viewData(indata)

% visualize sensor data

% parse in parameter
readings=parseData(indata);

% figure out how many time steps
[F, ~]=size(readings);

% get coordinates
[xc, yc]=getSensorCoordinates;

% and off we go
for t=1:F
    clf;    hold on; 
    xlim([0 7000]); ylim([0 12500]);
    active=~~readings(t,:);
    plot(xc(active),yc(active),'o');
    pause(.05);
    
end


end