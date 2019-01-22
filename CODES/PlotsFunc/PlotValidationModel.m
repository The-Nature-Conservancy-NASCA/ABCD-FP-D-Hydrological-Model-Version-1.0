function [Fig, SummaryVal] = PlotValidationModel(UserData) 
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

%%
PoPo                            = UserData.PoPo;
                            
[Qsim,~,~,~,~] = HMO(   UserData.DateCalibration,...
                        UserData.P(:,PoPo),...
                        UserData.ETP(:,PoPo),...
                        UserData.DemandSup(:,PoPo,:),...
                        UserData.DemandSub(:,PoPo),...
                        UserData.Returns(:,PoPo,:),...
                        UserData.BasinArea(PoPo),...
                        UserData.FloodArea(PoPo),... 
                        UserData.ArcID(PoPo),...
                        UserData.Arc_InitNode(PoPo),...
                        UserData.Arc_EndNode(PoPo),...
                        UserData.DownGauges,...
                        UserData.a(PoPo),...
                        UserData.b(PoPo),...
                        UserData.c(PoPo),...
                        UserData.d(PoPo),...
                        UserData.Tpr(PoPo),...
                        UserData.Trp(PoPo),...
                        UserData.Q_Umb(PoPo),...
                        UserData.V_Umb(PoPo),...
                        UserData.IDExtAgri(PoPo),...
                        UserData.IDExtDom(PoPo),...
                        UserData.IDExtLiv(PoPo),... 
                        UserData.IDExtHy(PoPo),... 
                        UserData.IDExtMin(PoPo),...
                        UserData.IDRetAgri(PoPo),...
                        UserData.IDRetDom(PoPo),...
                        UserData.IDRetLiv(PoPo),...
                        UserData.IDRetHy(PoPo),...
                        UserData.IDRetMin(PoPo),...
                        UserData.ParamExtSup(PoPo),...
                        UserData.Sw(PoPo),...
                        UserData.Sg(PoPo),...
                        UserData.Vh(PoPo),...
                        UserData.IDAq(PoPo));

ArcID   = UserData.ArcID(PoPo);
QArcID      = (ArcID == UserData.DownGauges);

obs     = UserData.Qobs;
sim     = reshape(Qsim(QArcID,1,:),[],1);
P       = nanmean(UserData.P(:,PoPo),2);

Date    = datenum(UserData.DateValidation);

sim(sim<0) = 0.1;

%% Coefficient Nash
Nash        = 1 - ((mean((obs-sim).^2, 'omitnan'))./var(obs(isnan(obs) == 0)));

%% Absolute Mean error 
Fuc_AME     = max(abs(obs-sim));
    
%% unlike peaks 
Fuc_PDIFF   = max(obs)-max(sim);

%% Mean Absolute Error 
Fuc_MAE     = mean(abs(obs-sim),'omitnan');

%% Mean Square Error 
Fuc_MSE     = mean((obs-sim).^2,'omitnan');

%% Mean Error
% Fuc_ME      = nanmean(obs-sim);

%% Root Mean Square Error
Fuc_RMSE    = sqrt(Fuc_MSE);

%% Root Fourth Mean Square Fourth Error
Fuc_R4MS4E  = nthroot((mean((obs-sim).^4,'omitnan')),4);

%% Root Absolute Error 
Fuc_RAE     = sum(abs(obs-sim),'omitnan')/sum(abs(obs-mean(obs,'omitnan')),'omitnan');

%% percent Error in peak 
Fuc_PEP     = ((max(obs)-max(sim))/max(obs))*100;

%% Mean Absolute Relative Error
Fuc_MARE    = mean(sum((abs(obs-sim))/obs,'omitnan'),'omitnan');

%% Mean Relative Error 
Fuc_MRE     = mean(sum((obs-sim)/obs,'omitnan'),'omitnan');

%% Mean Square Relative Error 
Fuc_MSRE    = mean(sum(((obs-sim)/obs).^2,'omitnan'),'omitnan');

%% Relative Volume Error
Fuc_RVE     = sum(obs-sim,'omitnan')/sum(obs,'omitnan');

%% Nash-Sutcliffe Coefficient of Efficiency
Enum    = sum((obs-sim).^2,'omitnan');
Edenom  = sum((obs-mean(obs,'omitnan')).^2,'omitnan');
Fuc_CE      = 1-Enum/Edenom;

%% Correlation Coefficient
Rnum    = sum((obs-mean(obs,'omitnan')).*(sim-mean(sim,'omitnan')),'omitnan');
Rdenom  = sqrt(sum((obs-mean(obs,'omitnan')).^2,'omitnan')*sum((sim-mean(sim,'omitnan')).^2,'omitnan'));
Fuc_R       = Rnum/Rdenom;

%% Percentage Bias Error
Fuc_PBE     = sum(sim-obs,'omitnan')/sum(obs,'omitnan')*100;

