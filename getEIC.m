%usage: [spectra,intensity,rt]=EIC(M,pk,settings)
%M is an array of structure containing multi MS raw data 
%settings structure: ppm, rtm, ave

function [spectra,intensity,rt]=getEIC(M,pk,settings)

%M is an array of structure, use M(i).filename, M(i).data to retrieve data
num_file=length(M);
spectra=cell(num_file,1);
% intensity=zeros(num_file,1);
% rt=zeros(num_file,1);
for j=1:num_file
    
     signal=slice(M(j),pk,settings);  %slice of EIC curve, (rt vs int)
    
     signal(:,3)=smooth(signal(:,2),settings.ave);  %moving average, stored in 3rd col.
    
     spectra{j}=signal;  %store all the EIC curves.
     
     peak=[];
    if size(signal,1)>2
     [peak,loc]=findpeaks(signal(:,3),sort(signal(:,1)+rand(size(signal,1),1)/1e7),...%avoid identical x
     'MinPeakProminence',settings.prominence,...  %threshold
     'MinPeakWidth',settings.peakwidth);    %peakwidth
    end
        if isempty(peak)
            peak=0;loc=pk.rt;  %if nothing is found, set intensity=0 and rt=original rt
        end
      [~,ind]=max(peak); %find max peak      
      intensity(j)=peak(ind);   %max intensity
      rt(j)=loc(ind);  %rt location at max 
      
      [~,loc]=max(signal(:,3));
      intensity(j)=signal(loc,3);   %max intensity
      
          
end  

end

function signal=slice(mat,pk,settings)

mz=pk.mz;rt=pk.rt;
if isfield(mat,'rt')
    rt_array=mat.rt;
else
    rt_array=cell2mat(mat.data(:,1));
end

%ind = find(abs(rt_array-pk.rt)<settings.rtm); %-----slow method
 range=[rt-settings.rtm,rt+settings.rtm]; %---fast method, updated 10/3/2019
 [b,c]=findInSorted(rt_array,range);
 ind=b:c;

dm=pk.mz*settings.ppm;
dm=min(dm,0.005); %----------------restrict the resolution to resolve 13C-15N: (1.00335-0.997)


sig=zeros(length(ind),1); %---  updated 10/3/2019
for i=1:length(ind)
mass=mat.data{ind(i),2};
intensity=mat.data{ind(i),3};
%ind_mz=find(abs(mass-pk.mz)<dm);  %-----slow method
   range=[mz-dm,mz+dm];        %--- fast method  updated 10/3/2019
   [b,c]=findInSorted(mass,range);
   ind_mz=b:c;                                  %---
sig(i)=sum(intensity(ind_mz));    
end
signal=[rt_array(ind),sig(:)];

end

