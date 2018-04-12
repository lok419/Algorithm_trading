function varargout = play(varargin)
% PLAY MATLAB code for play.fig
%      PLAY, by itself, creates a new PLAY or raises the existing
%      singleton*.
%
%      H = PLAY returns the handle to a new PLAY or the handle to
%      the existing singleton*.
%
%      PLAY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLAY.M with the given input arguments.
%
%      PLAY('Property','Value',...) creates a new PLAY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before play_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to play_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help play

% Last Modified by GUIDE v2.5 31-Mar-2018 00:19:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @play_OpeningFcn, ...
                   'gui_OutputFcn',  @play_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before play is made visible.
function play_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to play (see VARARGIN)

% Choose default command line output for play
handles.output = hObject;

menu1 = 'SMA';
menu2 = 'EMA';
menu3 = 'RSI';
menu4 = 'MACD';
menu5 = 'RSI/EMA';
menu_string = {menu1,menu2,menu3,menu4,menu5};
set(handles.popupmenu1,'string',menu_string);
handles.status = [];

menu1 = 'HSBC';
menu2 = 'Geely';
menu3 = 'SHK';
menu4 = 'Tencent';
menu_string = {menu1,menu2,menu3,menu4};
set(handles.popupmenu2,'string',menu_string);




% Update handles structure
guidata(hObject, handles);

% UIWAIT makes play wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = play_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% retrieve the data from two edit box
start_date = datenum(char(get(handles.edit1,'String')),'dd/mm/yyyy');
end_date = datenum(char(get(handles.edit2,'String')),'dd/mm/yyyy');

handles.filename = get(handles.popupmenu2,'String');
handles.filename = char(handles.filename(get(handles.popupmenu2,'Value')));

[~, ~, raw] = xlsread(handles.filename,'');
raw = raw(2:end,:);
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
raw(R) = {NaN}; % Replace non-numeric cells
data = reshape([raw{:}],size(raw));
handles.Date1 = data(:,1);

i = start_date;
j = end_date;

while isempty(find(handles.Date1 == i-693960,1)) || isempty(find(handles.Date1 == j-693960,1))
    if isempty(find(handles.Date1 == i-693960,1))
        i=i+1;
    end
    if isempty(find(handles.Date1 == j-693960,1))
        j=j-1;
    end
end

start_index = find(handles.Date1 == i-693960);
end_index = find(handles.Date1 == j-693960);    

handles.Open1 = data(start_index:end_index,2);
handles.High1 = data(start_index:end_index,3);
handles.Low1 = data(start_index:end_index,4);
handles.Close1 = data(start_index:end_index,5);
handles.AdjClose1 = data(start_index:end_index,6);
handles.Volume1 = data(start_index:end_index,7);


axes(handles.axes1);
plot(handles.AdjClose1);
title(handles.filename);
ylabel('Closing Price');
xlabel('Trading Days');


if i ~= start_date
    handles.status{end+1}='';
    handles.status{end+1}=['Invalid date: ',datestr(start_date,'dd/mm/yyyy'),' changes to ',datestr(i,'dd/mm/yyyy')];
    set(handles.text1,'String',fliplr(handles.status));
end
if j ~= end_date
    handles.status{end+1}='';
    handles.status{end+1}=['Invalid date: ',datestr(end_date,'dd/mm/yyyy'),' changes to ',datestr(j,'dd/mm/yyyy')];
    set(handles.text1,'String',fliplr(handles.status));
end

handles.status{end+1}='';
handles.status{end+1}=['Retrieved ',handles.filename,' data from ',datestr(i,'dd/mm/yyyy'),' to ',datestr(j,'dd/mm/yyyy')];
set(handles.text1,'String',fliplr(handles.status));



guidata(hObject, handles);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Date1 = handles.Date1;
Open1 = handles.Open1;
High1 = handles.High1;
Low1 = handles.Low1;
Close1 = handles.Close1;
AdjClose1 = handles.AdjClose1;
Volume1 = handles.Volume1;