%% Average Absolute Relative Error
Fuc_ARE     = abs(((sim-obs)./obs)*100);
Fuc_ARE(isnan(Fuc_ARE)) = 0; Fuc_ARE(isinf(Fuc_ARE)) = 0;
Fuc_AARE    = mean(Fuc_ARE,'omitnan');

%% Threshold Statistics
p = zeros(1,size(obs,1)); 
q = zeros(1,size(obs,1)); 
r = zeros(1,size(obs,1)); 
s = zeros(1,size(obs,1));

for l = 1:size(obs,1)
       if Fuc_ARE(l)<1;   p(l) = 1; else, p(l) = 0; end
       if Fuc_ARE(l)<25;  q(l) = 1; else, q(l) = 0; end
       if Fuc_ARE(l)<50;  r(l) = 1; else, r(l) = 0; end
       if Fuc_ARE(l)<100; s(l) = 1; else, s(l) = 0; end      
end

Fuc_TS1   = mean(p,'omitnan')*100;
Fuc_TS25  = mean(q,'omitnan')*100;
Fuc_TS50  = mean(r,'omitnan')*100;
Fuc_TS100 = mean(s,'omitnan')*100;

%% The Relative Error in the Maximum Flow (%MF)
% Fuc_MF = ((max(sim)-max(obs))/max(obs))*100;


%% Plot 
Fig     = figure('color',[1 1 1]);
T       = [30, 15];
set(Fig, 'Units', 'Inches', 'PaperPosition', [0, 0, T],'Position',...
[0, 0, T],'PaperUnits', 'Inches','PaperSize', T,'PaperType','e', 'Visible','off')


%% Precipitacion
subplot(2,20,1:15);
bar(Date, P,'FaceColor',[0.5 0.5 0.5])
xlabel('Tiempo','interpreter','latex','FontSize',22, 'FontWeight','bold');
ylabel('Precipitaci\''on (mm)','interpreter','latex','FontSize',22, 'FontWeight','bold');
datetick('x','yyyy')
axis([min(Date) max(Date) 0 (max(P) + (max(P)*0.1))])
set(gca, 'TickLabelInterpreter','latex','FontSize',28, 'FontWeight','bold')

title(['Estaci\''on - ',num2str(UserData.GaugesStreamFlowQ),'  [ Nash = ',num2str(Nash,'%.2f'),' ]'],...
    'interpreter','latex','FontSize',25, 'FontWeight','bold');

%% Tabla
subplot(2,20,17:20);
plot(0:1, 0:1.2, '.', 'color', [1 1 1])
set(gca, 'box','off','XTickLabel',[],'XTick',[],'YTickLabel',[],'YTick',[], 'XColor','none','YColor','none')
Coor_X = 0;
maxcor = 1; max(max(obs),max(sim));
mincor = 0; min(min(obs),min(sim));

FnZ = 22;
lkn = 0.05;
% Dont change the spaces after the words 
text(Coor_X,((lkn*19*(maxcor-mincor))+ mincor),'AME', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((lkn*18*(maxcor-mincor))+ mincor),'PDIFF', 'interpreter','latex', 'FontSize',FnZ)
text(Coor_X,((lkn*17*(maxcor-mincor))+ mincor),'MAE', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((lkn*16*(maxcor-mincor))+ mincor),'MSE', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((lkn*15*(maxcor-mincor))+ mincor),'RMSE', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((lkn*14*(maxcor-mincor))+ mincor),'R4MS4E', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((lkn*13*(maxcor-mincor))+ mincor),'RAE', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((lkn*12*(maxcor-mincor))+ mincor),'PEP', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((lkn*11*(maxcor-mincor))+ mincor),'MARE', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((lkn*10*(maxcor-mincor))+ mincor),'MRE', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((lkn*9*(maxcor-mincor))+ mincor),'MSRE', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((lkn*8*(maxcor-mincor))+ mincor),'RVE', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((lkn*7*(maxcor-mincor))+ mincor),'R', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((lkn*6*(maxcor-mincor))+ mincor),'CE', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((lkn*5*(maxcor-mincor))+ mincor),'PBE', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((lkn*4*(maxcor-mincor))+ mincor),'AARE', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((lkn*3*(maxcor-mincor))+ mincor),'TS1', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((lkn*2*(maxcor-mincor))+ mincor),'TS25', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((lkn*1*(maxcor-mincor))+ mincor),'TS50', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.00*(maxcor-mincor))+ mincor),'TS100', 'interpreter','latex', 'FontSize', FnZ)

Coor_X = 0.3;

