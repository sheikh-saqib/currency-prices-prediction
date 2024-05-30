clc; clear; close all;

% Load data
[nos, txt] = xlsread("eurofxref-hist.csv");

% Identify NaN values
[r, c] = find(isnan(nos) == 1);

% Convert date column to datetime format
dates = datetime(txt(2:end, 1), 'InputFormat', 'dd-MM-yyyy');

% USD/EUR Rate
figure('Name', 'USD/EUR Rate', 'NumberTitle', 'off');
plot(dates, nos(:, 1), 'LineWidth', 0.75);
xlabel('Date');
ylabel('USD/Euro Rate');
grid on;

% JPY/EUR Rate
figure('Name', 'JPY/EUR Rate', 'NumberTitle', 'off');
plot(dates,nos(:, 2), 'LineWidth', 0.75);
ylabel('JPY/EUR Rate');
xlabel('Date');
grid on;

% Fig: Ratio of JPY to USD
figure('Name', 'JPY/USD Ratio', 'NumberTitle', 'off');
plot(dates,nos(:, 2) ./ nos(:, 1), 'LineWidth', 0.75)
ylabel('JPY/USD Ratio')
grid on;


% Fig 2: Box chart for USD
figure('Name', 'USD/EUR Rate', 'NumberTitle', 'off');
boxchart(nos(:, 1));
ylabel('USD/EUR Rate');

% Fig: Box chart for JPY
figure('Name', 'JPY/EUR Rate', 'NumberTitle', 'off');
boxchart(nos(:, 2))
ylabel('JPY/EUR Rate')

% Box chart for JPY/USD ratio
figure('Name', 'JPY/USD Ratio', 'NumberTitle', 'off');
boxchart(nos(:, 2) ./ nos(:, 1))
ylabel('JPY/USD Ratio')

% Scatter plot
figure('Name', 'Scatter plot', 'NumberTitle', 'off');
scatter(nos(:, 1), nos(:, 2), 10, 'filled', 'MarkerEdgeColor', 'k')
xlabel('USD/EUR Exchange Rate')
ylabel('JPY/EUR Exchange Rate')
grid on


% Create a new figure for histograms
figure('Name', 'Exchange Rate Histograms', 'NumberTitle', 'off');

subplot(1, 3, 1)
histogram(nos(:, 1))
title('USD/EUR')

subplot(1, 3, 2)
histogram(nos(:, 2))
title('JPY/EUR')

subplot(1, 3, 3)
histogram(nos(:, 2) ./ nos(:, 1))
title('JPY/USD')

% Calculate correlation coefficient
correlation_coefficient = corrcoef(nos(:, 1), nos(:, 2));

% Display correlation coefficient
disp(['Correlation Coefficient: ' num2str(correlation_coefficient(1, 2))]);


% Extract the relevant columns for USD table 1
usd_rates_n_minus_1 = nos(1:end-1, 1);  % USD rates at time n-1
usd_rates_n = nos(2:end, 1);            % USD rates at time n
usd_table1 = [usd_rates_n_minus_1, usd_rates_n];

% Extract the relevant columns for JPY table 1
jpy_rates_n_minus_1 = nos(1:end-1, 2);  % JPY rates at time n-1
jpy_rates_n = nos(2:end, 2);            % JPY rates at time n
jpy_table1 = [jpy_rates_n_minus_1, jpy_rates_n];

% Extract the relevant columns for USD table 2
usd_rates_n_minus_2 = nos(1:end-2, 1);  % USD rates at time n-2
usd_rates_n_minus_1 = nos(2:end-1, 1);  % USD rates at time n-1
usd_rates_n = nos(3:end, 1);            % USD rates at time n
usd_table2 = [usd_rates_n_minus_2, usd_rates_n_minus_1, usd_rates_n];

% Extract the relevant columns for JPY table 2
jpy_rates_n_minus_2 = nos(1:end-2, 2);  % JPY rates at time n-2
jpy_rates_n_minus_1 = nos(2:end-1, 2);  % JPY rates at time n-1
jpy_rates_n = nos(3:end, 2);            % JPY rates at time n
jpy_table2 = [jpy_rates_n_minus_2, jpy_rates_n_minus_1, jpy_rates_n];


