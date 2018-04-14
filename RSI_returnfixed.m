%% This script is created on 05/01/2018, the day after meeting Dr. Fok
%%The aim of this program is to improve the existing return calculation
%%system by considering porfolio return
%%Trading algorithm is based on relative strength index
%%This program uses buy all and sell all strategy
%%We ignore short-selling first, either stock = 0 or cash = 0 everytime,
%%cash out everything at the end
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
%% Define some initial variables (upper and lower limits) and load in the rsi
rsi = rsindex(AdjClose1);

Numberoftradingdays = length(AdjClose1)  ;           %%set the data length=number of trading days
upperlimit = 65;                        %%Define the upper limit, let's try to be agressive here
lowerlimit = 35;                        %%Define the lower limit, 30 is obviously not a bright choice since HSI never hits below 30
dummy = 0;

RSIUpper = ones(Numberoftradingdays,1);
RSIUpper = RSIUpper.*upperlimit;

RSILower = ones(Numberoftradingdays,1);
RSILower = RSILower.*lowerlimit;

%% Initial Plot of rsi, upper and lower (for testing)

figure;
hold on;
plot (rsi,'b');
plot (RSIUpper, '--r');
plot (RSILower, '--g');
legend('RSI on HSI','Overbought Region', 'Oversold Region');
ylabel('Relative Strength Index (0-100)');
xlabel('Trading Days');
title('Relative Strength Index of HSI 2016-2017');
hold off;

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

%% Trading Algorithm here

portfolio(1) = cash(1) + stockvalue(1);

for i = 2:Numberoftradingdays
    cash(i) = cash(i-1);
    stockvalue(i) = AdjClose1(i)*position;
    portfolio(i) = cash(i) + stockvalue(i);
    if rsi(i) < lowerlimit && cash (i) > 0
        stockvalue(i) = cash(i);
        position = stockvalue(i)/AdjClose1(i);
        cash(i) = 0;
        numberoftrades = numberoftrades+1;
    elseif rsi(i) > upperlimit && cash(i) == 0
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
plot([rsi, RSIUpper, RSILower]);
ylabel('Relative Strength Index');
xlabel('Trading Days');
subplot(3,1,3);
plot(portfolio);
title(['Portfolio Return = ' num2str(Totalpercentagereturnintradingperiod)...
    '%', ' Number of trades = ' num2str(numberoftrades)...
    ' Sharpe Ratio = ' num2str(AnnualSharpeRatio) ]);
ylabel('Portfolio Value');
xlabel('Trading Days');


    



            
        
    


