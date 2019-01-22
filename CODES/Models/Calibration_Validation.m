function UserData = Calibration_Validation(UserData)
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
% -------------------------------------------------------------------------
%                               DESCRIPTION 
% -------------------------------------------------------------------------
% 
% This function perform the calibration and validation of the ABDC-FP-D 
% Model through of the Shuffled complex evolution
% 
% -------------------------------------------------------------------------
%                               INPUT DATA
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
%

%% Initial Weitbar
warning off
ProgressBar     = waitbar(0, 'Load Data...');
wbch            = allchild(ProgressBar);
jp              = wbch(1).JavaPeer;
jp.setIndeterminate(1)

%% CALIBRACION
% Id Basin by Arcid Downstream
PoPo        = zeros(length(UserData.ArcID),1); 
PoPoID      = PoPo;
NumberCat   = unique(UserData.CatGauges);

SummaryCal  = [];

Answer      = questdlg('Calibration Method', 'Calibration Model',...
            'Total','Sequential','Resume','');

% Handle response
switch Answer
    case 'Total'
        ControlCal = 0;
        ResumeCal   = 0;

    case 'Sequential'
        ControlCal = 1;
        ResumeCal   = 0;

    case 'Resume'
        ControlCal = 1;
        ResumeCal = 1;
end

TextResults = sprintf([ '------------------------------------------------------------------------------------------ \n',...
                        '                                         Calibration \n',...
                        '------------------------------------------------------------------------------------------']);
PrintResults(TextResults,0)

