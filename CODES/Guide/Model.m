function varargout = Model(varargin)
% MODEL MATLAB code for Model.fig
%      MODEL, by itself, creates a new MODEL or raises the existing
%      singleton*.
%
%      H = MODEL returns the handle to a new MODEL or the handle to
%      the existing singleton*.
%
%      MODEL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MODEL.M with the given input arguments.
%
%      MODEL('Property','Value',...) creates a new MODEL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Model_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Model_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Model

% Last Modified by GUIDE v2.5 19-Jan-2019 16:00:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Model_OpeningFcn, ...
                   'gui_OutputFcn',  @Model_OutputFcn, ...
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


% --- Executes just before Model is made visible.
function Model_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

%% Color white Figure 
set(handles.figure1,'Color',[1 1 1])

%% Logos 
% Logo de TNC
axes(handles.Icons_TNC)
Logo = imread('Logo_TNC.png');
image(Logo);
axis off
 
% Logo de SNAPP
axes(handles.Icons_SNAPP)
Logo = imread('Logo_SNAPP.jpg');
image(Logo);
axis off

% Logo Model
axes(handles.Icons_Models)
Logo = imread('Model.png');
image(Logo);
axis off

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Model wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = Model_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%% New Project
% --------------------------------------------------------------------
function FlashNew_ClickedCallback(hObject, eventdata, handles)

global UserData
UserData    = struct;
Tmp         = uigetdir;

% ID = fopen('Data.txt','w');
DirModel = pwd;
% fprintf(ID,'%s',A);
% fclose(ID)

