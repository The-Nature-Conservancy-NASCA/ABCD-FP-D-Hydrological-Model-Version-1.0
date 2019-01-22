function varargout = ConfigPath(varargin)
% CONFIGPATH MATLAB code for ConfigPath.fig
%      CONFIGPATH, by itself, creates a new CONFIGPATH or raises the existing
%      singleton*.
%
%      H = CONFIGPATH returns the handle to a new CONFIGPATH or the handle to
%      the existing singleton*.
%
%      CONFIGPATH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONFIGPATH.M with the given input arguments.
%
%      CONFIGPATH('Property','Value',...) creates a new CONFIGPATH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ConfigPath_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ConfigPath_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ConfigPath

% Last Modified by GUIDE v2.5 16-Jan-2019 10:13:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ConfigPath_OpeningFcn, ...
                   'gui_OutputFcn',  @ConfigPath_OutputFcn, ...
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


% --- Executes just before ConfigPath is made visible.
function ConfigPath_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ConfigPath (see VARARGIN)

% Choose default command line output for ConfigPath
handles.output = hObject;

% Logo de TNC
axes(handles.axes1)
Logo = imread('Logo_TNC.png');
image(Logo);
axis off

set(handles.figure1,'Color',[1 1 1])

% set(handles.Panel_Geo,'Visible', 'off')

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ConfigPath wait for user response (see UIRESUME)
% uiwait(handles.figure1);

global UserData
if nargin > 3
    % Project Path
    UserData = varargin{1};

    % Name Project
    if isfield(UserData, 'NameProject')
        set(handles.NameProject,'String',UserData.NameProject)
        set(handles.File_HUA,'String', UserData.NameFile_HUA)
        set(handles.File_DEM,'String', UserData.NameFile_DEM)
        set(handles.File_P,'String', UserData.NameFile_Pcp)
        set(handles.File_DmSub,'String', UserData.NameFileDm_Sub)
        set(handles.File_Q,'String', UserData.NameFile_Q)
        set(handles.ModeModel,'Value',UserData.ModeModel)        
        set(handles.Cal_ETP,'Value',UserData.Cal_ETP)
        set(handles.TypeFile_P,'Value',UserData.TypeFile_Pcp)
        
        if UserData.Cal_ETP == 1
            set(handles.TypeFile_ETP,'Value',UserData.TypeFile_ETP)
            set(handles.File_ETP,'String', UserData.NameFile_ETP);
        else
            set(handles.TypeFile_T,'Value',UserData.TypeFile_T)
            set(handles.File_T,'String', UserData.NameFile_T);
        end

        % Inc of Agricultural Demand
        set(handles.Agri_checkbox,'Value',UserData.Inc_Agri)
        % Inc of Domestic Demand
        set(handles.Dom_checkbox,'Value',UserData.Inc_Dom)
        % Inc of Livestock Demand
        set(handles.Liv_checkbox,'Value',UserData.Inc_Liv)
        % Inc of Hydrocarbons Demand
        set(handles.Hy_checkbox,'Value',UserData.Inc_Hy)
        % Inc of Mining Demand
        set(handles.Min_checkbox,'Value',UserData.Inc_Min)
        % Inc of underground Demand
        set(handles.Sub_checkbox,'Value',UserData.Inc_Sub)
        
        % Date Init Analysis
        set(handles.DateInit,'String',UserData.DateInit);
        % Date End Analysis
        set(handles.DateEnd,'String',UserData.DateEnd)
        
        % check block
        % -----------------------------------------------------------------
        % Modo simulation or Calibration
        value = get(handles.ModeModel,'value');
        if value == 2
            set(handles.File_Q,'Enable','off')
        else
            set(handles.File_Q,'Enable','on')
        end
        
        % Estimation evapotranpitation 
        value = get(handles.Cal_ETP,'value');
        if value == 1
            set(handles.File_T,'Enable','off')
            set(handles.TypeFile_T,'Enable','off')
            set(handles.File_ETP,'Enable','on')
            set(handles.TypeFile_ETP,'Enable','on')
        else
            set(handles.File_T,'Enable','on')
            set(handles.TypeFile_T,'Enable','on')
            set(handles.File_ETP,'Enable','off')
            set(handles.TypeFile_ETP,'Enable','off')
        end
        
        % estimation ETP
        value  = get(handles.Cal_ETP,'Value');
        value2 = get(handles.TypeFile_T,'Value');
        value3 = get(handles.TypeFile_ETP,'Value');

        if value == 1
            if value3  == 1
                set(handles.File_DEM,'Enable','on')
            else
                set(handles.File_DEM,'Enable','off')
            end
        else
            if value2  == 1
                set(handles.File_DEM,'Enable','on')
            else
                set(handles.File_DEM,'Enable','off')
            end
        end
        
        % Underground demamd
        value = get(handles.Sub_checkbox,'Value');

        if value == 0
            set(handles.File_DmSub,'Enable','off')
        else
            set(handles.File_DmSub,'Enable','on')
        end

    end
