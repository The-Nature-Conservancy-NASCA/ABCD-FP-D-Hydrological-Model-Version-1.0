function varargout = ListResults(varargin)
% LISTRESULTS MATLAB code for ListResults.fig
%      LISTRESULTS, by itself, creates a new LISTRESULTS or raises the existing
%      singleton*.
%
%      H = LISTRESULTS returns the handle to a new LISTRESULTS or the handle to
%      the existing singleton*.
%
%      LISTRESULTS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LISTRESULTS.M with the given input arguments.
%
%      LISTRESULTS('Property','Value',...) creates a new LISTRESULTS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ListResults_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ListResults_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ListResults

% Last Modified by GUIDE v2.5 21-Jul-2018 18:13:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ListResults_OpeningFcn, ...
                   'gui_OutputFcn',  @ListResults_OutputFcn, ...
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


% --- Executes just before ListResults is made visible.
function ListResults_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ListResults (see VARARGIN)

% Choose default command line output for ListResults
handles.output = hObject;

set(handles.figure1,'Color',[1 1 1])

% Logo de TNC
axes(handles.axes1)
Logo = imread('Logo_TNC.png');
image(Logo);
axis off

global UserData
if nargin > 3
    % Project Path
    UserData = varargin{1};
    
    if isfield(UserData,'Inc_R_Q')
        
        % Streamflow
        set(handles.Q,'Value',UserData.Inc_R_Q)
        
        % Climate Varibale
        set(handles.P,'Value',UserData.Inc_R_P)
        set(handles.ETP,'Value',UserData.Inc_R_ETP)
        set(handles.ETR,'Value',UserData.Inc_R_ETR)
        set(handles.Esc,'Value',UserData.Inc_R_Esc)
        
        % Thomas Models
        set(handles.Sw,'Value',UserData.Inc_R_Sw)
        set(handles.Sg,'Value',UserData.Inc_R_Sg)
        set(handles.Y,'Value',UserData.Inc_R_Y)
        set(handles.Ro,'Value',UserData.Inc_R_Ro)
        set(handles.Rg,'Value',UserData.Inc_R_Rg)
        set(handles.Qg,'Value',UserData.Inc_R_Qg)
        
        % Floodplains Model
        set(handles.Ql,'Value',UserData.Inc_R_Ql)
        set(handles.Rl,'Value',UserData.Inc_R_Rl)
        set(handles.Vh,'Value',UserData.Inc_R_Vh)
        
        % Demand
        set(handles.Agri_D,'Value',UserData.Inc_R_Agri_Dm)
        set(handles.Dom_D,'Value',UserData.Inc_R_Dom_Dm)
        set(handles.Liv_D,'Value',UserData.Inc_R_Liv_Dm)
        set(handles.Mn_D,'Value',UserData.Inc_R_Min_Dm)
        set(handles.Hy_D,'Value',UserData.Inc_R_Hy_Dm)
        set(handles.Agri_R,'Value',UserData.Inc_R_Agri_R)
        
        % Return
        set(handles.Agri_R,'Value',UserData.Inc_R_Dom_R)
        set(handles.Dom_R,'Value',UserData.Inc_R_Dom_R)
        set(handles.Liv_R,'Value',UserData.Inc_R_Liv_R)
        set(handles.Mn_R,'Value',UserData.Inc_R_Min_R)
        set(handles.Hy_R,'Value',UserData.Inc_R_Hy_R)
        
        % Index
        set(handles.Index,'Value',UserData.Inc_R_Index)
        
        % Graphic
        set(handles.TS,'Value',UserData.Inc_R_TS)
        set(handles.Box,'Value',UserData.Inc_R_Box)
        set(handles.Fur,'Value',UserData.Inc_R_Fur)
        set(handles.DC,'Value',UserData.Inc_R_DC)
        set(handles.MMM,'Value',UserData.Inc_R_MMM)
    else
        %streamflow
        UserData.Inc_R_Q        = get(handles.Q,'Value');

        % Climate Var
        UserData.Inc_R_P        = get(handles.P,'Value');
        UserData.Inc_R_Esc      = get(handles.Esc,'Value');
        UserData.Inc_R_ETP      = get(handles.ETP,'Value');
        UserData.Inc_R_ETR      = get(handles.ETR,'Value');

        % Thomas Model
        UserData.Inc_R_Sw       = get(handles.Sw,'Value');
        UserData.Inc_R_Sg       = get(handles.Sg,'Value');
        UserData.Inc_R_Y        = get(handles.Y,'Value');
        UserData.Inc_R_Ro       = get(handles.Ro,'Value');
        UserData.Inc_R_Rg       = get(handles.Rg,'Value');
        UserData.Inc_R_Qg       = get(handles.Qg,'Value');

        % Floodplains Model
        UserData.Inc_R_Ql       = get(handles.Ql,'Value');
        UserData.Inc_R_Rl       = get(handles.Rl,'Value');
        UserData.Inc_R_Vh       = get(handles.Vh,'Value');

        % Demand
        UserData.Inc_R_Agri_Dm  = get(handles.Agri_D,'Value');
        UserData.Inc_R_Dom_Dm   = get(handles.Dom_D,'Value');
        UserData.Inc_R_Liv_Dm   = get(handles.Liv_D,'Value');
        UserData.Inc_R_Mn_Dm    = get(handles.Mn_D,'Value');
        UserData.Inc_R_Hy_Dm    = get(handles.Hy_D,'Value');

        % Return
        UserData.Inc_R_Agri_R   = get(handles.Agri_R,'Value');
        UserData.Inc_R_Dom_R    = get(handles.Dom_R,'Value');
        UserData.Inc_R_Liv_R    = get(handles.Liv_R,'Value');
        UserData.Inc_R_Mn_R     = get(handles.Mn_R,'Value');
        UserData.Inc_R_Hy_R     = get(handles.Hy_R,'Value');

        % Index 
        UserData.Inc_R_Index    = get(handles.Index,'Value');

        % Graphic
        UserData.Inc_R_TS       = get(handles.TS,'Value');
        UserData.Inc_R_Box      = get(handles.Box,'Value');
        UserData.Inc_R_Fur      = get(handles.Fur,'Value');
        UserData.Inc_R_DC       = get(handles.DC,'Value');
        UserData.Inc_R_MMM      = get(handles.MMM,'Value');

    end
