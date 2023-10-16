clear all
close all
clc

% Prompt the user to select the Excel file
[filename, pathname] = uigetfile('*.xlsx', 'Select the Excel file');
filepath = fullfile(pathname, filename);

% Read the data
data = readtable(filepath);

% Convert year columns to datetime format
data.year1 = datetime(data.year1, 'InputFormat', 'd-MMM-yyyy');
data.year2 = datetime(data.year2, 'InputFormat', 'd-MMM-yyyy');

% Find common dates
[commonDates, ia, ib] = intersect(data.year1, data.year2);

% Filter data for common dates
modelledHs_common = data.modelledHs(ia);
measuredHs_common = data.measuredHs(ib);
modelledTm_common = data.modelledTm(ia);
measuredTm_common = data.measuredTm(ib);

%% --- Time Series Plots ---
% Increase the font size for all plots
set(0, 'DefaultAxesFontSize', 14);
figure;
% Wave height plot
subplot(2,1,1);
hold on;
plot(data.year1, data.modelledHs, '-o');
plot(data.year2, data.measuredHs, '--');
legend('Modelled Hs', 'Measured Hs');
xlabel('Date');
ylabel('Significant Wave Height (Hs)');
title('Time Series of Significant Wave Height');
grid on;
hold off;
% Activate the box around the plot
box on;


% Wave period plot
subplot(2,1,2);
hold on;
plot(data.year1, data.modelledTm, '-o');
plot(data.year2, data.measuredTm, '--');
legend('Modelled Tm', 'Measured Tm');
xlabel('Date');
ylabel('Mean Wave Period (Tm)');
title('Time Series of Mean Wave Period');
grid on;
hold off;
% Save the time series plots with high resolution
print('TimeSeriesPlots', '-dpng', '-r300');
% Activate the box around the plot
box on;


%% --- Scatter Plots with Fit Line ---
figure;
% Wave height scatter plot with fit line
subplot(2,1,1);
hold on;
scatter(data.modelledHs(ia), data.measuredHs(ib), 'o');
if exist('fit', 'file')
    % Using Curve Fitting Toolbox
    fitObjHs = fit(data.modelledHs(ia), data.measuredHs(ib), 'poly1');
    plot(fitObjHs);
else
    % Alternative: Using polyfit and polyval
    p = polyfit(data.modelledHs(ia), data.measuredHs(ib), 1);
    f = polyval(p, data.modelledHs);
    plot(data.modelledHs, f, 'r-');
end
xlabel('Modelled Hs');
ylabel('Measured Hs');
title('Scatter Plot of Significant Wave Height with Fit Line');
grid on;
hold off;
% Activate the box around the plot
box on;

% Wave period scatter plot with fit line
subplot(2,1,2);
hold on;
scatter(data.modelledTm(ia), data.measuredTm(ib), 'o');
if exist('fit', 'file')
    % Using Curve Fitting Toolbox
    fitObjTm = fit(data.modelledTm(ia), data.measuredTm(ib), 'poly1');
    plot(fitObjTm);
else
    % Alternative: Using polyfit and polyval
    p = polyfit(data.modelledTm(ia), data.measuredTm(ib), 1);
    f = polyval(p, data.modelledTm(ia));
    plot(data.modelledTm, f, 'r-');
end
xlabel('Modelled Tm');
ylabel('Measured Tm');
title('Scatter Plot of Mean Wave Period with Fit Line');
grid on;
hold off;
% Activate the box around the plot
box on;



% Save the scatter plots with high resolution
print('ScatterPlotsWithFitLine', '-dpng', '-r300');


%% Statistical Indices
% 4. Compute the correlation coefficient (CC) and RMSE
CC_Hs = corr(data.modelledHs(ia), data.measuredHs(ib));
RMSE_Hs = sqrt(mean((data.measuredHs(ib) - data.modelledHs(ia)).^2));
ScatterIndex_Hs = std(data.modelledHs(ia) - data.measuredHs(ib)) / mean(data.measuredHs(ib));
BIAS_Hs = mean(data.modelledHs(ia) - data.measuredHs(ib));

CC_Tm = corr(data.modelledTm(ia), data.measuredTm(ib));
RMSE_Tm = sqrt(mean((data.measuredTm(ib) - data.modelledTm(ia)).^2));
ScatterIndex_Tm = std(data.modelledTm(ia) - data.measuredTm(ib)) / mean(data.measuredTm(ib));
BIAS_Tm = mean(data.modelledTm(ia) - data.measuredTm(ib));

fprintf('CC for Hs: %.2f\n', CC_Hs);
fprintf('RMSE for Hs: %.2f\n', RMSE_Hs);
fprintf('ScatterIndex for Hs: %.2f\n', ScatterIndex_Hs);
fprintf('BIAS for Hs: %.2f\n', BIAS_Hs);

fprintf('CC for Tm: %.2f\n', CC_Tm);
fprintf('RMSE for Tm: %.2f\n', RMSE_Tm);
fprintf('ScatterIndex for Tm: %.2f\n', ScatterIndex_Tm);
fprintf('BIAS for Tm: %.2f\n', BIAS_Tm);
