function [Pi] = PrecipitationFields(X, Y, P, Xi, Yi, vstruct)
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
%--------------------------------------------------------------------------
%                               DESCRIPTION 
%--------------------------------------------------------------------------
%
% This function estimates the precipitation fields through the Ordinary 
% Kriging method.
%
%--------------------------------------------------------------------------
%                               INPUT DATA 
%--------------------------------------------------------------------------
%
% Data required for the construction of the semivarigram.
%   X       [n,1]       = Coordinates on the X axis of the base data            [meters]
%   Y       [n,1]       = Coordinates on the Y axis of the base data            [meters]
%   P       [n,1]       = Precipitation at each point X, Y                      [mm]
%   Xi      [n,1]       = Coordinates on the Xi axis of the data to interpolate [meters]
%   Yi      [n,1]       = Coordinates on the Yi axis of the data to interpolate [meters]
%   vstruct [struct]    = Teoric Semivariogram
%
% Coordinates of the points to interpolate.
%
%--------------------------------------------------------------------------
%                              OUTPUT DATA 
%--------------------------------------------------------------------------
%
%   Pi [n,1] = Precipitation interpolate in the points of coordinates Xi & Yi [mm]
%
%--------------------------------------------------------------------------
%                              REFERENCES
%--------------------------------------------------------------------------
%
% https://es.mathworks.com/matlabcentral/fileexchange/29025-ordinary-kriging
% https://es.mathworks.com/matlabcentral/fileexchange/25948-variogramfit
% https://es.mathworks.com/matlabcentral/fileexchange/20355-experimental-semi-variogram
% Wackernagel, H. (1995): Multivariate Geostatistics, Springer.
% Webster, R., Oliver, M. (2001): Geostatistics for
% Environmental Scientists. Wiley & Sons.
% Minsasny, B., McBratney, A. B. (2005): The Matrn function as
% general model for soil variograms. Geoderma, 3-4, 192-207.
%

%% Construction of the emperic semivariogram 
id = (isnan(P) == 0);

%% Interpolation
if length(X(id)) > 500000
    Chunksize   =  500000;
    [Pi,~]      = kriging(vstruct, X(id), Y(id), P(id), Xi, Yi, Chunksize);
else
    Chunksize   = length(X(id));
    Pi          = kriging(vstruct, X(id), Y(id), P(id), Xi, Yi, Chunksize);
end

%% Filters
Pmax            = max(P(id));
Pi(Pi < 1)      = 0;
Pi(Pi > Pmax)   = Pmax;
end