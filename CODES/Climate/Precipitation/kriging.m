function zi = kriging(vstruct,x,y,z,xi,yi,chunksize)
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
%               Carlos Andr閟 Rog閘iz 
%               Specialist in Integrated Analysis of Water Systems NASCA
%               carlos.rogeliz@tnc.org
%               
%               Jonathan Nogales Pimentel
%               Hydrology Specialist
%               jonathan.nogales@tnc.org
% 
% Date        : November, 2017
% 
% --------------------------------------------------------------------------
% This code was taken of  
% https://es.mathworks.com/matlabcentral/fileexchange/29025-ordinary-kriging
% Author        : Wolfgang Schwanghart (w.schwanghart[at]unibas.ch)
% E-mail    	: woodchips@rochester.rr.com
% Release date  : 13. October, 2010
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
% kriging uses ordinary kriging to interpolate a variable z measured at
% locations with the coordinates x and y at unsampled locations xi, yi.
% The function requires the variable vstruct that contains all
% necessary information on the variogram. vstruct is the forth output
% argument of the function variogramfit.
% 
% This is a rudimentary, but easy to use function to perform a simple
% kriging interpolation. I call it rudimentary since it always includes
% ALL observations to estimate values at unsampled locations. This may
% not be necessary when sample locations are not within the
% autocorrelation range but would require something like a k nearest
% neighbor search algorithm or something similar. Thus, the algorithms
% works best for relatively small numbers of observations (100-500).
% For larger numbers of observations I recommend the use of GSTAT.
% 
% Note that kriging fails if there are two or more observations at one
% location or very, very close to each other. This may cause that the 
% system of equation is badly conditioned. Currently, I use the
% pseudo-inverse (pinv) to come around this problem. If you have better
% ideas, please let me know.
% 
%--------------------------------------------------------------------------
%                               INPUT DATA 
%--------------------------------------------------------------------------
%
%     vstruct   structure array with variogram information as returned
%               variogramfit (forth output argument)
%     x,y       coordinates of observations
%     z         values of observations
%     xi,yi     coordinates of locations for predictions 
%     chunksize nr of elements in zi that are processed at one time.
%               The default is 100, but this depends largely on your 
%               available main memory and numel(x).
%
%--------------------------------------------------------------------------
%                              OUTPUT DATA 
%--------------------------------------------------------------------------
%
%     zi        kriging predictions
%     zivar     kriging variance
%
%--------------------------------------------------------------------------
%                             REFERENCES 
%--------------------------------------------------------------------------
%
% https://es.mathworks.com/matlabcentral/fileexchange/29025-ordinary-kriging
% Wackernagel, H. (1995): Multivariate Geostatistics, Springer.
% Webster, R., Oliver, M. (2001): Geostatistics for
% Environmental Scientists. Wiley & Sons.
% Minsasny, B., McBratney, A. B. (2005): The Matrn function as
% general model for soil variograms. Geoderma, 3-4, 192-207.
%

%%
% size of input arguments // tama帽o de los argumentos de entrada 
sizest = size(xi);
numest = numel(xi);
numobs = numel(x);

% force column vectors
xi = xi(:);
yi = yi(:);
x  = x(:);
y  = y(:);
z  = z(:);

if nargin == 6
    chunksize = 100;
elseif nargin == 7
else
    error('wrong number of input arguments')
end

% check if the latest version of variogramfit is used// Revisar si est谩 en uso la 煤ltima versi贸n de 'variogramfit'
if ~isfield(vstruct, 'func')
    error('please download the latest version of variogramfit from the FEX')
end


% variogram function definitions /Definici贸n de la funci贸n variograma 
switch lower(vstruct.model)    
    case {'whittle' 'matern'}
        error('whittle and matern are not supported yet');
    case 'stable'
        stablealpha = vstruct.stablealpha; %#ok<NASGU> % will be used in an anonymous function
end


% distance matrix of locations with known values// Distancia de las ubicaciones de la matriz con valores conocidos
Dx = hypot(bsxfun(@minus,x,x'),bsxfun(@minus,y,y'));


% // Si se tiene un modelo de variograma acotado, es conveniente definir las distancias que son superiores al rango.
% Desde ac谩 ser谩 el mismo y no necesitar谩 fuciones compuestas. 

% if we have a bounded variogram model, it is convenient to set distances
% that are longer than the range to the range since from here on the
% variogram value remains the same and we dont need composite functions.

switch vstruct.type
    case 'bounded'
        Dx = min(Dx,vstruct.range);
    otherwise
end

% now calculate the matrix with variogram values// Calcular la matriz con los valores del variograma 
A = vstruct.func([vstruct.range vstruct.sill],Dx);
if ~isempty(vstruct.nugget)
    A = A+vstruct.nugget;
end

%// La matriz debe ser expandida por una l铆nea y una columna para tener en cuenta la condici贸n.
%Todos los pesos deben sumar uno (Multiplicador de Lagrange)

% the matrix must be expanded by one line and one row to account for
% condition, that all weights must sum to one (lagrange multiplier)
A = [[A ones(numobs,1)];ones(1,numobs) 0];

% //'A' es frecuentemente mal condicionada. Por lo tanto se usar谩 
% el 'Pseudo-inverso para resolver la ecuaci贸n 

% A is often very badly conditioned. Hence we use the Pseudo-Inverse for
% solving the equations
A = pinv(A);

% we also need to expand z// Expansi贸n de z
z  = [z;0];

% allocate the output zi// Asignar la salida de zi
zi = nan(numest,1);

% parametrize engine// Parametrizaci贸n
nrloops   = ceil(numest/chunksize);

% now loop //BUCLE (Instrucciones de repetici贸n hasta que la condici贸n sea satisfecha)
for r = 1:nrloops

    % built chunks// Construcci贸n de fragmentos 
    if r<nrloops
        IX = (r-1)*chunksize + 1 : r*chunksize;
    else
        IX = (r-1)*chunksize +1 : numest;
        chunksize = numel(IX);
    end
    
    % build b// Contruir b
    b = hypot(bsxfun(@minus,x,xi(IX)'),bsxfun(@minus,y,yi(IX)'));
    
    % again set maximum distances to the range
    switch vstruct.type
        case 'bounded'
            b = min(vstruct.range,b);
    end
    
    % expand b with ones// Expandir 'b'
    b = [vstruct.func([vstruct.range vstruct.sill],b);ones(1,chunksize)];
    if ~isempty(vstruct.nugget)
        b = b + vstruct.nugget;
    end
    
    % solve system
    lambda = A*b;
    
    % estimate zi
    zi(IX)  = lambda'*z;
    
end

% reshape zi// Reshape (reconfiguraci贸n de zi)
zi = reshape(zi,sizest);

