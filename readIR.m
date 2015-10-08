function sensorVals = readIR(s)
if s.BytesAvailable
fread(s,s.BytesAvailable);
end
fprintf(s,'N');
sensorString = fscanf(s);
splitString = regexp(sensorString,',','split');
sensorVals = cellfun(@str2num,splitString(2:end));
end