if Tmp ~= 0 
    UserData.PathProject        = Tmp;
    UserData.Parallel           = false;
    UserData.Verbose            = false;
    UserData.CoresNumber        = 1;
    UserData.DemandVar          = {'Agricultural','Domestic','Livestock','Hydrocarbons','Mining'};
    UserData.ClimateVar         = {'Pcp','T','ETP'};
    UserData.NameProject        = 'Dummy_Model';
    UserData.ModeModel          = 1;
    UserData.Cal_ETP            = 1;
    UserData.Scenarios          = {'Scenario-1',1,true};
    UserData.NumberSceCal       = 1; 
    UserData.DateInit           = '01-2000';
    UserData.DateEnd            = '05-2002';
    UserData.TypeFile_Pcp       = 1;
    UserData.NameFile_Pcp       = 'Precipitation.xlsx';
    UserData.TypeFile_T         = 1;
    UserData.NameFile_T         = 'Temperature.xlsx';
    UserData.TypeFile_ETP       = 1;
    UserData.NameFile_ETP       = 'Evapotranspiration.xlsx';
    UserData.NameFile_Q         = 'Hydrological.xlsx';
    UserData.NameFile_HUA       = 'HUA.shp';
    UserData.NameFile_DEM       = 'DEM.tif';
    UserData.NamesFileDm_Agri   = cell(1,2);
    UserData.NamesFileDm_Dom    = cell(1,2);
    UserData.NamesFileDm_Liv    = cell(1,2);
    UserData.NamesFileDm_Hy     = cell(1,2);
    UserData.NamesFileDm_Min    = cell(1,2);
    UserData.NameFileDm_Sub     = 'DmSub.xlsx';
    UserData.Mode               = 1;
    UserData.Inc_Agri           = false;
    UserData.Inc_Dom            = false;
    UserData.Inc_Liv            = false;
    UserData.Inc_Hy             = false;
    UserData.Inc_Min            = false;
    UserData.Inc_Sub            = false;
    UserData.Inc_R_Q            = true;
    UserData.Inc_R_P            = true;
    UserData.Inc_R_Esc          = true;
    UserData.Inc_R_ETP          = true;
    UserData.Inc_R_ETR          = true;
    UserData.Inc_R_Sw           = true;
    UserData.Inc_R_Sg           = true;
    UserData.Inc_R_Y            = true;
    UserData.Inc_R_Ro           = true;
    UserData.Inc_R_Rg           = true;
    UserData.Inc_R_Qg           = true;
    UserData.Inc_R_Ql           = true;
    UserData.Inc_R_Rl           = true;
    UserData.Inc_R_Vh           = true;
    UserData.Inc_R_Agri_Dm      = true;
    UserData.Inc_R_Dom_Dm       = true;
    UserData.Inc_R_Liv_Dm       = true;
    UserData.Inc_R_Hy_Dm        = true;
    UserData.Inc_R_Min_Dm        = true;
    UserData.Inc_R_Agri_R       = true;
    UserData.Inc_R_Dom_R        = true;
    UserData.Inc_R_Liv_R        = true;
    UserData.Inc_R_Hy_R         = true;
    UserData.Inc_R_Min_R        = true;
    UserData.Inc_R_Index        = true;
    UserData.Inc_R_TS           = true;
    UserData.Inc_R_Box          = true;
    UserData.Inc_R_Fur          = true;
    UserData.Inc_R_DC           = true;
    UserData.Inc_R_MMM          = true;   
    
    warning off
    %% Create Folders 
    mkdir(fullfile(UserData.PathProject,'FIGURES'))
    mkdir(fullfile(UserData.PathProject,'RESULTS'))
    mkdir(fullfile(UserData.PathProject,'DATA'))
    mkdir(fullfile(UserData.PathProject,'DATA','ExcelFormat'))
    mkdir(fullfile(UserData.PathProject,'DATA','Climate'))
    mkdir(fullfile(UserData.PathProject,'DATA','Climate','Precipitation'))
    mkdir(fullfile(UserData.PathProject,'DATA','Climate','Temperature'))
    mkdir(fullfile(UserData.PathProject,'DATA','Climate','Evapotranspiration'))
    mkdir(fullfile(UserData.PathProject,'DATA','Hydrological'))
    mkdir(fullfile(UserData.PathProject,'DATA','Parameters'))
    mkdir(fullfile(UserData.PathProject,'DATA','Demand'))
    mkdir(fullfile(UserData.PathProject,'DATA','Demand','Mining-Demand'))
    mkdir(fullfile(UserData.PathProject,'DATA','Demand','Livestock-Demand'))
    mkdir(fullfile(UserData.PathProject,'DATA','Demand','Hydrocarbons-Demand'))
    mkdir(fullfile(UserData.PathProject,'DATA','Demand','Domestic-Demand'))
    mkdir(fullfile(UserData.PathProject,'DATA','Demand','Agricultural-Demand'))
    mkdir(fullfile(UserData.PathProject,'DATA','Demand','Underground-Demand'))
    mkdir(fullfile(UserData.PathProject,'DATA','Geographic'))
    mkdir(fullfile(UserData.PathProject,'DATA','Geographic','DEM'))
    mkdir(fullfile(UserData.PathProject,'DATA','Geographic','HUA'))
    mkdir(fullfile(UserData.PathProject,'DATA','Geographic','SU'))
    mkdir(fullfile(UserData.PathProject,'DATA','Geographic','SUD'))
    mkdir(fullfile(UserData.PathProject,'DATA','Geographic','OTHERS'))    
    
    % Format Excel 
    mkdir(fullfile(UserData.PathProject,'DATA','ExcelFormat')) 
    
    PathFormat  = ['copy "',fullfile(DirModel,'Configure.xlsx'),'" "',fullfile(UserData.PathProject,'DATA','ExcelFormat','Format-Climate.xlsx'),'"'];
    PathFormat1 = ['copy "',fullfile(DirModel,'Configure.xlsx'),'" "',fullfile(UserData.PathProject,'DATA','ExcelFormat','Format-Demand.xlsx'),'"'];
    PathFormat2 = ['copy "',fullfile(DirModel,'Configure.xlsx'),'" "',fullfile(UserData.PathProject,'DATA','ExcelFormat','Format-Hydrological.xlsx'),'"'];
    PathFormat3 = ['copy "',fullfile(DirModel,'Configure.xlsx'),'" "',fullfile(UserData.PathProject,'DATA','ExcelFormat','Parameters.xlsx'),'"'];
    PathFormat4 = ['copy "',fullfile(DirModel,'Configure.xlsx'),'" "',fullfile(UserData.PathProject,'DATA','ExcelFormat','Configure.xlsx'),'"'];
    
    system(PathFormat)
    system(PathFormat1)
    system(PathFormat2)
    system(PathFormat3)
    system(PathFormat4)
    
%     copyfile('Format-Climate.xlsx', fullfile(UserData.PathProject,'DATA','ExcelFormat','Format-Climate.xlsx'))
%     copyfile('Format-Demand.xlsx', fullfile(UserData.PathProject,'DATA','ExcelFormat','Format-Demand.xlsx'))
%     copyfile('Format-Hydrological.xlsx', fullfile(UserData.PathProject,'DATA','ExcelFormat','Format-Hydrological.xlsx'))
%     copyfile('Parameters.xlsx', fullfile(UserData.PathProject,'DATA','ExcelFormat','Parameters.xlsx'))
%     copyfile('Configure.xlsx', fullfile(UserData.PathProject,'DATA','ExcelFormat','Configure.xlsx'))
    
    %% Configure
    UserData                = ConfigPath(UserData);
