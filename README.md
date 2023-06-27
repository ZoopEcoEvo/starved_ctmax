# Starvation reduces thermal limits of the widespread copepod *Acartia tonsa*

G. Rueda Moreno<sup>1</sup>, M.C. Sasaki<sup>2,3</sup>

1. New York University, Department of Biology
2. University of Connecticut, Department of Marine Sciences  
3. University of Vermont, Department of Biology  

This project examined how starvation affects the upper thermal limits of the widespread and ecologically important copepod *Acartia tonsa*. Copepods were collected from Eastern Long Island Sound during the summer of 2020. 

Data archived: [![DOI](https://zenodo.org/badge/563165816.svg)](https://doi.org/10.5281/zenodo.8057948)        

## Directory Structure 
The root directory contains the README and Licensing files, along with a .Rproj file and four sub-directories: Data, Manuscript, Output, and Scripts.  

-   `Data/` contains the raw data used in this analysis.  

-   `Manuscript/` contains the R Markdown file, templates, and bibliography used to produce the manuscript draft. 

-   `Output/` contains the various products of the project (processed data, figures, knit reports, and a PDF copy of the manuscript. Note, the `Reports/` directory contains the R Markdown file used to generate the figures used in the manuscript.  

-   `Scripts/` contains two R scripts. 
    -   `01_Data_analysis.R` is used to process the raw data. The primary component is the conversion from timepoint measurements of when each individual reached its CTmax to a measurement in °C using the continuous temperature record from the experiment. 
    -   `02_make_report.R` is use to control the project workflow. Through this script, you can choose to run the process the data, make the figures, or knit the manuscript. This script should be used rather than running isolated fragments individually. 


## Data Description 

The `Data/` directory contains three directories, one for each type of data analyzed in the project:  

-   `body_size` contains the prosome measurements from each replicate experiment. Each file name includes the date of the experiment in YYYY_MM_DD format. Data files include the following columns:  
    -   *tube* - The vessel ID from the CTmax experiment. Allows body sizes to be matched to thermal limit measurements.
    -   *length*	- The prosome length of the individual, measured in mm.
    -   *sex* - The sex of the individual. Note, female copepods were selected at the beginning of the experiment, so this column is not informative.  

-   `temperature_data` contains the continuous temperature data logged onto the Arduino device during the CTmax assay. Each file name includes the date of the experiment in YYYY_MM_DD format. Data files include the following columns:   
    -   *Date* - The date recorded by the temperature logger. Note, these dates may not reflect the actual experimental dates - all information about the date the experiment was performed should be taken from the file name. 	  
    -   *Time*	- The time each temperature measurement was recorded. Again, the absolute time may not be correct, but this column is used to follow the progression of the CTmax assay.    
    -   *Temp1/Temp2/Temp3* - The temperatures (in °C) recorded by each of the three temperature sensors, recorded in their own columns.   

-   `time_data` contains the information for each of the replicate CTmax experiments. Each file name includes the date of the experiment in YYYY_MM_DD format.    
    -   *run_date* - The date the experiment was performed. Should be redundant with the date in the file name.	  
    -   *experiment*	- Which experiment the replicate was for. Experiment one examined the effects of phytoplankton prey options on CTmax, while experiment two examined the effects of starvation on CTmax.     
    -   *start_time* - What time the experiment started. 
    -   *culture* - The copepod culture individuals were collected from. All copepods were collected from the July culture, so this column is redundant.   
    -   *diet* - What the copepods were fed (for experiment one), or whether the copepods were fed or starved (for experiment two).   
    -   *tube*	- The vessel ID. Allows thermal limits measurements to be matched to body size measurements. 
    -   *minute*	- The minute component of the time the individual was observed to have reached its thermal limit in integer form.   
    -   *second*	- The second component of the time the individual was observed to have reached its thermal limit in integer form.   

  
## Workflow

The workflow is operated via the 02_Make_report.R script in the Scripts directory. It is not recommended that you run analyses or knit documents from the files themselves as the file paths are internally set and may not be correct otherwise. At the top of this script, you are able to indicate whether:

1. The raw data should be processed to estimate thermal limits.  

2. The summary file (located in the Output/Reports directory) should be knit. This markdown file will generate the figures used in the manuscript, as well as an HTML and a GitHub flavored markdown document.

3. The manuscript file (located in the Manuscripts directory) should be knit. This markdown file will produce formatted PDF and word document versions of the manuscript. 


## Versioning   

R version 4.2.2 (2022-10-31)  

Platform: x86_64-apple-darwin17.0 (64-bit)  

Running under: macOS Ventura 13.4 
  
**Attached base packages:** stats, graphics, grDevices, utils, datasets, methods, base     

**Other; attached; packages:**; ggpubr_0.5.0; knitr_1.41; RColorBrewer_1.1-3; ggbeeswarm_0.7.1; dabestr_0.3.0; magrittr_2.0.3; forcats_0.5.2; stringr_1.5.0; dplyr_1.0.10; purrr_1.0.0; readr_2.1.3; tidyr_1.2.1; tibble_3.1.8; ggplot2_3.4.2; tidyverse_1.3.2; rmarkdown_2.20  


## Funding

This study was funded by grants from the National Science Foundation (OCE-1947965, OCE-2205848, and DBI-1658663).
