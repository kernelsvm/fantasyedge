function data = ParseFile(fname, mask)
% USAGE: data = ParseFile(fname, mask)
%   Reads columns of data from a data file

% AUTHOR: J.D. Yamokoski
% DATE: 11/7/2007

fid = fopen(fname);

% Determine how many column headers are actually in the data file
n = 0;
firstLine = fgetl(fid);
availableHeaders = {};
nextIndex = 1;

while (nextIndex < length(firstLine))
    n = n + 1;
    [header,cnt,errmsg,ind] = sscanf(firstLine(nextIndex:end),'%s',1);
    if (~isempty(header))
        availableHeaders{n,1} = header;
    end
    nextIndex = nextIndex + ind;
end

colHeaders = mask(:,1);
colFormats = mask(:,2);
format = '';

for n = 1:length(availableHeaders)
    ind = find( strcmp(availableHeaders{n,1}, colHeaders) );
    
    if ( ~isempty(ind) )
        format = [format, colFormats{ind,1}];
    else
        format = [format, '%*s'];
    end
end

rawdata = textscan(fid, format, 'multipleDelimsAsOne', 1, 'headerLines', 0);

for n = 1:length(colHeaders)
    data.(colHeaders{n,1}) = rawdata{n};
end

%data.num = length(data.Team);

% Close the file.. we are done
fclose(fid);