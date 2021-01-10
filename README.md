# MyofiberQuant
Quantify myofibrillar structural characteristics in images of stem cell-derived cardiomyocytes.
# Reference This Work
Ufford, Kathryn, et al. "Myofibrillar Structural Variability Underlies Contractile Function in Stem Cell-Derived Cardiomyocytes."

# Getting Started
1.	Download and unzip MyofiberQuant-main and navigate to the MyofiberQuant-main folder in MATLAB.
2.	Copy all TIF images to be analyzed to a single folder (containing only the images to be analyzed) in the same parent directory as MyofiberQuant.
3.	Add the parent directory of MyofiberQuant and all subfolders to the MATLAB path by right clicking on the parent directory folder and Add to Path > Selected Folders and Subfolders
4.	To initialize analysis, type the following in the MATLAB command line
`MyofiberQuant`
3.	Wait for a File Explorer window to pop up and select a single TIF file for analysis.
4.	The analysis will run and values for specific images will appear in a folder titled MFAnalysis in the folder containing the images. An Excel workbook with values will be populated in a file titled MyofiberQuantResults.xls in the MFAnalysis folder.

# System Requirements
MATLAB Version >= 9.6
Curve Fitting Toolbox Version 3.5.11
Image Processing Toolbox Version 11.1
Signal Processing Toolbox Version 8.4
Wavelet Toolbox 5.4

To check the version of MATLAB and which Toolboxes you have installed, type the following in the MATLAB command line:
`ver`
