clear all; clc; close all;

% Folder Directories
mainfolder = {'C:\Users\Admin\OneDrive\Documents\School\AFIT_Classes\Research\SiC_Size_Dependence_in_AM_Mo\Data\Optical\Surface_Roughness_Images\Mo','C:\Users\Admin\OneDrive\Documents\School\AFIT_Classes\Research\SiC_Size_Dependence_in_AM_Mo\Data\Optical\Surface_Roughness_Images\18nm_MoSiC','C:\Users\Admin\OneDrive\Documents\School\AFIT_Classes\Research\SiC_Size_Dependence_in_AM_Mo\Data\Optical\Surface_Roughness_Images\80nm_MoSiC'};
filetype = '*.csv'; % file type
data=cell(3,15); % Empty Cell for an array

%Storing Table Arrays into a Cell Array
for i=1:numel(mainfolder)
    files = findfiles(filetype,mainfolder{i});
    for k=1:numel(files)
        data{i,k} = rows2vars(readtable(files{k},'Range','A9:B16','ReadRowNames',true),'VariableNamingRule','preserve');% skips the first 8 rows of data
    end
end

%Storing Table Values tables 
Mo_Roughness=vertcat(data{1,1:end});
MoSiC18nm_Roughness=vertcat(data{2,1:end});
MoSiC80nm_Roughness=vertcat(data{3,1:end});

%Exporting Tables
writetable(Mo_Roughness,'Surface_Roughness_Values.xlsx','Sheet',1);
writetable(MoSiC18nm_Roughness,'Surface_Roughness_Values.xlsx','Sheet',2);
writetable(MoSiC80nm_Roughness,'Surface_Roughness_Values.xlsx','Sheet',3);

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
