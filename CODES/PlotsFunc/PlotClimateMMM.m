function Fig = PlotClimateMMM(Date, Data, TypeVar)
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
%                              INPUT DATA 
% -------------------------------------------------------------------------
%   Date      [1,n]       : Datetime of the Date 
%   Data      [1,n]       : Array of Data 
%   TypeVar   [integer]   : 0 - Streamflow
%                           1 - Precipitation
%                           2 - Temperature
%                           3 - Potential Evapotranspiration
%                           4 - Actual Evapotransoiration
%                           5 - Sunshine
%                           6 - Relative Humidity
%
% -------------------------------------------------------------------------
%                              OUTPUT DATA 
% -------------------------------------------------------------------------
% Fig [Object]  : Figure climate Multianual monthly average 
%

% Months
Month   = {'\bf ENE','\bf FEB','\bf MAR','\bf ABR','\bf MAY','\bf JUN',...
           '\bf JUL','\bf AGO','\bf SEP','\bf OCT','\bf NOV','\bf DIC'};
       
switch TypeVar
    case 0 % Streamflow
        NameLabel   = '\bf Streamflow ${(m^3/Seg)}$';
        ColorG      = [0 0.25 0.25];
        
    case 1 % Precipitation
        NameLabel   = '\bf Precipitation (mm)';
        ColorG      = [0 0.5 0.5];
        
    case 2 % Temperature 
        NameLabel   = '\bf Temperature (C)';
        ColorG      = 'red';
        
    case 3 % Potential Evapotranspiration
        NameLabel   = '\bf Potential Evapotranspiration (mm)';
        ColorG      = 'red';
        
    case 4 % Actual Evapotransoiration
        NameLabel   = '\bf Actual Evapotranspiration (mm)';
        ColorG      = 'red';
        
    case 5 % Sunshine
        NameLabel   = '\bf Sunshine (hr)';
        ColorG      = 'red';
        
    case 6 % Relative Humidity
        NameLabel   = '\bf Relative Humidity (Porc)';
        ColorG      = 'blue';
end
        
Y       = unique(year(Date));
DataTmp = NaN(length(Y),12);
M       = month(Date);

for i = 1:12
    Tmp = Data(M == i);
    DataTmp(1:length(Tmp),i) = Tmp; 
end

DataC   = [quantile(DataTmp,0.1); nanmean(DataTmp); quantile(DataTmp,0.95)];
Fig     = figure('color',[1 1 1], 'Visible','off');
T       = [20, 10];
set(Fig, 'Units', 'Inches', 'PaperPosition', [0, 0, T],'Position',...
    [0, 0, T],'PaperUnits', 'Inches','PaperSize', T,'PaperType','e')

DataTmp = [DataC(1,:); diff(DataC)];
n       = 0.8;
nm      = max(max(DataC')');
nmi     = min(min(DataC')');    

if TypeVar > 1
    h = area(DataTmp', nmi);
else
    h = area(DataTmp', 0);
end
h(3).FaceColor = ColorG;
h(2).FaceColor = ColorG;
h(1).FaceColor = ColorG;
h(1).FaceAlpha = 0.3;
h(2).FaceAlpha = 0.5;
h(3).FaceAlpha = 0.8;
ylabel(NameLabel, 'interpreter','latex', 'FontSize',30)

if TypeVar == 1
    axis([1 12 0 (nm + (0.05*nm))])
else
    axis([1 12 (nmi - (0.05*nmi)) (nm + (0.05*nm))])
end

set(gca, 'FontSize',28, 'Xticklabels', Month, 'ticklabelinterpreter','latex')
ln = legend('Dry','Average','Damp');
set(ln, 'interpreter','latex','FontSize',28)