function [bestx,bestf,allbest,allEvals] = sce(fctname,x0,bl,bu,ngs,userdata) 
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
% Shuffled Complex Evolution (SCE-UA) METHOD
%
% written (MATLAB)  by Q.Duan   09.2004
% sligthly modified by F.Anctil 01.2009
% lhs initialisation and Parallel version by D.Brochero 10.2015
%
% INPUTS
%  fctname = character string of the function to optimize
%  x0      = the initial parameter array at the start;
%          = the optimized parameter array at the end;
%  bl      = the lower bound of the parameters
%  bu      = the upper bound of the parameters
%  ngs     = number of complexes (sub-pop.)- between 2 and 20
%  userdata (optional) - for the function to optimize
%
%%% FA modifications
%
% 0. commented unused command lines
% 1. reduced the number of inputs by preselection
% 2. add the function name (to be optimized) to the input list
% 3. allow userdata to be passed to that function
% 4. keep track of each loop best f and x, and of number of trials
% 
% DB modifications
%
% 0. Parallel version of complex evaluations
% 1. options to change directly algorithm parameters 
% 2. default parameters if they are not defined
% 3. LHS initialisation of points
% 4. initial population (x0) is correctly included if it is definede
% 5. stop for convergency is fixed by including a return command
%
% % PRESELECTED INPUTS (by FA according to the recommendation of Duan)
% %
% maxn   = 10000 ;
% kstop  = 10 ;
% pcento = 0.1 ;
% peps   = 0.001;
% iniflg = 0 ;
%
%  maxn   = maximum number of function evaluations allowed during optimization
%  kstop  = maximum number of evolution loops before convergency
%  pcento = percentage change allowed in kstop loops before convergency
%  peps   = preselected samll parameter space
%  iniflg = flag for initial parameter array
%           ==1 include it in initial population; otherwise, not included)
%
% LIST OF LOCAL VARIABLES
%  f0        = objective fct value corresponding to the initial parameters
%            = objective fct value corresponding to the optimized parameters
%  npg       = number of members in a complex
%  nps       = number of members in a simplex
%  nspl      = number of evolution steps for each complex before shuffling
%  mings     = minimum number of complexes required during the
%              optimization process
%  x(.,.)    = coordinates of points in the population
%  xf(.)     = function values of x(.,.)
%  xx(.)     = coordinates of a single point in x
%  cx(.,.)   = coordinates of points in a complex
%  cf(.)     = function values of cx(.,.)
%  s(.,.)    = coordinates of points in the current simplex
%  sf(.)     = function values of s(.,.)
%  bestx(.)  = best point at current shuffling loop
%  bestf     = function value of bestx(.)
%  worstx(.) = worst point at current shuffling loop
%  worstf    = function value of worstx(.)
%  xnstd(.)  = standard deviation of parameters in the population
%  gnrng     = normalized geometri%mean of parameter ranges
%  lcs(.)    = indices locating position of s(.,.) in x(.,.)
%  bound(.)  = bound on ith variable being optimized
%  ngs1      = number of complexes in current population
%  ngs2      = number of complexes in last population
%  iseed1    = current random seed
%  criter(.) = vector containing the best criterion values of the last
%              10 shuffling loops
%
% 
% TODO: generate exemple and readme file to share easily this function

kstop  = 10 ;
peps   = 0.001;

% PRESELECTED INPUTS (by FA according to the recommendation of Duan)
%  ngs     = number of complexes (sub-pop.)- between 2 and 20
%  npg     = number of members in a complex
%  nps     = number of members in a simplex
%  nspl    = number of evolution steps for each complex before shuffling

if nargin < 6, userdata = []; end
if isfield(userdata,'maxIter'),     maxn        = userdata.maxIter;     else, maxn      = 10000;                    end
if isfield(userdata,'parRuns'),     Parallel    = userdata.parRuns;     else, Parallel  = 0;                        end
if isfield(userdata,'complexSize'), npg         = userdata.complexSize; else, npg       = max(ngs, 2*length(bl)+1); end
if isfield(userdata,'simplexSize'), nps         = userdata.simplexSize; else, nps       = length(bl)+1;             end
if isfield(userdata,'evolSteps'),   nspl        = userdata.evolSteps;   else, nspl      = npg;                      end
if isfield(userdata,'verbose'),     verbose     = userdata.verbose;     else, verbose   = 0;                        end
if isfield(userdata,'gain'),        pcento      = userdata.gain;        else, pcento    = 0.1;                      end

