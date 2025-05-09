% collect all MS2 .mzXML files and inclusion list .csv under current folder 

function ms2_index(fn_index)
A=dir('*.mzXML');
B=dir('*.csv');
A1=fullfile({A.folder},{A.name});
B1=fullfile({B.folder},{B.name});
out=[A1',B1'];
writecell(out,fn_index)