% this function calls mzxmlread_xi, convert mzxml into M structure
function [M,A] = mzxml2structMS2_com(fname)

A=mzxmlread_xi(fname);
A=A.scan;B=[];
for i=1:length(A)
    if A(i).msLevel==2
      precursor(i)=A(i).precursorMz.value;
    else
      precursor(i)=0;
    end
end
items=unique(precursor)';
B=[];
for i=1:length(items)
  B{i}=A(abs(precursor-items(i))<0.0002);  
end
for f=1:length(B)
    mat=[];
   for i=1:length(B{f})      
    rt_str=B{f}(i).retentionTime; %rt time
    mat{i,1}=str2num(rt_str(3:end-1))/60;
    pair=B{f}(i).peaks.mz;%mass-inten pair
    mz=pair(1:2:length(pair)-1);
    inten=pair(2:2:length(pair));
    mat{i,2}=mz;
    mat{i,3}=inten;
   end
    %M(f).filename=items{f};
    M(f).data=mat;
    M(f).rt=cell2mat(M(f).data(:,1));     
    M(f).precursor=items(f);   
     
end
