%% Homework 2 - Noise
%{
 Each TIFF file is one frame. Exposure time (expT) and Gain are noted
 in the record's names (folder names).
1. Calculate for each recording (make a table)
a. Temporal Noise
b. Global Spatial Noise (after averaging in time)
c. Local Spatial Noise with window size of 7 (after averaging in time)
d. Local Spatial Noise with window size of 7 per frame – then average over all frames.
Is it equal to the total Noise [ totalNoise = √TemporalNoise2 + LocalSpatialNoise2 ] ?
3. Which noise is recorded when the exposure time is 21µs (given this is the minimum exposure time for 
that camera) and the camera is closed with a cover ?
4. Which noises are recorded when the exposure time is >>21µs and the camera is closed with a cover ?
5. Which noise dominates in the recording when the camera is not closed, and the exposure time is 
>>21µs ? 
Calculate temporalNoise2
/Mean for this recording. 
Does it (approximately) equal to 2
𝑛𝐵𝑖𝑡𝑠[𝐷𝑈]
maxcapacity[e]
⋅ 10𝑔𝑎𝑖𝑛[𝑑𝐵]/20 ?
Why do you think the Global Spatial Noise is much higher than the Local Spatial Noise (try to plot the 
mean image with imagesc(mean(rec,3)) )?
Notes:
• The camera used for this recording is Basler acA1440-220um (additional data) 
Maximum capacity of this camera is 10,500[e]
• The records were recorded at Mono12 (grayscale of 12bits)
• Useful functions 
- std(im,w,dim)
- stdfilt(im,nhood)
- mean2(im)
- mean(rec,dim)



Make sure that the records dont start with a number
%}

clear all
clc
close all

% Add the auxiliary code folder to the path
auxiliary_code_Folder = '\\madrid.eng.biu.ac.il\enggrad\tzroyaa\My Documents\Nerophotonics\HW2_209010651\auxiliary_code';
addpath(auxiliary_code_Folder);

% Define the path to the records directory
recordsPath = '\\madrid.eng.biu.ac.il\enggrad\tzroyaa\My Documents\Nerophotonics\HW2_209010651\records';
% Get a list of all subfolders in the records directory
subfolders = dir(recordsPath);
% Remove '.' and '..' directories
subfolders = subfolders([subfolders.isdir] & ~ismember({subfolders.name}, {'.', '..'}));

% Initialize variables for the table
recordFolderIndex = [];
recordPath = {};
recordRec = {};
recordInfo = {};
num_records=length(subfolders);
% Define constants
nBits = 12;  % Number of bits (Mono12)
max_capacity=10500;
% Define window size for local spatial noise
window_size = 7;

% Initialize arrays to store noise results
temporalNoise = zeros(num_records, 1);
globalSpatialNoise= zeros(num_records, 1);
localSpatialNoise_avg_time = zeros(num_records, 1);
localSpatialNoise_per_frame_Thenavg_frames = zeros(num_records, 1);
totalNoise = zeros(num_records, 1);
noiseNumber5 = zeros(num_records, 1);
theoreticalNoise = zeros(num_records, 1);

% Loop through each subfolder and store its path and files
for recordIndex = 1:length(subfolders)
    folderName= subfolders(recordIndex).name;
    nametemp{recordIndex}=folderName;

    folderPath = fullfile(recordsPath, folderName);
 
    % Store the path of the folder
    fprintf('Processing folder: %s\n', folderPath);
    % Call the ReadRecord function
    [rec, info] = ReadRecord(folderPath, [], []);
    
    % Store rec and info in the table
    recordRec = [recordRec; {rec}];
    recordInfo = [recordInfo; {info}];
    recordPath=[ recordPath ; {folderPath}];

    % Load the recording - Calculate for each recording (make a table)
    % rec = recordsTable.RecordRec{recordIndex};
    %a. Temporal Noise
    temporalNoise(recordIndex)=mean2(std(rec,0,3));
    % b. Global Spatial Noise (after averaging in time)
    globalSpatialNoise(recordIndex)=std2(mean(rec,3)); 
    %c. Local Spatial Noise with window size of 7 (after averaging in time)
    localSpatialNoise_avg_time(recordIndex)=mean2(stdfilt(mean(rec,3),ones(window_size))); 
    % d. Local Spatial Noise with window size of 7 per frame – then average over all frames.
    for frameIndex=1:size(rec,3)
        localSpatialNoise_temp(frameIndex)=mean2(stdfilt(rec(:,:,frameIndex),ones(window_size)));
    end
    localSpatialNoise_per_frame_Thenavg_frames(recordIndex)=mean2(localSpatialNoise_temp);

    % d. Is it equal to the total Noise [ totalNoise = √TemporalNoise2 + LocalSpatialNoise2 ]
    totalNoise(recordIndex)=sqrt(temporalNoise(recordIndex).^2+localSpatialNoise_avg_time(recordIndex).^2);

    % Noise of question number 5 - temporal noise in power 2 divided by the
    % average of the pixels
    noiseNumber5(recordIndex)=temporalNoise(recordIndex).^2./mean2(mean(rec,3));

    % Calculate temporalNoise^2 / Mean and compare with the given formula
    gain_dB = info.name.Gain;  % Assuming Gain is in RecordInfo
    theoreticalNoise(recordIndex) = ((2^nBits) / max_capacity) * 10^(gain_dB / 20);
