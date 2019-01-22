function [vstruct] = SemivariogramSetting(X, Y, P)
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
% This function estimates the Semivariogram required for building of the 
% precipitation fields through the Ordinary Kriging method.
%
%--------------------------------------------------------------------------
%                               INPUT DATA 
%--------------------------------------------------------------------------
%
% Data required for the construction of the semivarigram.
%   X [n,1] = Vector coordinates on the X axis of the base data [meters]
%   Y [n,1] = Vector coordinates on the Y axis of the base data [meters]
%   P [n,1] = Vector precipitation at each point X, Y           [mm]
%
%--------------------------------------------------------------------------
%                            OUTPUT DATA 
%--------------------------------------------------------------------------
%
%   vstruct  -> Teoric Semivariogram [Struct]
%       .range
%       .sill
%       .nugget
%       .model      - theoretical variogram
%       .func       - anonymous function of variogram model (only the
%                     function within range for bounded models)
%       .h          - distance
%       .gamma      - experimental variogram values
%       .gammahat   - estimated variogram values
%       .residuals  - residuals
%       .Rs         - R-square of goodness of fit
%       .weights    - weights
%       .exitflag   - see fminsearch
%       .algorithm  - see fminsearch
%       .funcCount  - see fminsearch
%       .iterations - see fminsearch
%       .message    - see fminsearch
%
% Property name/property values:
% 
%     'model'   a string that defines the function that can be fitted 
%               to the experimental variogram. 
% 
%               Supported bounded functions are:
%               'blinear' (bounded linear) 
%               'circular' (circular model)
%               'spherical' (spherical model, =default)
%               'pentaspherical' (pentaspherical model)
% 
%               Supported unbounded functions are:
%               'exponential' (exponential model)
%               'gaussian' (gaussian variogram)
%               'whittle' Whittle's elementary correlation (involves a
%                         modified Bessel function of the second kind.
%               'stable' (stable models sensu Wackernagel 1995). Same as
%                         gaussian, but with different exponents. Supply 
%                         the exponent alpha (<2) in an additional pn,pv 
%                         pair: 
%                        'stablealpha',alpha (default = 1.5).
%               'matern' Matern model. Requires an additional pn,pv pair. 
%                        'nu',nu (shape parameter > 0, default = 1)
%                        Note that for particular values of nu the matern 
%                        model reduces to other authorized variogram models.
%                        nu = 0.5 : exponential model
%                        nu = 1 : Whittles model
%                        nu -> inf : Gaussian model
%               
%               See Webster and Oliver (2001) for an overview on variogram 
%               models. See Minasny & McBratney (2005) for an introduction
%               to the Matern variogram.
%           
%     'nugget'  initial value (scalar) for nugget variance. The default
%               value is []. In this case variogramfit doesn't fit a nugget
%               variance. 
% 
%     'plotit'  true (default), false: plot experimental and theoretical 
%               variogram together.
% 
%     'solver'  'fminsearchbnd' (default) same as fminsearch , but with  
%               bound constraints by transformation (function by John 
%               D'Errico, File ID: #8277 on the FEX). The advantage in 
%               applying fminsearchbnd is that upper and lower bound 
%               constraints can be applied. That prevents that nugget 
%               variance or range may become negative.           
%               'fminsearch'
%
%     'weightfun' 'none' (default). 'cressie85' and 'mcbratney86' require
%               you to include the number of observations per experimental
%               gamma value (as returned by VARIOGRAM). 
%               'cressie85' uses m(hi)/gammahat(hi)^2 as weights
%               'mcbratney86' uses m(hi)*gammaexp(hi)/gammahat(hi)^3
%
%--------------------------------------------------------------------------
%                             REFERENCES 
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

%% Semivariograms models to evaluate
Models      = {'circular','spherical','gaussian'};

%% Construction of the emperic semivariogram 
id          = isnan(P) == 0;
v           = variogram([X(id) Y(id)], P(id),'plotit',false, 'nrbins',length(P(id)));
Distance    = v.distance;
Value       = v.val;

%% Select best Models 
Error       = NaN(length(Models),1);
for i = 1:length(Models)
    Error(i) = variogramfit(Distance,Value,[],[],[],'model',Models{i}); 
end

%% Best model
[~,vstruct] = variogramfit(Distance,Value,[],[],[],'model', Models{Error == nanmax(Error)});

end