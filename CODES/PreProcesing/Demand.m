function Demand(UserData)
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

clc

warning off

% Progres Process
% --------------
ProgressBar = waitbar(0, 'Processing Demand Data...');
wbch        = allchild(ProgressBar);
jp          = wbch(1).JavaPeer;
jp.setIndeterminate(1)
        
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

% Create Demand Folder
mkdir( fullfile(UserData.PathProject,'RESULTS','Demand') )

% Scenarios by Demand
Tmp         = cell2mat(UserData.Scenarios(:,2));
Tmp1        = cell2mat(UserData.Scenarios(:,3));
Scenarios   = Tmp(Tmp1==1);
            
NameDemandVar = {'Agri','Dom','Liv','Hy','Min'};

% Demand Type
for i = 1:length(UserData.DemandVar)
    
    % True or False - Include Demand
    if eval(['UserData.Inc_',NameDemandVar{i}]) == 1
        
        % Number Excel File by Demand - i
        for Nexc = 1:length(eval(['UserData.NamesFileDm_',NameDemandVar{i},'(:,2)']))
                        
            for NSce = 1:length(Scenarios)
                
                % Creation of folder of the type of demand.
                mkdir(fullfile(UserData.PathProject,'RESULTS','Demand', UserData.DemandVar{i}, ['Scenario-',num2str(Scenarios(NSce))],'Demand'))

                % Returns
                mkdir(fullfile(UserData.PathProject,'RESULTS','Demand', UserData.DemandVar{i}, ['Scenario-',num2str(Scenarios(NSce))],'Return'))
                
                if strcmp(UserData.DemandVar{i},'Agricultural')
                    % Creation of folder of the type of demand.
                    mkdir(fullfile(UserData.PathProject,'RESULTS','Demand', UserData.DemandVar{i}, ['Scenario-',num2str(Scenarios(NSce))],'Balance'))

                    % Returns
                    mkdir(fullfile(UserData.PathProject,'RESULTS','Demand', UserData.DemandVar{i}, ['Scenario-',num2str(Scenarios(NSce))],'Kc'))
                    
                    % Returns
                    mkdir(fullfile(UserData.PathProject,'RESULTS','Demand', UserData.DemandVar{i}, ['Scenario-',num2str(Scenarios(NSce))],'Area'))
                end
                
                disp(eval(['UserData.NamesFileDm_',NameDemandVar{i},'{Nexc,1}']))
                
                % Value [2] or Module [3] Processing
                try
                    % load Excel File
                    [TmpN, TmpS] = xlsread( fullfile(UserData.PathProject,'DATA','Demand', [UserData.DemandVar{i},'-Demand'],...
                                    [eval(['UserData.NamesFileDm_',NameDemandVar{i},'{Nexc,1}']), '.xlsx' ]),...
                                    ['Scenario-',num2str(Scenarios(NSce))],'','basic');
                catch
                    close(ProgressBar);
                    errordlg(['The File "',eval(['UserData.NamesFileDm_',NameDemandVar{i},'{Nexc,1}']),'" not found'],'!! Error !!')
                    return
                end
                
                
                %% Load Data of Excel File - Value
                DemandData.EstDemand    = TmpS{5,5};
                
                % Spatial Analysis Mode
                DemandData.TypeInfo     = TmpS{6,5};
                
                if strcmp(UserData.DemandVar{i},'Agricultural')
                    % Type Crop
                    DemandData.TypeCrop     = TmpS{7,5};
                    % Phenological Time
                    DemandData.TimeCrop     = TmpN(3,5);
                end
                
                % Porcentage Returns
                DemandData.PorReturns   = TmpN(4,5);                

                % Losses Domestic
                DemandData.Loss         = TmpN(5,5);
                
                % Shapefile of Spatial Unit 
                DemandData.ShpSU        = fullfile(UserData.PathProject,'DATA','Geographic','SU',TmpS{11,5},[TmpS{11,5},'.shp']);
                
                % Raster of Spatial Unit
                DemandData.RasterSU     = fullfile(UserData.PathProject,'DATA','Geographic','SUD',TmpS{11,5},[TmpS{11,5},'.tif']);
                
                % Code Spatial Unit
                DemandData.CodeSU       = TmpN(8:end,1);
                DemandData.CodeSU       = DemandData.CodeSU(isnan(DemandData.CodeSU(:,1)) == 0);
                
                % Data type 
                DataType     = TmpS(13:end,3);
                DataType     = DataType(1:length(DemandData.CodeSU));
                
                % Date
                Date1       = datetime(['01-',UserData.DateInit,' 00:00:00'],'InputFormat','dd-MM-yyyy HH:mm:ss');
                Date2       = datetime(['01-',UserData.DateEnd,' 00:00:00'],'InputFormat','dd-MM-yyyy HH:mm:ss');
                DemandData.Date   = (Date1:calmonths:Date2)';
                
                CheckByDate = 0;
                % Check Type Analysis with Date 
                for j = 1:length(DemandData.CodeSU)
                    if strcmp(DataType(j),'Temporal Serie')
                        CheckByDate = 1;
                        break
                    end
                end
                
                CheckTypeInfo = 0;
                if ~strcmp(DemandData.TypeInfo, 'Average' )
                    CheckTypeInfo = 1;
                end
            
                if (CheckByDate == 1) || (CheckTypeInfo == 1)
                    
                    % Check Date 
                    Juepuchica = TmpS(12,18:end);
                    
                    DateTmp = {};
                    CoJu    = 1;
                    for re = 1:length(Juepuchica)
                        if length(Juepuchica{re}) == 7
                            DateTmp{CoJu} = Juepuchica{re};
                            CoJu = CoJu + 1;
                        else
                            break
                        end
                    end
                    
                    DateTmp = DateTmp';
                    % Check Date
                    for w = 1:length(DateTmp)
                        DateTmp{w} = ['01-',DateTmp{w},' 00:00:00'];        
                    end

                    try
                        Date_tmp = datetime(DateTmp,'InputFormat','dd-MM-yyyy HH:mm:ss');
                    catch
                        errordlg('The date has not been entered in the correct format.','!! Error !!')
                        return
                    end

                    [id,PosiDate] = ismember(DemandData.Date,Date_tmp);
                    if sum(id) ~= length(DemandData.Date)
                        errordlg('The dates of the file are not in the defined ranges','!! Error !!')
                    end

                    tmp = diff(PosiDate);
                    if sum(tmp ~= 1)>0
                        errordlg('The dates of the file are not organized chronologically','!! Error !!')
                    end                    
                
                end                                    
                
                if strcmp(DemandData.TypeInfo, 'Average' )
                    
                    % Calculation Distribution Data
                    DemandData.DistCal      = TmpS{5,18};
                    
                    % Code Distribution
                    DemandData.DistCode     = TmpN(1,18);
                    
                    % Name Folder Spatial Unit Distribution
                    DemandData.RasterSUD    = TmpS{7,18};
                    
                else

                    % Code Distribution 
                    DemandData.DistCode     = TmpN(5,18:end);
                    DemandData.DistCode     = DemandData.DistCode(isnan(DemandData.DistCode) == 0);
                    
                    % Calculation Distribution Data
                    DemandData.DistCal      = TmpS(9,18:end);
                    DemandData.DistCal      = DemandData.DistCal(1:length(DemandData.DistCode));
                    
                    % Name Folder Spatial Unit Distribution
                    DemandData.RasterSUD    = TmpS(11,18:end);
                    DemandData.RasterSUD    = DemandData.RasterSUD(1:length(DemandData.DistCode));
                    
                    % update values in limit date Analysis
                    DemandData.DistCode     = DemandData.DistCode(PosiDate) ;
                    DemandData.DistCal      = DemandData.DistCal(PosiDate);
                    DemandData.RasterSUD    = DemandData.RasterSUD(PosiDate);
                    
                end
                                                
                % Module 
                DataMTmp     = TmpN(8:end,4);
                DataMTmp     = DataMTmp(1:length(DemandData.CodeSU));
                
                % Serie Data
                DataTmp      = TmpN(8:end,5:end);
                DataTmp      = DataTmp(1:length(DemandData.CodeSU),:);
                
                DataM   = zeros(length(DataType),length(DemandData.Date));
                DataV   = zeros(length(DataType),length(DemandData.Date));
                nm      = length(DemandData.Date);
                nn      = month(DemandData.Date(1)); 
                
                for j = 1:length(DemandData.CodeSU)
                    if strcmp(DataType(j),'Annual Multi-Year Average')
                        % Data Annual Multi-Year Average
                        DataV(j,:) = DataTmp(j,1)./12;
                        DataM(j,:) = DataMTmp(j,1);
                        
                    elseif strcmp(DataType(j),'Multi-Year Monthly Average')
                        % Data Multi-Year Monthly Average
                        Tmp         = repmat(DataTmp(j,2:13),1,length(unique(year(DemandData.Date))));
                        DataV(j,:)  = Tmp(:,nn:(nm + nn - 1));
                        DataM(j,:)  = DataMTmp(j,1);

                    elseif strcmp(DataType(j),'Temporal Serie')
                        % Data Temporal Serie
                        DateChanf  = DataTmp(j,14:end);
                        DataV(j,:) = DateChanf(PosiDate);
                        DataM(j,:) = DataMTmp(j,1);
                    end
                end
                
                DataM(isnan(DataV)) = 0;
                DataV(isnan(DataV)) = 0;
                
                clearvars TmpN TmpS
                
                %% Load Data of Excel File - Module                
                if strcmp(DemandData.EstDemand, 'True' )
                    
                    %% Calculate Demand
                    % !!! Demand in Cubic Meters (m3) !!!
                    % 1) => Agricultural    
                    % 2) => Domestic
                    % 3) => Livestock
                    % 4) => Hydrocarbons
                    % 5) => Mining

                    DayMonths   = [31 28 31 30 31 30 31 31 30 31 30 31];
                    nm          = length(DemandData.Date);
                    nn          = month(datetime(DemandData.Date(1),'ConvertFrom','datenum'));

                    if strcmp(UserData.DemandVar{i},'Agricultural')
                        % -------------------------------------------------------------------------
                        % Precipitation 
                        % -------------------------------------------------------------------------
                        try
                            DemandData.P = dlmread(fullfile(UserData.PathProject,'RESULTS','P',['Pcp_Scenario-',num2str(NSce),'.csv']),',',1,1);
                            Date_test   = datetime(DemandData.P(:,1),'ConvertFrom','datenum');
                            [id,PosiDate] = ismember(DemandData.Date,Date_test);
                            if sum(id) ~= length(DemandData.Date)
                                errordlg('The dates of the file are not in the defined ranges','!! Error !!')
                            end
                            
                            DemandData.P = DemandData.P(PosiDate,2:end);
                        catch
                            close(ProgressBar);
                            errordlg('The Precipitation Data Not Found','!! Error !!')
                            return
                        end
                        
                        % -------------------------------------------------------------------------
                        % Evapotranspiration
                        % -------------------------------------------------------------------------
                        try
                            DemandData.ET   = dlmread(fullfile(UserData.PathProject,'RESULTS','ETP',['ETP_Scenario-',num2str(NSce),'.csv']),',',1,1);
                            Date_test       = datetime(DemandData.ET(:,1),'ConvertFrom','datenum');
                            [id,PosiDate]   = ismember(DemandData.Date,Date_test);
                            if sum(id) ~= length(DemandData.Date)
                                errordlg('The dates of the file are not in the defined ranges','!! Error !!')
                            end
                            DemandData.ET      = DemandData.ET(PosiDate,2:end);
                        catch
                            close(ProgressBar);
                            errordlg('The Evapotranspiration Data Not Found','!! Error !!')
                            return
                        end

                        % Area in Hec to Squart Meter
                        FactorArea = 10000;
                        
                        DemandData.DataMM = DataM; 
                        DemandData.DataMM(DataM < 0) = NaN;
                        
                        if strcmp(DemandData.TypeCrop, 'Trasients')                           
                            DataVV = DataV;
                            DataVV(:,1:DemandData.TimeCrop) = cumsum(DataV(:,1:DemandData.TimeCrop), 2, 'omitnan');
                            for r = (DemandData.TimeCrop + 1):length(DataV(1,:))                            
                                DataVV(:,r) = sum(DataV(:,(r-DemandData.TimeCrop+1):r), 2, 'omitnan');
                            end
                            % Area in m2
                            DemandData.Dm = DataVV * FactorArea;
                        else

                            % Area in m2
                            DemandData.Dm  = DataV * FactorArea;
                        end

                    elseif strcmp(UserData.DemandVar{i},'Domestic')
                        % !!! Demand in Cubic Meters (m^3) !!!
                        % Liters to Cubic Meter
                        Factor_lts_M3           = (1/1000);
                        Tmp                     = repmat(DayMonths,length(DemandData.CodeSU),length(unique(year(DemandData.Date))));
                        DemandData.Dm   = (Factor_lts_M3 .* DataV .* DataM .* Tmp(:,nn:(nm + nn - 1)))./(1 - Loss);

                    elseif strcmp(UserData.DemandVar{i},'Livestock') || strcmp(UserData.DemandVar{i},'Hydrocarbons')
                        % !!! Demand in Cubic Meters (m^3) !!!
                         % Liters to Cubic Meter
                        Factor_lts_M3           = (1/1000);
                        Tmp                     = repmat(DayMonths,length(DemandData.CodeSU),length(year(DemandData.Date)));
                        DemandData.Dm   = (Factor_lts_M3 .* DataV .* DataM .* Tmp(:,nn:(nm + nn - 1)))./(1 - Loss);

                    elseif strcmp(UserData.DemandVar{i},'Mining')
                        % !!! Demand in Cubic Meters (m^3) !!!
                        DemandData.Dm = DataV .* DataM;
                        DemandData.Dm = DemandData.Dm./(1 - Loss);

                    end
                else
                    
                    DemandData.Dm  = DataV;
                    DemandData.DataMM      = DataV*0;
                end
                                
                %% Distribution Demand Data by Basin                
                % Load Shapefile of Spatial Unit 
                try
                    [DemandData.SU, CodeSU_shp]    = shaperead(DemandData.ShpSU);

                    if isfield(CodeSU_shp,'Code') 
                        DemandData.CodeSU_shp = [CodeSU_shp.Code]';
                    else
                        close(ProgressBar);
                        errordlg('There is no attribute called "Code" in the Shapefile of UAH','!! Error !!')
                        return
                    end

                catch
                    close(ProgressBar);
                    errordlg(['The Shapefile "',ShpSU,'" not found'],'!! Error !!')
                    return
                end
                              
                % Check Codes SU
                [tmp,~] = ismember(DemandData.CodeSU, DemandData.CodeSU_shp);
                if sum(tmp) ~= length(DemandData.CodeSU)
                    close(ProgressBar);
                    errordlg('There is a discrepancy between the excel codes and the shapefile','!! Error !!')
                    return
                end
                
                % Load Shapefile of Hydrological Analisys Unit
                try
                    [DemandData.Basin, CodeBasin]      = shaperead( fullfile(UserData.PathProject,'DATA','Geographic','HUA',UserData.NameFile_HUA) );
                    
                    if isfield(CodeBasin,'Code') 
                        DemandData.CodeBasin = [CodeBasin.Code]';
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
                                
                if strcmp(DemandData.TypeInfo, 'Average' )
                    if strcmp(UserData.DemandVar{i},'Agricultural')
                        [Values, KcCrop] = DistributionDemandAverage(i, UserData,DemandData);  
                    else
                        Values = DistributionDemandAverage(i, UserData,DemandData);
                    end
                    