end

%% OPEN PROJECT
% --------------------------------------------------------------------
function FlashOpen_ClickedCallback(hObject, eventdata, handles)

global UserData
[FileName,PathName] = uigetfile('*.mat');
if PathName ~= 0
    Tmp                  = load(fullfile(PathName,FileName));
    UserData             = Tmp.UserData;
    UserData.PathProject = PathName;
    UserData             = ConfigPath(UserData);
end

%% SAVE PROJECT
% --------------------------------------------------------------------
function FlashSave_ClickedCallback(hObject, eventdata, handles)
global UserData
if ~isempty(UserData)
    uisave('UserData',fullfile(UserData.PathProject, UserData.NameProject))
else
    errordlg('There is no record of any project','!! Error !!')
end


%% RUN MODEL
function FlashRunModel_ClickedCallback(hObject, eventdata, handles)
global UserData
if ~isempty(UserData)
    [UserData, StatusRun]   = ListResults(UserData);
    if StatusRun
        UserData    = RunModel(UserData);
        save(fullfile(UserData.PathProject, UserData.NameProject),'UserData')
    end
else
    errordlg('There is no record of any project','!! Error !!')
end

% --------------------------------------------------------------------
function FlashHelp_ClickedCallback(hObject, eventdata, handles)

%% Calibration Model
function Flash_Calibration_ClickedCallback(hObject, eventdata, handles)