% Extract the relevant columns for USD table 3
usd_rates_n_minus_3 = nos(1:end-3, 1);  % USD rates at time n-3
usd_rates_n_minus_2 = nos(2:end-2, 1);  % USD rates at time n-2
usd_rates_n_minus_1 = nos(3:end-1, 1);  % USD rates at time n-1
usd_rates_n = nos(4:end, 1);            % USD rates at time n
usd_table3 = [usd_rates_n_minus_3, usd_rates_n_minus_2, usd_rates_n_minus_1, usd_rates_n];


% Extract the relevant columns for JPY table 3
jpy_rates_n_minus_3 = nos(1:end-3, 2);  % JPY rates at time n-3
jpy_rates_n_minus_2 = nos(2:end-2, 2);  % JPY rates at time n-2
jpy_rates_n_minus_1 = nos(3:end-1, 2);  % JPY rates at time n-1
jpy_rates_n = nos(4:end, 2);            % JPY rates at time n
jpy_table3 = [jpy_rates_n_minus_3, jpy_rates_n_minus_2, jpy_rates_n_minus_1, jpy_rates_n];


mdl1 = fitlm(usd_table1(1:6000,1), usd_table1(1:6000,2));
prd_tbl1 = predict(mdl1, usd_table1(:,1));
resids = 100 * (usd_table1(:,1) - prd_tbl1) ./ usd_table1(:,1);
resids_mean = mean(usd_table1(:,1) - prd_tbl1);
resids_std  = std(usd_table1(:,1) - prd_tbl1);

% Create figure for JPY/EUR linear regression analysis
figure('Name', 'USD/EUR Linear Regression Analysis', 'NumberTitle', 'off')

% Scatter plot for the first 6000 data points
subplot(2,2,1)
scatter(usd_table1(1:6000,2), prd_tbl1(1:6000), 50, 'filled', 'MarkerEdgeColor', 'k')
xlim([min(usd_table1(:,2)) max(usd_table1(:,2))])
ylim([min(usd_table1(:,2)) max(usd_table1(:,2))])
xlabel('Actual Rates')
ylabel('Predicted Rates')
title('USD/EUR LR - Trained Set')

% Scatter plot for the remaining data points
subplot(2,2,2); hold on
scatter(usd_table1(6000:end,2), prd_tbl1(6000:end), 50, 'filled', 'MarkerEdgeColor', 'k')
scatter(usd_table1(6000:end,2), prd_tbl1(6000:end), 50, 'filled', 'MarkerEdgeColor', 'k')
xlim([min(usd_table1(:,2)) max(usd_table1(:,2))])
ylim([min(usd_table1(:,2)) max(usd_table1(:,2))])
xlabel('Actual Rates')
ylabel('Predicted Rates')
title('USD/EUR LR - Test Set')

% Residuals plot
subplot(2,2,[3,4]); hold on
scatter(1:length(usd_table1), resids, 50, 'filled', 'MarkerEdgeColor', 'k')
scatter(6000:length(usd_table1), resids(6000:end), 50, 'filled', 'MarkerEdgeColor', 'k')
ylabel('Residuals %age')
xlabel('Data Point')
title('Residuals Plot - USD/EUR')


% Fit linear regression model for JPY/EUR rates
mdl2 = fitlm(jpy_table1(1:6000,1), jpy_table1(1:6000,2));
prd_tbl2 = predict(mdl2, jpy_table1(:,1));
resids_jpy = 100 * (jpy_table1(:,1) - prd_tbl2) ./ jpy_table1(:,1);

% Create figure for JPY/EUR linear regression analysis
figure('Name', 'JPY/EUR Linear Regression Analysis', 'NumberTitle', 'off')

% Scatter plot for the first 6000 data points
subplot(2,2,1)
scatter(jpy_table1(1:6000,2), prd_tbl2(1:6000), 50, 'filled', 'MarkerEdgeColor', 'k')
xlim([min(jpy_table1(:,2)) max(jpy_table1(:,2))])
ylim([min(jpy_table1(:,2)) max(jpy_table1(:,2))])
xlabel('Actual Rates')
ylabel('Predicted Rates')
title('JPY/EUR LR - Trained Set')