%% ----------------------------------------------------------------------------------------------------------------------------------------------------                    
                else
                    
                    if strcmp(UserData.DemandVar{i},'Agricultural')
                        [Values, KcCrop] = DistributionDemandTime(i, UserData,DemandData);  
                    else
                        Values = DistributionDemandTime(i, UserData,DemandData);
                    end

                end
                
                DemandData.CodeBasin = sort(DemandData.CodeBasin);
                                                       
                %% Save Data
                NameBasin    = cell(1,length(DemandData.CodeBasin) + 1);
                NameBasin{1} = 'Date_Matlab';   
                
                for k = 2:length(DemandData.CodeBasin) + 1
                    NameBasin{k} = ['Basin_',num2str(DemandData.CodeBasin(k - 1))];
                end

                NameDate    = cell(1,length(DemandData.Date));
                for k = 1:length(DemandData.Date)
                    NameDate{k} = datestr(DemandData.Date(k),'dd-mm-yyyy');
                end
                
                Date = datenum(DemandData.Date);
                
                %% Agricultural Demand
                if strcmp(UserData.DemandVar{i},'Agricultural')
                    if strcmp(DemandData.EstDemand, 'True' )
                        % Water Balance
                        KcCrop(isnan(KcCrop)) = 0;
                        
                        BalanceH = ((DemandData.ET.* KcCrop) - DemandData.P);
                        BalanceH(BalanceH<0) = 0;
                        
                        % Estimation Agricultural Demand                        
                        ValuesDemand = (Values .* (BalanceH./1000))/(1 - DemandData.Loss);
                
                        % Save Area (m2)
                        Results = [Date Values];
                        Results = array2table(Results,'VariableNames',NameBasin,'RowNames',NameDate);

                        writetable(Results,...
                            fullfile(UserData.PathProject,'RESULTS','Demand', UserData.DemandVar{i},['Scenario-',num2str(Scenarios(NSce))],'Area',[eval(['UserData.NamesFileDm_',NameDemandVar{i},'{Nexc,1}']),'.csv']),...
                            'WriteRowNames',true)

                        % Save Balance (mm)
                        Results = [Date BalanceH];
                        Results = array2table(Results,'VariableNames',NameBasin,'RowNames',NameDate);

                        writetable(Results,...
                            fullfile(UserData.PathProject,'RESULTS','Demand', UserData.DemandVar{i},['Scenario-',num2str(Scenarios(NSce))],'Balance',[eval(['UserData.NamesFileDm_',NameDemandVar{i},'{Nexc,1}']),'.csv']),...
                            'WriteRowNames',true)

                        % Save Kc
                        Results = [Date KcCrop];
                        Results = array2table(Results,'VariableNames',NameBasin,'RowNames',NameDate);

                        writetable(Results,...
                            fullfile(UserData.PathProject,'RESULTS','Demand', UserData.DemandVar{i},['Scenario-',num2str(Scenarios(NSce))],'Kc',[eval(['UserData.NamesFileDm_',NameDemandVar{i},'{Nexc,1}']),'.csv']),...
                            'WriteRowNames',true)

                        % Save Demand (m3)
                        Results = [Date ValuesDemand];
                        Results = array2table(Results,'VariableNames',NameBasin,'RowNames',NameDate);

                        writetable(Results,...
                            fullfile(UserData.PathProject,'RESULTS','Demand', UserData.DemandVar{i},['Scenario-',num2str(Scenarios(NSce))],'Demand',[eval(['UserData.NamesFileDm_',NameDemandVar{i},'{Nexc,1}']),'.csv']),...
                            'WriteRowNames',true)

                        % Save Return (m3)                    
                        Results = [Date (ValuesDemand.*DemandData.PorReturns)];
                        Results = array2table(Results,'VariableNames',NameBasin,'RowNames',NameDate);

                        writetable(Results,...
                            fullfile(UserData.PathProject,'RESULTS','Demand', UserData.DemandVar{i},['Scenario-',num2str(Scenarios(NSce))],'Return',[eval(['UserData.NamesFileDm_',NameDemandVar{i},'{Nexc,1}']),'.csv']),...
                            'WriteRowNames',true)
                    else
                        ValuesDemand = Values /(1 - DemandData.Loss);
                        
                        % Save Demand (m3)
                        Results = [Date ValuesDemand];
                        Results = array2table(Results,'VariableNames',NameBasin,'RowNames',NameDate);

                        writetable(Results,...
                            fullfile(UserData.PathProject,'RESULTS','Demand', UserData.DemandVar{i},['Scenario-',num2str(Scenarios(NSce))],'Demand',[eval(['UserData.NamesFileDm_',NameDemandVar{i},'{Nexc,1}']),'.csv']),...
                            'WriteRowNames',true)

                        % Save Return (m3)                    
                        Results = [Date (ValuesDemand.*DemandData.PorReturns)];
                        Results = array2table(Results,'VariableNames',NameBasin,'RowNames',NameDate);

                        writetable(Results,...
                            fullfile(UserData.PathProject,'RESULTS','Demand', UserData.DemandVar{i},['Scenario-',num2str(Scenarios(NSce))],'Return',[eval(['UserData.NamesFileDm_',NameDemandVar{i},'{Nexc,1}']),'.csv']),...
                            'WriteRowNames',true)
                    end
                
                else
                    
                    ResultsRetur = [Date (Values.*DemandData.PorReturns)];
                    ResultsRetur = array2table(ResultsRetur,'VariableNames',NameBasin,'RowNames',NameDate);

                    writetable(ResultsRetur,...
                        fullfile(UserData.PathProject,'RESULTS','Demand', UserData.DemandVar{i},['Scenario-',num2str(Scenarios(NSce))],'Return',[eval(['UserData.NamesFileDm_',NameDemandVar{i},'{Nexc,1}']),'.csv']),...
                        'WriteRowNames',true)

                    Results = [Date Values];
                    Results = array2table(Results,'VariableNames',NameBasin,'RowNames',NameDate);

                    writetable(Results,...
                    fullfile(UserData.PathProject,'RESULTS','Demand', UserData.DemandVar{i},['Scenario-',num2str(Scenarios(NSce))],'Demand',[eval(['UserData.NamesFileDm_',NameDemandVar{i},'{Nexc,1}']),'.csv']),...
                    'WriteRowNames',true)
                
                
                end
                
            end
            
        end
    end 
