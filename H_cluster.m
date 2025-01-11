
%% -------------------------------------------------
%  Author: Dr. Munir Gunes Kutlu
%  Affiliation: Temple University, Center for Substance Abuse Research
%  https://www.mathworks.com/help/bioinfo/ug/working-with-the-clustergram-function.html#d123e16640
%  -------------------------------------------------

% Specify the folder where the files live.
myFolder1 = '/folder';
% Check to make sure that folder actually exists.  Warn user if it doesn't.
if ~isfolder(myFolder1)
    errorMessage = sprintf('Error: The following folder does not exist:\n%s\nPlease specify a new folder.', myFolder1);
    uiwait(warndlg(errorMessage));
    myFolder1 = uigetdir(); % Ask for a new one.
    if myFolder1 == 0
         % User clicked Cancel
         return;
    end
end

% Get a list of all files in the folder with the desired file name pattern.
filePattern = fullfile(myFolder1, '*.csv'); % Change to whatever pattern you need.
csvfiles1 = dir(filePattern);
for k = 1 : length(csvfiles1)
    baseFileName = csvfiles1(k).name;
    fullFileName = fullfile(csvfiles1(k).folder, baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);
end

names = struct2table (csvfiles1)
Cell_ids = names.name
% Cell_ids = readcell('Cell_id_list_actual_filenames.csv');
Sample_ids = readcell('Sample_row_name_list.csv'); 

values = csvread('combined_cell_signal.csv'); 
values = downsample( values , 5 ) %downsample by 10 for 20fps and 5 for 13 fps
Sample_ids = downsample( Sample_ids , 5 ) %downsample by 10 for 20fps and 5 for 13 fps


% %%%%CS values%%%%
% values (1:6,:) = []
% Sample_ids (1:6,:) = []
% values (30:39,:) = []
% Sample_ids (30:39,:) = []


%%Shock values%%%%
values (1:30,:) = []
Sample_ids (1:30,:) = []


cg_s = clustergram(values, 'RowLabels', Sample_ids,...
                               'ColumnLabels', Cell_ids,...
                               'Cluster', 'row',...
                               'ImputeFun', @knnimpute,...
                               'OptimalLeafOrder', 'true' )
get(cg_s)

cg_s.ColumnPDist = 'cosine' ;
cg_s.Dendrogram = 1;

cg_s.Colormap = redbluecmap;
cg_s.DisplayRange = 3;

%%
%%%write results%%%%%
data = increase_cells.ColumnNodeNames'
data1 = cell2table(data)
% writetable(data, 'CS_Node2_cells.csv');
% csvwrite('CS_Node2_cells.csv',data)

data = decrease_cells.ColumnNodeNames'
data2 = cell2table(data)
% writetable(data, 'CS_Node1_cells.csv');            



node1_list = cell(1,(height(data1)));
node2_list = cell(1,(height(data2)));

node1_list = table2cell (data1);
node2_list = table2cell (data2);

%%
myFolder1 = '/folder/cell_files';
List = node1_list; %CHANGE THIS; select from variable above

 % Get a list of all files in the folder with the desired file name pattern.
filePattern = fullfile(myFolder1, '*.csv'); % Change to whatever pattern you need.
csvfiles = dir(filePattern);
for k = 1:length(csvfiles)
    for n = 1:length(List) 
        if isequal(List{n}, csvfiles(k).name);
            %CHANGE THIS; selects new folder where to copy file 
            copyfile(csvfiles(k).name, '/folder/Node1')
        end
    end
end



myFolder1 = '/folder/cell_files';
List = node2_list; %CHANGE THIS; select from variable above

 % Get a list of all files in the folder with the desired file name pattern.
filePattern = fullfile(myFolder1, '*.csv'); % Change to whatever pattern you need.
csvfiles = dir(filePattern);
for k = 1:length(csvfiles)
    for n = 1:length(List) 
        if isequal(List{n}, csvfiles(k).name);
            %CHANGE THIS; selects new folder where to copy file 
            copyfile(csvfiles(k).name, '/folder/Node2')
        end
    end
end