for i = 1:length(NumberCat)
    
    if i > 1
        TextResults = sprintf([TextResults, '\n------------------------------------------------------------------------------------------']);
        PrintResults(TextResults,0)
    end

    if ControlCal == 1
        Answer      = questdlg('Calibration HAU', 'Calibration Model',...
            ['Calibration HAU [Order ',num2str(i),']'],'Calibration Total','');

        % Handle response
        switch Answer
            case ['Calibration HAU [Order ',num2str(i),']']
                ControlCal = 1;
            case 'Calibration Total'
                ControlCal = 0;
        end

    end

    %%
    id = find(UserData.CatGauges == NumberCat(i) );

    SummaryCal_i    = NaN(length(id), 22);

    for j = 1:length(id)
                
        % time 
        tic
        
        UserData.DownGauges     = UserData.ArIDGauges(id(j));
        
                  
        PoPo       = GetNetwork(  UserData.ArcID,...
                                  UserData.Arc_InitNode,...
                                  UserData.Arc_EndNode,...
                                  UserData.ArIDGauges(id(j)),...
                                  PoPo);

        PoPoID                  = (PoPoID + PoPo);
        UserData.IDPoPo         = (PoPoID  == 1);
        UserData.PoPo           = logical(PoPo);
        
        % Date calibration 
        ID_Po1 = find(UserData.Date == UserData.DateCal_Init(id(j)));
        ID_Po2 = find(UserData.Date == UserData.DateCal_End(id(j)));
        UserData.DateCalibration = UserData.Date(ID_Po1:ID_Po2);
        
        % streamflow calibration
        UserData.Qobs = UserData.RawQobs(ID_Po1:ID_Po2,id(j));
         
        SummaryCal_i(j,1) = UserData.CodeGauges(id(j));

        % Disp Results
        TextResults = sprintf([TextResults,'\n[Order = ',num2str(i),' - Control = ',num2str(j), ']  Gauges = ',num2str(UserData.ArIDGauges(id(j)))]);
        PrintResults(TextResults,0)

        if UserData.Verbose == 1
            disp(['[Order = ',num2str(i),' - Control = ',num2str(j), ']  Gauges = ',num2str(UserData.ArIDGauges(id(j)))])
            disp('-------------------------------------------')  
        end

        if ResumeCal == 1
            try
                load(fullfile(UserData.PathProject, 'RESULTS','Parameters_Model',...
                        [num2str(UserData.CodeGauges(id(j))),'-',num2str(UserData.DownGauges),'.mat']))

            catch
            end

        else

            [Param, Bestf, allbest, allEvals] = sce('Function_Obj',UserData.pop_ini,...
                                                    [UserData.a_min, UserData.b_min, UserData.c_min, UserData.d_min, UserData.Q_Umb_min, ...
                                                    UserData.V_Umb_min, UserData.Tpr_min,UserData.Trp_min, UserData.ExtSup_min],...
                                                    [UserData.a_max, UserData.b_max, UserData.c_max, UserData.d_max, UserData.Q_Umb_max,...
                                                    UserData.V_Umb_max ,UserData.Tpr_max ,UserData.Trp_max ,UserData.ExtSup_max],...
                                                    UserData.ncomp, UserData);

            save(fullfile(UserData.PathProject, 'RESULTS','Parameters_Model',...
                [num2str(UserData.CodeGauges(id(j))),'-',num2str(UserData.DownGauges),'.mat']),...
                'Param','Bestf','allbest','allEvals')
          
        end

        % asignacion de parametros
        UserData.a(UserData.IDPoPo)             = Param(1);
        UserData.b(UserData.IDPoPo)             = Param(2);
        UserData.c(UserData.IDPoPo)             = Param(3);
        UserData.d(UserData.IDPoPo)             = Param(4);        
        UserData.Q_Umb(UserData.IDPoPo)         = Param(5);
        UserData.V_Umb(UserData.IDPoPo)         = Param(6);
        UserData.Tpr(UserData.IDPoPo)           = Param(7);
        UserData.Trp(UserData.IDPoPo)           = Param(8);
        UserData.ParamExtSup(UserData.IDPoPo)   = Param(9);

        UserData.GaugesStreamFlowQ   = UserData.CodeGauges(id(j));

        % -------------------------------------------------------------------------
        % Plot Calibration Series
        % -------------------------------------------------------------------------
        [Fig, SummaryCal_i(j,2:end)] = PlotCalibrationModel(Param, UserData);

        saveas(Fig, fullfile(UserData.PathProject, 'FIGURES','Calibration',...
            [num2str(UserData.CodeGauges(id(j))),'-',num2str(UserData.DownGauges),'.jpg']))

        clearvars Fig

        Nash = 1 - Bestf;
        if Nash < 0.4
            TextResults = sprintf([TextResults,' ==>  #  Nash = ', num2str(Nash,'%0.3f'),'  Time = ',num2str(toc,'%0.1f'),' Seg']);
            PrintResults(TextResults,0)
        else
            TextResults = sprintf([TextResults,' ==>     Nash = ', num2str(Nash,'%0.3f'),'  Time = ',num2str(toc,'%0.1f'),' Seg']);
            PrintResults(TextResults,0)
        end

        if UserData.Verbose == 1
            disp(['  Nash = ', num2str(1 - Bestf,'%0.3f'),'  Time = ',num2str(toc,'%0.3f')])
            disp('-------------------------------------------') 
        end

    end

    if ControlCal == 1

        Answer      = questdlg('Want recalibration some HUA?', 'Calibration Model',...
            'Yes','No','');

        % Handle response
        switch Answer
            case 'Yes'
                List = cell(1,length(id));

                for j = 1:length(id)
                    List{j} = ['HUA-',num2str(j),':     Order-',num2str(i)];
                end

                [i_ReCal,ReCal] = listdlg('ListString',List);
            case 'No'
                ReCal = 0;
        end

        if ReCal == 1
            for jj = 1:length(i_ReCal)

                j = i_ReCal(jj);

                UserData.DownGauges     = UserData.ArIDGauges(id(j));

                PoPo       = GetNetwork(  UserData.ArcID,...
                                          UserData.Arc_InitNode,...
                                          UserData.Arc_EndNode,...
                                          UserData.ArIDGauges(id(j)),...
                                          PoPo);

                PoPoID                  = (PoPoID + PoPo);
                UserData.IDPoPo         = (PoPoID  == 1);
                UserData.PoPo           = logical(PoPo);

                % Date calibration 
                ID_Po1 = find(UserData.Date == UserData.DateCal_Init(id(j)));
                ID_Po2 = find(UserData.Date == UserData.DateCal_End(id(j)));
                UserData.DateCalibration = UserData.Date(ID_Po1:ID_Po2);

                % streamflow calibration
                UserData.Qobs = UserData.RawQobs(ID_Po1:ID_Po2,id(j));

                SummaryCal_i(j,1) = UserData.CodeGauges(id(j));

                % Disp Results
                TextResults = sprintf([TextResults,'\n[Order = ',num2str(i),' - Control = ',num2str(j), ']  Gauges = ',num2str(UserData.ArIDGauges(id(j)))]);
                PrintResults(TextResults,0)

                if UserData.Verbose == 1
                    disp(['[Order = ',num2str(i),' - Control = ',num2str(j), ']  Gauges = ',num2str(UserData.ArIDGauges(id(j)))])
                    disp('-------------------------------------------')  
                end

                if ResumeCal == 1
                    try
                        load(fullfile(UserData.PathProject, 'RESULTS','Parameters_Model',...
                                [num2str(UserData.CodeGauges(id(j))),'-',num2str(UserData.DownGauges),'.mat']))

                    catch
                    end

                else

                    sce('Function_Obj',UserData.pop_ini,...
                                                    [UserData.a_min, UserData.b_min, UserData.c_min, UserData.d_min, UserData.Q_Umb_min, ...
                                                    UserData.V_Umb_min, UserData.Tpr_min,UserData.Trp_min, UserData.ExtSup_min],...
                                                    [UserData.a_max, UserData.b_max, UserData.c_max, UserData.d_max, UserData.Q_Umb_max,...
                                                    UserData.V_Umb_max ,UserData.Tpr_max ,UserData.Trp_max ,UserData.ExtSup_max],...
                                                    UserData.ncomp, UserData);

                    save(fullfile(UserData.PathProject, 'RESULTS','Parameters_Model',...
                        [num2str(UserData.CodeGauges(id(j))),'-',num2str(UserData.DownGauges),'.mat']),...
                        'Param','Bestf','allbest','allEvals')

                end

                % asignacion de parametros
                UserData.a(UserData.IDPoPo)             = Param(1);
                UserData.b(UserData.IDPoPo)             = Param(2);
                UserData.c(UserData.IDPoPo)             = Param(3);
                UserData.d(UserData.IDPoPo)             = Param(4);        
                UserData.Q_Umb(UserData.IDPoPo)         = Param(5);
                UserData.V_Umb(UserData.IDPoPo)         = Param(6);
                UserData.Tpr(UserData.IDPoPo)           = Param(7);
                UserData.Trp(UserData.IDPoPo)           = Param(8);
                UserData.ParamExtSup(UserData.IDPoPo)   = Param(9);

                UserData.GaugesStreamFlowQ   = UserData.CodeGauges(id(j));

                % -------------------------------------------------------------------------
                % Plot Calibration Series
                % -------------------------------------------------------------------------
                [Fig, SummaryCal_i(j,2:end)] = PlotCalibrationModel(Param, UserData);

                saveas(Fig, fullfile(UserData.PathProject, 'FIGURES','Calibration',...
                    [num2str(UserData.CodeGauges(id(j))),'-',num2str(UserData.DownGauges),'.jpg']))

                clearvars Fig

                Nash = 1 - Bestf;
                if Nash < 0.4
                    TextResults = sprintf([TextResults,' ==>  #  Nash = ', num2str(Nash,'%0.3f'),'  Time = ',num2str(toc,'%0.1f'),' Seg']);
                    PrintResults(TextResults,0)
                else
                    TextResults = sprintf([TextResults,' ==>     Nash = ', num2str(Nash,'%0.3f'),'  Time = ',num2str(toc,'%0.1f'),' Seg']);
                    PrintResults(TextResults,0)
                end

                if UserData.Verbose == 1
                    disp(['  Nash = ', num2str(1 - Bestf,'%0.3f'),'  Time = ',num2str(toc,'%0.3f')])
                    disp('-------------------------------------------') 
                end
            end
        end
    end

    SummaryCal = [SummaryCal; SummaryCal_i];
    
