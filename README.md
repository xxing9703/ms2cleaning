# ms2cleaning
## Introduction
MS2 spectrum collected in Parallel Reaction Monitoring (PRM) mode, also known as t-MS2, is a targeted mothed. An inclusion list is provided. Even though a narrow m/z window is set (usually ~ 0.5- 1 Da), allien or background peaks can enter, resulting in fragment peaks not truly from the fragmentation of the precursor. These fake fragment peaks need to be removed.  Since the MS2 of a targeted peak is collected continuously within an RT window (typically ~ 3 mins), EICs (Extracted Ion Chromatogram) for each precusor as well as its fragment peaks can be extracted. Peak shape correlation (Pearson) between fragment EIC and precusor EIC can be used to determine whether the fragment peak is real or not.

## Use of this code
1. Raw data need to be converted to mzXML first, see screenshot_MSconvert for setting up the MSconvertor 
2. Put all mzXML files and csv files(inclusion list) in the same data folder.
3. Each .mzXML file should be associated with an inclusion list in .csv, defined by "index.xlsx", which can be generated either manually or automatically. see an example index file
4. "ms2_index.m" provides an automatic tool for pairing up all mzXML files with all csv files within the folder and generates index.xlsx. Please make sure there are no other non-relavent mzXML or csv files in the same folder.  It's always good to manually check afterwards and see if the association is correct. 
5. "ms2_clean_main"  is the main script for processing & cleaning MS2.  step 4 is integrated in.  Simply run it, select a folder where the MS2 data is located, and done.
6. output:  two .mgf files, (1 for clean and 1 for unclean).  ms2info.mat files store all MS2 information in matlab structure, for further use in matlab coding. 
