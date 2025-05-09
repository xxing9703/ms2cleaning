% main script to run ms2cleaning

fn = 'index.xlsx';  % an index file referencing MS2 files with inclusion lists
prefix='diet_';
mode='neg';

settings.rtm=1; %rt window
settings.rtm_long=1; 
settings.rtm_short=0.3; 
settings.ave=3; %moving average for EIC
settings.prominence=1e3;
settings.peakwidth=0.02;
settings.ppm=5; %m/z ppm
settings.cutoff=0.01; %intensity cutoff for mass spectra
settings.corr=0.8; %correlation score cutoff

% pull MS2 information from data
folder=ms2_index(fn);  % auto generating index file, return the working folder.
fn=fullfile(folder,fn);
ms2info=ms2_index2info(fn,settings);
%%
% export .mat structure 
save(fullfile(folder,'ms2info'),"ms2info",'-mat'); 

% export mgf files (clean & unclean)
fn_mgf = fullfile(folder, [prefix, mode,'_unclean.mgf']);
cl=0; both=0;
ms2_info2mgf(ms2info,fn_mgf,mode,cl,both)

fn_mgf = fullfile(folder, [prefix, mode,'_clean.mgf']);
cl=1; both=0;
ms2_info2mgf(ms2info,fn_mgf,mode,cl,both)