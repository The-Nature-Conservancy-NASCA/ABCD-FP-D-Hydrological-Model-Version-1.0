function Climate_Precipitation_Time(UserData)
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
mkdir(fullfile(UserData.PathProject,'RESULTS','P'))

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

%% Data Type - Points        
% Progres Process
% --------------
ProgressBar     = waitbar(0,'Processing Precipitation - Please wait...');

% Scenarios by Demand
Tmp = cell2mat(UserData.Scenarios(:,2));
Tmp1 = cell2mat(UserData.Scenarios(:,3));
Scenarios = Tmp(Tmp1==1);

Cont = 1;

for i = 1:length(Scenarios)
    % Load Data
    try
        [Data, DateTmp] = xlsread( fullfile(UserData.PathProject,'DATA','Climate','Precipitation', UserData.NameFile_Pcp),...
            ['Scenario-',num2str(Scenarios(i))]);
    catch
        close(ProgressBar)
        errordlg(['The File "',UserData.NameFile_Pcp,'" not found'],'!! Error !!')
        return
    end
    
    CodeBasin   = Data(1,:)';
    Values      = Data(2:end,:);
    DateTmp     = DateTmp(2:length(Values(:,1))+1,1);

    % Check Date 
    % -------------------
    Date1       = datetime(['01-',UserData.DateInit,' 00:00:00'],'InputFormat','dd-MM-yyyy HH:mm:ss');
    Date2       = datetime(['01-',UserData.DateEnd,' 00:00:00'],'InputFormat','dd-MM-yyyy HH:mm:ss');
    DateModel   = (Date1:calmonths:Date2)'; 
    
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
    Values      = Values(PosiDate,:);
    
    %% NaN
    Months = month(datetime(Date,'ConvertFrom', 'datenum'));
    
    for k = 1:length(Values(1,:))
        Posi = find(isnan(Values(:,k)) == 1);
        
        for j = 1:length(Posi)
            m = Months(Posi(j));
            Values(Posi(j),k) = mean(Values(m:12:length(Values(:,1)),k),'omitnan');
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

    writetable(Results, fullfile(UserData.PathProject,'RESULTS','P',['Pcp_Scenario-',num2str(i),'.csv']), 'WriteRowNames',true)
    
    % Progres Process
    % ----------------
    waitbar(Cont / length(Scenarios))
    Cont = Cont + 1;
            
end

% Progres Process
% --------------
close(ProgressBar);
% --------------
    
%% Operation Completed
[Icon,~] = imread('Completed.jpg'); 
msgbox('Operation Completed','Success','custom',Icon);