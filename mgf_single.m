%% convert to .MGF
function txt = mgf_single(info,mode,cl,both)
mz=info.precursor;
rt=info.rt;
ms1=info.MS1_ms;
%ms1(:,2)=ms1(:,2)/max(ms1(:,2));%normalize ms1
ms2=info.MS2_ms;
ms2(:,2)=ms2(:,2)/max(ms2(:,2));%normalize ms2
ms2_cl=info.MS2_ms_clean;
if ~isempty(ms2_cl)
  ms2_cl(:,2)=ms2_cl(:,2)/max(ms2_cl(:,2));%normalize cleaned ms2
end
ID=info.index;
txt='BEGIN IONS\n';
txt=[txt,'PEPMASS=',num2str(mz),'\n'];
if strcmp(mode,'Negative')
  txt=[txt,'CHARGE=1-','\n'];
elseif strcmp(mode,'Positive')
  txt=[txt,'CHARGE=1+','\n'];
end   
txt=[txt,'TITLE=','ID=',num2str(ID),'_mz=',num2str(mz),'_rt=',num2str(rt),'\n'];
%MS1
if both==0
else
    txt=[txt,'MSLEVEL=1','\n'];
    tt=sprintf('%.4f %.4f\n',ms1');
    txt=[txt,tt];
end
%MS2
txt=[txt,'MSLEVEL=2','\n'];
if cl==0
  tt=sprintf('%.4f %.4f\n',ms2');  % use original MS2
elseif cl==1
  tt=sprintf('%.4f %.4f\n',ms2_cl'); %use cleaned MS2
end
txt=[txt,tt];


txt=[txt,'END IONS\n\n'];
end