% impose row vectors
if size(bl,1) > 1, bl = bl'; end
if size(bu,1) > 1, bu = bu'; end

% number of variables to optimise
nopt    = length(bl);
npt     = npg * ngs ;
x       = zeros(npt,nopt);
bound   = bu-bl;

if nps <= 1, nps = 2; end
if npg <= 1, npg = 2; end

% nps cannot be greater than npg
if nps > npg, nps = npg; end

if isempty(x0)
    try
        % latin hypercube design for initial points
        rlhs = lhsdesign(npt, nopt);
        x = repmat(bl, npt, 1) + repmat(bound, npt, 1).*rlhs;
    catch
        x = repmat(bl, npt, 1) + repmat(bound, npt, 1).*rand(npt, nopt);
    end
else
    if size(x0,1) < npt
        try
            % latin hypercube design for initial points
            rlhs = lhsdesign(npt, nopt);
            x = repmat(bl, npt, 1) + repmat(bound, npt, 1).*rlhs;
        catch
            x = repmat(bl, npt, 1) + repmat(bound, npt, 1).*rand(npt, nopt);
        end
        x(1:size(x0,1),:) = x0;
    else
        x(1:npt,:) = x0(1:npt,:);
    end
end

if Parallelnloop
    parfor i=1:npt
        xf(i,1) = feval(fctname, x(i,:), userdata);
    end
else
    for i=1:npt
        xf(i,1) = feval(fctname, x(i,:), userdata);
    end
end
icall = npt;

% Sort the population in order of increasing function values;
[xf,idx]    = sort(xf);
x           = x(idx,:);

allEvals = [x xf];

% Record the best and worst points;
bestx   = x(1,:);       
bestf   = xf(1);
worstx  = x(npt,:);    
worstf  = xf(npt);
BESTF   = bestf;        
BESTX   = bestx;ICALL=icall;

% Computes the normalized geometric range of the parameters
gnrng = exp(mean(log((max(x)-min(x))./bound)));

if verbose
    disp('The Initial Loop: 0');
    disp(['BESTF  : ' num2str(bestf)]);
    disp(['BESTX  : ' num2str(bestx)]);
    disp(['WORSTF : ' num2str(worstf)]);
    disp(['WORSTX : ' num2str(worstx)]);
end

% Check for convergency;
if icall >= maxn
    if verbose
        disp('*** OPTIMIZATION SEARCH TERMINATED BECAUSE THE LIMIT');
        disp('ON THE MAXIMUM NUMBER OF TRIALS ');
        disp(maxn);
        disp('HAS BEEN EXCEEDED.  SEARCH WAS STOPPED AT TRIAL NUMBER:');
        disp(icall);
        disp('OF THE INITIAL LOOP!');
    end
    allbest = nan;
    return
end

if gnrng < peps
    %disp('THE POPULATION HAS CONVERGED TO A PRESPECIFIED SMALL PARAMETER SPACE');
end

% Begin evolution loops:
nloop           = 0;
criter          = [];
criter_change   = 1e+5;