end

% Create a table with the collected data
recordsTable = table(recordPath, recordRec, recordInfo, 'VariableNames', {'RecordPath', 'RecordRec', 'RecordInfo'});
recordsTable.RecordName=nametemp(:);
% Add noise columns to the table
recordsTable.TemporalNoise = temporalNoise;%a
recordsTable.GlobalSpatialNoise = globalSpatialNoise;%b
recordsTable.LocalSpatialNoiseAvgTime = localSpatialNoise_avg_time;%c
recordsTable.LocalSpatialNoisePerFrames = localSpatialNoise_per_frame_Thenavg_frames; %d
recordsTable.TotalNoise = totalNoise; %d
recordsTable.TemporalNoiseContribution = noiseNumber5; %5
recordsTable.TheorticalNoise = theoreticalNoise;%5

%% Plotting
datatToPlot=recordsTable(:,4:end);

% Calculate the number of rows and columns
[numRows, numCols] = size(datatToPlot);

% Define the size of each cell in pixels
cellWidth = 100;
cellHeight = 30;

% Calculate the width and height of the uitable
tableWidth = cellWidth * numCols+300;
tableHeight = cellHeight * numRows;

% Create a figure with adjusted size
f = figure('DefaultAxesFontUnits', 'Points', 'DefaultAxesFontSize', 18, 'DefaultAxesFontName', 'Times New Roman', ...
    'DefaultTextFontUnits', 'Points', 'DefaultTextFontSize', 20, 'DefaultTextFontName', 'Times New Roman', ...
    'DefaultLineLineWidth', 1, 'Color', 'White','Position', [100, 100, tableWidth + 40, tableHeight + 60]);
% Create a uitable in the figure
uit = uitable('Parent', f, 'Data', table2cell(datatToPlot), ...
    'ColumnName', datatToPlot.Properties.VariableNames, ...
    'RowName', datatToPlot.Properties.RowNames, ...
    'Position', [20, 20, tableWidth, tableHeight]);

%% Create a figure with adjusted size
f = figure('DefaultAxesFontUnits', 'Points', 'DefaultAxesFontSize', 18, 'DefaultAxesFontName', 'Times New Roman', ...
    'DefaultTextFontUnits', 'Points', 'DefaultTextFontSize', 20, 'DefaultTextFontName', 'Times New Roman', ...
    'DefaultLineLineWidth', 1, 'Color', 'White');
recordIndex = 1; % Record where the camera is not closed
imagesc(mean(recordsTable.RecordRec{recordIndex},3));
colorbar;
title(recordsTable.RecordName{recordIndex})

%% Create a figure with adjusted size
f = figure('DefaultAxesFontUnits', 'Points', 'DefaultAxesFontSize', 18, 'DefaultAxesFontName', 'Times New Roman', ...
    'DefaultTextFontUnits', 'Points', 'DefaultTextFontSize', 20, 'DefaultTextFontName', 'Times New Roman', ...
    'DefaultLineLineWidth', 1, 'Color', 'White');
for recordIndex = 1:num_records % Record where the camera is not closed

    subplot(2,2,recordIndex);
    imagesc(mean(recordsTable.RecordRec{recordIndex},3));
    colorbar;
    title(recordsTable.RecordName{recordIndex})
end