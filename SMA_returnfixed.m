%% This script is created on 05/01/2018, the day after meeting Dr. Fok
%%The aim of this program is to use buy all and sell all strategy 
%%Trading algorithm is based on simple moving average
%% Load in data from excel
importfile('./data/HSI.xlsx');  %%import the data as columns from the excel file, we already have a predefined function in importfile.m
%% Replace the NaN values 
%%Replace the NaN values by the average of the previous and next value,
%%applicable to Close1 and AdjClose1

number = length(AdjClose1);

TFADjClose1=isnan(AdjClose1);
TFClose1=isnan(Close1);
count = 0;
count2 = 0;
for i = 1:number-1
    if TFADjClose1(i) == 1
        AdjClose1(i) = [AdjClose1(i-1)+AdjClose1(i+1)]/2;
    end
end
for i = 1:number-1
    if TFClose1(i) == 1
        Close1(i) = [Close1(i-1)+Close1(i+1)]/2;
    end
end
%% Define initial variables an formulate the SMA
twentydays = 20;
fiftydays = 50;
sma20 = tsmovavg(AdjClose1,'s',twentydays,1);
sma50 = tsmovavg(AdjClose1,'s',fiftydays,1);
Numberoftradingdays = length(AdjClose1);           %%set the data length=number of trading days
figure;
plot([sma20,sma50]);
legend('sma20','sma50');

%% Cash, Share Value, Portfolio
%%Position(i) = stockvalue(i)/AdjClose1(i)
cash = zeros(Numberoftradingdays,1);
stockvalue = zeros(Numberoftradingdays,1);
portfolio = zeros(Numberoftradingdays,1);
position = 0;
initialcash = 1000000;
cash(1) = initialcash; %%we start with 1 million cash
stockvalue(1) = 0;
numberoftrades = 0;

%% Trading Strategy here
%%Golden Cross = 20SMA > 50SMA (buy signal)
%%Death Cross = 50SMA < 20SMA (sell signal)

count1 = 0;
count2 = 0;
portfolio(1) = cash(1) + stockvalue(1);

for i = 2:Numberoftradingdays
    cash(i) = cash(i-1);
    stockvalue(i) = AdjClose1(i)*position;
    portfolio(i) = cash(i) + stockvalue(i);
    if sma20(i) > sma50(i) && sma20(i-1) > sma50(i-1) && cash(i) > 0
        count1 = count1+1;
        stockvalue(i) = cash(i);
        position = stockvalue(i)/AdjClose1(i);
        cash(i) = 0;
        numberoftrades = numberoftrades+1;
    elseif sma20(i) < sma50(i) && sma20(i-1) < sma50(i-1) && cash(i) == 0
        count2 = count2+1;
        cash(i) = stockvalue(i);
        position = 0;
        stockvalue(i) = 0;
        numberoftrades = numberoftrades+1;
    end
end
%% calculate return on the investment

dailyreturn = zeros(Numberoftradingdays,1);
for i = 2:Numberoftradingdays
    dailyreturn (i) = [portfolio(i)/portfolio(i-1)] - 1;
end

Totalpercentagereturnintradingperiod = [portfolio(Numberoftradingdays)/initialcash - 1]*100;
AnnualSharpeRatio = sqrt(Numberoftradingdays)*sharpe(dailyreturn,0);

%% Plot graph
figure;
subplot(3,1,1);
plot(AdjClose1);
title(['HSI 2016-2017']);
ylabel('Closing Price');
xlabel('Trading Days');

subplot(3,1,2);
plot(portfolio);
title(['Portfolio Return = ' num2str(Totalpercentagereturnintradingperiod)...
    '%', ' Number of trades = ' num2str(numberoftrades)...
    ' Sharpe Ratio = ' num2str(AnnualSharpeRatio) ]);
ylabel('Portfolio Value');
xlabel('Trading Days');

subplot(3,1,3);
plot([sma20,sma50]);
legend('sma20','sma50');
ylabel('Moving Averages');
xlabel('Trading Days');