while icall<maxn && gnrng>peps && criter_change>pcento
    nloop = nloop+1;
    
    % Loop on complexes (sub-populations);
    if Parallel
        
        % Complexes
        I = reshape(1:npt, ngs, []);
        
        parfor igs = 1: ngs
            
            c{igs}  = x(I(igs,:),:);
            cf{igs} = xf(I(igs,:));
            
            % Evolve sub-population
            
            for j = 1:nspl

                if nps == npg
                    lcs = 1:nps;
                else                
                    % Select subcomplex based on the uniform distribution
                    tmpIdx = randperm(npg);
                    tmpIdx(tmpIdx==1) = [];
                    if npg > nps
                        lcs = sort([1 tmpIdx(1:nps-1)]); % force to include first index
                    else
                        lcs = sort([1 tmpIdx]); % force to include first index
                    end
                end
                
                s = c{igs}(lcs,:);
                sf = cf{igs}(lcs);
                
                % Construct the simplex:
                [snew, fnew, Ficall{igs}(j)]=cce_ua(fctname,s,sf,bl,bu,0,userdata);
                
                % update s and sf
                s(end,:)    = snew;
                sf(end)     = fnew;
                
                % update lcs, s and sf
                [sf, idx]   = sort(sf);
                lcs         = lcs(idx);
                s           = s(idx, :);
                
                % update c for next evolution step
                c{igs}(lcs,:)   = s;
                cf{igs}(lcs)    = sf;
                
                % Sort the complex;
                [cf{igs},idx]   = sort(cf{igs});
                c{igs}          = c{igs}(idx,:);
                
            end
        end
        
        % Update icall and x outside parfor loop
        icall = icall + sum(cellfun(@sum,Ficall));
        
        % Replace the complexes back into the population;
        for i=1:ngs
            x(I(i,:),:) = c{i};
            xf(I(i,:))  = cf{i};
        end
        % End of Loop on Complex Evolution;
    else
        
        for igs = 1: ngs
            
            % Partition the population into complexes (sub-populations);
            k1          = 1:npg;
            k2          = (k1-1)*ngs+igs;
            cx(k1,:)    = x(k2,:);
            cf(k1)      = xf(k2);
            
            % Evolve sub-population igs for nspl steps:
            for loop = 1:nspl
                
                % Select simplex by sampling the complex according to a linear
                % probability distribution
                lcs(1) = 1;
                for k3=2:nps
                    for iter=1:1000
                        lpos    = 1 + floor(npg+0.5-sqrt((npg+0.5)^2 - npg*(npg+1)*rand));
                        idx     = (lcs(1:k3-1)==lpos); 
                        if isempty(idx) 
                            break 
                        end
                    end
                    lcs(k3) = lpos;
                end
                lcs = sort(lcs);
                
                % Construct the simplex:
                s=cx(lcs,:); sf = cf(lcs);
                
                [snew,fnew,icall]=cce_ua(fctname,s,sf,bl,bu,icall,userdata);
                
                % Replace the worst point in Simplex with the new point:
                s(nps,:)    = snew; sf(nps) = fnew;
                
                % Replace the simplex into the complex;
                cx(lcs,:)   = s;
                cf(lcs)     = sf;
                
                % Sort the complex;
                [cf,idx]    = sort(cf); 
                cx          =cx(idx,:);
                
                % End of Inner Loop for Competitive Evolution of Simplexes
            end
            
            % Replace the complex back into the population;
            x(k2,:) = cx(k1,:);
            xf(k2) = cf(k1);
            
            % End of Loop on Complex Evolution;
        end
    end
    
    % Shuffled the complexes;
    [xf,idx]    = sort(xf); 
    x           = x(idx,:);
    % PX=x; PF=xf;      % NOT USED - FA
    
    allEvals(nloop*npt+1:(nloop+1)*npt,:) = [x xf];
    
    % Record the best and worst points;
    bestx   = x(1,:); 
    bestf   = xf(1);
    worstx  = x(npt,:); 
    worstf  = xf(npt);
    BESTX   = [BESTX;bestx]; 
    BESTF   = [BESTF;bestf];
    ICALL   = [ICALL;icall];
    
    % Computes the normalized geometric range of the parameters
    gnrng=exp(mean(log((max(x)-min(x))./bound)));
    
    if verbose
        disp(['Evolution Loop: ' num2str(nloop) '  - Trial - ' num2str(icall)]);
        disp(['BESTF  : ' num2str(bestf)]);
        disp(['BESTX  : ' num2str(bestx)]);
        disp(['WORSTF : ' num2str(worstf)]);
        disp(['WORSTX : ' num2str(worstx)]);
    end
    
    % keep allbest (FA)
    allbest.f(nloop)     = bestf ;
    allbest.x(nloop,:)   = bestx ;
    allbest.trial(nloop) = icall ;
    
    % Check for convergency;
    if icall >= maxn
        if verbose
            disp('*** OPTIMIZATION SEARCH TERMINATED BECAUSE THE LIMIT');
            disp(['ON THE MAXIMUM NUMBER OF TRIALS ' num2str(maxn) ' HAS BEEN EXCEEDED!']);
        end
        return
    end
    
    if gnrng < peps
        if verbose
            disp('THE POPULATION HAS CONVERGED TO A PRESPECIFIED SMALL PARAMETER SPACE');
        end
        return
    end
    
    criter = [criter;bestf];
    if (nloop >= kstop)
        criter_change=abs(criter(nloop)-criter(nloop-kstop+1))*100;
        criter_change=criter_change/mean(abs(criter(nloop-kstop+1:nloop)));
        if criter_change < pcento
            if verbose
                disp(['THE BEST POINT HAS IMPROVED IN LAST ' num2str(kstop) ' LOOPS BY ', ...
                    'LESS THAN THE THRESHOLD ' num2str(pcento) '%']);
                disp('CONVERGENCY HAS ACHIEVED BASED ON OBJECTIVE FUNCTION CRITERIA!!!')
            end
            return
        end
    end
    
    % End of the Outer Loops
