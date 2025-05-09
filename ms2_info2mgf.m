function ms2_info2mgf(ms2info,fname,mode,cl,both)
for i=1:length(ms2info)
    i
  fp=fopen(fname,'a');
  txt=mgf_single(ms2info(i),mode,cl,both);
  fprintf(fp,txt);
  fclose(fp);
end
