function [allReadings, timeStart]=readData(filename)

% Read data from a txt
%
% Each line either contains the date (which we irgnore)
% or a vector of sensor readings
%

fid=fopen(filename,'r');

allReadings=[];

tline = fgetl(fid);
tnum=str2num(tline);
if length(tnum)==50
    allReadings=[allReadings; tnum];
end

% assuming first line is time stamp
timeStart=datenum(tline);

while ischar(tline)
    tline = fgetl(fid);
    if ischar(tline)
        tnum=str2num(tline);
        if length(tnum)==50
            allReadings=[allReadings; tnum];
        end
    end
end

%
% size(allReadings)
allReadings=allReadings(:,1:43);

fclose(fid);

end

