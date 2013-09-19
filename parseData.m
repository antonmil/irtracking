function readings=parseData(indata)
% if data is reading matrix, return
% or if it's a file name, parse first

if isnumeric(indata) && ismatrix(indata)
    readings=indata;
elseif ischar(indata)
    readings=readData(indata);
else
    error('data unrecognized');
end