end

% Update handles structure
guidata(hObject, handles);



% UIWAIT makes ListResults wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ListResults_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
uiwait(gcf)
global UserData StatusRun
varargout{1} = UserData;
varargout{2} = StatusRun;

% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Average.
function Average_Callback(hObject, eventdata, handles)
% hObject    handle to Average (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Average


% --- Executes on button press in Q.
function Q_Callback(hObject, eventdata, handles)
% hObject    handle to Q (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Q


% --- Executes on button press in Agri_D.
function Agri_D_Callback(hObject, eventdata, handles)
% hObject    handle to Agri_D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Agri_D


% --- Executes on button press in Esc.
function Esc_Callback(hObject, eventdata, handles)
% hObject    handle to Esc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Esc


% --- Executes on button press in ETP.
function ETP_Callback(hObject, eventdata, handles)
% hObject    handle to ETP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ETP


% --- Executes on button press in ETR.
function ETR_Callback(hObject, eventdata, handles)
% hObject    handle to ETR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ETR


% --- Executes on button press in Sw.
function Sw_Callback(hObject, eventdata, handles)
% hObject    handle to Sw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Sw


% --- Executes on button press in Sg.
function Sg_Callback(hObject, eventdata, handles)
% hObject    handle to Sg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Sg


% --- Executes on button press in Y.
function Y_Callback(hObject, eventdata, handles)
% hObject    handle to Y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Y


% --- Executes on button press in Ro.
function Ro_Callback(hObject, eventdata, handles)
% hObject    handle to Ro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Ro


% --- Executes on button press in Rg.
function Rg_Callback(hObject, eventdata, handles)
% hObject    handle to Rg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Rg


% --- Executes on button press in Qg.
function Qg_Callback(hObject, eventdata, handles)
% hObject    handle to Qg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Qg


% --- Executes on button press in Dom_D.
function Dom_D_Callback(hObject, eventdata, handles)
% hObject    handle to Dom_D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Dom_D


% --- Executes on button press in Liv_D.
function Liv_D_Callback(hObject, eventdata, handles)
% hObject    handle to Liv_D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Liv_D


% --- Executes on button press in Mn_D.
function Mn_D_Callback(hObject, eventdata, handles)
% hObject    handle to Mn_D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Mn_D


% --- Executes on button press in Hy_D.
function Hy_D_Callback(hObject, eventdata, handles)
% hObject    handle to Hy_D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Hy_D


% --- Executes on button press in checkbox17.
function checkbox17_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox17


% --- Executes on button press in Ql.
function Ql_Callback(hObject, eventdata, handles)
% hObject    handle to Ql (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Ql


% --- Executes on button press in Rl.
function Rl_Callback(hObject, eventdata, handles)
% hObject    handle to Rl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Rl


% --- Executes on button press in Index.
function Index_Callback(hObject, eventdata, handles)
% hObject    handle to Index (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Index


% --- Executes on button press in Ok.
function Ok_Callback(hObject, eventdata, handles)
% hObject    handle to Ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global UserData StatusRun
% Streamflow
UserData.Inc_R_Q        = get(handles.Q,'Value');

% Climate Var
UserData.Inc_R_P        = get(handles.P,'Value');
UserData.Inc_R_Esc      = get(handles.Esc,'Value');
UserData.Inc_R_ETP      = get(handles.ETP,'Value');
UserData.Inc_R_ETR      = get(handles.ETR,'Value');

% Thomas Model
UserData.Inc_R_Sw       = get(handles.Sw,'Value');
UserData.Inc_R_Sg       = get(handles.Sg,'Value');
UserData.Inc_R_Y        = get(handles.Y,'Value');
UserData.Inc_R_Ro       = get(handles.Ro,'Value');
UserData.Inc_R_Rg       = get(handles.Rg,'Value');
UserData.Inc_R_Qg       = get(handles.Qg,'Value');

% Floodplains Model
UserData.Inc_R_Ql       = get(handles.Ql,'Value');
UserData.Inc_R_Rl       = get(handles.Rl,'Value');
UserData.Inc_R_Vh       = get(handles.Vh,'Value');

% Demand
UserData.Inc_R_Agri_Dm  = get(handles.Agri_D,'Value');
UserData.Inc_R_Dom_Dm   = get(handles.Dom_D,'Value');
UserData.Inc_R_Liv_Dm   = get(handles.Liv_D,'Value');
UserData.Inc_R_Mn_Dm    = get(handles.Mn_D,'Value');
UserData.Inc_R_Hy_Dm    = get(handles.Hy_D,'Value');

% Return
UserData.Inc_R_Agri_R   = get(handles.Agri_R,'Value');
UserData.Inc_R_Dom_R    = get(handles.Dom_R,'Value');
UserData.Inc_R_Liv_R    = get(handles.Liv_R,'Value');
UserData.Inc_R_Mn_R     = get(handles.Mn_R,'Value');
UserData.Inc_R_Hy_R     = get(handles.Hy_R,'Value');

% Index 
UserData.Inc_R_Index    = get(handles.Index,'Value');

% Graphic
UserData.Inc_R_TS       = get(handles.TS,'Value');
UserData.Inc_R_Box      = get(handles.Box,'Value');
UserData.Inc_R_Fur      = get(handles.Fur,'Value');
UserData.Inc_R_DC       = get(handles.DC,'Value');
UserData.Inc_R_MMM      = get(handles.MMM,'Value');

StatusRun = true;

close(gcf)

% --- Executes on button press in Cancel.
function Cancel_Callback(hObject, eventdata, handles)
% hObject    handle to Cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global StatusRun
StatusRun = false;
close(gcf)

% --- Executes on button press in Fur.
function Fur_Callback(hObject, eventdata, handles)
% hObject    handle to Fur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Fur


% --- Executes on button press in DC.
function DC_Callback(hObject, eventdata, handles)
% hObject    handle to DC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DC


% --- Executes on button press in Box.
function Box_Callback(hObject, eventdata, handles)
% hObject    handle to Box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Box


% --- Executes on button press in TS.
function TS_Callback(hObject, eventdata, handles)
% hObject    handle to TS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of TS

% --- Executes on button press in MMM.
function MMM_Callback(hObject, eventdata, handles)
% hObject    handle to MMM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of MMM


% --- Executes on button press in P.
function P_Callback(hObject, eventdata, handles)
% hObject    handle to P (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of P


% --- Executes on button press in Hy_R.
function Hy_R_Callback(hObject, eventdata, handles)
% hObject    handle to Hy_R (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Hy_R


% --- Executes on button press in Mn_R.
function Mn_R_Callback(hObject, eventdata, handles)
% hObject    handle to Mn_R (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Mn_R


% --- Executes on button press in Liv_R.
function Liv_R_Callback(hObject, eventdata, handles)
% hObject    handle to Liv_R (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Liv_R


% --- Executes on button press in Dom_R.
function Dom_R_Callback(hObject, eventdata, handles)
% hObject    handle to Dom_R (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Dom_R


% --- Executes on button press in Agri_R.
function Agri_R_Callback(hObject, eventdata, handles)
% hObject    handle to Agri_R (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Agri_R


% --- Executes on button press in Vh.
function Vh_Callback(hObject, eventdata, handles)
% hObject    handle to Vh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Vh
