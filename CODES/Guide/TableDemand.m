function varargout = TableDemand(varargin)
% TABLEDEMAND MATLAB code for TableDemand.fig
%      TABLEDEMAND, by itself, creates a new TABLEDEMAND or raises the existing
%      singleton*.
%
%      H = TABLEDEMAND returns the handle to a new TABLEDEMAND or the handle to
%      the existing singleton*.
%
%      TABLEDEMAND('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TABLEDEMAND.M with the given input arguments.
%
%      TABLEDEMAND('Property','Value',...) creates a new TABLEDEMAND or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TableDemand_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TableDemand_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TableDemand

% Last Modified by GUIDE v2.5 22-Jan-2019 10:21:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TableDemand_OpeningFcn, ...
                   'gui_OutputFcn',  @TableDemand_OutputFcn, ...
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


% --- Executes just before TableDemand is made visible.
function TableDemand_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TableDemand (see VARARGIN)

% Choose default command line output for TableDemand
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TableDemand wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global TypeDemand PathProject ExcelFile
if nargin > 3
    PathProject         = varargin{1};
    TypeDemand          = varargin{2};
    ExcelFile           = varargin{3};
    
    [~, col]          = size(ExcelFile);
    
    DemandVar = {'Agricultural','Domestic','Livestock','Hydrocarbons','Mining'};
    
    Tmp = dir(fullfile(PathProject,'DATA','Demand', [DemandVar{TypeDemand},'-Demand'], '*.xlsx'));
    NameExcel = {Tmp.name};
    
    if isempty(NameExcel)
        ExcelFile       = {['there are no files for ',DemandVar{TypeDemand},'-Demand']};
        FormatData      = {'char'};
        WidthData       = {300};
        NameCol         = {'Error'};
        ColEdit         = false;
    else
        % 'numeric'
        FormatData      = cell(1,col);
        FormatData{1}   = NameExcel;
        FormatData{2}   = 'numeric';

        WidthData       = cell(1,col);
        WidthData{1}    = 150;
        WidthData{2}    = 80;

        NameCol         = cell(1,col);
        NameCol{1}      = 'Demand Unit';
        NameCol{2}      = 'Scenario-1';

        for i = 3:col
            FormatData{i}   = 'numeric';
            WidthData{i}    = 80;
            NameCol{i}      = ['Scenario-',num2str(i - 2)];
        end   
        ColEdit = true(1,col);
    end
        
    set(handles.TableDemand,'ColumnFormat', FormatData)
    set(handles.TableDemand,'ColumnEditable', ColEdit)
    set(handles.TableDemand,'ColumnWidth', WidthData)
    set(handles.TableDemand,'ColumnName', NameCol)
    set(handles.TableDemand,'Data',ExcelFile)
    
    
end


% --- Outputs from this function are returned to the command line.
function varargout = TableDemand_OutputFcn(hObject, eventdata, handles) 

uiwait(gcf)
global ExcelFile

if length(ExcelFile(:,1)) > 1 
    Cont    = 1;
    Posi    = [];
    for i = 1:length(ExcelFile(:,1))
        if ~isempty(ExcelFile{i,1})
            Posi(Cont) = i; 
            Cont = Cont + 1;
        end
    end

    if isempty(Posi) 
        ExcelFile = cell(1,2);
    else
        ExcelFile = ExcelFile(Posi,:);
        if length(ExcelFile(:,1)) > 1 
            Cont    = 2;
            Posi    = [];
            Posi(1) = 1;
            for i = 1:length(ExcelFile(:,1))
                for j = 2:length(ExcelFile(1,:))
                    if ~isempty(ExcelFile{i,j})
                        Posi(Cont) = j; 
                        Cont = Cont + 1;
                    end
                end
            end

            Posi = unique(Posi);

            if isempty(Posi) 
                ExcelFile = ExcelFile(:,1:2);
            else
                ExcelFile = ExcelFile(:,Posi);
            end
        end
    end
else
    ExcelFile = cell(1,2);
end
varargout{1} = ExcelFile;


% --- Executes on button press in Ok.
function Ok_Callback(hObject, eventdata, handles)

global ExcelFile
ExcelFile = get(handles.TableDemand,'Data');
close(gcf)

% --- Executes on button press in Cancel.
function Cancel_Callback(hObject, eventdata, handles)

close(gcf)

% --- Executes during object creation, after setting all properties.
function DemandNumber_Callback(hObject, eventdata, handles)

value = ceil(str2double(get(handles.DemandNumber,'String')));
if isnan(value)
    errordlg('Please enter one numeric value!!','!! Error !!')
    set(handles.DemandNumber,'String','1')
    return
end

function DemandNumber_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Update.
function Update_Callback(hObject, eventdata, handles)
global TypeDemand PathProject

value = ceil(str2double(get(handles.ScenarioNumber,'String')));
if isnan(value)
    errordlg('Please enter one numeric value!!','!! Error !!')
    set(handles.ScenarioNumber,'String','1')
    return
end
 
value = ceil(str2double(get(handles.DemandNumber,'String')));
if isnan(value)
    set(handles.DemandNumber,'String','1')
    errordlg('Please enter one numeric value!!','!! Error !!')
    return
end

% data demand                                 
Raw         = get(handles.TableDemand,'Data');

[fil,Col]   = size(Raw);
N           = str2double(get(handles.DemandNumber,'String'));
M           = str2double(get(handles.ScenarioNumber,'String'));

if M < 1, M = 1; end
if N < 1, N = 1; end

M = M + 1;
DemandVar = {'Agricultural','Domestic','Livestock','Hydrocarbons','Mining'};
    
Tmp = dir(fullfile(PathProject,'DATA','Demand', [DemandVar{TypeDemand},'-Demand'], '*.xlsx'));
NameExcel = {Tmp.name};

% 'numeric'
FormatData      = cell(1,M);
FormatData{1}   = NameExcel;
FormatData{2}   = 'numeric';

WidthData       = cell(1,M);
WidthData{1}    = 150;
WidthData{2}    = 80;

NameCol         = cell(1,M);
NameCol{1}      = 'Demand Unit';
NameCol{2}      = 'Scenario-1';

for i = 3:M
    FormatData{i}   = 'numeric';
    WidthData{i}    = 80;
    NameCol{i}      = ['Scenario-',num2str(i - 1)];
end   

set(handles.TableDemand,'ColumnFormat', FormatData(1:M))
set(handles.TableDemand,'ColumnEditable', true(1,M))
set(handles.TableDemand,'ColumnWidth', WidthData(1:M))
set(handles.TableDemand,'ColumnName', NameCol(1:M))

if (N >= fil) && (M >= Col)
    o = cell(N,M);
    o(1:fil,1:Col) = Raw(1:fil,1:Col);    
    set(handles.TableDemand,'Data',o)
    
elseif (N >= fil) && (M < Col)
    o = cell(N,M);
    o(1:fil,1:M) = Raw(1:fil,1:M);
    set(handles.TableDemand,'Data',o)
    
elseif (N < fil) && (M >= Col)
    o = cell(N,M);
    o(1:N,1:Col) = Raw(1:N,1:Col);
    set(handles.TableDemand,'Data',o)
    
elseif (N < fil) && (M < Col)
    o = Raw(1:N,1:M);
    set(handles.TableDemand,'Data',o)
    
end


% --- Executes when entered data in editable cell(s) in TableDemand.
function TableDemand_CellEditCallback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function ScenarioNumber_Callback(hObject, eventdata, handles)
value = ceil(str2double(get(handles.ScenarioNumber,'String')));
if isnan(value)
    errordlg('Please enter one numeric value!!','!! Error !!')
    set(handles.ScenarioNumber,'String','1')
    return
end

function ScenarioNumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ScenarioNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
