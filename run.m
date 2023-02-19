function varargout = run(varargin)
% RUN MATLAB code for run.fig
%      RUN, by itself, creates a new RUN or raises the existing
%      singleton*.
%
%      H = RUN returns the handle to a new RUN or the handle to
%      the existing singleton*.
%
%      RUN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RUN.M with the given input arguments.
%
%      RUN('Property','Value',...) creates a new RUN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before run_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to run_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help run

% Last Modified by GUIDE v2.5 30-Nov-2021 21:02:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @run_OpeningFcn, ...
                   'gui_OutputFcn',  @run_OutputFcn, ...
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


% --- Executes just before run is made visible.
function run_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a futureOD version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to run (see VARARGIN)

% Choose default command line output for run
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes run wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = run_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a futureOD version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on selection change in method.
function method_Callback(hObject, eventdata, handles)
% hObject    handle to method (see GCBO)
% eventdata  reserved - to be defined in a futureOD version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns method contents as cell array
%        contents{get(hObject,'Value')} returns selected item from method
m = get(hObject, 'Value'); %根据选项获得迭代方法
switch m
    case 2
        method = 'Average';
    case 3
        method = 'Detroit';
    case 4
        method = 'Fratar';
    case 5
        method = 'Furness';
end
handles.method = method;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function method_CreateFcn(hObject, eventdata, handles)
% hObject    handle to method (see GCBO)
% eventdata  reserved - to be defined in a futureOD version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in run.
function run_Callback(hObject, eventdata, handles)
% hObject    handle to run (see GCBO)
% eventdata  reserved - to be defined in a futureOD version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s1 = size(handles.OD_origin); % 获取现状OD矩阵现状
F_O = zeros(1, s1(1)); %设置全空O误差指标向量
F_D = zeros(1, s1(2)); %设置全空D误差指标向量
OD_now = handles.OD_origin; %获取当前计算使用OD矩阵
total_every_O_now = sum(OD_now, 2); %获取现状矩阵总生成量
total_every_D_now = sum(OD_now); %获取现状矩阵总吸收量
handles.number = 1; %迭代轮次计数变量设置
[stop, F_O, F_D] = calculate_and_check(hObject, handles, F_O, F_D, total_every_O_now, total_every_D_now); %检查不经过迭代是否满足误差要求
guidata(hObject, handles);
OD_final = do(hObject, handles, F_O, F_D, OD_now, stop, total_every_O_now, total_every_D_now); %算法迭代
set(handles.futureOD,'Data',OD_final); % 预测OD表显示



function inputOD_Callback(hObject, eventdata, handles)
% hObject    handle to inputOD (see GCBO)
% eventdata  reserved - to be defined in a futureOD version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inputOD as text
%        str2double(get(hObject,'String')) returns contents of inputOD as a double
OD_origin = str2num(get(hObject,'string')); %获取用户输入的现状OD矩阵
handles.OD_origin = OD_origin;
s = size(OD_origin); %获得现在OD矩阵的形状
handles.len_O = s(1); %发生点O的个数为行数
handles.len_D = s(2); %吸收点D的个数为列数
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function inputOD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inputOD (see GCBO)
% eventdata  reserved - to be defined in a futureOD version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in number.
function number_Callback(hObject, eventdata, handles)
% hObject    handle to number (see GCBO)
% eventdata  reserved - to be defined in a futureOD version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns number contents as cell array
%        contents{get(hObject,'Value')} returns selected item from number
n = get(hObject, 'Value'); %根据选项获得保留小数位数
switch n
    case 2
        num = 1;
    case 3
        num = 2;
    case 4
        num = 3;
    case 5
        num = 4;
end
handles.num = num;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function number_CreateFcn(hObject, eventdata, handles)
% hObject    handle to number (see GCBO)
% eventdata  reserved - to be defined in a futureOD version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function inputvector_Callback(hObject, eventdata, handles)
% hObject    handle to inputvector (see GCBO)
% eventdata  reserved - to be defined in a futureOD version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inputvector as text
%        str2double(get(hObject,'String')) returns contents of inputvector as a double
vector = str2num(get(hObject,'string')); %获取用户输入的将来发生和吸引交通量向量
total_every_O_future = vector(1, :); %第一行为将来发生向量
total_every_D_future = vector(2, :); %第二行为将来吸引向量
total_future = sum(sum(vector)) / 2; %计算交通出行总量
handles.total_every_O_future = total_every_O_future;
handles.total_every_D_future = total_every_D_future;
handles.total_future = total_future;
handles.vec = vector;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function inputvector_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inputvector (see GCBO)
% eventdata  reserved - to be defined in a futureOD version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function error_Callback(hObject, eventdata, handles)
% hObject    handle to error (see GCBO)
% eventdata  reserved - to be defined in a futureOD version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of error as text
%        str2double(get(hObject,'String')) returns contents of error as a double
error = str2double(get(hObject,'String')); %获取用户希望误差系数
handles.error = error / 100;               %转换成小数
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function error_CreateFcn(hObject, eventdata, handles)
% hObject    handle to error (see GCBO)
% eventdata  reserved - to be defined in a futureOD version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when entered data in editable cell(s) in nowOD.
function nowOD_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to nowOD (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in OK1.
function OK1_Callback(hObject, eventdata, handles)
% hObject    handle to OK1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.nowOD,'Data',handles.OD_origin); %将现状OD表格内容设置成输入的现状OD矩阵
guidata(hObject, handles);

% --- Executes on button press in OK2.
function OK2_Callback(hObject, eventdata, handles)
% hObject    handle to OK2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.vector,'Data',handles.vec); %将将来的发生和吸引量表格内容设置成输入的将来发生和吸引交通量向量
guidata(hObject, handles);


% --- Executes on button press in help.
function help_Callback(hObject, eventdata, handles)
% hObject    handle to help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
open("help.pdf") %打开帮助文档


% --- Executes on button press in log.
function log_Callback(hObject, eventdata, handles)
% hObject    handle to log (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
open("result.log") %打开log日志


% --- Executes on button press in exit.
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcf) %关闭GUI界面
