%% This script is to test trading strategies on MACD

%% Load in data from excel
importfile('HSI2016-2017')  %%import the data as columns from the excel file, we already have a predefined function in importfile.m
%% Replace the NaN values 
%%Replace the NaN values by the average of the previous and next value,
%%applicable to Close1 and AdjClose1

number = length(AdjClose1)

TFADjClose1=isnan(AdjClose1)
TFClose1=isnan(Close1)
count = 0
count2 = 0
for i = 1:number-1
    if TFADjClose1(i) == 1
        AdjClose1(i) = [AdjClose1(i-1)+AdjClose1(i+1)]/2
    end
end
for i = 1:number-1
    if TFClose1(i) == 1
        Close1(i) = [Close1(i-1)+Close1(i+1)]/2
    end
end

%% MACD indicators

Numberoftradingdays = length(AdjClose1)             %%set the data length=number of trading days
[MACD, ema9] = macd(AdjClose1)
diff = MACD - ema9
figure
subplot(2,1,1)
candle(High1, Low1, Open1, AdjClose1)
subplot(2,1,2)
zeroline = zeros(Numberoftradingdays,1)
plot([MACD, ema9,zeroline])

%% Cash, Share Value, Portfolio
%%Position(i) = stockvalue(i)/AdjClose1(i)
cash = zeros(Numberoftradingdays,1)
stockvalue = zeros(Numberoftradingdays,1)
portfolio = zeros(Numberoftradingdays,1)
position = 0
initialcash = 1000000
cash(1) = initialcash %%we start with 1 million cash
stockvalue(1) = 0
numberoftrades = 0

%% Trading Algorithm Here

portfolio(1) = cash(1) + stockvalue(1)

for i = 2:Numberoftradingdays
    cash(i) = cash(i-1)
    stockvalue(i) = AdjClose1(i)*position
    portfolio(i) = cash(i) + stockvalue(i)
    if MACD(i) > ema9 (i) 
        if MACD (i) > 0 && cash (i) > 0
        stockvalue(i) = cash(i)
        position = stockvalue(i)/AdjClose1(i)
        cash(i) = 0
        numberoftrades = numberoftrades+1
        end
    elseif MACD (i) < ema9 (i) 
        if MACD(i) < 0 && cash(i) == 0
        cash(i) = stockvalue(i)
        position = 0
        stockvalue(i) = 0
        numberoftrades = numberoftrades+1
        end
    end
end

%% calculate return on the investment

dailyreturn = zeros(Numberoftradingdays,1)
for i = 2:Numberoftradingdays
    dailyreturn (i) = [portfolio(i)/portfolio(i-1)] - 1
end

Totalpercentagereturnintradingperiod = [portfolio(Numberoftradingdays)/initialcash - 1]*100
AnnualSharpeRatio = sqrt(Numberoftradingdays)*sharpe(dailyreturn,0);

%% Plot graph
figure
subplot(3,1,1)
plot(AdjClose1)
title(['HSI 2016-2017'])
ylabel('Closing Price')
xlabel('Trading Days')

subplot(3,1,2)
plot([ema9, MACD, zeroline])
legend('ema9','MACD')
ylabel('MACD')
xlabel('Trading Days')

subplot(3,1,3)
plot(portfolio)
title(['Portfolio Return = ' num2str(Totalpercentagereturnintradingperiod)...
    '%', ' Number of trades = ' num2str(numberoftrades)...
    ' Sharpe Ratio = ' num2str(AnnualSharpeRatio) ])
ylabel('Portfolio Value')
xlabel('Trading Days')