end

%% Parameters Assignation 
CBNC = unique(UserData.TypeBasinCal(logical(PoPoID ==  0)));
for i = 1:length(CBNC)
    id = UserData.TypeBasinCal == CBNC(i);

    UserData.a(id)      = UserData.a(UserData.ArcID== CBNC(i) );
    UserData.b(id)      = UserData.b(UserData.ArcID== CBNC(i) );
    UserData.c(id)      = UserData.c(UserData.ArcID== CBNC(i) );
    UserData.d(id)      = UserData.d(UserData.ArcID== CBNC(i) );    
    UserData.Q_Umb(id)  = UserData.Q_Umb(UserData.ArcID== CBNC(i) );
    UserData.V_Umb(id)  = UserData.V_Umb(UserData.ArcID== CBNC(i) );
    UserData.Tpr(id)    = UserData.Tpr(UserData.ArcID== CBNC(i) );
    UserData.Trp(id)    = UserData.Trp(UserData.ArcID== CBNC(i) );
    UserData.ParamExtSup(id) = UserData.d(UserData.ArcID== CBNC(i) );
end

% Save project update
save(fullfile(UserData.PathProject, [UserData.NameProject,'.mat']),'UserData')

% Update Parameters table
NameParamsR = ['Code,Basin Area (m2),Flooplains Area (m2),Type,Aquifer Code,From Node,',...
                'To Node,Sw (mm),Sg (mm),Vh (mm),a (Ad),b (mm),c (Ad),d (Ad),Sup (Porc),',...
                'Trp (Porc),Tpr (Porc),Q_Umb (mm),V_Umb (mm),ID_Dm_Agri,ID_Dm_Dom,ID_Dm_Liv,',...
                'ID_Dm_Hy,ID_Dm_Min,ID_Re_Agri,ID_Re_Dom,ID_Re_Liv,ID_Re_Hy,ID_Re_Min\n'];

