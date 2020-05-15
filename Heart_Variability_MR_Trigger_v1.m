%%% Tyler E. Cork
%%% Stanford University
%%% March 3rd, 2020

%% User Input to Caluclate Heart Rate Pattern
clear all
close all
clc

indir     = '/Users/tecork/Desktop/';   % Initial Directory
N_beats   = 300;                        % Number of Beats
N_skipped = 30;                         % Number of Skipped Heart Beats
RR_mean   = 1014;                       % Mean R-R interval
RR_std    = 65.3;                       % Standard Deviation of R-R Interval

% R-R mean of 1014 and R-R Standard Deviation of 65.3 come from this paper:
% https://onlinelibrary.wiley.com/doi/abs/10.1111/anae.12317 


% Set up Directories for storing information
today = date;
d = [today(8:end), '-', today(4:6), '-', today(1:2)];

folder_Path    = [d,                  '_Heart_Rate_Variability_', ...
                  num2str(N_beats),   '_Beats_',                  ...
                  num2str(N_skipped), '_skipped_beats'];
              
main_folder    = fullfile(indir, folder_Path);

Excell_Path    = ['Key_',                                         ...
                   num2str(N_beats),   '_Beats_',                 ...
                   num2str(N_skipped), '_skipped_beats.xlsx'];


Fig_1_Path     = ['HRV_Plot_',                                    ...
                  num2str(N_beats),   '_Beats_',                  ...
                  num2str(N_skipped), '_skipped_beats.pdf'];
            
Fig_2_Path     = ['Scanner_Trigger_',                             ...
                  num2str(N_beats),   '_Beats_',                  ...
                  num2str(N_skipped), '_skipped_beats.pdf'];
              
Arduino_Folder = ['HRV_Arduino_Script_',                          ...
                  num2str(N_beats),   '_Beats_',                  ...
                  num2str(N_skipped), '_skipped_beats'];
              
Arduino_Path   = ['HRV_Arduino_Script_',                          ...
                  num2str(N_beats),   '_Beats_',                  ...
                  num2str(N_skipped), '_skipped_beats.ino'];

if ~exist(main_folder, 'dir')
       mkdir(main_folder)
end

if ~exist(fullfile(main_folder, Arduino_Folder), 'dir')
       mkdir(fullfile(main_folder, Arduino_Folder))
end

%% Creates Heart Rate Variability Patern and plots mean and std
x = round(RR_mean + RR_std * randn(N_beats,1, 'single'));
%disp(sum(x));                     % Original duration
for i = 1:N_skipped
    ind = randi([2 size(x,1)]);   % ind to skip (cant skip first beat)
    x(ind-1) = x(ind-1) + x(ind); % Add skipped beat duration to previous
    x(ind) = [];                  % Remove skipped beat
    skipped(1,i) = ind;
end
%disp(sum(x));                     % Duration should remain the same

%% Plots Guassian Distriburtion of Heart Beat Times
fig_1 = figure(1);
plot(x, 'k', 'LineWidth', 2)
hold on
plot((ones(N_beats,1)*RR_mean), 'r--', 'LineWidth', 2)
hold on
plot((ones(N_beats,1)*RR_mean + [RR_std -RR_std]), 'b-.', 'LineWidth', 2)
title('Guassian Distriburtion of Heart Beat Times')
xlabel('Beat Number, (A.U.)')
ylabel('R-R peak interval, (ms)')
legend('R-R interval time', ['\mu = ',num2str(RR_mean), ' ms'], ...
        ['\sigma = ', num2str(RR_std), ' ms'])
saveas(fig_1, fullfile(indir, folder_Path, Fig_1_Path))

%% Write Arduino File
f = fopen(fullfile(indir, folder_Path, Arduino_Folder, Arduino_Path),'wt');

fprintf(f, '\n');
fprintf(f, 'const int led  =  13;        //use digital I/O pin 13\n');
fprintf(f, 'void setup()\n');
fprintf(f, '{\n');
fprintf(f, 'pinMode(led,OUTPUT);         //set pin 13 to be an output\n');
fprintf(f, 'delay(100);                  //delay 100 milliseconds\n');
fprintf(f, '}\n');
fprintf(f, 'void loop()\n');
fprintf(f, '{\n');

ss = 1;
for ii = 1:numel(x)
    ee = ss + x(ii) - 101;
    y(ss:ee) = 0;
    y(ee+1:ee+101) = 5;
    ss = ee+101;
    fprintf(f, 'delay(%s);                //delay %s milliseconds\n', ...
            num2str(x(ii) - 100), num2str(x(ii) - 100));
    fprintf(f, 'digitalWrite(led,HIGH);   //set pin 13 HIGH\n');
    fprintf(f, 'delay(100);               //delay 100 milliseconds\n'); 
    fprintf(f, 'digitalWrite(led,LOW);    //set pin 13 LOW\n');
end
fprintf(f, '}\n');

%% Plots external trigger that scanner will see
fig_2 = figure(2)
plot(y)
ylim([0 6])
xlim([0 length(y)])
ylabel('Volts, (V)')
xlabel('Time, (ms)')
title('Trigger to Scanner')
saveas(fig_2, fullfile(indir, folder_Path, Fig_2_Path))

%% Creates Heart Rate Key
key = cell(numel(x),3);

for i = 1:numel(x)

    if x(i) >  1.5 * RR_mean 
        note = ['Includes Skipped beat'];
    else note = [''];
    end
    key(i,1) = {i};
    key(i,2) = {x(i)};
    key(i,3) = {note};
    clear note
end

%% Writes Key to Excell File
key = cell2table(key, 'VariableNames',{'Triger_Number' 'RR_Interval' 'Notes'});
writetable(key, fullfile(indir, folder_Path, Excell_Path))
