function UserData = RunModel(UserData)
% -------------------------------------------------------------------------
% Matlab Version - R2018b 
% -------------------------------------------------------------------------
%                              BASE DATA 
% -------------------------------------------------------------------------
% The Nature Conservancy - TNC
% 
% Project     : Landscape planning for agro-industrial expansion in a large, 
%               well-preserved savanna: how to plan multifunctional 
%               landscapes at scale for nature and people in the Orinoquia 
%               region, Colombia
% 
% Team        : Tomas Walschburger 
%               Science Sr Advisor NASCA
%               twalschburger@tnc.org
% 
%               Carlos Andrés Rogéliz 
%               Specialist in Integrated Analysis of Water Systems NASCA
%               carlos.rogeliz@tnc.org
%               
%               Jonathan Nogales Pimentel
%               Hydrology Specialist
%               jonathan.nogales@tnc.org
% 
% Author      : Jonathan Nogales Pimentel
% Email       : jonathannogales02@gmail.com
% Date        : November, 2017
% 
% -------------------------------------------------------------------------
% This program is free software: you can redistribute it and/or modify it 
% under the terms of the GNU General Public License as published by the 
% Free Software Foundation, either version 3 of the License, or option) any 
% later version. This program is distributed in the hope that it will be 
% useful, but WITHOUT ANY WARRANTY; without even the implied warranty of 
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
% ee the GNU General Public License for more details. You should have 
% received a copy of the GNU General Public License along with this program
% If not, see http://www.gnu.org/licenses/.
%
% -------------------------------------------------------------------------
% INPUT DATA
% -------------------------------------------------------------------------
% UserData [Struct]
%   .ArcID               [Cat,1]         = ID of each section of the network                     [Ad]
%   .Arc_InitNode        [Cat,1]         = Initial node of each section of the network           [Ad]
%   .Arc_EndNode         [Cat,1]         = End node of each section of the network               [Ad]
%   .ArcID_Downstream    [1,1]           = ID of the end node of accumulation                    [Ad]
%   .AccumVar            [Cat,Var]       = Variable to accumulate                                
%   .AccumStatus         [Cat,Var]       = Status of the accumulation variable == AccumVar       
%   .ArcIDFlood          [CatFlood,1]    = ID of the section of the network with floodplain      [Ad]
%   .FloodArea           [CatFlood,1]    = Floodplain Area                                       [m^2]
%   .IDExtAgri           [Cat,1]         = ID of the HUA where to extraction Agricultural Demand [Ad]
%   .IDExtDom            [Cat,1]         = ID of the HUA where to extraction Domestic Demand     [Ad]
%   .IDExtLiv            [Cat,1]         = ID of the HUA where to extraction Livestock Demand    [Ad]
%   .IDExtMin            [Cat,1]         = ID of the HUA where to extraction Mining Demand       [Ad]
%   .IDExtHy             [Cat,1]         = ID of the HUA where to extraction Hydrocarbons Demand [Ad]
%   .IDRetDom            [Cat,1]         = ID of the HUA where to return Domestic Demand         [Ad]
%   .IDRetLiv            [Cat,1]         = ID of the HUA where to return Livestock Demand        [Ad]
%   .IDRetMin            [Cat,1]         = ID of the HUA where to return Mining Demand           [Ad]
%   .IDRetHy             [Cat,1]         = ID of the HUA where to return Hydrocarbons Demand     [Ad]
%   .P                   [Cat,1]         = Precipitation                                         [mm]
%   .ETP                 [Cat,1]         = Actual Evapotrasnpiration                             [mm]
%   .Vh                  [CatFlood,1]    = Volume of the floodplain Initial                      [mm]
%   .Ql                  [CatFlood,1]    = Lateral flow between river and floodplain             [mm]
%   .Rl                  [CatFlood,1]    = Return flow from floodplain to river                  [mm]
%   .Trp                 [CatFlood,1]    = Percentage lateral flow between river and floodplain  [dimensionless]
%   .Tpr                 [CatFlood,1]    = Percentage return flow from floodplain to river       [dimensionless]
%   .Q_Umb               [CatFlood,1]    = Threshold lateral flow between river and floodplain   [mm]
%   .V_Umb               [CatFlood,1]    = Threshold return flow from floodplain to river        [mm]
%   .a                   [Cat,1]         = Soil Retention Capacity                               [dimensionless]
%   .b                   [Cat,1]         = Maximum Capacity of Soil Storage                      [dimensionless]
%   .Y                   [Cat,1]         = Evapotranspiration Potential                          [mm]
%   .PoPo                [Cat,1]         = ID of the HUA to calibrate                            [Ad]
%   .PoPoFlood           [Cat,1]         = ID of the HUA to calibrate with floodplains           [Ad]
%   .ArcID_Downstream2   [1,1]           = ID of the end node of accumulation                    [Ad]

%% INPUT DATA

ProgressBar     = waitbar(0, 'Processing...');
wbch            = allchild(ProgressBar);
jp              = wbch(1).JavaPeer;
jp.setIndeterminate(1)

%% INPUT DATA
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

if sum(isnan(Tmp),2) > 0
    close(ProgressBar)
    errordlg('There are erroneous valuesâ€‹in the parameters.csv file','!! Error !!')  
    return
end
        