text(Coor_X,((0.95*(maxcor-mincor))+ mincor),'=', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.90*(maxcor-mincor))+ mincor),'=', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.85*(maxcor-mincor))+ mincor),'=', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.80*(maxcor-mincor))+ mincor),'=', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.75*(maxcor-mincor))+ mincor),'=', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.70*(maxcor-mincor))+ mincor),'=', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.65*(maxcor-mincor))+ mincor),'=', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.60*(maxcor-mincor))+ mincor),'=', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.55*(maxcor-mincor))+ mincor),'=', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.50*(maxcor-mincor))+ mincor),'=', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.45*(maxcor-mincor))+ mincor),'=', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.40*(maxcor-mincor))+ mincor),'=', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.35*(maxcor-mincor))+ mincor),'=', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.30*(maxcor-mincor))+ mincor),'=', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.25*(maxcor-mincor))+ mincor),'=', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.20*(maxcor-mincor))+ mincor),'=', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.15*(maxcor-mincor))+ mincor),'=', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.10*(maxcor-mincor))+ mincor),'=', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.05*(maxcor-mincor))+ mincor),'=', 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.00*(maxcor-mincor))+ mincor),'=', 'interpreter','latex', 'FontSize', FnZ)

Coor_X = 0.4;
text(Coor_X,((0.95*(maxcor-mincor))+ mincor),[num2str(Fuc_AME,'%0.3f')], 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.90*(maxcor-mincor))+ mincor),[num2str(Fuc_PDIFF,'%0.3f')], 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.85*(maxcor-mincor))+ mincor),[num2str(Fuc_MAE,'%0.3f')], 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.80*(maxcor-mincor))+ mincor),[num2str(Fuc_MSE,'%0.3f')], 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.75*(maxcor-mincor))+ mincor),[num2str(Fuc_RMSE,'%0.3f')], 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.70*(maxcor-mincor))+ mincor),[num2str(Fuc_R4MS4E,'%0.3f')], 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.65*(maxcor-mincor))+ mincor),[num2str(Fuc_RAE,'%0.3f')], 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.60*(maxcor-mincor))+ mincor),[num2str(Fuc_PEP,'%0.3f')], 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.55*(maxcor-mincor))+ mincor),[num2str(Fuc_MARE,'%0.3f')], 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.50*(maxcor-mincor))+ mincor),[num2str(Fuc_MRE,'%0.3f')], 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.45*(maxcor-mincor))+ mincor),[num2str(Fuc_MSRE,'%0.3f')], 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.40*(maxcor-mincor))+ mincor),[num2str(Fuc_RVE,'%0.3f')], 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.35*(maxcor-mincor))+ mincor),[num2str(Fuc_R,'%0.3f')], 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.30*(maxcor-mincor))+ mincor),[num2str(Fuc_CE,'%0.3f')], 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.25*(maxcor-mincor))+ mincor),[num2str(Fuc_PBE/100,'%0.3f')], 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.20*(maxcor-mincor))+ mincor),[num2str(Fuc_AARE,'%0.3f')], 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.15*(maxcor-mincor))+ mincor),[num2str(Fuc_TS1/100,'%0.3f')], 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.10*(maxcor-mincor))+ mincor),[num2str(Fuc_TS25/100,'%0.3f')], 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.05*(maxcor-mincor))+ mincor),[num2str(Fuc_TS50/100,'%0.3f')], 'interpreter','latex', 'FontSize', FnZ)
text(Coor_X,((0.00*(maxcor-mincor))+ mincor),[num2str(Fuc_TS100/100,'%0.3f')], 'interpreter','latex', 'FontSize', FnZ)

% Summary metric 
SummaryVal = [  Nash,...
                Fuc_AME, Fuc_PDIFF, Fuc_MAE, Fuc_MSE, Fuc_RMSE, Fuc_R4MS4E, Fuc_RAE,...
                Fuc_PEP, Fuc_MARE, Fuc_MRE, Fuc_MSRE, Fuc_RVE, Fuc_R, Fuc_CE, Fuc_PBE/100,...
                Fuc_AARE, Fuc_TS1/100, Fuc_TS25/100, Fuc_TS50/100, Fuc_TS100/100];
            
%% Caudales
subplot(2,20,21:35)
plot(Date, obs,'k','LineWidth', 1.5)
hold on
plot(Date, sim,'-.','color',[0.5 0.5 0.5], 'LineWidth', 3)
datetick('x','yyyy')

xlabel('Tiempo','interpreter','latex','FontSize',22, 'FontWeight','bold');
ylabel('Caudal ${(m^3/Seg)}$','interpreter','latex','FontSize',22, 'FontWeight','bold');
le = legend('Obs', 'Sim');
set(le,'interpreter','latex','FontSize',25, 'FontWeight','bold')
set(gca, 'TickLabelInterpreter','latex','FontSize',28, 'FontWeight','bold')


%% Obs Vs Sim
subplot(2,20,37:40)
Limit   = max([max(obs); max(sim)]);
x       = [0; Limit];
plot(x,x,'k','LineWidth',1.5)
hold on
scatter(obs, sim, 10,[0.5 0.5 0.5],'filled')
axis([0 Limit 0 Limit])
xlabel('Qobs ${(m^3/Seg)}$','interpreter','latex','FontSize',22, 'FontWeight','bold');
ylabel('Qsim ${(m^3/Seg)}$','interpreter','latex','FontSize',22, 'FontWeight','bold');
set(gca, 'TickLabelInterpreter','latex','FontSize',25, 'FontWeight','bold')


