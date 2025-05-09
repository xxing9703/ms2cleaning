%this function takes one .mzxml and corresponding .csv inclusion file, extract ms2info
%(_com) differs from the previous version: precurssor m/z not from
% "filterline
%dependancy: eic_corr; mzxml2structMS2_com; mzxmlread_xi; getEIC; getMS
function ms2info=get_MS2info_com(fname_mzxml,fname_csv, settings)
%fname_mzxml='\\msdata\people\xxing\MS_data\20200327-msms-std\0327-neg-ms2-std-201.mzXML';
%fname_csv='\\msdata\people\xxing\MS_data\20200327-msms-std\0327-neg-cpd-with-std-201.csv';
M=mzxml2structMS2_com(fname_mzxml); %M(1) is MS1, M(2:end) are MS2
A=readtable(fname_csv); % inclusion file
nMS2peaks=size(A,1); %number of MS2 peaks

% settings.rtm=1; %rt window
% settings.ave=3; %moving average for EIC
% settings.prominence=1e3;
% settings.peakwidth=0.02;
% settings.ppm=5; %m/z ppm
% settings.cutoff=0.01; %intensity cutoff for mass spectra
% settings.corr=0.8; %correlation score cutoff
ct=0;ms2info=[];
for i=1:nMS2peaks %loop over MS2 precursor peaks
   index = A{i,1}; %Compound ID   
   rt = .5*(A{i,6}+A{i,7});  % avg of start rt and end rt
   mz = A{i,4};
   iplus=find(abs([M.precursor]-mz)<0.005); %iplus should=i+1
   if isempty(iplus) % precursor in csv not found in the mzXML!
       break
   end
   ct=ct+1;
   pk_.rt=rt;pk_.mz=mz;
   settings.rtm=settings.rtm_long; % use the longer rt window here
   [tp,inten,rt2]=getEIC(M(1),pk_,settings); 
   MS1_eic.mz=mz;
   MS1_eic.rt=rt2;
   MS1_eic.inten=inten;
   MS1_eic.eic=tp{1}; %get MS1 eic
   
    
   MS1_ms=getMS(M(1),pk_);
   MS1_ms=MS1_ms{:}; %get MS1 ms
   %figure,stem(MS1_ms(:,1),MS1_ms(:,2),'.b')
   %figure,plot(MS1_eic(:,1),MS1_eic(:,3))
   
   pk_.rt=rt2;
   pk_.mz=mz; 
   MS2_ms=getMS(M(iplus),pk_); %get MS2 ms
   MS2_ms=MS2_ms{:};
   %figure,stem(MS2_ms(:,1),MS2_ms(:,2),'.b')
   
% get clean MS2 by correlation
   % remove fragments with <cutoff(default=0.01) top intensity
   int_arr=MS2_ms(:,2);   
   aa=find(int_arr>max(int_arr)*settings.cutoff);%apply cutoff   
   ms=MS2_ms(aa,:); %filtered MS2 mass spectrum    
  
  settings.rtm=settings.rtm_short;  %shorten EIC window for correlation analysis 
  score=[];MS2_eic=[];
  for k=1:size(ms,1)
    pk_.mz=ms(k,1); %update mz
    pk_.rt=rt2;
    [spec,inten,rt_]=getEIC(M(iplus),pk_,settings);
    MS2_eic(k).mz=ms(k,1);
    MS2_eic(k).sig=ms(k,2);
    MS2_eic(k).inten=inten;
    MS2_eic(k).rt=rt_;
    MS2_eic(k).eic=spec{:}; %eic for each MS2 fragment 
    score(k)=eic_corr(MS1_eic.eic,MS2_eic(k).eic);    
  end 
  tp=find(score>settings.corr);
  if ~isempty(tp)
    MS2_ms_clean=ms(tp,:); %cleaned spectrum
  else
    MS2_ms_clean=[];  
  end
  ms2info(ct).fname=fname_mzxml;
  ms2info(ct).fname_csv=fname_csv;
  ms2info(ct).item=i;
  ms2info(ct).flag='';    
  ms2info(ct).index=index;
  ms2info(ct).precursor=mz;
  ms2info(ct).rt=rt;
  ms2info(ct).rt_fix=rt2;
  ms2info(ct).rtshift=rt2-rt;  
  ms2info(ct).MS1_eic=MS1_eic;
  ms2info(ct).MS2_eic=MS2_eic;
  ms2info(ct).MS1_ms=MS1_ms;
  ms2info(ct).MS2_ms=MS2_ms;
  ms2info(ct).MS2_ms_clean=MS2_ms_clean; 
  
 end