ResultsParamTota = [UserData.ArcID,...
                    UserData.BasinArea,...
                    UserData.FloodArea,...
                    UserData.TypeBasinCal,...
                    UserData.IDAq,...
                    UserData.Arc_InitNode,...
                    UserData.Arc_EndNode,...
                    UserData.Sw,...
                    UserData.Sg,...
                    UserData.Vh,...
                    UserData.a,...
                    UserData.b,...
                    UserData.c,...
                    UserData.d,...
                    UserData.ParamExtSup,...
                    UserData.Trp,...
                    UserData.Tpr,...
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
                    UserData.IDRetMin];
                
fileID = fopen( fullfile(UserData.PathProject,'RESULTS','Parameters_Model','Parameters.csv') ,'w');
Format = '%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f\n';
fprintf(fileID,NameParamsR);
fprintf(fileID,Format,ResultsParamTota');
fclose(fileID);

%% VALIDATION
% Id Basin by Arcid Downstream
PoPo        = zeros(length(UserData.ArcID),1); 
PoPoID      = PoPo;
NumberCat   = unique(UserData.CatGauges);

SummaryVal  = [];

TextResults = sprintf([ TextResults,'\n \n \n \n ------------------------------------------------------------------------------------------ \n',...
                        '                                    Results Validation \n',...
                        '------------------------------------------------------------------------------------------']);
PrintResults(TextResults,0)

for i = 1:length(NumberCat)

    id = find(UserData.CatGauges == NumberCat(i) );
    SummaryVal_i  = NaN(length(id), 22);

    for j = 1:length(id)

        UserData.DownGauges     = UserData.ArIDGauges(id(j));

        PoPo       = GetNetwork(  UserData.ArcID,...
                                  UserData.Arc_InitNode,...
                                  UserData.Arc_EndNode,...
                                  UserData.ArIDGauges(id(j)),...
                                  PoPo);

        PoPoID                  = (PoPoID + PoPo);
        UserData.IDPoPo         = (PoPoID  == 1);
        UserData.PoPo           = logical(PoPo);
        
        % Check Validation 
        if UserData.DateVal_Init(id(j)) == UserData.DateNaN
            continue
        end

        % Date calibration 
        ID_Po1 = find(UserData.Date == UserData.DateVal_Init(id(j)));
        ID_Po2 = find(UserData.Date == UserData.DateVal_End(id(j)));
        UserData.DateValidation = UserData.Date(ID_Po1:ID_Po2);

        % streamflow calibration
        UserData.Qobs = UserData.RawQobs(ID_Po1:ID_Po2,id(j));

        SummaryVal_i(j,1) = UserData.CodeGauges(id(j));

        %% plot 1
        [Fig, SummaryVal_i(j,2:end)] = PlotValidationModel(UserData);

        saveas(Fig, fullfile(UserData.PathProject, 'FIGURES','Validation',...
            [num2str(UserData.CodeGauges(id(j))),'-',num2str(UserData.DownGauges),'.jpg']))
        
        clearvars Fig
        
        Nash = SummaryVal_i(j,2);
        if Nash < 0.4
            TextResults = sprintf([TextResults,...
                '\n[Order = ',num2str(i),' - Control = ',num2str(j), ']  Gauges = ',num2str(UserData.ArIDGauges(id(j))),...
                ' ==>  #  Nash = ', num2str(Nash,'%0.3f'),'  Time = ',num2str(toc,'%0.1f'),' Seg']);
            PrintResults(TextResults,0)
        else
            TextResults = sprintf([TextResults,...
                '\n[Order = ',num2str(i),' - Control = ',num2str(j), ']  Gauges = ',num2str(UserData.ArIDGauges(id(j))),...
                ' ==>     Nash = ', num2str(Nash,'%0.3f'),'  Time = ',num2str(toc,'%0.1f'),' Seg']);
            PrintResults(TextResults,0)
        end

    end
    ik = isnan(SummaryVal_i(:,1)) == 0;
    SummaryVal_i = SummaryVal_i(ik,:);
    SummaryVal = [SummaryVal; SummaryVal_i];
    
end

% save Metric get to calibration
save(fullfile(UserData.PathProject, 'RESULTS','Parameters_Model','Metric.mat'),'SummaryCal', 'SummaryVal')

close(ProgressBar)

%% Operation Completed
[Icon,~] = imread('Completed.jpg'); 
msgbox('Operation Completed','Success','custom',Icon);