end


%% TOTAL DEMAND
DeRe = {'Demand','Return'};
% Demand Type
for i = 1:length(UserData.DemandVar) 
    
    % True or False - Include Demand
    if eval(['UserData.Inc_',NameDemandVar{i}]) == 1
        
        for NSce = 1:length(Scenarios)
            try
                for dr = 1:2

                    % Store Total Demand
                    NameFile = dir(fullfile(UserData.PathProject,'RESULTS','Demand',UserData.DemandVar{i},['Scenario-',num2str(Scenarios(NSce))],DeRe{dr},'*.csv'));
                    NameFile = {NameFile.name}';

                    if isempty(NameFile)
                        NameFile    = dir(fullfile(UserData.PathProject,'RESULTS','Demand',UserData.DemandVar{i},['Scenario-',num2str(Scenarios(NSce))],DeRe{1},'*.csv'));
                        NameFile    = {NameFile.name}';
                        Tmp         = dlmread(fullfile(UserData.PathProject,'RESULTS','Demand',UserData.DemandVar{i},['Scenario-',num2str(Scenarios(NSce))],DeRe{1},NameFile{1}),',',1,1);
                        Data        = Tmp(:,2:end)*0;

                    else
                        for k = 1:length(NameFile)
                            Tmp     = dlmread(fullfile(UserData.PathProject,'RESULTS','Demand',UserData.DemandVar{i},['Scenario-',num2str(Scenarios(NSce))],DeRe{dr},NameFile{k}),',',1,1);
                            DateD   = Tmp(:,1);
                            Tmp     = Tmp(:,2:end);
                            if k == 1
                                Data = Tmp;
                            else 
                                Data = Data + Tmp;
                            end

                        end
                    end

                    %% Save Demand - Sector
                    NameDate    = cell(1,length(DateD));
                    for k = 1:length(DateD)
                        NameDate{k} = datestr(DateD(k),'dd-mm-yyyy');
                    end

                    Results = [DateD Data];
                    Results = array2table(Results,'VariableNames',NameBasin,'RowNames',NameDate);

                    writetable(Results, fullfile(UserData.PathProject,'RESULTS','Demand',UserData.DemandVar{i},['Scenario-',num2str(NSce)],['Total_',DeRe{dr},'.csv']), 'WriteRowNames',true)
                end
            catch
            end
        end
    end
