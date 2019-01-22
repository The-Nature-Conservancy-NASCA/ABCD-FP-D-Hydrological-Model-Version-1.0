function [Ti, varargout] = TemperatureFields(Z, T, Zi)
% -------------------------------------------------------------------------
% Matlab Version - R2018b 
% -------------------------------------------------------------------------
%                              BASE DATA 
% --------------------------------------------------------------------------
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
% --------------------------------------------------------------------------
% This program is free software: you can redistribute it and/or modify it 
% under the terms of the GNU General Public License as published by the 
% Free Software Foundation, either version 3 of the License, or option) any 
% later version. This program is distributed in the hope that it will be 
% useful, but WITHOUT ANY WARRANTY; without even the implied warranty of 
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
% ee the GNU General Public License for more details. You should have 
% received a copy of the GNU General Public License along with this program
% If not, see http://www.gnu.org/licenses/.
% --------------------------------------------------------------------------
%                               DESCRIPTION 
% --------------------------------------------------------------------------
% 
% This function estimates the temperature fields through one linear 
% regression
% 
% --------------------------------------------------------------------------
%                               INPUT DATA 
% --------------------------------------------------------------------------
% 
%   Z   [n,1] = Elevation of the Temperature gauges                     [m.s.n.m]
%   T   [n,1] = Temperature at each point with elevation Z              [Celsius]
%   Zi  [n,1] = Coordinates on the Z axis of the data to interpolation  [m.s.n.m]
% 
% --------------------------------------------------------------------------
%                              OUTPUT DATA 
% --------------------------------------------------------------------------
% 
%   Ti  [n,1] = Temperature estimates in each point Zi [Celsius]
%

%% Temperature Filter 
id      = T < 0;
T(id)   = NaN;

%% Data identifier with value
id      = isnan(T) == 0;

%% Fit lineal
Params  = polyfit(Z(id),T(id),1);

%% Interpolation 
Ti      = polyval(Params,double(Zi));

%% Error - [Nash-Sutcliffe]
Nash    = 1 - ((nanmean((T(id) - Ti)).^2)/nanvar(T(id)));
varargout{1} = Nash;

end