global UserData
if ~isempty(UserData)
    
    %% Crate Folder 
    mkdir(fullfile(UserData.PathProject, 'FIGURES','Calibration'))
    mkdir(fullfile(UserData.PathProject, 'FIGURES','Validation'))
    mkdir(fullfile(UserData.PathProject, 'RESULTS','Parameters_Model'))

    %% PARALLEL POOL ON CLUSTER
    if UserData.Parallel == 1
        try
           myCluster                = parcluster('local');
           myCluster.NumWorkers     = UserData.CoresNumber;
           saveProfile(myCluster);
           parpool;
        catch
        end
    end

    %% Date
    Date1       = datetime(['01-',UserData.DateInit,' 00:00:00'],'InputFormat','dd-MM-yyyy HH:mm:ss');
    Date2       = datetime(['01-',UserData.DateEnd,' 00:00:00'],'InputFormat','dd-MM-yyyy HH:mm:ss');
    UserData.Date   = (Date1:calmonths:Date2)'; 
    
    UserData.DateNaN = datetime('01-01-1800 00:00:00','InputFormat','dd-MM-yyyy HH:mm:ss');
    
    %% Calibration Scenario
    Sce = UserData.NumberSceCal;

    %% INPUT DATA
    % -------------------------------------------------------------------------
    % SCE main configuration
    % -------------------------------------------------------------------------
    try
        Tmp = xlsread( fullfile(UserData.PathProject,'DATA','Parameters','Configure.xlsx'), 'Params_SCE');
    catch
        close(ProgressBar)
        errordlg('The Configure.xlsx not found','!! Error !!')
        return
    end

    if sum(isnan(Tmp)) > 0
        close(ProgressBar)
        errordlg('There are erroneous values​in the RangeParams sheet of the Configure.xlsx file','!! Error !!')  
        return
    end

    % parallel version: false or 0, true or otherwise
    if UserData.Parallel == 1
        UserData.parRuns    = 1; %true;
    else
        UserData.parRuns    = 0; %true;
    end
    % Define pop_ini to force initial evaluation of this population. Values
    % must be in real limits, otherwise pop_ini must be empty
    UserData.pop_ini        = [];
    % Maximum number of experiments or evaluations
    UserData.maxIter        = Tmp(1); 
    % ncomp: number of complexes (sub-pop.)- between 2 and 20
    UserData.ncomp          = Tmp(2);
    % ComplexSize: number of members en each complex
    UserData.complexSize    = Tmp(3);
    % simplexSize: number of members en each simplex
    UserData.simplexSize    = Tmp(4);
    % evolutionSteps
    UserData.evolSteps      = Tmp(5);
    % Reflection step lengths in the Simplex method
    UserData.alpha          = Tmp(6);
    % Contraction step lengths in the Simplex method
    UserData.beta           = Tmp(7);
    % verbose mode: false or 0, true or otherwise
    UserData.Verbose        = 0;

    % -------------------------------------------------------------------------
    % Limit Parameters
    % -------------------------------------------------------------------------
    try
        Tmp = xlsread( fullfile(UserData.PathProject,'DATA','Parameters','Configure.xlsx'), 'RangeParams');
    catch
        close(ProgressBar)
        errordlg('The Configure.xlsx not found','!! Error !!')
        return
    end

    if sum(isnan(Tmp),2) > 0
        close(ProgressBar)
        errordlg('There are erroneous values​in the RangeParams sheet of the Configure.xlsx file','!! Error !!')  
        return
    end

    UserData.a_min       = Tmp(1,1);     UserData.a_max       = Tmp(1,2);
    UserData.b_min       = Tmp(2,1);     UserData.b_max       = Tmp(2,2);
    UserData.c_min       = Tmp(3,1);     UserData.c_max       = Tmp(3,2);
    UserData.d_min       = Tmp(4,1);     UserData.d_max       = Tmp(4,2);
    UserData.Q_Umb_min   = Tmp(5,1);     UserData.Q_Umb_max   = Tmp(5,2);
    UserData.V_Umb_min   = Tmp(6,1);     UserData.V_Umb_max   = Tmp(6,2);
    UserData.Trp_min     = Tmp(7,1);     UserData.Trp_max     = Tmp(7,2);
    UserData.Tpr_min     = Tmp(8,1);     UserData.Tpr_max     = Tmp(8,2);
    UserData.ExtSup_min  = Tmp(9,1);     UserData.ExtSup_max  = Tmp(9,2);

    % -------------------------------------------------------------------------
    % Load HUA
    % -------------------------------------------------------------------------
    try
        [~, CodeBasin] = shaperead( fullfile(UserData.PathProject,'DATA','Geographic','HUA',UserData.NameFile_HUA) );

        if isfield(CodeBasin,'Code') 
            CodeBasin = [CodeBasin.Code]';
        else
            close(ProgressBar);
            errordlg('There is no attribute called "Code" in the Shapefile of UAH','!! Error !!')
            return
        end

    catch
        close(ProgressBar);
        errordlg(['The Shapefile "',UserData.NameFile_HUA,'" not found'],'!! Error !!')
        return
    end

    % -------------------------------------------------------------------------
    % Parameter  Model
    % -------------------------------------------------------------------------
    % Load Parameters Model
    try
        Tmp = dlmread( fullfile(UserData.PathProject,'DATA','Parameters','Parameters.csv'), ',',1,0);
    catch
        close(ProgressBar)
        errordlg('The Parameters.csv not found','!! Error !!')    
        return
    end

    % Check Codes 
    [id, ~] = ismember(CodeBasin, Tmp(:,1));
    if sum(id) ~= length(CodeBasin)
        close(ProgressBar)
        errordlg('There is a discrepancy between the codes of the Parameters.csv and the HUA shapefile','!! Error !!')    
        return
    end

    [id, ~] = ismember(Tmp(:,1),CodeBasin);
    if sum(id) ~= length(Tmp(:,1))
        close(ProgressBar)
        errordlg('There is a discrepancy between the codes of the Parameters.csv and the HUA shapefile','!! Error !!')  
        return
    end

    % Sort Codes 
    CodeBasin_Sort  = sort(CodeBasin);
    [~,Poo]         = ismember(CodeBasin_Sort, CodeBasin);
    Tmp             = Tmp(Poo,:);

    UserData.ArcID          = Tmp(:,1);
    UserData.BasinArea      = Tmp(:,2);
    UserData.FloodArea      = Tmp(:,3);
    UserData.TypeBasinCal   = Tmp(:,4);
    UserData.IDAq           = Tmp(:,5);
    UserData.Arc_InitNode   = Tmp(:,6);
    UserData.Arc_EndNode    = Tmp(:,7);
    UserData.Sw             = zeros(length(UserData.ArcID),1) + 100;
    UserData.Sg             = zeros(length(UserData.ArcID),1) + 100;
    UserData.Vh             = zeros(length(UserData.ArcID),1);
    UserData.a              = NaN(length(UserData.ArcID),1);
    UserData.b              = NaN(length(UserData.ArcID),1);
    UserData.c              = NaN(length(UserData.ArcID),1);
    UserData.d              = NaN(length(UserData.ArcID),1);
    UserData.ParamExtSup    = NaN(length(UserData.ArcID),1);
    UserData.Trp            = NaN(length(UserData.ArcID),1);
    UserData.Tpr            = NaN(length(UserData.ArcID),1);
    UserData.Q_Umb          = NaN(length(UserData.ArcID),1);
    UserData.V_Umb          = NaN(length(UserData.ArcID),1);
    UserData.IDExtAgri      = Tmp(:,20);
    UserData.IDExtDom       = Tmp(:,21);
    UserData.IDExtLiv       = Tmp(:,22); 
    UserData.IDExtHy        = Tmp(:,23); 
    UserData.IDExtMin       = Tmp(:,24);
    UserData.IDRetAgri      = Tmp(:,25);
    UserData.IDRetDom       = Tmp(:,26);
    UserData.IDRetLiv       = Tmp(:,27);
    UserData.IDRetHy        = Tmp(:,28);
    UserData.IDRetMin       = Tmp(:,29);

    % -------------------------------------------------------------------------
    % River Downstream
    % -------------------------------------------------------------------------
    try
        Tmp = xlsread( fullfile(UserData.PathProject,'DATA','Parameters','Configure.xlsx'), 'RiverMouth');
    catch
        close(ProgressBar)
        errordlg('The Configure.xlsx not found','!! Error !!')
        return
    end

    if ~isempty(Tmp)
        [id, ~] = ismember(Tmp, UserData.ArcID);
        if sum(id) == length(id)
            UserData.ArcID_Downstream   = Tmp;
        else
            errordlg('There is one or several river mouth codes that are not consistent with the HUAs','!! Error !!')
        end
    else
        close(ProgressBar)
        errordlg('River mouth codes not found','!! Error !!')
        return
    end

    % -------------------------------------------------------------------------
    % Interes Points
    % -------------------------------------------------------------------------
    try
        [Tmp, Tmp1] = xlsread( fullfile(UserData.PathProject,'DATA','Parameters','Configure.xlsx'), 'Interest_Points');  
    catch
        close(ProgressBar)
        errordlg(['The Excel "',UserData.DataParams,'" not found'],'!! Error !!')
        return
    end

    Tmp = Tmp(isnan(Tmp) == 0);
    if ~isempty(Tmp)
        [id, ~] = ismember(Tmp, UserData.ArcID);
        if sum(id) == length(id)
            UserData.Interest_Points_Code = Tmp;
            UserData.Interest_Points_Name = Tmp1(2:length(Tmp)+1);

        else
            close(ProgressBar)
            errordlg('There is one or several interest points codes that are not consistent with the HUAs','!! Error !!')
            return
        end
    else
        UserData.Interest_Points_Code = [];
    end

    % -------------------------------------------------------------------------
    % Calibration Streamflow
    % -------------------------------------------------------------------------
    try
        [Tmp, TmpDate] = xlsread( fullfile(UserData.PathProject,'DATA','Parameters','Configure.xlsx'), 'Calibration_Validation');
    catch
        close(ProgressBar)
        errordlg('The Excel Configure.csv not found','!! Error !!')
        return
    end

    UserData.CodeGauges = Tmp(:,1);
    UserData.ArIDGauges = Tmp(:,2);
    UserData.CatGauges  = Tmp(:,3);

    TmpDate = TmpDate(3:(length(UserData.CodeGauges) + 2),4:7);

    UserData.DateCal_Init = datetime;
    UserData.DateCal_End  = datetime;
    for dt = 1:length(UserData.CodeGauges)
        try
            UserData.DateCal_Init(dt)    = datetime(['01-',TmpDate{dt,1},' 00:00:00'],'InputFormat','dd-MM-yyyy HH:mm:ss');
            UserData.DateCal_End(dt)     = datetime(['01-',TmpDate{dt,2},' 00:00:00'],'InputFormat','dd-MM-yyyy HH:mm:ss');
        catch
            close(ProgressBar)
            errordlg('The date has not been entered in the correct format.','!! Error !!')
            return
        end
    end

    UserData.DateVal_Init = datetime;
    UserData.DateVal_End  = datetime;
    
    for dt = 1:length(UserData.CodeGauges)
        if ~strcmp(TmpDate{dt,3},'NaN')
            try
                UserData.DateVal_Init(dt)    = datetime(['01-',TmpDate{dt,3},' 00:00:00'],'InputFormat','dd-MM-yyyy HH:mm:ss');
                UserData.DateVal_End(dt)     = datetime(['01-',TmpDate{dt,4},' 00:00:00'],'InputFormat','dd-MM-yyyy HH:mm:ss');
            catch
                close(ProgressBar)
                errordlg('The date has not been entered in the correct format.','!! Error !!')
                return
            end
        else
            UserData.DateVal_Init(dt)    = UserData.DateNaN;
            UserData.DateVal_End(dt)     = UserData.DateNaN;
        end
    end

    % -------------------------------------------------------------------------
    % LOAD STRAMFLOW DATA
    % -------------------------------------------------------------------------
    % Load Data
    try
        [Data, DateTmp] = xlsread( fullfile(UserData.PathProject,'DATA','Hydrological',UserData.NameFile_Q),...
            'Calibration');
    catch
        close(ProgressBar)
        errordlg(['The File "',UserData.NameFile_Pcp,'" not found'],'!! Error !!')
        return
    end

    CodeGaugesQ = Data(1,:)';
    Values      = Data(2:end,:);
    DateTmp     = DateTmp(2:length(Values(:,1))+1,1);

    % Check Codes 
    [id, pp] = ismember(UserData.CodeGauges, CodeGaugesQ);
    if sum(id) ~= length(UserData.CodeGauges)
        close(ProgressBar)
        errordlg('There is a discrepancy between the codes of the gauges','!! Error !!')    
        return
    end

    Values = Values(:,pp);

    % Check Date 
    % -------------------
    for w = 1:length(DateTmp)
        DateTmp{w} = ['01-',DateTmp{w},' 00:00:00'];        
    end

    try
        Date = datetime(DateTmp,'InputFormat','dd-MM-yyyy HH:mm:ss');
    catch
        errordlg('The date has not been entered in the correct format.','!! Error !!')
        return
    end

    [id,PosiDate] = ismember(UserData.Date, Date);
    if sum(id) ~= length(UserData.Date)
        errordlg('The dates of the file are not in the defined ranges','!! Error !!')
    end

    tmp = diff(PosiDate);
    if sum(tmp ~= 1)>0
        errordlg('The dates of the file are not organized chronologically','!! Error !!')
    end

    UserData.RawQobs      = Values(PosiDate,:);

    %% Save Data
    NameBasin       = cell(1,length(UserData.ArcID) + 1);
    NameBasin{1}    = 'Date_Matlab';

    ArcID = UserData.ArcID;
    for k = 2:length(UserData.ArcID) + 1
        NameBasin{k} = ['Basin_',num2str(ArcID(k - 1))];
    end

    clearvars ArcID


    %% LOAD CLIMATE DATA
    % -------------------------------------------------------------------------
    % Precipitation 
    % -------------------------------------------------------------------------
    try
        UserData.P = dlmread(fullfile(UserData.PathProject,'RESULTS','P',['Pcp_Scenario-',num2str(Sce),'.csv']),',',1,1);

        Date_test   = datetime(UserData.P(:,1),'ConvertFrom','datenum');
        [id,PosiDate] = ismember(UserData.Date,Date_test);
        if sum(id) ~= length(UserData.Date)
            errordlg('The dates of the file are not in the defined ranges','!! Error !!')
        end

        UserData.P = UserData.P(PosiDate,2:end);
    catch
        errordlg('The Precipitation Data Not Found','!! Error !!')
        close(ProgressBar)
        return
    end

    % -------------------------------------------------------------------------
    % Evapotranspiration
    % -------------------------------------------------------------------------
    try
        UserData.ETP     = dlmread(fullfile(UserData.PathProject,'RESULTS','ETP',['ETP_Scenario-',num2str(Sce),'.csv']),',',1,1);

        Date_test   = datetime(UserData.ETP(:,1),'ConvertFrom','datenum');
        [id,PosiDate] = ismember(UserData.Date,Date_test);
        if sum(id) ~= length(UserData.Date)
            errordlg('The dates of the file are not in the defined ranges','!! Error !!')
        end

        UserData.ETP = UserData.ETP(PosiDate,2:end);
    catch
        errordlg('The Evapotranspiration Data Not Found','!! Error !!')
        close(ProgressBar)
        return
    end

    %% LOAD DEMAND DATA  
    % TOTAL SURFACE DEMAND
    UserData.DemandVar  = {'Agricultural','Domestic','Livestock','Hydrocarbons','Mining'};
    UserData.DemandSup  = zeros(length(UserData.Date), length(UserData.ArcID),length(UserData.DemandVar));
    UserData.Returns    = zeros(length(UserData.Date), length(UserData.ArcID),length(UserData.DemandVar));

    NameDemandVar = {'Agri','Dom','Liv','Hy','Min'};
    NameDm = {'UserData.DemandSup', 'UserData.Returns'};    
    for dr = 1:2
        for VarD = 1:length(UserData.DemandVar)
            if eval(['UserData.Inc_',NameDemandVar{VarD}]) == 1
                DeRe = {'Demand','Return'};
                try
                    Tmp     = dlmread(fullfile(UserData.PathProject,'RESULTS','Demand',UserData.DemandVar{VarD},['Scenario-',num2str(Sce)],['Total_',DeRe{dr},'.csv']),',',1,1);
                    Tmp(isnan(Tmp)) = 0;

                    % Check Date
                    Date_test   = datetime(Tmp(:,1),'ConvertFrom','datenum');
                    [id,~] = ismember(UserData.Date,Date_test);
                    if sum(id) ~= length(UserData.Date)
                        close(ProgressBar)
                        errordlg('The dates of the file are not in the defined ranges','!! Error !!')
                        return
                    end

                    % value Demand
                    eval([NameDm{dr},'(:,:,',num2str(VarD),') = Tmp(PosiDate,2:end);']);
                catch
                    close(ProgressBar)
                    errordlg(['Total_',DeRe{dr},'.csv of ',UserData.DemandVar{VarD},'Demand Not Found'],'!! Error !!')
                    return
                end
            end
        end
    end

    % TOTAL UNDERGROUND DEMANDA
    if UserData.Inc_Sub == 1
         % Load Data
        try
            [Data, DateTmp] = xlsread( fullfile(UserData.PathProject,'DATA','Demand','Underground-Demand',UserData.NameFileDm_Sub ),...
                ['Scenario-',num2str(Sce)]);
        catch
            close(ProgressBar)
            errordlg(['The File "',UserData.NameFileDm_Sub,'" not found'],'!! Error !!')
            return
        end

        CodeSub             = Data(1,:)';
        UserData.DemandSub  = Data(2:end,:);

        % Check Codes 
        [id, ~] = ismember(UserData.ArcID, CodeSub);
        if sum(id) ~= length(UserData.ArcID)
            close(ProgressBar)
            errordlg('There is a discrepancy between the codes of the Parameters.csv and the HUA shapefile','!! Error !!')    
            return
        end

        [id, ~] = ismember(CodeSub,UserData.ArcID);
        if sum(id) ~= length(CodeSub)
            close(ProgressBar)
            errordlg('There is a discrepancy between the codes of the Parameters.csv and the HUA shapefile','!! Error !!')  
            return
        end

        % Check Date 
        % -------------------   
        DateTmp             = DateTmp(2:length(UserData.DemandSub(:,1))+1,1);
        for w = 1:length(DateTmp)
            DateTmp{w} = ['01-',DateTmp{w},' 00:00:00'];        
        end

        try
            Date = datetime(DateTmp,'InputFormat','dd-MM-yyyy HH:mm:ss');
        catch
            close(ProgressBar)
            errordlg('The date has not been entered in the correct format.','!! Error !!')
            return
        end

        [id,PosiDate] = ismember(UserData.Date, Date);
        if sum(id) ~= length(UserData.Date)
            errordlg('The dates of the file are not in the defined ranges','!! Error !!')
        end

        tmp = diff(PosiDate);
        if sum(tmp ~= 1)>0
            errordlg('The dates of the file are not organized chronologically','!! Error !!')
        end
        UserData.DemandSub  = UserData.DemandSub(PosiDate,:);
    else
        UserData.DemandSub  = zeros(length(UserData.Date), length(UserData.ArcID));
    end

    % Total 
    UserData.DemandSub = bsxfun(@times, sum( UserData.DemandSup, 3) , (1 - UserData.ParamExtSup')) + UserData.DemandSub;
    
    %% Run function Calibration
    UserData = Calibration_Validation(UserData);
    
    save(fullfile(UserData.PathProject, UserData.NameProject),'UserData')    
else
    errordlg('There is no record of any project','!! Error !!')
end


%% MENU PROCESSING
function MenuProcessing_Callback(hObject, eventdata, handles)
function MenuProClimate_Callback(hObject, eventdata, handles)
function MenuProDemand_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function MenuProDemandAll_Callback(hObject, eventdata, handles)
global UserData
if ~isempty(UserData)
    UserData.DemandVar = {'Agricultural','Domestic','Livestock','Hydrocarbons','Mining'};
    Demand(UserData)
    save(fullfile(UserData.PathProject, UserData.NameProject),'UserData')
else
    errordlg('There is no record of any project','!! Error !!')
end


% --------------------------------------------------------------------
function MenuPro_Agri_Callback(hObject, eventdata, handles)
global UserData
if ~isempty(UserData)
    UserData.DemandVar = {'Agricultural'};
    Demand(UserData)
    UserData.DemandVar = {'Agricultural','Domestic','Livestock','Hydrocarbons','Mining'};
    save(fullfile(UserData.PathProject, UserData.NameProject),'UserData')
else
    errordlg('There is no record of any project','!! Error !!')
end


% --------------------------------------------------------------------
function MenuPro_Dom_Callback(hObject, eventdata, handles)
global UserData
if ~isempty(UserData)
    UserData.DemandVar = {'Domestic'};
    Demand(UserData)
    UserData.DemandVar = {'Agricultural','Domestic','Livestock','Hydrocarbons','Mining'};
    save(fullfile(UserData.PathProject, UserData.NameProject),'UserData')
else
    errordlg('There is no record of any project','!! Error !!')
end


% --------------------------------------------------------------------
function MenuPro_Liv_Callback(hObject, eventdata, handles)
global UserData
if ~isempty(UserData)
    UserData.DemandVar = {'Livestock'};
    Demand(UserData)
    UserData.DemandVar = {'Agricultural','Domestic','Livestock','Hydrocarbons','Mining'};
    save(fullfile(UserData.PathProject, UserData.NameProject),'UserData')
else
    errordlg('There is no record of any project','!! Error !!')
end


% --------------------------------------------------------------------
function MenuPro_Hy_Callback(hObject, eventdata, handles)
global UserData
if ~isempty(UserData)
    UserData.DemandVar = {'Hydrocarbons'};
    Demand(UserData)
    UserData.DemandVar = {'Agricultural','Domestic','Livestock','Hydrocarbons','Mining'};
    save(fullfile(UserData.PathProject, UserData.NameProject),'UserData')
else
    errordlg('There is no record of any project','!! Error !!')
end


% --------------------------------------------------------------------
function MenuPro_Min_Callback(hObject, eventdata, handles)
global UserData
if ~isempty(UserData)
    UserData.DemandVar = {'Mining'};
    Demand(UserData)
    UserData.DemandVar = {'Agricultural','Domestic','Livestock','Hydrocarbons','Mining'};
    save(fullfile(UserData.PathProject, UserData.NameProject),'UserData')
else
    errordlg('There is no record of any project','!! Error !!')
end


% --------------------------------------------------------------------
function MenuProClimateAll_Callback(hObject, eventdata, handles)

global UserData

if ~isempty(UserData)
    % Precipitation
    if UserData.TypeFile_Pcp == 1
        Climate_Precipitation_Points(UserData)
    elseif UserData.TypeFile_Pcp == 2
        Climate_Precipitation_Time(UserData)
    end

    % Evapotranspiration
    if UserData.Cal_ETP == 1
        % False
        UserData.Mode = 3;
    else
        % True
        UserData.Mode = 2;
    end

    if eval(['UserData.TypeFile_',UserData.ClimateVar{UserData.Mode}]) == 1
        Climate_Evapotranspitation_Points(UserData)
    elseif eval(['UserData.TypeFile_',UserData.ClimateVar{UserData.Mode}]) == 2
        Climate_Evapotranspitation_Time(UserData)
    end

else
    errordlg('There is no record of any project','!! Error !!')
end


% --------------------------------------------------------------------
function MenuPro_P_Callback(hObject, eventdata, handles)
global UserData
if ~isempty(UserData)
    if UserData.TypeFile_Pcp == 1
        Climate_Precipitation_Points(UserData)
    elseif UserData.TypeFile_Pcp == 2
        Climate_Precipitation_Time(UserData)
    end
else
    errordlg('There is no record of any project','!! Error !!')
end



% --------------------------------------------------------------------
function MenuPro_T_ETP_Callback(hObject, eventdata, handles)
global UserData
if ~isempty(UserData)
    % Evapotranspiration
    if UserData.Cal_ETP == 1
        % False
        UserData.Mode = 3;
    else
        % True
        UserData.Mode = 2;
    end

    if eval(['UserData.TypeFile_',UserData.ClimateVar{UserData.Mode}]) == 1
        Climate_Evapotranspitation_Points(UserData)
    elseif eval(['UserData.TypeFile_',UserData.ClimateVar{UserData.Mode}]) == 2
        Climate_Evapotranspitation_Time(UserData)
    end

else
    errordlg('There is no record of any project','!! Error !!')
end



%% MENU EDIT 
% --------------------------------------------------------------------
function FlashEdit_ClickedCallback(hObject, eventdata, handles)

global UserData

if ~isempty(UserData)
    UserData = ConfigPath(UserData);
    save(fullfile(UserData.PathProject, UserData.NameProject),'UserData')
else
    errordlg('There is no record of any project','!! Error !!')
end

% --------------------------------------------------------------------
function FlashPlot_ClickedCallback(hObject, eventdata, handles)

global UserData

if ~isempty(UserData)
    UserData    = ListResults(UserData);
    save(fullfile(UserData.PathProject, UserData.NameProject),'UserData')
else
    errordlg('There is no record of any project','!! Error !!')
end
