function Fig = PlotIndex(Qbase,QSce)
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
%                              INPUT DATA 
% -------------------------------------------------------------------------
%   Q [n,1] : Streamflow (m3/seg)
%
% -------------------------------------------------------------------------
%                              OUTPUT DATA 
% -------------------------------------------------------------------------
% Fig [Object]  : Figure Duration Curve
%

% check Input Data 
if nargin < 1, error('No Data'), end

DataP               = [5 10 25 75 99];

[Por_Q,Qd]          = hist(Qbase,length(unique(Qbase)));
[Qsort_base, id ]   = sort(Qd, 'descend');
PQ_base             = (cumsum(Por_Q(id))/sum(Por_Q(id)))*100;
[~, id]             = unique(PQ_base);

DataQ_Base          = interp1(PQ_base(id), Qsort_base(id), DataP);

[Por_Q,Qd]          = hist(QSce,length(unique(QSce)));
[Qsort_Sce, id ]    = sort(Qd, 'descend');
PQ_Sce              = (cumsum(Por_Q(id))/sum(Por_Q(id)))*100;
[~, id]             = unique(PQ_Sce); 

DataQ_Sce           = interp1(PQ_Sce(id), Qsort_Sce(id), DataP);

%% Plot
Fig     = figure('color',[1 1 1], 'Visible','on');
T       = [15, 8];
set(Fig, 'Units', 'Inches', 'PaperPosition', [0, 0, T],'Position',...
    [0, 0, T],'PaperUnits', 'Inches','PaperSize', T,'PaperType','e')

Im = (Qsort_base - Qsort_Sce) < 0;

plot(PQ_base, Qsort_base)
hold on 
plot(PQ_Sce, Qsort_Sce)

subplot(1,20,1:17)
h = area(PQ, Qsort);
h.FaceColor = 'y';
h.FaceAlpha = 0.5;
hold on 
plot(PQ, Qsort,'k','Linewidth',2);
axis([0 100 0 max(Qsort)])
xlabel('\bf Percentage Frequency', 'interpreter', 'latex','fontsize',30)
ylabel('\bf Streamflow ${\bf (m^3/seg)}$', 'interpreter', 'latex', 'fontsize',30)
set(gca,'TickLabelInterpreter','latex', 'fontsize',25)

ly = 0.95:-0.05:0.9 -(0.05*(length(DataQ)-1));
plot(DataP,DataQ, 'r*')
plot(DataP,DataQ, 'ro')
for i = 1:length(DataP)
    text(10 ,(ly(i)*max(Qsort)), ...
        ['\bf Q',num2str(DataP(i),'%0.0f'),' = ', num2str(DataQ(i),'%0.2f')],  'interpreter', 'latex', 'fontsize',15)
end

subplot(1,20,19:20)
boxplot(Q, 'PlotStyle','compact')
set(gca,'XTick',1,'XTickLabel','\bf Boxplot', 'TickLabelInterpreter','latex', 'fontsize',20)

axes('Position',[0.46 0.58 0.3 0.3]);
h = histogram(Q);
h.FaceColor = [0 0.5 0.5];
h.FaceAlpha = 0.5;
set(gca,'TickLabelInterpreter','latex', 'fontsize',20)
ylabel('\bf Frecuency', 'interpreter', 'latex','fontsize',20)
xlabel('\bf Streamflow ${\bf (m^3/seg)}$', 'interpreter', 'latex', 'fontsize',20)
