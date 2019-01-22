function varargout = PrintResults(varargin)
% PRINTRESULTS MATLAB code for PrintResults.fig
%      PRINTRESULTS, by itself, creates a new PRINTRESULTS or raises the existing
%      singleton*.
%
%      H = PRINTRESULTS returns the handle to a new PRINTRESULTS or the handle to
%      the existing singleton*.
%
%      PRINTRESULTS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PRINTRESULTS.M with the given input arguments.
%
%      PRINTRESULTS('Property','Value',...) creates a new PRINTRESULTS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PrintResults_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PrintResults_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PrintResults

% Last Modified by GUIDE v2.5 12-Jul-2018 13:57:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PrintResults_OpeningFcn, ...
                   'gui_OutputFcn',  @PrintResults_OutputFcn, ...
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


% --- Executes just before PrintResults is made visible.
function PrintResults_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PrintResults (see VARARGIN)

% Choose default command line output for PrintResults
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

global TextResults
global Po
if nargin > 3
    TextResults     = varargin{1};
    Po              = varargin{2};
    set(handles.List_Results,'string', TextResults)
end

% UIWAIT makes PrintResults wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PrintResults_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
global Po

if Po == 1
    uiwait(gcf)
end

% --- Executes on selection change in List_Results.
function List_Results_Callback(hObject, eventdata, handles)
% hObject    handle to List_Results (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns List_Results contents as cell array
%        contents{get(hObject,'Value')} returns selected item from List_Results


% --- Executes during object creation, after setting all properties.
function List_Results_CreateFcn(hObject, eventdata, handles)
% hObject    handle to List_Results (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Con.
function Con_Callback(hObject, eventdata, handles)
% hObject    handle to Con (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcf)
