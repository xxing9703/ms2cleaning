%This function calculates pearson correlation between two eics
%eic1 is the longer eic for MS1, 
%eic2 is the shorter eic for MS2,
%score returns the correlation
function score=eic_corr(eic1,eic2)

    ub=max(eic2(:,1));
    lb=min(eic2(:,1));
    
    ind=find(eic1(:,1)<ub & eic1(:,1)>lb);
    eic1=eic1(ind,:); %trancate eic1
    eic2_interp=interp1(eic2(:,1),eic2(:,3),eic1(:,1));%interpolation
    eic2_interp(isnan(eic2_interp))=0;  %replace NaN with 0
    
    c=corrcoef(eic1(:,3),eic2_interp);    
    score=c(2); 
