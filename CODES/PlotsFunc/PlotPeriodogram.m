function Fig = PlotPeriodogram(Date, Data)
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
%
% -------------------------------------------------------------------------
%                              OUTPUT DATA 
% -------------------------------------------------------------------------
% Fig [Object]  : Figure Periodogram
%

N   = length(Data);
n   = mod(N,2); 
if n~=0
    N       = N-1;
    Data    = Data(1:N);
    Date    = Date(1:N);
end

Temp    = 0:(N-1);
n       = repmat(Temp',[1 N]); 
k       = n';
Fr      = ((cos( (2 * pi * k .* n) / N ) * Data) / N);
Fi      = -((sin( (2 * pi * k .* n) / N ) * Data) / N);
F       = (Fr.^2) + (Fi.^2);
Fm      = F(2:floor(N/2),1);

K       = N./(0:(N-1))';
Km      = K(2:floor(N/2),1);
% years  

% Normalize Spectral Power
VarData = sum(F(2:end));
Fm      = Fm / VarData;

%% Plot 
Fig     = figure('color',[1 1 1]);
T       = [16, 8];
set(Fig, 'Units', 'Inches', 'PaperPosition', [0, 0, T],'Position',...
[0, 0, T],'PaperUnits', 'Inches','PaperSize', T,'PaperType','e', 'Visible','off')

%% Periodograma
h = area(Km, Fm);
h.FaceColor = [0 0.65 0.65];
h.FaceAlpha = 0.5;
hold on 
plot(Km, Fm,'k','Linewidth',1.2);
axis([min(Km) max(Km) 0 (max(Fm) + (0.05*max(Fm)))])
xlabel('\bf Years', 'interpreter', 'latex','fontsize',28)
ylabel('\bf Percentage Variance', 'interpreter', 'latex', 'fontsize',28)
set(gca,'TickLabelInterpreter','latex', 'Xscale','log','fontsize',25)

%% Time Series
axes('Position',[0.58 0.58 0.3 0.3]);
h = area(Date, Data);
h.FaceColor = [0.5 0.5 0.5];
h.FaceAlpha = 0.5;
hold on 
plot(Date, Data,'color',[0.2 0.2 0.2],'LineWidth', 1.2)
xlabel('Time','interpreter','latex','FontSize',18, 'FontWeight','bold');
ylabel('\bf Streamflow ${(m^3/Seg)}$','interpreter','latex','FontSize',18, 'FontWeight','bold');
datetick('x','yyyy')
axis([min(Date) max(Date) 0 (max(Data) + (max(Data)*0.1))])
xtickangle(45)
set(gca, 'TickLabelInterpreter','latex','FontSize',14, 'FontWeight','bold')