%% Batch File Processing for MFAnalysis %%

clear all;
close all;

% get filename info for images
% Select one file in the folder containing all files to be analyzed.
[filename, pathname, filterIndex] = uigetfile('*.*', 'Open Tissue/Cell Image');
cd(pathname);
direct=dir;

%prompt = "Is this folder for tissue images(press 1) or cell images(press 0)?";
%Tissue = input(prompt); % Input 1 for tissue. Input 0 for cells.
Tissue = 1;

% create output directory
dirOut = 'MFAnalysisNew'; % Name of folder containing outputs.
mkdir(dirOut);

% establish excel file for outputs
experiment_title = 'SampleData'; % Name of output excel file.
cd(dirOut);

if Tissue == 1
    headers = {'ImageNames','Length','Width','Area','MFArea','MFDensity',...
            'PIndex','Alignment','HIndex'};
elseif Tissue == 0
    headers = {'ImageNames','Length','Width','Area','MFArea','MFDensity',...
            'PIndex','Alignment','HIndex'};
end
writecell(headers,strcat(experiment_title,'.xls'), 'Range', 'A1');

n=1; %count all files in directory
m=1; %count only analyzed files
parfor imgCount=1:length(direct)
    cd(pathname);
    if direct(imgCount).bytes < 10000 || strcmp(direct(imgCount).name, '.DS_Store')  % Filter based on filesize
        n=n+1;                  % Skip small files (headers,text, & other)
    else                        % Continue if large enough to be an image
        try
            File = direct(imgCount).name; %Get name of file being analyzed
            fprintf('File %s selected\n', File);
            if Tissue == 1
                 fprintf('Tissue selected\n')
                 [Length, Width, Area, MFArea, Density, PIndex, Alignment, HIndex] = ProcessTissue_combined(pathname,File,dirOut);
                 fprintf('ProcessTissue_combined successful\n');
                 xlsOut = table(string(File), Length, Width, Area, MFArea, Density, PIndex, Alignment, HIndex);
                 xlsRow = strcat('A',num2str(imgCount+1));
                 fprintf('Output concatenation successful\n');
                 cd(dirOut);
                 writetable(xlsOut,strcat(experiment_title,'.xls'),'Range',xlsRow, 'WriteVariableNames', false);
                 fprintf('Writing to table successful\n');
            elseif Tissue == 0
                close all;
                [CellLength, CellWidth, CellArea, MFArea, Density, PIndex, Alignment, HIndex] = ProcessImage_combined(pathname,File,dirOut);
                xlsOut = {File, CellLength, CellWidth, CellArea, MFArea, Density, PIndex, Alignment, HIndex};
                xlsRow = strcat('A',num2str(imgCount+1));
                cd(dirOut);
                writecell(xlsOut, strcat(experiment_title,'.xls'), 'Range', xlsRow);
                
            end
        catch 
            warning("Error with file " + File);
        end
        
    end
end