handles.status{end+1}='';
handles.status{end+1}='Computing........';
set(handles.text1,'String',fliplr(handles.status));


algos = get(handles.popupmenu1,'Value');
switch algos   
    case 1
        disp('alog: SMA');

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

        twentydays = 20;
        fiftydays = 50;
        sma20 = tsmovavg(AdjClose1,'s',twentydays,1);
        sma50 = tsmovavg(AdjClose1,'s',fiftydays,1);
        Numberoftradingdays = length(AdjClose1);           %%set the data length=number of trading days

        cash = zeros(Numberoftradingdays,1);
        stockvalue = zeros(Numberoftradingdays,1);
        portfolio = zeros(Numberoftradingdays,1);
        position = 0;
        initialcash = 1000000;
        cash(1) = initialcash; %%we start with 1 million cash
        stockvalue(1) = 0;
        numberoftrades = 0;

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

        dailyreturn = zeros(Numberoftradingdays,1);
        for i = 2:Numberoftradingdays
            dailyreturn (i) = [portfolio(i)/portfolio(i-1)] - 1;
        end

        Totalpercentagereturnintradingperiod = [portfolio(Numberoftradingdays)/initialcash - 1]*100;
        AnnualSharpeRatio = sqrt(Numberoftradingdays)*sharpe(dailyreturn,0);

        handles.AdjClose1 = AdjClose1;
        handles.Totalpercentagereturnintradingperiod = Totalpercentagereturnintradingperiod;
        handles.numberoftrades = numberoftrades;
        handles.portfolio = portfolio;
        handles.AnnualSharpeRatio = AnnualSharpeRatio;
        handles.sma20 = sma20;
        handles.sma50 = sma50;  
        
    case 2
        disp('alog: EMA');
        
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

        twentydays = 20;
        fiftydays = 50;
        ema20 = tsmovavg(AdjClose1,'e',twentydays,1);
        ema50 = tsmovavg(AdjClose1,'e',fiftydays,1);
        Numberoftradingdays = length(AdjClose1);           %%set the data length=number of trading days

        cash = zeros(Numberoftradingdays,1);
        stockvalue = zeros(Numberoftradingdays,1);
        portfolio = zeros(Numberoftradingdays,1);
        position = 0;
        initialcash = 1000000;
        cash(1) = initialcash; %%we start with 1 million cash
        stockvalue(1) = 0;
        numberoftrades = 0;

        count1 = 0;
        count2 = 0;
        portfolio(1) = cash(1) + stockvalue(1);

        for i = 2:Numberoftradingdays
            cash(i) = cash(i-1);
            stockvalue(i) = AdjClose1(i)*position;
            portfolio(i) = cash(i) + stockvalue(i);
            if ema20(i) > ema50(i) && ema20(i-1) > ema50(i-1) && cash(i) > 0
                count1 = count1+1;
                stockvalue(i) = cash(i);
                position = stockvalue(i)/AdjClose1(i);
                cash(i) = 0;
                numberoftrades = numberoftrades+1;
            elseif ema20(i) < ema50(i) && ema20(i-1) < ema50(i-1) && cash(i) == 0
                count2 = count2+1;
                cash(i) = stockvalue(i);
                position = 0;
                stockvalue(i) = 0;
                numberoftrades = numberoftrades+1;
            end
        end

        dailyreturn = zeros(Numberoftradingdays,1);
        for i = 2:Numberoftradingdays
            dailyreturn (i) = [portfolio(i)/portfolio(i-1)] - 1;
        end

        Totalpercentagereturnintradingperiod = [portfolio(Numberoftradingdays)/initialcash - 1]*100;
        AnnualSharpeRatio = sqrt(Numberoftradingdays)*sharpe(dailyreturn,0);

        handles.AdjClose1 = AdjClose1;
        handles.Totalpercentagereturnintradingperiod = Totalpercentagereturnintradingperiod;
        handles.numberoftrades = numberoftrades;
        handles.portfolio = portfolio;
        handles.AnnualSharpeRatio = AnnualSharpeRatio;
        handles.ema20 = ema20;
        handles.ema50 = ema50;
        
    case 3
        disp('alog: RSI');

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

        rsi = rsindex(AdjClose1);

        Numberoftradingdays = length(AdjClose1);            %%set the data length=number of trading days
        upperlimit = 65;                        %%Define the upper limit, let's try to be agressive here
        lowerlimit = 35;                        %%Define the lower limit, 30 is obviously not a bright choice since HSI never hits below 30
        dummy = 0;

        RSIUpper = ones(Numberoftradingdays,1);
        RSIUpper = RSIUpper.*upperlimit;

        RSILower = ones(Numberoftradingdays,1);
        RSILower = RSILower.*lowerlimit;

        cash = zeros(Numberoftradingdays,1);
        stockvalue = zeros(Numberoftradingdays,1);
        portfolio = zeros(Numberoftradingdays,1);
        position = 0;
        initialcash = 1000000;
        cash(1) = initialcash ;%%we start with 1 million cash
        stockvalue(1) = 0;
        numberoftrades = 0;


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

        dailyreturn = zeros(Numberoftradingdays,1);
        for i = 2:Numberoftradingdays
            dailyreturn (i) = [portfolio(i)/portfolio(i-1)] - 1;
        end

        Totalpercentagereturnintradingperiod = [portfolio(Numberoftradingdays)/initialcash - 1]*100;
        AnnualSharpeRatio = sqrt(Numberoftradingdays)*sharpe(dailyreturn,0);

        handles.AdjClose1 = AdjClose1;
        handles.rsi = rsi;
        handles.RSIUpper = RSIUpper;
        handles.RSILower = RSILower;
        handles.portfolio = portfolio;
        handles.Totalpercentagereturnintradingperiod = Totalpercentagereturnintradingperiod;
        handles.numberoftrades = numberoftrades;
        handles.AnnualSharpeRatio = AnnualSharpeRatio;
        
    case 4
        disp('alog: MACD');
        
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

        Numberoftradingdays = length(AdjClose1);           %%set the data length=number of trading days
        [MACD, ema9] = macd(AdjClose1);
        diff = MACD - ema9;
        zeroline = zeros(Numberoftradingdays,1);

        cash = zeros(Numberoftradingdays,1);
        stockvalue = zeros(Numberoftradingdays,1);
        portfolio = zeros(Numberoftradingdays,1);
        position = 0;
        initialcash = 1000000;
        cash(1) = initialcash; %%we start with 1 million cash
        stockvalue(1) = 0;
        numberoftrades = 0;


        portfolio(1) = cash(1) + stockvalue(1);

        for i = 2:Numberoftradingdays
            cash(i) = cash(i-1);
            stockvalue(i) = AdjClose1(i)*position;
            portfolio(i) = cash(i) + stockvalue(i);
            if MACD(i) > ema9 (i) 
                if MACD (i) > 0 && cash (i) > 0
                stockvalue(i) = cash(i);
                position = stockvalue(i)/AdjClose1(i);
                cash(i) = 0;
                numberoftrades = numberoftrades+1;
                end
            elseif MACD (i) < ema9 (i) 
                if MACD(i) < 0 && cash(i) == 0
                cash(i) = stockvalue(i);
                position = 0;
                stockvalue(i) = 0;
                numberoftrades = numberoftrades+1;
                end
            end
        end

        dailyreturn = zeros(Numberoftradingdays,1);
        for i = 2:Numberoftradingdays
            dailyreturn (i) = [portfolio(i)/portfolio(i-1)] - 1;
        end

        Totalpercentagereturnintradingperiod = [portfolio(Numberoftradingdays)/initialcash - 1]*100;
        AnnualSharpeRatio = sqrt(Numberoftradingdays)*sharpe(dailyreturn,0);

        handles.AdjClose1 = AdjClose1;
        handles.ema9 = ema9;
        handles.MACD = MACD;
        handles.zeroline = zeroline;
        handles.Totalpercentagereturnintradingperiod = Totalpercentagereturnintradingperiod;
        handles.numberoftrades = numberoftrades;
        handles.AnnualSharpeRatio = AnnualSharpeRatio;
        handles.portfolio = portfolio;
        
    case 5
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

        rsi = rsindex(AdjClose1);

        Numberoftradingdays = length(AdjClose1);          %%set the data length=number of trading days
        upperlimit = 65;                        %%Define the upper limit, let's try to be agressive here
        lowerlimit = 35;                        %%Define the lower limit, 30 is obviously not a bright choice since HSI never hits below 30
        dummy = 0;

        RSIUpper = ones(Numberoftradingdays,1);
        RSIUpper = RSIUpper.*upperlimit;

        RSILower = ones(Numberoftradingdays,1);
        RSILower = RSILower.*lowerlimit;
        
        twentydays = 20;
        fiftydays = 50;
        ema20 = tsmovavg(AdjClose1,'e',twentydays,1);
        ema50 = tsmovavg(AdjClose1,'e',fiftydays,1);
        Numberoftradingdays = length(AdjClose1);             %%set the data length=number of trading days

        cash = zeros(Numberoftradingdays,1);
        stockvalue = zeros(Numberoftradingdays,1);
        portfolio = zeros(Numberoftradingdays,1);
        position = 0;
        initialcash = 1000000;
        cash(1) = initialcash;
        stockvalue(1) = 0;
        numberoftrades = 0;


        portfolio(1) = cash(1) + stockvalue(1);

        for i = 2:Numberoftradingdays
            cash(i) = cash(i-1);
            stockvalue(i) = AdjClose1(i)*position;
            portfolio(i) = cash(i) + stockvalue(i);
            if rsi(i) < lowerlimit 
                if ema20 (i) > ema50(i) && cash (i) > 0
                stockvalue(i) = cash(i);
                position = stockvalue(i)/AdjClose1(i);
                cash(i) = 0;
                numberoftrades = numberoftrades+1;
                end
            elseif rsi(i) > upperlimit 
                if ema20(i) < ema50(i) && cash(i) == 0
                cash(i) = stockvalue(i);
                position = 0;
                stockvalue(i) = 0;
                numberoftrades = numberoftrades+1;
                end
            end
        end

        dailyreturn = zeros(Numberoftradingdays,1);
        for i = 2:Numberoftradingdays
            dailyreturn (i) = [portfolio(i)/portfolio(i-1)] - 1;
        end

        Totalpercentagereturnintradingperiod = [portfolio(Numberoftradingdays)/initialcash - 1]*100;
        AnnualSharpeRatio = sqrt(Numberoftradingdays)*sharpe(dailyreturn,0);
        
        handles.AdjClose1 = AdjClose1;
        handles.rsi = rsi;
        handles.RSIUpper = RSIUpper;
        handles.RSILower = RSILower;
        handles.ema20 = ema20;
        handles.ema50 = ema50;
        handles.portfolio = portfolio;
        handles.Totalpercentagereturnintradingperiod = Totalpercentagereturnintradingperiod;
        handles.numberoftrades = numberoftrades;
        handles.AnnualSharpeRatio = AnnualSharpeRatio;     
