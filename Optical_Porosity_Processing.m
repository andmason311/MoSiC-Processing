clear all; clc; close all;

mainfolder = {'C:\Users\Admin\OneDrive\Documents\School\AFIT_Classes\Research\SiC_Size_Dependence_in_AM_Mo\Data\Optical\Optical_Porosity_Images\Mo','C:\Users\Admin\OneDrive\Documents\School\AFIT_Classes\Research\SiC_Size_Dependence_in_AM_Mo\Data\Optical\Optical_Porosity_Images\18nm_MoSiC','C:\Users\Admin\OneDrive\Documents\School\AFIT_Classes\Research\SiC_Size_Dependence_in_AM_Mo\Data\Optical\Optical_Porosity_Images\80nm_MoSiC'};
filetype = '*.jpg'; % file type ending
data=cell(3,15); % Empty Cell for an array
%Storing Table Arrays into a Cell Array
for i=1:numel(mainfolder)
    files = findfiles(filetype,mainfolder{i});
    t=1; % initialize index counter
    for k=1:numel(files)/2 
        data{i,k} = mean([findporosity(files{t},85),findporosity(files{t+1},85)]);
        t=t+2; %index counter
    end
end

%Export data as excel folder
writetable(array2table(transpose(data),'VariableNames',{'Mo','MoSiC_18nm','MoSiC_80nm'}),'Optical_Porosity_Values.xlsx');

%% Convert Image to Black/White and Determine Porosity Function
function porosity = findporosity(filename,thresholdValue)
A = imread(filename); %imshow(A);

% convert to gray scale
originalImage = rgb2gray(A);imshow(originalImage)

%Create Histogram of Sweep of Threshold Values
[pixelCount, grayLevels] = imhist(originalImage);
figure(2)
bar(pixelCount);
title('Histogram of Threshold Values for Image Conversion to Binary Color Pixels', 'FontSize', 16);
xlim([0 200]); % Scale x axis manually.
grid on;

binaryImage = originalImage < thresholdValue; % Bright objects will be chosen if you use >.
binaryImage = imfill(binaryImage, 'holes');

hold on;
maxYValue = ylim;
line([thresholdValue, thresholdValue], maxYValue, 'Color', 'r');
% Place a text label on the bar chart showing the threshold.
annotationText = sprintf('%d Grey Level Threshold', thresholdValue);
% For text(), the x and y need to be of the data class "double" so let's cast both to double.
text(double(thresholdValue + 1), double(0.7 *300000), annotationText, 'FontSize', 10, 'Color', [1,0,0]);
text(double(thresholdValue - 70), double(0.98 * 300000), 'Background', 'FontSize', 10, 'Color', [0 0 .5]);
text(double(thresholdValue + 80), double(0.77 * 300000), 'Foreground', 'FontSize', 10, 'Color', [0 0 .5]);

% Display the binary image.
figure(3)
imshow(binaryImage);
title('Pixel Count ', 'FontSize', 16);
solid = sum(sum(binaryImage == 0));
void = sum(sum(binaryImage == 1));
porosity = void/(solid+void)*100;
end


%% Find All Specified File Types Under a Main Folder Function
function flist = findfiles(pattern,basedir)
% Recursively finds all instances of files and folders with a naming pattern
%
% FLIST = FINDFILES(PATTERN) returns a cell array of all files and folders
% matching the naming PATTERN in the current folder and all folders below
% it in the directory structure. The PATTERN is specified as a string, and
% can include standard file-matching wildcards.
%
% FLIST = FINDFILES(PATTERN,BASEDIR) finds the files starting at the
% BASEDIR folder instead of the current folder.
%
% Examples:
% Find all MATLAB code files in and below the current folder:
%   >> files = findfiles('*.m');
% Find all files and folders starting with "matlab"
%   >> files = findfiles('matlab*');
% Find all CSV in and below the folder C:\Mo
%   >> files = findfiles('*.csv','C:\Mo');
%
% Copyright 2016 The MathWorks, Inc.
% Maybe need to add extra bulletproofing for stupid things like
% findfiles('.*')
% Input check
if nargin < 2
    basedir = pwd;
end
if ~ischar(pattern) || ~ischar(basedir)
    error('File name pattern and base folder must be specified as strings')
end
if ~isfolder(basedir)
    error(['Invalid folder "',basedir,'"'])
end
% Get full-file specification of search pattern
fullpatt = [basedir,filesep,pattern];
% Get list of all folders in BASEDIR
d = cellstr(ls(basedir));
d(1:2) = [];
d(~cellfun(@isfolder,strcat(basedir,filesep,d))) = [];
% Check for a direct match in BASEDIR
% (Covers the possibility of a folder with the name of PATTERN in BASEDIR)
if any(strcmp(d,pattern))
    % If so, that's our match
    flist = {fullpatt};
else
    % If not, do a directory listing
    f = ls(fullpatt);
    if isempty(f)
        flist = {};
    else
        flist = strcat(basedir,filesep,cellstr(f));
    end
end
% Recursively go through folders in BASEDIR
for k = 1:length(d)
    flist = [flist;findfiles(pattern,[basedir,filesep,d{k}])]; %#ok<AGROW>
end
end