% Scatter plot for the remaining data points
subplot(2,2,2)
scatter(jpy_table1(6000:end,2), prd_tbl2(6000:end), 50, 'filled', 'MarkerEdgeColor', 'k')
xlim([min(jpy_table1(:,2)) max(jpy_table1(:,2))])
ylim([min(jpy_table1(:,2)) max(jpy_table1(:,2))])
xlabel('Actual Rates')
ylabel('Predicted Rates')
title('JPY/EUR LR - Test Set')

% Residuals plot
subplot(2,2,[3,4])
hold on
scatter(1:length(jpy_table1), resids_jpy, 50, 'filled', 'MarkerEdgeColor', 'k')
scatter(6000:length(jpy_table1), resids_jpy(6000:end), 50, 'filled', 'MarkerEdgeColor', 'k')
ylabel('Residuals %age')
xlabel('Data Point')
title('Residuals Plot - JPY/EUR')

% Linear Regression Analysis for USD Table 2
mdl_usd_table2 = fitlm(usd_table2(:,1:2), usd_table2(:,3));
prd_usd_table2 = predict(mdl_usd_table2, usd_table2(:,1:2));
resids_usd_table2 = 100 * (usd_table2(:,3) - prd_usd_table2) ./ usd_table2(:,3);

% Create figure for USD Table 2 linear regression analysis
figure('Name', 'USD Table 2 LR Analysis', 'NumberTitle', 'off')

% Scatter plot
subplot(2,2,1)
scatter(usd_table2(1:6000,3), prd_usd_table2(1:6000), 50, 'filled', 'MarkerEdgeColor', 'k')
xlim([min(usd_table2(:,3)) max(usd_table2(:,3))])
ylim([min(usd_table2(:,3)) max(usd_table2(:,3))])
xlabel('Actual Rates')
ylabel('Predicted Rates')
title('USD/EUR Table 2 LR - Trained Set')

% Scatter plot for the remaining data points
subplot(2,2,2)
scatter(usd_table2(6000:end,3), prd_usd_table2(6000:end), 50, 'filled', 'MarkerEdgeColor', 'k')
xlim([min(usd_table2(:,3)) max(usd_table2(:,3))])
ylim([min(usd_table2(:,3)) max(usd_table2(:,3))])
xlabel('Actual Rates')
ylabel('Predicted Rates')
title('USD/EUR Table 2 LR - Test Set')

% Residuals plot
subplot(2,2,[3,4])
hold on
scatter(1:length(usd_table2), resids_usd_table2, 50, 'filled', 'MarkerEdgeColor', 'k')
scatter(6000:length(usd_table2), resids_usd_table2(6000:end), 50, 'filled', 'MarkerEdgeColor', 'k')
ylabel('Residuals %age')
xlabel('Data Point')
title('Residuals Plot - USD/EUR Table 2')


% Linear Regression Analysis for USD Table 3
mdl_usd_table3 = fitlm(usd_table3(:,1:3), usd_table3(:,4));
prd_usd_table3 = predict(mdl_usd_table3, usd_table3(:,1:3));
resids_usd_table3 = 100 * (usd_table3(:,4) - prd_usd_table3) ./ usd_table3(:,4);

% Create figure for USD Table 3 linear regression analysis
figure('Name', 'USD/EUR Table 3 LR Analysis', 'NumberTitle', 'off')

% Scatter plot
subplot(2,2,1)
scatter(usd_table3(1:6000,4), prd_usd_table3(1:6000), 50, 'filled', 'MarkerEdgeColor', 'k')
xlim([min(usd_table3(:,4)) max(usd_table3(:,4))])
ylim([min(usd_table3(:,4)) max(usd_table3(:,4))])
xlabel('Actual Rates')
ylabel('Predicted Rates')
title('USD/EUR Table 3 LR - Trained Set')

% Scatter plot for the remaining data points
subplot(2,2,2)
scatter(usd_table3(6000:end,4), prd_usd_table3(6000:end), 50, 'filled', 'MarkerEdgeColor', 'k')
xlim([min(usd_table3(:,4)) max(usd_table3(:,4))])
ylim([min(usd_table3(:,4)) max(usd_table3(:,4))])
xlabel('Actual Rates')
ylabel('Predicted Rates')
title('USD/EUR Table 3 LR - Test Set')