end

% remove repeated evaluations
allEvals = unique(allEvals, 'rows', 'stable');

if verbose
    disp(['SEARCH WAS STOPPED AT TRIAL NUMBER: ' num2str(icall)]);
    disp(['NORMALIZED GEOMETRIC RANGE = ' num2str(gnrng)]);
    disp(['THE BEST POINT HAS IMPROVED IN LAST ' num2str(kstop) ' LOOPS BY ', ...
        num2str(criter_change) '%']);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [snew,fnew,icall]=cce_ua(fctname,s,sf,bl,bu,icall,userdata)
%  This is the subroutine for generating a new point in a simplex
%
%   s(.,.) = the sorted simplex in order of increasing function values
%   s(.) = function values in increasing order
%
% LIST OF LOCAL VARIABLES
%   sb(.) = the best point of the simplex
%   sw(.) = the worst point of the simplex
%   w2(.) = the second worst point of the simplex
%   fw = function value of the worst point
%   ce(.) = the centroid of the simplex excluding wo
%   snew(.) = new point generated from the simplex
%   iviol = flag indicating if constraints are violated
%         = 1 , yes
%         = 0 , no

[nps,nopt] = size(s);
n = nps;

if isfield(userdata,'alpha'), alpha = userdata.alpha; else alpha = 1; end
if isfield(userdata,'beta'), beta = userdata.beta; else beta = 0.5; end
if isfield(userdata,'verbose'), verbose = userdata.verbose; else verbose = 0; end

% Assign the best and worst points:
% sb=s(1,:); fb=sf(1);      % NOT USED - FA
sw  = s(n,:); 
fw  = sf(n);

% Compute the centroid of the simplex excluding the worst point:
ce  = mean(s(1:n-1,:),1); % ,1 added to avoid problems with simplex of only two elements

% Attempt a reflection point
snew = ce + alpha*(ce-sw);

% Check if is outside the bounds:
ibound  = 0;
s1      = snew-bl;
idx     = (s1<0); 
if ~isempty(idx); ibound=1; end
s1      = bu-snew; 
idx=(s1<0); if ~isempty(idx); ibound=2; end

if ibound >=1
    snew = bl + rand(1,nopt).*(bu-bl);
end

fnew = feval(fctname, snew, userdata);

icall = icall + 1;

% Reflection failed; now attempt a contraction point:
if fnew > fw
    if verbose
        disp('Reflection failed; now attempt a contraction point')
    end
    snew    = sw + beta*(ce-sw);
    fnew    = feval(fctname, snew, userdata);
    icall   = icall + 1;
    
    % Both reflection and contraction have failed, attempt a random point;
    if fnew > fw
        if verbose
            disp('Both reflection and contraction have failed, attempt a random point')
        end
        
        snew    = bl + rand(1,nopt).*(bu-bl);
        fnew    = feval(fctname, snew, userdata);
        icall   = icall + 1;
    end
end
