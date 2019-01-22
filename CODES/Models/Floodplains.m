function [Q, Vh, Ql, Rl] = Floodplains(P, ETP, Q, AreaFlood, Vh, Trp, Tpr, Q_Umb, V_Umb, b, Y )
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
% This function estimates the precipitation fields through the Ordinary 
% Kriging method.
%
%--------------------------------------------------------------------------
%                               INPUT DATA 
%--------------------------------------------------------------------------
%
%   P           [1,1]   = Precipitation                                         [mm]
%   ETP         [1,1]   = Potential Evapotranspiration                          [mm]
%   Q           [1,1]   = Streamflow                                            [m^3]
%   AreaFlood   [1,1]   = Area of the Floodplain                                [m^2]
%   Vh          [1,1]   = Volume of the floodplain Initial                      [mm]
%   Trp         [1,1]   = Percentage lateral flow between river and floodplain  [dimensionless]
%   Tpr         [1,1]   = Percentage return flow from floodplain to river       [dimensionless]
%   Q_Umb       [1,1]   = Threshold lateral flow between river and floodplain   [m^3]
%   V_Umb       [1,1]   = Threshold return flow from floodplain to river        [mm]
%   b           [1,1]   = Maximum Capacity of Soil Storage                      [dimensionless]
%   Y           [1,1]   = Evapotranspiration Potential                          [mm]
%
%--------------------------------------------------------------------------
%                              OUTPUT DATA 
%--------------------------------------------------------------------------
%
%   Q           [1,1]   = Streamflow                                 [m^3]
%   Vh          [1,1]   = Volume of the floodplain Initial           [mm]
%   Ql          [1,1]   = Lateral flow between river and floodplain  [mm]
%   Rl          [1,1]   = Return flow from floodplain to river       [mm]
%
%--------------------------------------------------------------------------
%                              REFERENCES
%--------------------------------------------------------------------------
%
% Floodplains hydrologic dynamics (Angarita, 2017)
% http://revistas.javeriana.edu.co/index.php/iyu/article/view/1137/807
%

%% Lateral flow between river and floodplain
if Q > Q_Umb
    Ql = Trp * (Q - Q_Umb);
else
    Ql = 0;
end

%% Return flow from floodplain to river
if Vh > V_Umb
    Rl = Tpr * (Vh - V_Umb);
else
    Rl = 0;
end

%% Actual Evapotrasnpiration
ETR     = Y * (1 - exp((-ETP) / b) );

%% Streamflow
Q       = Q - Ql + Rl;

%% Volume of the floodplain
Vh      = Vh + Ql - Rl + (AreaFlood*((P - ETR)/1000));

%% Filter
if Vh < 0 
    Vh = 0;
end
