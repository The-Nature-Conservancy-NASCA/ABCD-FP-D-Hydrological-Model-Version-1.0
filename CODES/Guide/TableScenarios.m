function varargout = TableScenarios(varargin)
% TABLESCENARIOS MATLAB code for TableScenarios.fig
%      TABLESCENARIOS, by itself, creates a new TABLESCENARIOS or raises the existing
%      singleton*.
%
%      H = TABLESCENARIOS returns the handle to a new TABLESCENARIOS or the handle to
%      the existing singleton*.
%
%      TABLESCENARIOS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TABLESCENARIOS.M with the given input arguments.
%
%      TABLESCENARIOS('Property','Value',...) creates a new TABLESCENARIOS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TableScenarios_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TableScenarios_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TableScenarios

% Last Modified by GUIDE v2.5 16-Jan-2019 08:51:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TableScenarios_OpeningFcn, ...
                   'gui_OutputFcn',  @TableScenarios_OutputFcn, ...
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


% --- Executes just before TableScenarios is made visible.
function TableScenarios_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TableScenarios (see VARARGIN)

% Choose default command line output for TableScenarios
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TableScenarios wait for user response (see UIRESUME)

global Scenarios SceRef
if nargin > 3
    
    Scenarios   = varargin{1};
    SceRef      = varargin{2};
    set(handles.Table,'Data',Scenarios)
    set(handles.SceRef,'String',SceRef)
    
end

% --- Outputs from this function are returned to the command line.
function varargout = TableScenarios_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
uiwait(gcf)
global Scenarios SceRef
varargout{1}  = Scenarios;
varargout{2}  = SceRef;


function BasinNumber_Callback(hObject, eventdata, handles)
% hObject    handle to text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text as text
%        str2double(get(hObject,'String')) returns contents of text as a double



% --- Executes during object creation, after setting all properties.
function BasinNumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BasinNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Update.
function Update_Callback(hObject, eventdata, handles)
% hObject    handle to Update (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Raw     = get(handles.Table,'Data');
[fil,~] = size(Raw);
N       = str2num(get(handles.BasinNumber,'String'));
if N > fil
    o = cell(N,3);
    o(1:fil,:) = Raw;
    set(handles.Table,'Data',o)
else
    o = cell(N,3);
    o = Raw(1:N,:);
    set(handles.Table,'Data',o)
end

% --- Executes on button press in Save.
function Save_Callback(hObject, eventdata, handles)
% hObject    handle to Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global Scenarios SceRef
Scenarios   = get(handles.Table,'Data');
Posi = [];
Cont = 1;
for i = 1:length(Scenarios(:,1))
    Number  = Scenarios{i,2};    
    if (~isempty(Number)) && (~isnan(Number))
        Posi(Cont) = i;
        Cont = Cont + 1;
    end
      
end

if isempty(Posi)
    Scenarios = {'',[],[]};
else
    Scenarios = Scenarios(Posi,:);
end

for i = 1:length(Scenarios(:,1))
    Status  = Scenarios{i,3}; 
    if isempty(Status)
        Scenarios{i,3} = false;        
    end
end

% Verificar que el scenario se encuentre 
SceRef      = get(handles.SceRef,'String');
close(gcf)

% --- Executes on button press in Cancel.
function Cancel_Callback(hObject, eventdata, handles)
% hObject    handle to Cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcf)

function SceRef_Callback(hObject, eventdata, handles)
% hObject    handle to SceRef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SceRef as text
%        str2double(get(hObject,'String')) returns contents of SceRef as a double


% --- Executes during object creation, after setting all properties.
function SceRef_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SceRef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when entered data in editable cell(s) in Table.
function Table_CellEditCallback(hObject, eventdata, handles)