end
guidata(hObject, handles);


% --- Executes on button press in Signal.
function Signal_Callback(hObject, eventdata, handles)
% hObject    handle to Signal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.status{end+1}='';
handles.status{end+1}='Generate signal.....';
set(handles.text1,'String',fliplr(handles.status));

algos = get(handles.popupmenu1,'Value');
switch algos
    case 1
        plot_SMA(handles,1);
    case 2
        plot_EMA(handles,1);
    case 3
        plot_RSI(handles,1);
    case 4
        plot_MACD(handles,1);
    case 5
        plot_RSI_EMA(handles,1);
end
guidata(hObject, handles);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.status{end+1}='';
handles.status{end+1}='Trade.....';
set(handles.text1,'String',fliplr(handles.status));
guidata(hObject, handles);


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.status{end+1}='';
handles.status{end+1}='Performance';
set(handles.text1,'String',fliplr(handles.status));


algos = get(handles.popupmenu1,'Value');
switch algos
    case 1
        plot_SMA(handles,2);
    case 2
        plot_EMA(handles,2);
    case 3
        plot_RSI(handles,2);
    case 4
        plot_MACD(handles,2);
    case 5
        plot_RSI_EMA(handles,2);
end
guidata(hObject, handles);


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function plot_SMA(handles,choice)
switch choice
    case 1
        axes(handles.axes2);
        plot([handles.sma20,handles.sma50]);
        legend('sma20','sma50');
        ylabel('Moving Averages');
        xlabel('Trading Days');
        
    case 2
        axes(handles.axes3);
        plot(handles.portfolio)
        title(['Portfolio Return = ' num2str(handles.Totalpercentagereturnintradingperiod)...
            '%', ' Number of trades = ' num2str(handles.numberoftrades)...
            ' Sharpe Ratio = ' num2str(handles.AnnualSharpeRatio) ]);
        ylabel('Portfolio Value');
        xlabel('Trading Days');        