end

 % Progres Process
% --------------
close(ProgressBar);
% --------------

%% Operation Completed
[Icon,~] = imread('Completed.jpg'); 
msgbox('Operation Completed','Success','custom',Icon);

end


%% Average Distribution Demand - True
function [Values, varargout] = DistributionDemandAverage(i, UserData,DemandData)
    
    
    if strcmp(UserData.DemandVar{i},'Agricultural')
        KcCrop    = zeros(length(DemandData.Date),length(DemandData.CodeBasin));
    end
        
    % Storage Values
    Values          = zeros(length(DemandData.Date),length(DemandData.CodeBasin));
                
    % Distribution Demand 
    if strcmp(DemandData.DistCal, 'False') % False Distribution

        % Load Raster Spatial Unit
        % -------------------------------------------------------------------------------------------
        try
            [SUD, Tmp]      = geotiffread(DemandData.RasterSU);
            ExtentRaster    = [ Tmp.YWorldLimits, Tmp.XWorldLimits ];
        catch
            close(ProgressBar);
            errordlg(['The Raster "',RasterSU,'" not found'],'!! Error !!')
            return
        end

        [fil, col]  = size(SUD);
        x           = linspace(ExtentRaster(3), ExtentRaster(4),col);
        y           = linspace(ExtentRaster(2), ExtentRaster(1),fil);
        [x, y]      = meshgrid(x,y);
        x           = reshape(x,[],1);
        y           = reshape(y,[],1);
        SUD         = reshape(SUD,[],1);
        Carajo      = unique(SUD);
        [idd,~]     = ismember(Carajo, DemandData.CodeSU);
        Chanfle     = Carajo(idd == 0);

        for ff = 1:length(Chanfle)
            x           = x(SUD ~= Chanfle(ff));
            y           = y(SUD ~= Chanfle(ff));
            SUD         = SUD(SUD ~= Chanfle(ff));
        end

        SUD         = double(SUD);
        SUDD        = zeros(length(SUD), length(DemandData.Date));
        
        % Kc Crop
        % -------------------------------------------------------------------------------------------
        if strcmp(UserData.DemandVar{i},'Agricultural')
            Kc = SUDD*NaN;
        end
        
        % Distribution Demand by point number 
        % -------------------------------------------------------------------------------------------
        CodeSUD     = unique(SUD);

        for k = 1:length(CodeSUD)
            Temp    = SUD == CodeSUD(k);
            IIDD    = DemandData.CodeSU == CodeSUD(k);
            if sum(IIDD) ~= 0
                for we = 1:length(DemandData.Date)
                    SUDD(Temp,we)   = DemandData.Dm(IIDD,we) / sum(Temp);
                    Kc(Temp,we)     = DemandData.DataMM(IIDD ,we);
                end
            end
        end
        
        SUD = SUDD;
        % Sort Basin
        % -------------------------------------------------------------------------------------------
        CodeBasin_Sort  = sort(DemandData.CodeBasin);
        [~,Poo]         = ismember(CodeBasin_Sort,DemandData.CodeBasin);

        % Demand by Basin
        % -------------------------------------------------------------------------------------------
        for k = 1:length(CodeBasin_Sort)

            id  = inpolygon(x, y, DemandData.Basin(Poo(k)).X, DemandData.Basin(Poo(k)).Y);

            if strcmp(UserData.DemandVar{i},'Agricultural')
                [fil,~] = size(SUD(id,:));
                if fil == 1
                    Values(:,k) = SUD(id,:)';
                    % Area  (m2)
                    KcCrop(:,k) = Kc(id,:)';
                    SUD(id,:)   = 0;
                    Kc(id,:)    = 0;
                else
                    Values(:,k) = sum( SUD(id,:) , 'omitnan')';
                    % Area  (m2)
                    KcCrop(:,k) = mean( Kc(id,:), 'omitnan' )';
                    SUD(id,:)   = 0;
                    Kc(id,:)    = 0;
                end
            else
                [fil,~] = size(SUD(id,:));
                if fil == 1
                    Values(:,k) = SUD(id,:)';
                    SUD(id,:)   = 0;
                else
                    Values(:,k) = sum( SUD(id,:),'omitnan' )';
                    SUD(id,:)   = 0;
                end
            end

        end

    elseif strcmp(DemandData.DistCal, 'True')

        %% True Distribution 
        % Load Raster Spatial Unit Distribution
        % -------------------------------------------------------------------------------------------
        try
            [SUD, Tmp]      = geotiffread( fullfile(UserData.PathProject,'DATA','Geographic','SUD', DemandData.RasterSUD, [DemandData.RasterSUD, '.tif']) );
            ExtentRaster    = [ Tmp.YWorldLimits, Tmp.XWorldLimits ];
        catch
            errordlg(['The Raster "',[RasterSUD, '.tif'],'" not found'],'!! Error !!')
            return
        end

        % Coordinates
        [fil, col]      = size(SUD);
        x               = linspace(ExtentRaster(3), ExtentRaster(4),col);
        y               = linspace(ExtentRaster(2), ExtentRaster(1),fil);
        [x, y]          = meshgrid(x,y);
        x               = reshape(x,[],1);
        y               = reshape(y,[],1);
        SUD             = reshape(SUD,[],1);
        x               = x(SUD == DemandData.DistCode);
        y               = y(SUD == DemandData.DistCode);

        CodeSU_shp_Sort = sort(DemandData.CodeSU_shp);
        [~,Poo]         = ismember(CodeSU_shp_Sort,DemandData.CodeSU_shp);
        CodeSU_shp      = CodeSU_shp_Sort;                        

        SUD             = zeros(length(x), length(DemandData.Date));

        id      = Poo > 0;
        Poo     = Poo(id);

        [~, Poo2]       = ismember(DemandData.CodeSU, CodeSU_shp);

        id      = Poo2 > 0;
        Poo2    = Poo2(id);

        % Kc Crop
        % -------------------------------------------------------------------------------------------
        if strcmp(UserData.DemandVar{i},'Agricultural')
            Kc = SUD*NaN;
        end
        
        % Distribution Demand whit Spatial Unit 
        % -------------------------------------------------------------------------------------------       
        for k = 1:length(Poo2)
            
            Temp = inpolygon(x, y, DemandData.SU(Poo(Poo2(k))).X, DemandData.SU(Poo(Poo2(k))).Y);
            IIDD = find(DemandData.CodeSU == CodeSU_shp(Poo2(k)));
            
            if sum(SUD(Temp,1)) > 0
                Tepille = 1;
            else
                Tepille = 0;
            end
            
            gdf = find(Temp == 1);
            fdg = (SUD(Temp,1) == 0);
            if (sum(Temp) > 0) && (Tepille == 0)
                if sum(IIDD) ~= 0
                    for we = 1:length(DemandData.Date)
                        SUD(gdf(fdg),we) = DemandData.Dm(IIDD,we) ./ sum(Temp);
                    end
                end
                JoJoPo          = 0;
            else

                JoJoPo          = 1;

                ExtentBasin     = DemandData.SU(Poo(Poo2(k))).BoundingBox;                                
                xtmp            = linspace(ExtentBasin(1,1), ExtentBasin(2,1),10);
                ytmp            = linspace(ExtentBasin(2,2), ExtentBasin(1,2),10);
                [xtmp, ytmp]    = meshgrid(xtmp, ytmp);
                xtmp            = reshape(xtmp,[],1);
                ytmp            = reshape(ytmp,[],1);

                Temp1           = inpolygon(xtmp, ytmp, DemandData.SU(Poo(Poo2(k))).X, DemandData.SU(Poo(Poo2(k))).Y);

                x               = [x; xtmp(Temp1)];
                y               = [y; ytmp(Temp1)];

                SUD             = [SUD; zeros(length(xtmp(Temp1)),length(DemandData.Date))]; 

                Temp            = inpolygon(x, y, DemandData.SU(Poo(Poo2(k))).X, DemandData.SU(Poo(Poo2(k))).Y);
                
                gdf = find(Temp == 1);
                fdg = (SUD(Temp,1) == 0);
                for we = 1:length(DemandData.Date)                    
                    SUD(gdf(fdg),we) = DemandData.Dm(IIDD ,we) ./ sum(fdg);
                end

            end

            if strcmp(UserData.DemandVar{i},'Agricultural') % Agricultural Demand
                if JoJoPo == 1
                    Kc        = [Kc; zeros(length(xtmp(Temp1)),length(DemandData.Date))];
                    clearvars JoJoPo
                end

                for we = 1:length(DemandData.Date)
                    Kc(gdf(fdg),we)  = DemandData.DataMM(IIDD ,we);
                end

            end

        end
        
        % Sort Basin
        % -------------------------------------------------------------------------------------------
        CodeBasin_Sort  = sort(DemandData.CodeBasin);
        [~,Poo]         = ismember(CodeBasin_Sort,DemandData.CodeBasin);
        
        % Assignation of Demand in Basin
        % -------------------------------------------------------------------------------------------
        for k = 1:length(CodeBasin_Sort)

            id  = inpolygon(x, y, DemandData.Basin(Poo(k)).X, DemandData.Basin(Poo(k)).Y);

            if strcmp(UserData.DemandVar{i},'Agricultural')
                [fil,~] = size(SUD(id,:));
                if fil == 1
                    Values(:,k) = SUD(id,:)';
                    % Area  (m2)
                    KcCrop(:,k) = Kc(id,:)';
                    SUD(id,:)   = 0;
                    Kc(id,:)    = 0;
                else
                    Values(:,k) = sum( SUD(id,:) , 'omitnan')';
                    % Area  (m2)
                    KcCrop(:,k) = mean( Kc(id,:), 'omitnan' )';
                    SUD(id,:)   = 0;
                    Kc(id,:)    = 0;
                end
            else
                [fil,~] = size(SUD(id,:));
                if fil == 1
                    Values(:,k) = SUD(id,:)';
                    SUD(id,:)   = 0;
                else
                    Values(:,k) = sum( SUD(id,:),'omitnan' )';
                    SUD(id,:)   = 0;
                end
            end

        end

    end
    
    % Outputs
    if strcmp(UserData.DemandVar{i},'Agricultural')
        varargout{1} = KcCrop;
    end
    