UserData.ArcID          = Tmp(:,1);
UserData.BasinArea      = Tmp(:,2);
UserData.FloodArea      = Tmp(:,3);
UserData.TypeBasinCal   = Tmp(:,4);
UserData.IDAq           = Tmp(:,5);
UserData.Arc_InitNode   = Tmp(:,6);
UserData.Arc_EndNode    = Tmp(:,7);
UserData.Sw             = Tmp(:,8);
UserData.Sg             = Tmp(:,9);
UserData.Vh             = Tmp(:,10);
UserData.a              = Tmp(:,11);
UserData.b              = Tmp(:,12);
UserData.c              = Tmp(:,13);
UserData.d              = Tmp(:,14);
UserData.ParamExtSup    = Tmp(:,15);
UserData.Trp            = Tmp(:,16);
UserData.Tpr            = Tmp(:,17);
UserData.Q_Umb          = Tmp(:,18);
UserData.V_Umb          = Tmp(:,19);
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

%% Date
Date1           = datetime(['01-',UserData.DateInit,' 00:00:00'],'InputFormat','dd-MM-yyyy HH:mm:ss');
Date2           = datetime(['01-',UserData.DateEnd,' 00:00:00'],'InputFormat','dd-MM-yyyy HH:mm:ss');
UserData.Date   = (Date1:calmonths:Date2)';
                
%% SCENARIOS
Tmp         = cell2mat(UserData.Scenarios(:,2));
Tmp1        = cell2mat(UserData.Scenarios(:,3));
Scenario    = Tmp(Tmp1==1);

%% Save Data
NameBasin       = cell(1,length(UserData.ArcID) + 1);
NameBasin{1}    = 'Date_Matlab';

for k = 2:length(UserData.ArcID) + 1
    NameBasin{k} = ['Basin_',num2str(UserData.ArcID(k - 1))];
end

for Sce = 1:length(Scenario)
    
    %% LOAD CLIMATE DATA
    % -------------------------------------------------------------------------
    % Precipitation 
    % -------------------------------------------------------------------------
    try
        UserData.P = dlmread(fullfile(UserData.PathProject,'RESULTS','P',['Pcp_Scenario-',num2str(Scenario(Sce)),'.csv']),',',1,1);
        
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
        UserData.ETP     = dlmread(fullfile(UserData.PathProject,'RESULTS','ETP',['ETP_Scenario-',num2str(Scenario(Sce)),'.csv']),',',1,1);
        
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
        for i = 1:length(UserData.DemandVar)
            if eval(['UserData.Inc_',NameDemandVar{i}]) == 1
                DeRe = {'Demand','Return'};
                try
                    Tmp     = dlmread(fullfile(UserData.PathProject,'RESULTS','Demand',UserData.DemandVar{i},['Scenario-',num2str(Scenario(Sce))],['Total_',DeRe{dr},'.csv']),',',1,1);
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
                    eval([NameDm{dr},'(:,:,',num2str(i),') = Tmp(PosiDate,2:end);']);
                catch
                    close(ProgressBar)
                    errordlg(['Total_',DeRe{dr},'.csv of ',UserData.DemandVar{i},'Demand Not Found'],'!! Error !!')
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
                ['Scenario-',num2str(Scenario(Sce))]);
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
        if sum(id) ~= length(DateModel)
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
        
    %% RUN MODEL
    [UserData.VAc,...
     UserData.Esc,...
     UserData.ETR,...
     UserData.StatesMT,...
     UserData.StatesMF] = HMO(  UserData.Date,...
                                UserData.P,...
                                UserData.ETP,...
                                UserData.DemandSup,...
                                UserData.DemandSub,...
                                UserData.Returns,...
                                UserData.BasinArea,...
                                UserData.FloodArea,... 
                                UserData.ArcID,...
                                UserData.Arc_InitNode,...
                                UserData.Arc_EndNode,...
                                UserData.ArcID_Downstream,...
                                UserData.a,...
                                UserData.b,...
                                UserData.c,...
                                UserData.d,...
                                UserData.Tpr,...
                                UserData.Trp,...
                                UserData.Q_Umb,...
                                UserData.V_Umb,...
                                UserData.IDExtAgri,...
                                UserData.IDExtDom,...
                                UserData.IDExtLiv,... 
                                UserData.IDExtHy,... 
                                UserData.IDExtMin,...
                                UserData.IDRetAgri,...
                                UserData.IDRetDom,...
                                UserData.IDRetLiv,...
                                UserData.IDRetHy,...
                                UserData.IDRetMin,...
                                UserData.ParamExtSup,...
                                UserData.Sw,...
                                UserData.Sg,...
                                UserData.Vh,...
                                UserData.IDAq);

    % Save Data 
    save(fullfile(UserData.PathProject, UserData.NameProject),'UserData')
                                            
    %% Results
    if UserData.NumberSceCal == Scenario(Sce)
        Qref = reshape(UserData.VAc(:,1,:),length(UserData.ArcID), length(UserData.Date))';
    end
    
    if UserData.NumberSceCal == Scenario(Sce)
        VariablesResults(Scenario(Sce), UserData, Qref)
    else
        VariablesResults(Scenario(Sce), UserData)
    end
    
end
close(ProgressBar)


%% Operation Completed
[Icon,~] = imread('Completed.jpg'); 
msgbox('Operation Completed','Success','custom',Icon);
