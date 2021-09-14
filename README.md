# MyofiberQuant
Quantify myofibrillar structural characteristics in images of stem cell-derived cardiomyocytes.
Quantify myofibrillar structural characteristics in images of micron-scale 2D cardiac muscle bundles derived from stem cell-derived cardiomyocytes.

# Reference This Work
Ufford, Kathryn, et al. "Myofibrillar Structural Variability Underlies Contractile Function in Stem Cell-Derived Cardiomyocytes." Stem Cell Reports 2021. PMID 33577793.

Tsan, Yao-Chang, et al. "Physiologic Biomechanics Enhance Reproducible Contractile Development in a Stem Cell Derived Cardiac Muscle Platform." Nature Comm. In press. 

DOI: 10.5281/zenodo.5508165

# Getting Started
1.	Download and unzip MyofiberQuant-main and navigate to the MyofiberQuant-main folder in MATLAB.
2.	Copy all TIF images to be analyzed to a single folder (containing only the images to be analyzed) in the same parent directory as MyofiberQuant.
3.	Add the parent directory of MyofiberQuant and all subfolders to the MATLAB path by right clicking on the parent directory folder and Add to Path > Selected Folders and Subfolders
4.	To initialize analysis, type the following in the MATLAB command line
`MyofiberQuantCell` for a single micropatterned iPSC-CM analysis or 'MyofiberQuantM2B' for an M2B analysis. Parallel processing is used for the M2B analysis due to larger file size - adjust settings in Matlab to optimize for number of M2Bs being analyzed and threads available on the workstation (M2Bs are run in parallel such that each file will use a single thread).
5.	Wait for a File Explorer window to pop up and select a single TIF file for analysis.
6.	The analysis will run and values for specific images will appear in a folder titled MFAnalysis in the folder containing the images. An Excel workbook with values will be populated in a file titled MyofiberQuantResults.xls in the MFAnalysis folder.

# Notes
- MyofiberQuant assumes that myofibrils will be generally organized through micropatterning and that myofibrils will be generally oriented along the horizontal axis of the image. The algorithm will not be accurate for disorganized myofibrils that occur in absence of micropatterning since signal peaks are expected to occur along the horizontal axis - disorganized myofibrils will cause signal intensity drop-out and over-estimates of alignment.
- MyofiberQuant recognizes myofibrils through relative peak intensities from the Gaussian distributions of F-actin signal. This approach results in some relative over-estimation of myofibrillar abundance in cells/tissues with sparse myofibrils and relative underestimation of myofibrillar abundance in cells/tissues with very dense myofibrils.  

# System Requirements
MATLAB Version >= 9.6
Curve Fitting Toolbox Version 3.5.11
Image Processing Toolbox Version 11.1
Signal Processing Toolbox Version 8.4
Wavelet Toolbox 5.4

To check the version of MATLAB and which Toolboxes you have installed, type the following in the MATLAB command line:
`ver`
