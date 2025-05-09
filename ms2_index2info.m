function ms2info=ms2_index2info(fn_index,settings)
A=readcell(fn_index);
ms2info=[];
% settings.rtm=1; %rt window
% settings.rtm_long=1; 
% settings.rtm_short=0.3; 
% settings.ave=3; %moving average for EIC
% settings.prominence=1e3;
% settings.peakwidth=0.02;
% settings.ppm=5; %m/z ppm
% settings.cutoff=0.01; %intensity cutoff for mass spectra
% settings.corr=0.8; %correlation score cutoff
% ms2info=[];
for i=1:size(A)
    i
  ms2info=[ms2info,get_MS2info_com(A{i,1},A{i,2}, settings)];
end