end


% --- Outputs from this function are returned to the command line.
function varargout = ConfigPath_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
uiwait(gcf)
global UserData
varargout{1} = UserData;


% --- Executes on selection change in ModeModel.
function ModeModel_Callback(hObject, eventdata, handles)
value = get(handles.ModeModel,'value');
if value == 2
    set(handles.File_Q,'Enable','off')
else
    set(handles.File_Q,'Enable','on')
end

global UserData
% Model Mode
Va = get(handles.ModeModel,'Value');
UserData.ModeModel                  = Va;

% --- Executes during object creation, after setting all properties.
function ModeModel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ModeModel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Cal_ETP.
function Cal_ETP_Callback(hObject, eventdata, handles)

value = get(handles.Cal_ETP,'value');
if value == 1
    set(handles.File_T,'Enable','off')
    set(handles.TypeFile_T,'Enable','off')
    set(handles.File_ETP,'Enable','on')
    set(handles.TypeFile_ETP,'Enable','on')
else
    set(handles.File_T,'Enable','on')
    set(handles.TypeFile_T,'Enable','on')
    set(handles.File_ETP,'Enable','off')
    set(handles.TypeFile_ETP,'Enable','off')
end

value2 = get(handles.TypeFile_T,'Value');
value3 = get(handles.TypeFile_ETP,'Value');

if value == 1
    if value3  == 1
        set(handles.File_DEM,'Enable','on')
    else
        set(handles.File_DEM,'Enable','off')
    end
else
    if value2  == 1
        set(handles.File_DEM,'Enable','on')
    else
        set(handles.File_DEM,'Enable','off')
    end
end

global UserData

% Calculation of Evapotranspiration
UserData.Cal_ETP                    = value;

if value == 1
    try
        UserData = rmfield(UserData,'TypeDataTemperature');
        UserData = rmfield(UserData,'DataTemperature');
    catch
    end
    Va = get(handles.TypeFile_ETP,'Value');
    UserData.TypeFile_ETP = Va;
    UserData.NameFile_ETP     = get(handles.File_ETP,'String');
    
else
     try
        UserData = rmfield(UserData,'TypeDataEvapotranspiration');
        UserData = rmfield(UserData,'DataEvapotranspiration');
    catch
    end
    Va = get(handles.TypeFile_T,'Value');
    UserData.TypeFile_T    = Va;
    UserData.NameFile_T        = get(handles.File_T,'String');
    
end




% --- Executes during object creation, after setting all properties.
function Cal_ETP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Cal_ETP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in TypeFile_T.
function TypeFile_T_Callback(hObject, eventdata, handles)

global UserData

Va  = get(handles.TypeFile_T,'Value');
UserData.TypeFile_T    = Va;



