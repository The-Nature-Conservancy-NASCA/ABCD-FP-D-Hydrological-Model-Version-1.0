function Climate_Evapotranspitation_Points(UserData)
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
%               Carlos Andr�s Rog�liz 
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
% -------------------------------------------------------------------------


%% Folder Resulst
warning off
mkdir(fullfile(UserData.PathProject,'RESULTS','ETP'))

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

%% Load ShapeFile HUA
try
    [Basin, CodeBasin]      = shaperead(fullfile(UserData.PathProject,'DATA','Geographic','HUA',UserData.NameFile_HUA));
    XBasin                  = {Basin.X}';
    YBasin                  = {Basin.Y}';
    BoundingBox             = {Basin.BoundingBox}';
    
    clearvars Basin
    
    if isfield(CodeBasin,'Code') 
        CodeBasin_Tmp = [CodeBasin.Code];
    else
        errordlg(['There is no attribute called "Code" in the Shapefile "',UserData.NameFile_HUA,'"'], '!! Error !!')
        return
    end

    [CodeBasin,PosiBasin]   = sort(CodeBasin_Tmp);
    CodeBasin               = CodeBasin';
    XBasin                  = XBasin(PosiBasin');
    YBasin                  = YBasin(PosiBasin');
    BoundingBox             = BoundingBox(PosiBasin');
    
    clearvars CodeBasin_Tmp
catch
    errordlg(['The Shapefile "',UserData.NameFile_HUA,'" not found'],'!! Error !!')
    return
end

%% Data Type - Points
% Progres Process
% --------------
ProgressBar     = waitbar(0, ['Processing ',UserData.ClimateVar{UserData.Mode},' Please wait...']);

% Sheet in Excel 
Cont = 1;

% Scenarios by Demand
Tmp         = cell2mat(UserData.Scenarios(:,2));
Tmp1        = cell2mat(UserData.Scenarios(:,3));
Scenarios   = Tmp(Tmp1==1);

Mode = UserData.Mode;

ClimateVar = {'','Temperature','Evapotranspiration'};

for i = 1:length(Scenarios)
    % Load Data
    try
        [Data, DateTmp] = xlsread( fullfile(UserData.PathProject,'DATA','Climate',ClimateVar{UserData.Mode}, ...
            eval(['UserData.NameFile_',UserData.ClimateVar{UserData.Mode}])), ['Scenario-',num2str(Scenarios(i))]);
    catch
        close(ProgressBar)
        errordlg(['The File "',eval(['UserData.NameFile_',UserData.ClimateVar{UserData.Mode}]),'" not found'],'!! Error !!')
        return
    end

    % Load Data
    try
        Tmp     = xlsread( fullfile(UserData.PathProject,'DATA','Parameters','Configure.xlsx'), 'Gauges_Catalog');
        Catalog = Tmp(:,[1 4 5 6 ]); 
    catch
        close(ProgressBar)
        errordlg(['The File "Configure.xlsx" not found'],'!! Error !!')
        return
    end

    CodeGauges  = Data(1,:)';
    Data        = Data(2:end,:);
    DateTmp     = DateTmp(2:length(Data(:,1))+1,1);
    [~, posi]   = ismember(CodeGauges, Catalog(:,1));
    
    % elevation gauges
    ZCatalog    = Catalog(posi,4);

    % Check Date 
    % -------------------
    Date1       = datetime(['01-',UserData.DateInit,' 00:00:00'],'InputFormat','dd-MM-yyyy HH:mm:ss');
    Date2       = datetime(['01-',UserData.DateEnd,' 00:00:00'],'InputFormat','dd-MM-yyyy HH:mm:ss');
    DateModel   = (Date1:calmonths:Date2)'; 
    
    Date = datetime;
    for w = 1:length(DateTmp)
        DateTmp{w} = ['01-',DateTmp{w},' 00:00:00'];        
    end
    
    try
        Date = datetime(DateTmp,'InputFormat','dd-MM-yyyy HH:mm:ss');
    catch
        errordlg('The date has not been entered in the correct format.','!! Error !!')
        return
    end
    
    [id,PosiDate] = ismember(DateModel, Date);
    if sum(id) ~= length(DateModel)
        errordlg('The dates of the file are not in the defined ranges','!! Error !!')
    end
    
    tmp = diff(PosiDate);
    if sum(tmp ~= 1)>0
        errordlg('The dates of the file are not organized chronologically','!! Error !!')
    end
    
    Date        = datenum(DateModel);
    Data        = Data(PosiDate,:);
    Values      = NaN(length(Data(:,1)),length(CodeBasin));
    Value_T     = NaN(length(Data(:,1)),length(CodeBasin));
    
    %% EVAPOTRANSPIRATION 
    % Load Raster DEM
    try
        [Z,~,~,ExtentRaster]      = geotiffread( fullfile(UserData.PathProject,'DATA','Geographic','DEM',UserData.NameFile_DEM) );
    catch
        close(ProgressBar)
        errordlg(['The Raster "',UserData.NameFile_DEM ,'" not found'],'!! Error !!')
        return
    end
    Z(Z<0) = NaN;
    [RowDEM, ColDEM] = size(Z);
    XDEM            = linspace(ExtentRaster(1,1), ExtentRaster(2,1),ColDEM);
    YDEM            = linspace(ExtentRaster(2,2), ExtentRaster(1,2),RowDEM);
    [XDEM, YDEM]    = meshgrid(XDEM, YDEM);

    Zetp = cell(length(CodeBasin),1);

    if UserData.Parallel == 1
        parfor k = 1:length(CodeBasin) 
            ExtentBasin = BoundingBox{k};
            x           = linspace(ExtentBasin(1,1), ExtentBasin(2,1),10);
            y           = linspace(ExtentBasin(2,2), ExtentBasin(1,2),10);
            [x, y]      = meshgrid(x, y);
            x           = reshape(x,[],1);
            y           = reshape(y,[],1);
            id          = inpolygon(x, y, XBasin{k}, YBasin{k});

            Zetp{k}     = interp2(XDEM, YDEM, Z, x(id), y(id), 'nearest');
        end

        for w = 1:length(Data(:,1))
            % Setting Parameters Temperature
            ParamT = TemperatureSetting(ZCatalog, Data(w,:)');
            
            parfor k = 1:length(CodeBasin)    
                if Mode == 2
                    % Temperature to Evapotranspiration
                    Value_T(w,k)    = mean(polyval(ParamT,double(Zetp{k})), 'omitnan');
                    Values(w,k)     = ETP_Thornthwaite(Value_T(w,k));
                else
                    Values(w,k)     = mean(polyval(ParamT,double(Zetp{k})),'omitnan');
                end

            end
            % Progres Process
            % --------------
            waitbar(Cont / ((length(Data(:,1)) * length(Scenarios))))
            Cont = Cont + 1;
        end

    else

        for k = 1:length(CodeBasin) 
            ExtentBasin = BoundingBox{k};
            x           = linspace(ExtentBasin(1,1), ExtentBasin(2,1),10);
            y           = linspace(ExtentBasin(2,2), ExtentBasin(1,2),10);
            [x, y]      = meshgrid(x, y);
            x           = reshape(x,[],1);
            y           = reshape(y,[],1);
            id          = inpolygon(x, y, XBasin{k}, YBasin{k});

            Zetp{k}     = interp2(XDEM, YDEM, Z, x(id), y(id), 'nearest');
        end

        for w = 1:length(Data(:,1))
            % Setting Parameters Temperature
            ParamT = TemperatureSetting(ZCatalog, Data(w,:)');

            for k = 1:length(CodeBasin)    
                if Mode == 2
                    % Temperature to Evapotranspiration
                    Value_T(w,k)    = mean(polyval(ParamT,double(Zetp{k})), 'omitnan');
                    Values(w,k)     = ETP_Thornthwaite(Value_T(w,k));
                else
                    Values(w,k)     = mean(polyval(ParamT,double(Zetp{k})),'omitnan');

                end

            end
            % Progres Process
            % --------------
            waitbar(Cont / ((length(Data(:,1)) * length(Scenarios))))
            Cont = Cont + 1;
        end
    end

    %% Save Data Table
    NameBasin       = cell(1,length(CodeBasin) + 1);
    NameBasin{1}    = 'Date_Matlab';
    for k = 2:length(CodeBasin) + 1
        NameBasin{k} = ['Basin_',num2str(CodeBasin(k - 1))];
    end

    NameDate    = cell(1,length(Date));
    for k = 1:length(Date)
        NameDate{k} = datestr(Date(k),'dd-mm-yyyy');
    end

    Results = [Date Values];
    Results = array2table(Results,'VariableNames',NameBasin,'RowNames',NameDate);
    writetable(Results, fullfile(UserData.PathProject,'RESULTS','ETP',['ETP_Scenario-',num2str(i),'.csv']), 'WriteRowNames',true)
    
    if strcmp(ClimateVar{UserData.Mode},'Temperature')        
        Results = [Date Value_T];
        Results = array2table(Results,'VariableNames',NameBasin,'RowNames',NameDate);
        
        mkdir(fullfile(UserData.PathProject,'RESULTS','T'))
        
        writetable(Results, fullfile(UserData.PathProject,'RESULTS','T',['T_Scenario-',num2str(i),'.csv']), 'WriteRowNames',true)        
    end

end

% Progres Process
% --------------
close(ProgressBar);
% --------------

%% Operation Completed
[Icon,~] = imread('Completed.jpg'); 
msgbox('Operation Completed','Success','custom',Icon);