end

%% Time Distribution Demand - False
function [Values, varargout] = DistributionDemandTime(i, UserData,DemandData)
    
    if strcmp(UserData.DemandVar{i},'Agricultural')
        KcCrop    = zeros(length(DemandData.Date),length(DemandData.CodeBasin));
    end
    
    % Storage Values
    Values          = zeros(length(DemandData.Date),length(DemandData.CodeBasin));
    
    for we = 1:length(DemandData.Date)
        % Distribution Demand 
        if strcmp(DemandData.DistCal{we}, 'False') % False Distribution

            % Load Raster Spatial Unit
            % -------------------------------------------------------------------------------------------
            try
                [SUD, Tmp]      = geotiffread(DemandData.RasterSU);
                ExtentRaster    = [ Tmp.YWorldLimits, Tmp.XWorldLimits ];
            catch
                close(ProgressBar);
                errordlg(['The Raster "',RasterSU,'" not found'],'!! Error !!')
                return
            end

            [fil, col]  = size(SUD);
            x           = linspace(ExtentRaster(3), ExtentRaster(4),col);
            y           = linspace(ExtentRaster(2), ExtentRaster(1),fil);
            [x, y]      = meshgrid(x,y);
            x           = reshape(x,[],1);
            y           = reshape(y,[],1);
            SUD         = reshape(SUD,[],1);
            Carajo      = unique(SUD);
            [idd,~]     = ismember(Carajo, DemandData.CodeSU);
            Chanfle     = Carajo(idd == 0);

            for ff = 1:length(Chanfle)
                x           = x(SUD ~= Chanfle(ff));
                y           = y(SUD ~= Chanfle(ff));
                SUD         = SUD(SUD ~= Chanfle(ff));
            end

            SUD         = double(SUD);
            SUDD        = zeros(length(SUD), length(DemandData.Date));

            % Kc Crop
            % -------------------------------------------------------------------------------------------
            if strcmp(UserData.DemandVar{i},'Agricultural')
                Kc = SUDD*NaN;
            end

            % Distribution Demand by point number 
            % -------------------------------------------------------------------------------------------
            CodeSUD     = unique(SUD);

            for k = 1:length(CodeSUD)
                Temp    = SUD == CodeSUD(k);
                IIDD    = DemandData.CodeSU == CodeSUD(k);
                if sum(IIDD) ~= 0
                    SUDD(Temp,we)   = DemandData.Dm(IIDD,we) / sum(Temp);
                    Kc(Temp,we)     = DemandData.DataMM(IIDD ,we);
                end
            end

            SUD = SUDD;
            % Sort Basin
            % -------------------------------------------------------------------------------------------
            CodeBasin_Sort  = sort(DemandData.CodeBasin);
            [~,Poo]         = ismember(CodeBasin_Sort,DemandData.CodeBasin);

            % Demand by Basin
            % -------------------------------------------------------------------------------------------
            for k = 1:length(CodeBasin_Sort)

                id  = inpolygon(x, y, DemandData.Basin(Poo(k)).X, DemandData.Basin(Poo(k)).Y);

                if strcmp(UserData.DemandVar{i},'Agricultural')
                    [fil,~] = size(SUD(id,we));
                    if fil == 1
                        Values(:,k) = SUD(id,we)';
                        % Area  (m2)
                        KcCrop(we,k) = Kc(id,we)';
                        SUD(id,we)   = 0;
                        Kc(id,we)    = 0;
                    else
                        Values(we,k) = sum( SUD(id,we) , 'omitnan')';
                        % Area  (m2)
                        KcCrop(we,k) = mean( Kc(id,we), 'omitnan' )';
                        SUD(id,we)   = 0;
                        Kc(id,we)    = 0;
                    end
                else
                    [fil,~] = size(SUD(id,we));
                    if fil == 1
                        Values(we,k) = SUD(id,we)';
                        SUD(id,we)   = 0;
                    else
                        Values(we,k) = sum( SUD(id,we),'omitnan' )';
                        SUD(id,we)   = 0;
                    end
                end

            end

        elseif strcmp(DemandData.DistCal{we}, 'True')

            %% True Distribution 
            % Load Raster Spatial Unit Distribution
            % -------------------------------------------------------------------------------------------
            try
                [SUD, Tmp]      = geotiffread( fullfile(UserData.PathProject,'DATA','Geographic','SUD', DemandData.RasterSUD{we}, [DemandData.RasterSUD{we}, '.tif']) );
                ExtentRaster    = [ Tmp.YWorldLimits, Tmp.XWorldLimits ];
            catch
                errordlg(['The Raster "',[RasterSUD, '.tif'],'" not found'],'!! Error !!')
                return
            end

            % Coordinates
            [fil, col]      = size(SUD);
            x               = linspace(ExtentRaster(3), ExtentRaster(4),col);
            y               = linspace(ExtentRaster(2), ExtentRaster(1),fil);
            [x, y]          = meshgrid(x,y);
            x               = reshape(x,[],1);
            y               = reshape(y,[],1);
            SUD             = reshape(SUD,[],1);
            x               = x(SUD == DemandData.DistCode(we));
            y               = y(SUD == DemandData.DistCode(we));

            CodeSU_shp_Sort = sort(DemandData.CodeSU_shp);
            [~,Poo]         = ismember(CodeSU_shp_Sort,DemandData.CodeSU_shp);
            CodeSU_shp      = CodeSU_shp_Sort;                        

            SUD             = zeros(length(x), 1);

            id      = Poo > 0;
            Poo     = Poo(id);

            [~, Poo2]       = ismember(DemandData.CodeSU, CodeSU_shp);

            id      = Poo2 > 0;
            Poo2    = Poo2(id);

            % Kc Crop
            % -------------------------------------------------------------------------------------------
            if strcmp(UserData.DemandVar{i},'Agricultural')
                Kc = SUD*NaN;
            end

            % Distribution Demand whit Spatial Unit 
            % -------------------------------------------------------------------------------------------       
            for k = 1:length(Poo2)

                Temp = inpolygon(x, y, DemandData.SU(Poo(Poo2(k))).X, DemandData.SU(Poo(Poo2(k))).Y);
                IIDD = find(DemandData.CodeSU == CodeSU_shp(Poo2(k)));

                if sum(SUD(Temp)) > 0
                    Tepille = 1;
                else
                    Tepille = 0;
                end

                gdf = find(Temp == 1);
                fdg = (SUD(Temp) == 0);
                if (sum(Temp) > 0) && (Tepille == 0)
                    if sum(IIDD) ~= 0
                        SUD(gdf(fdg)) = DemandData.Dm(IIDD,we) ./ sum(Temp);
                    end
                    JoJoPo          = 0;
                else

                    JoJoPo          = 1;

                    ExtentBasin     = DemandData.SU(Poo(Poo2(k))).BoundingBox;                                
                    xtmp            = linspace(ExtentBasin(1,1), ExtentBasin(2,1),10);
                    ytmp            = linspace(ExtentBasin(2,2), ExtentBasin(1,2),10);
                    [xtmp, ytmp]    = meshgrid(xtmp, ytmp);
                    xtmp            = reshape(xtmp,[],1);
                    ytmp            = reshape(ytmp,[],1);

                    Temp1           = inpolygon(xtmp, ytmp, DemandData.SU(Poo(Poo2(k))).X, DemandData.SU(Poo(Poo2(k))).Y);

                    x               = [x; xtmp(Temp1)];
                    y               = [y; ytmp(Temp1)];

                    SUD             = [SUD; zeros(length(xtmp(Temp1)),1)]; 

                    Temp            = inpolygon(x, y, DemandData.SU(Poo(Poo2(k))).X, DemandData.SU(Poo(Poo2(k))).Y);

                    gdf = find(Temp == 1);
                    fdg = (SUD(Temp) == 0);
                    SUD(gdf(fdg)) = DemandData.Dm(IIDD ,we) ./ sum(fdg);

                end

                if strcmp(UserData.DemandVar{i},'Agricultural') % Agricultural Demand
                    if JoJoPo == 1
                        Kc        = [Kc; zeros(length(xtmp(Temp1)),1)];
                        clearvars JoJoPo
                    end

                    Kc(gdf(fdg))  = DemandData.DataMM(IIDD ,we);

                end

            end

            % Sort Basin
            % -------------------------------------------------------------------------------------------
            CodeBasin_Sort  = sort(DemandData.CodeBasin);
            [~,Poo]         = ismember(CodeBasin_Sort,DemandData.CodeBasin);

            % Assignation of Demand in Basin
            % -------------------------------------------------------------------------------------------
            for k = 1:length(CodeBasin_Sort)

                id  = inpolygon(x, y, DemandData.Basin(Poo(k)).X, DemandData.Basin(Poo(k)).Y);

                if strcmp(UserData.DemandVar{i},'Agricultural')
                    [fil,~] = size(SUD(id));
                    if fil == 1
                        Values(we,k) = SUD(id)';
                        % Area  (m2)
                        KcCrop(we,k) = Kc(id)';
                        SUD(id)   = 0;
                        Kc(id)    = 0;
                    else
                        Values(we,k) = sum( SUD(id) , 'omitnan')';
                        % Area  (m2)
                        KcCrop(we,k) = mean( Kc(id), 'omitnan' )';
                        SUD(id)   = 0;
                        Kc(id)    = 0;
                    end
                else
                    [fil,~] = size(SUD(id));
                    if fil == 1
                        Values(we,k) = SUD(id)';
                        SUD(id)   = 0;
                    else
                        Values(we,k) = sum( SUD(id),'omitnan' )';
                        SUD(id)   = 0;
                    end
                end

            end

        end
    end
    
    Values(isnan(Values)) = 0;
    
    % Outputs
    if strcmp(UserData.DemandVar{i},'Agricultural')
        varargout{1} = KcCrop;
    end
    
end