% --- Executes during object creation, after setting all properties.
function TypeFile_T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TypeFile_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function Est_Hy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Est_Hy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Est_Min.
function Est_Min_Callback(hObject, eventdata, handles)

global UserData

Va = get(handles.Est_Min,'Value');
UserData.Cal_Mining                 = Va;


% --- Executes during object creation, after setting all properties.
function Est_Min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Est_Min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Save.
function Save_Callback(hObject, eventdata, handles)

global UserData

save(fullfile(UserData.PathProject,[UserData.NameProject,'.mat']), 'UserData')
close(gcf)


% --- Executes on button press in Cancel.
function Cancel_Callback(hObject, eventdata, handles)
% hObject    handle to Cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close(gcf)


% --- Executes on button press in Load_Gauges.
function Load_Gauges_Callback(hObject, eventdata, handles)
% hObject    handle to Load_Gauges (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global UserData
if isfield(UserData,'GaugesCatalog')
    UserData.GaugesCatalog = TableGauges(UserData.GaugesCatalog);
else
    UserData.GaugesCatalog = TableGauges;
end

% --- Executes on button press in Load_Network.
function Load_Network_Callback(hObject, eventdata, handles)
% hObject    handle to Load_Network (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in LoadData_Agri.
function LoadData_Agri_Callback(hObject, eventdata, handles)
% hObject    handle to LoadData_Agri (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Agricultural Demand Data Path
global UserData 
Tmp = get(handles.Agri_checkbox,'Value');

if Tmp == 1
    Data = TableDemand(UserData.PathProject,1,UserData.NamesFileDm_Agri);
    UserData.NamesFileDm_Agri = Data;

else
    errordlg('Estimate Agricultural Demand - False!!','!! Error !!')
end

% --- Executes on button press in LoadData_Dom.
function LoadData_Dom_Callback(hObject, eventdata, handles)

% Domestic Demand Data Path
global UserData 
Tmp = get(handles.Dom_checkbox,'Value');

if Tmp == 1
    Data = TableDemand(UserData.PathProject,2,UserData.NamesFileDm_Dom);
    UserData.NamesFileDm_Dom = Data;

else
    errordlg('Estimate Agricultural Demand - False!!','!! Error !!')
end

% --- Executes on button press in LoadData_Liv.
function LoadData_Liv_Callback(hObject, eventdata, handles)
% hObject    handle to LoadData_Liv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Livestock Demand Data Path
global UserData
Tmp = get(handles.Liv_checkbox,'Value');

if Tmp == 1
    Data = TableDemand(UserData.PathProject,3,UserData.NamesFileDm_Liv);
    UserData.NamesFileDm_Liv = Data;

else
    errordlg('Estimate Agricultural Demand - False!!','!! Error !!')
end

% --- Executes on button press in LoadData_Hy.
function LoadData_Hy_Callback(hObject, eventdata, handles)
% hObject    handle to LoadData_Hy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hydrocarbons Demand Data Path
global UserData
Tmp = get(handles.Hy_checkbox,'Value');

if Tmp == 1
    Data = TableDemand(UserData.PathProject,4,UserData.NamesFileDm_Hy);
    UserData.NamesFileDm_Hy = Data;

else
    errordlg('Estimate Agricultural Demand - False!!','!! Error !!')
end

% --- Executes on button press in LoadData_Min.
function LoadData_Min_Callback(hObject, eventdata, handles)
% hObject    handle to LoadData_Min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Mining Demand Data Path
global UserData
Tmp = get(handles.Min_checkbox,'Value');

if Tmp == 1
    Data = TableDemand(UserData.PathProject,5,UserData.NamesFileDm_Min);
    UserData.NamesFileDm_Min = Data;

else
    errordlg('Estimate Agricultural Demand - False!!','!! Error !!')
end

% Name Project
function NameProject_Callback(hObject, eventdata, handles)

global UserData

% Name Project
UserData.NameProject                = get(handles.NameProject,'String');



% --- Executes during object creation, after setting all properties.
function NameProject_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NameProject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in TypeFile_P.
function TypeFile_P_Callback(hObject, eventdata, handles)

global UserData

% Data Type Precipitation
value = get(handles.TypeFile_P,'Value');

UserData.TypeFile_Pcp      = value;



% --- Executes during object creation, after setting all properties.
function TypeFile_P_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TypeFile_P (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ScenariosRun.
function ScenariosRun_Callback(hObject, eventdata, handles)
% hObject    handle to ScenariosRun (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global UserData
if isfield(UserData,'Scenarios')
    Data    = {};
    [DataTmp, Tmp]= TableScenarios(UserData.Scenarios, num2str(UserData.NumberSceCal));
    for i = 1:length(DataTmp(:,1))
        for j = 1:length(DataTmp(1,:))
            T = DataTmp{i,j};
            if ~isempty(T)
                Data{i,j} = T;
            end
        end
    end
    UserData.Scenarios  = Data;
    UserData.NumberSceCal     = str2num(Tmp);
else
    Data    = {};
    [DataTmp, Tmp] = TableScenarios;
    for i = 1:length(DataTmp(:,1))
        for j = 1:length(DataTmp(1,:))
            T = DataTmp{i,j};
            if ~isempty(T)
                Data{i,j} = T;
            end
        end
    end
    UserData.Scenarios  = Data;
    UserData.NumberSceCal     = str2num(Tmp);
end


% --- Executes on button press in Agri_checkbox.
function Agri_checkbox_Callback(hObject, eventdata, handles)

global UserData
% Calculation of Agricultural Demand
Va = get(handles.Agri_checkbox,'Value');
UserData.Inc_Agri           = Va;


% --- Executes on button press in Dom_checkbox.
function Dom_checkbox_Callback(hObject, eventdata, handles)

global UserData

% Calculation of Domestic Demand
Va = get(handles.Dom_checkbox,'Value');
UserData.Inc_Dom               = Va;


% --- Executes on button press in Liv_checkbox.
function Liv_checkbox_Callback(hObject, eventdata, handles)

global UserData

% Calculation of Livestock Demand
Va = get(handles.Liv_checkbox,'Value');
UserData.Inc_Liv              = Va;


% --- Executes on button press in Hy_checkbox.
function Hy_checkbox_Callback(hObject, eventdata, handles)

global UserData

% Calculation of Hydrocarbons Demand
Va = get(handles.Hy_checkbox,'Value');
UserData.Inc_Hy           = Va;



% --- Executes on button press in Min_checkbox.
function Min_checkbox_Callback(hObject, eventdata, handles)

global UserData

% Calculation of Mining Demand
Va = get(handles.Min_checkbox,'Value');
UserData.Inc_Min                 = Va;


% --- Executes on button press in Sub_checkbox.
function Sub_checkbox_Callback(hObject, eventdata, handles)

global UserData

% Calculation of Mining Demand
value = get(handles.Sub_checkbox,'Value');

if value == 0
    set(handles.File_DmSub,'Enable','off')
else
    set(handles.File_DmSub,'Enable','on')
end

UserData.Inc_Sub = value;


function File_HUA_Callback(hObject, eventdata, handles)

global UserData

value = get(handles.File_HUA,'String');
Tmp = strsplit(value,'.');
if strcmp(Tmp{end},'shp')
    UserData.NameFile_HUA               = value;
else
    errordlg('The file does not have the ".shp" extension','!! Error !!')
end



% --- Executes during object creation, after setting all properties.
function File_HUA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to File_HUA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function File_DEM_Callback(hObject, eventdata, handles)

global UserData

value = get(handles.File_DEM,'String');
Tmp = strsplit(value,'.');
if strcmp(Tmp{end},'tif')
    UserData.NameFile_DEM               = value;
else
    errordlg('The file does not have the ".tif" extension','!! Error !!')
end


% --- Executes during object creation, after setting all properties.
function File_DEM_CreateFcn(hObject, eventdata, handles)
% hObject    handle to File_DEM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function File_Q_Callback(hObject, eventdata, handles)

global UserData

value = get(handles.File_Q,'String');
Tmp = strsplit(value,'.');
if strcmp(Tmp{end},'xlsx')
    UserData.NameFile_Q               = value;
else
    errordlg('The file does not have the ".xlsx" extension','!! Error !!')
end


% --- Executes during object creation, after setting all properties.
function File_Q_CreateFcn(hObject, eventdata, handles)
% hObject    handle to File_Q (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function File_P_Callback(hObject, eventdata, handles)

global UserData

value = get(handles.File_P,'String');
Tmp = strsplit(value,'.');
if strcmp(Tmp{end},'xlsx')
    UserData.NameFile_Pcp               = value;
else
    errordlg('The file does not have the ".xlsx" extension','!! Error !!')
end


% --- Executes during object creation, after setting all properties.
function File_P_CreateFcn(hObject, eventdata, handles)
% hObject    handle to File_P (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function File_T_Callback(hObject, eventdata, handles)

global UserData

value = get(handles.File_T,'String');
Tmp = strsplit(value,'.');
if strcmp(Tmp{end},'xlsx')
    UserData.NameFile_T               = value;
else
    errordlg('The file does not have the ".xlsx" extension','!! Error !!')
end


% --- Executes during object creation, after setting all properties.
function File_T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to File_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Est_Agri.
function Agri_Est_Callback(hObject, eventdata, handles)
% hObject    handle to Est_Agri (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Est_Agri contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Est_Agri


% --- Executes during object creation, after setting all properties.
function Agri_Est_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Est_Agri (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in TypeFile_ETP.
function TypeFile_ETP_Callback(hObject, eventdata, handles)

global UserData

Va  = get(handles.TypeFile_ETP,'Value');
UserData.TypeFile_ETP    = Va;


% --- Executes during object creation, after setting all properties.
function TypeFile_ETP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TypeFile_ETP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function File_ETP_Callback(hObject, eventdata, handles)

global UserData

value = get(handles.File_ETP,'String');
Tmp = strsplit(value,'.');
if strcmp(Tmp{end},'xlsx')
    UserData.NameFile_ETP               = value;
else
    errordlg('The file does not have the ".xlsx" extension','!! Error !!')
end


% --- Executes during object creation, after setting all properties.
function File_ETP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to File_ETP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function File_DmSub_Callback(hObject, eventdata, handles)

global UserData

value = get(handles.File_DmSub,'String');
Tmp = strsplit(value,'.');
if strcmp(Tmp{end},'xlsx')
    UserData.NameFileDm_Sub               = value;
else
    errordlg('The file does not have the ".xlsx" extension','!! Error !!')
end

% --- Executes during object creation, after setting all properties.
function File_DmSub_CreateFcn(hObject, eventdata, handles)
% hObject    handle to File_DmSub (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function DateInit_Callback(hObject, eventdata, handles)

global UserData
value = get(handles.DateInit,'String');
try
    Date = datetime(value,'InputFormat','MM-yyyy');
    UserData.DateInit = value;
catch
    set(handles.DateInit,'String', UserData.DateInit)
    errordlg('The date has not been entered in the correct format.','!! Error !!')
end




% --- Executes during object creation, after setting all properties.
function DateInit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DateInit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function DateEnd_Callback(hObject, eventdata, handles)

global UserData
value = get(handles.DateEnd,'String');
try
    Date = datetime(value,'InputFormat','MM-yyyy');
    UserData.DateEnd = value;
catch
    set(handles.DateEnd,'String',UserData.DateEnd)
    errordlg('The date has not been entered in the correct format.','!! Error !!')
end




% --- Executes during object creation, after setting all properties.
function DateEnd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DateEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
