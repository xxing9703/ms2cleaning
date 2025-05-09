function spectra=getMS(M,pk)
num_file=length(M);
spectra=cell(num_file,1);
for j=1:num_file
    rt_array=M(j).rt;
    [~, index] = min(abs(rt_array-pk.rt));    
    mz_array=M(j).data{index,2};
    sig_array=M(j).data{index,3};
    spectra{j}=[mz_array,sig_array];  
end