end

function plot_EMA(handles,choice)
switch choice       
    case 1
        axes(handles.axes2);
        plot([handles.ema20,handles.ema50]);
        legend('ema20','ema50');
        ylabel('Moving Averages');
        xlabel('Trading Days');
        
    case 2
        axes(handles.axes3);       
        plot(handles.portfolio);
        title(['Portfolio Return = ' num2str(handles.Totalpercentagereturnintradingperiod)...
            '%', ' Number of trades = ' num2str(handles.numberoftrades)...
            ' Sharpe Ratio = ' num2str(handles.AnnualSharpeRatio) ]);
        ylabel('Portfolio Value');
        xlabel('Trading Days');
end

function plot_RSI(handles,choice)
switch choice
    case 1
        axes(handles.axes2);
        plot([handles.rsi, handles.RSIUpper, handles.RSILower]);
        ylabel('Relative Strength Index');
        xlabel('Trading Days');
    case 2
        axes(handles.axes3);
        plot(handles.portfolio);
        title(['Portfolio Return = ' num2str(handles.Totalpercentagereturnintradingperiod)...
            '%', ' Number of trades = ' num2str(handles.numberoftrades)...
            ' Sharpe Ratio = ' num2str(handles.AnnualSharpeRatio) ]);
        ylabel('Portfolio Value');
        xlabel('Trading Days');