% Residuals plot
subplot(2,2,[3,4])
hold on
scatter(1:length(usd_table3), resids_usd_table3, 50, 'filled', 'MarkerEdgeColor', 'k')
scatter(6000:length(usd_table3), resids_usd_table3(6000:end), 50, 'filled', 'MarkerEdgeColor', 'k')
ylabel('Residuals %age')
xlabel('Data Point')
title('Residuals Plot - USD/EUR Table 3')


% Linear Regression Analysis for JPY Table 2
mdl_jpy_table2 = fitlm(jpy_table2(:,1:2), jpy_table2(:,3));
prd_jpy_table2 = predict(mdl_jpy_table2, jpy_table2(:,1:2));
resids_jpy_table2 = 100 * (jpy_table2(:,3) - prd_jpy_table2) ./ jpy_table2(:,3);

% Create figure for JPY Table 2 linear regression analysis
figure('Name', 'JPY/EUR Table 2 LR Analysis', 'NumberTitle', 'off')

% Scatter plot
subplot(2,2,1)
scatter(jpy_table2(1:6000,3), prd_jpy_table2(1:6000), 50, 'filled', 'MarkerEdgeColor', 'k')
xlim([min(jpy_table2(:,3)) max(jpy_table2(:,3))])
ylim([min(jpy_table2(:,3)) max(jpy_table2(:,3))])
xlabel('Actual Rates')
ylabel('Predicted Rates')
title('JPY/EUR Table 2 LR - Trained Set')

% Scatter plot for the remaining data points
subplot(2,2,2)
scatter(jpy_table2(6000:end,3), prd_jpy_table2(6000:end), 50, 'filled', 'MarkerEdgeColor', 'k')
xlim([min(jpy_table2(:,3)) max(jpy_table2(:,3))])
ylim([min(jpy_table2(:,3)) max(jpy_table2(:,3))])
xlabel('Actual Rates')
ylabel('Predicted Rates')
title('JPY/EUR Table 2 LR - Test Set')

% Residuals plot
subplot(2,2,[3,4])
hold on
scatter(1:length(jpy_table2), resids_jpy_table2, 50, 'filled', 'MarkerEdgeColor', 'k')
scatter(6000:length(jpy_table2), resids_jpy_table2(6000:end), 50, 'filled', 'MarkerEdgeColor', 'k')
ylabel('Residuals %age')
xlabel('Data Point')
title('Residuals Plot - JPY/EUR Table 2')


% Linear Regression Analysis for JPY Table 3
mdl_jpy_table3 = fitlm(jpy_table3(:,1:3), jpy_table3(:,4));
prd_jpy_table3 = predict(mdl_jpy_table3, jpy_table3(:,1:3));
resids_jpy_table3 = 100 * (jpy_table3(:,4) - prd_jpy_table3) ./ jpy_table3(:,4);

% Create figure for JPY Table 3 linear regression analysis
figure('Name', 'JPY/EUR Table 3 LR Analysis', 'NumberTitle', 'off')

% Scatter plot
subplot(2,2,1)
scatter(jpy_table3(1:6000,4), prd_jpy_table3(1:6000), 50, 'filled', 'MarkerEdgeColor', 'k')
xlim([min(jpy_table3(:,4)) max(jpy_table3(:,4))])
ylim([min(jpy_table3(:,4)) max(jpy_table3(:,4))])
xlabel('Actual Rates')
ylabel('Predicted Rates')
title('JPY/EUR Table 3 LR - Trained Set')

% Scatter plot for the remaining data points
subplot(2,2,2)
scatter(jpy_table3(6000:end,4), prd_jpy_table3(6000:end), 50, 'filled', 'MarkerEdgeColor', 'k')
xlim([min(jpy_table3(:,4)) max(jpy_table3(:,4))])
ylim([min(jpy_table3(:,4)) max(jpy_table3(:,4))])
xlabel('Actual Rates')
ylabel('Predicted Rates')
title('JPY/EUR Table 3 LR - Test Set')

% Residuals plot
subplot(2,2,[3,4])
hold on
scatter(1:length(jpy_table3), resids_jpy_table3, 50, 'filled', 'MarkerEdgeColor', 'k')
scatter(6000:length(jpy_table3), resids_jpy_table3(6000:end), 50, 'filled', 'MarkerEdgeColor', 'k')
ylabel('Residuals %age')
xlabel('Data Point')
title('Residuals Plot - JPY/EUR Table 3')








