% automatically generate an index file.
% collecting all .mzXML files and inclusion list .csv under the selected
% note:  remove all non-relavent mzXML and csv files in the folder. 
%

function folder=ms2_index(fn_index)
if nargin<1  % if no input, default output file name is 'index.xlsx';
    fn_index='index.xlsx';
end
folder=uigetdir();
A=dir(fullfile(folder,'*.mzXML'));
B=dir(fullfile(folder,'*.csv'));
A1=fullfile({A.folder},{A.name});
B1=fullfile({B.folder},{B.name});
if size(A,1)-size(B,1)==0
  out=[A1',B1'];
  writecell(out,fullfile(folder,fn_index))
else
    fprintf('error, number of mzXML and csv files does not match \n')
end