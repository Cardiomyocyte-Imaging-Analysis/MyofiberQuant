%% Batch File Processing for MFAnalysis %%

clear all;
close all;

% get filename info for images
% Select one file in the folder containing all files to be analyzed.
[filename, pathname, filterIndex] = uigetfile('*.*', 'Open Cell Image');
cd(pathname);
direct=dir;

% prompt = "Is this folder for tissue images(press 1) or cell images(press 0)?";
% Tissue = input(prompt); % Input 1 for tissue. Input 0 for cells.

% create output directory
dirOut = 'MFAnalysis'; % Name of folder containing outputs.
mkdir(dirOut);

% establish excel file for outputs
experiment_title = 'MyofiberQuantResults'; % Name of output excel file.
cd(dirOut);

Tissue = 0;
headers = {'ImageNames','Length','Width','Area','MFArea','MFDensity',...
            'PIndex','Alignment','HIndex'};
writecell(headers,strcat(experiment_title,'.xls'), 'Range', 'A1');

n=1; %count all files in directory
m=1; %count only analyzed files
for imgCount=1:length(direct)
    cd(pathname);
    if direct(imgCount).bytes < 10000 || strcmp(direct(imgCount).name, '.DS_Store')  % Filter based on filesize
        n=n+1;                  % Skip small files (headers,text, & other)
    else                        % Continue if large enough to be an image
        try
            File = direct(imgCount).name; %Get name of file being analyzed
            
            close all;
            [CellLength, CellWidth, CellArea, MFArea, Density, PIndex, Alignment, HIndex] = ProcessImage_combined(pathname,File,dirOut);
            xlsOut = {File, CellLength, CellWidth, CellArea, MFArea, Density, PIndex, Alignment, HIndex};
            xlsRow = strcat('A',num2str(m+1));
            cd(dirOut);
            writecell(xlsOut, strcat(experiment_title,'.xls'), 'Range', xlsRow);
                
            m=m+1;
        catch 
            warning("Error with file " + File);
        end
        n=n+1;
        
    end
end
