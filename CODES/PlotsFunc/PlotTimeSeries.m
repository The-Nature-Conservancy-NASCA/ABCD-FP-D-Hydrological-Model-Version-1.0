function Fig = PlotTimeSeries(Date, Data, TypeVar, varargin)
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
% Fig [Object]  : Figure Time Series
%

Val = 0;
if nargin < 2, error('No Data'), end
if nargin > 3, P = varargin{1}; Val = 1; end

switch TypeVar
    case 0 % Streamflow
        NameLabel   = '\bf Streamflow ${(m^3/Seg)}$';
        ColorG      = [0 0.75 0.75];
        
    case 1 % Precipitation
        NameLabel   = '\bf Precipitation (mm)';
        ColorG      = [0 0.35 0.35];
        
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

%% Plot 
Fig     = figure('color',[1 1 1]);
T       = [25, 12];
set(Fig, 'Units', 'Inches', 'PaperPosition', [0, 0, T],'Position',...
[0, 0, T],'PaperUnits', 'Inches','PaperSize', T,'PaperType','e', 'Visible','off')

%% Precipitation
if Val == 1
    subplot(2,1,1);
    bar(Date, P,'FaceColor',[0.5 0.5 0.5])
    xlabel('Time','interpreter','latex','FontSize',22, 'FontWeight','bold');
    ylabel('Precipitation (mm)','interpreter','latex','FontSize',22, 'FontWeight','bold');
    datetick('x','yyyy')
    axis([min(Date) max(Date) 0 (max(P) + (max(P)*0.1))])
    xtickangle(45)
    set(gca, 'TickLabelInterpreter','latex','FontSize',28, 'FontWeight','bold')

end

if Val == 1
    subplot(2,1,2)
end

if TypeVar == 1
    bar(Date, Data,'FaceColor',[0.5 0.5 0.5])
    xlabel('Time','interpreter','latex','FontSize',22, 'FontWeight','bold');
    ylabel('Precipitation (mm)','interpreter','latex','FontSize',22, 'FontWeight','bold');
    datetick('x','yyyy')
    axis([min(Date) max(Date) 0 (max(Data) + (max(Data)*0.1))])
    xtickangle(45)
    set(gca, 'TickLabelInterpreter','latex','FontSize',28, 'FontWeight','bold')
else
    plot(Date, Data,'color',ColorG,'LineWidth', 1.5)
    xlabel('Time','interpreter','latex','FontSize',22, 'FontWeight','bold');
    ylabel(NameLabel,'interpreter','latex','FontSize',22, 'FontWeight','bold');
    datetick('x','yyyy')
    axis([min(Date) max(Date) 0 (max(Data) + (max(Data)*0.1))])
    xtickangle(45)
    set(gca, 'TickLabelInterpreter','latex','FontSize',28, 'FontWeight','bold')
end