end

function plot_MACD(handles,choice)
switch choice
    case 1
        axes(handles.axes2);
        plot([handles.ema9, handles.MACD, handles.zeroline]);
        legend('ema9','MACD');
        ylabel('MACD');
        xlabel('Trading Days');
    case 2
        axes(handles.axes3);
        plot(handles.portfolio);
        title(['Portfolio Return = ' num2str(handles.Totalpercentagereturnintradingperiod)...
            '%', ' Number of trades = ' num2str(handles.numberoftrades)...
            ' Sharpe Ratio = ' num2str(handles.AnnualSharpeRatio) ]);
        ylabel('Portfolio Value');
        xlabel('Trading Days');
end

function plot_RSI_EMA(handles,choice)
switch choice
    case 1
        axes(handles.axes2);
        plot([handles.rsi,handles.RSIUpper,handles.RSILower])
        title(['Relative Strength Index of ',handles.filename]);
        legend('rsi','Overbought','Oversold');
        ylabel('Relative Strength Index');
        
        figure;
        plot([handles.ema20,handles.ema50])
        title(['EMA of ',handles.filename]);
        legend('ema20','ema50');
        ylabel('Moving Averages');
        xlabel('Trading Days');
    case 2
        axes(handles.axes3);
        plot(handles.portfolio);
        title(['Portfolio Return = ' num2str(handles.Totalpercentagereturnintradingperiod)...
            '%', ' Number of trades = ' num2str(handles.numberoftrades)...
            ' Sharpe Ratio = ' num2str(handles.AnnualSharpeRatio) ]);
        ylabel('Portfolio Value');
        xlabel('Trading Days');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
