function [VAc, Esc, ETR, StatesMT, StatesMF] = HMO(Date, P, ETP, DemandSup, DemandSub, Returns,...
                                                BasinArea, FloodArea, ArcID, Arc_InitNode, Arc_EndNode,...
                                                ArcID_Downstream, a, b, c, d, Tpr, Trp, Q_Umb, V_Umb,...
                                                IDExtAgri, IDExtDom, IDExtLiv, IDExtHy, IDExtMin,...
                                                IDRetAgri, IDRetDom, IDRetLiv, IDRetHy, IDRetMin,...
                                                ParamExtSup, Sw, Sg, Vh, IDAq)
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
% ABCD-FP-D Model 
%--------------------------------------------------------------------------
%                               INPUT DATA 
%--------------------------------------------------------------------------
%
%   Date                [t,1]           = Date                                                  [Datenum]
%   P                   [t,Cat]         = Precipitation                                         [mm]
%   ETP                 [t,Cat]         = Potential Evapotranspiration                          [mm]
%   DemandSup           [t,Cat]         = Demand                                                [m^3]
%   DemandSub           [t,Cat]         = Groundwater Demand                                    [m^3]
%   Returns             [t,Cat]         = Returns                                               [m^3]
%   BasinArea           [Cat,1]         = Basin Area                                            [m^2]
%   FloodArea           [t,Cat]         = Floodplain Area                                       [m^2]
%   ArcID               [t,Cat]         = ID of each section of the network                     [Ad]
%   Arc_InitNode        [t,Cat]         = Initial node of each section of the network           [Ad]
%   Arc_EndNode         [t,Cat]         = End node of each section of the network               [Ad] 
%   ArcID_Downstream    [t,Cat]         = ID of the end node of accumulation                    [Ad]
%   a                   [Cat,1]         = Soil Retention Capacity                               [Ad]
%   b                   [Cat,1]         = Maximum Capacity of Soil Storage                      [Ad]
%   c                   [Cat,1]         = Flow Fraction Soil - Aquifer                          [Ad]
%   d                   [Cat,1]         = Flow Fraction Aquifer - Soil                          [Ad]
%   Tpr                 [CatFlood,1]    = Percentage return flow from floodplain to river       [Ad]
%   Trp                 [CatFlood,1]    = Percentage lateral flow between river and floodplain  [Ad]
%   Q_Umb               [CatFlood,1]    = Threshold lateral flow between river and floodplain   [mm]
%   V_Umb               [CatFlood,1]    = Threshold return flow from floodplain to river        [mm]
%   IDExtAgri           [Cat,1]         = ID of the HUA where to extraction Agricultural Demand [Ad]
%   IDExtDom            [Cat,1]         = ID of the HUA where to extraction Domestic Demand     [Ad]
%   IDExtLiv            [Cat,1]         = ID of the HUA where to extraction Livestock Demand    [Ad]
%   IDExtMin            [Cat,1]         = ID of the HUA where to extraction Mining Demand       [Ad]
%   IDExtHy             [Cat,1]         = ID of the HUA where to extraction Hydrocarbons Demand [Ad]
%   IDRetDom            [Cat,1]         = ID of the HUA where to return Domestic Demand         [Ad]
%   IDRetLiv            [Cat,1]         = ID of the HUA where to return Livestock Demand        [Ad]
%   IDRetMin            [Cat,1]         = ID of the HUA where to return Mining Demand           [Ad]
%   IDRetHy             [Cat,1]         = ID of the HUA where to return Hydrocarbons Demand     [Ad]
%   ArcIDFlood          [CatFlood,1]    = ID basins with floodplain                             [Ad]
%   ParamExtSup         [Cat,1]         = Percentage of Superficial Extraction                  [Ad]
%   Sw                  [Cat,1]         = Soil Moinsture                                        [mm]
%   Sg                  [Cat,1]         = Aquifer Storage                                       [mm]
%   Vh                  [CatFlood,1]    = Volume of the floodplain Initial                      [mm]
%   IDAq                [Cat,1]         = ID Aquifer                                            [Ad]
%
% -------------------------------------------------------------------------
%                               OUTPUT DATA
% -------------------------------------------------------------------------
%   VAc                 [Cat,15,t]      = Cumulative variables
%   ETR                 [t,Cat]         = Actual Evapotranspiration                 [mm]
%   StatesMT            [t,Cat,6]       = States Variable of the Thomas Model       [mm]
%   StatesMF            [t,Cat,3]       = States Variable of the Floodplains Model  [mm]

%% PARAMETERS 
% Normal Year
DayMothNor  = [31 28 31 30 31 30 31 31 30 31 30 31];

% Leap-Year
DayMothBis  = [31 29 31 30 31 30 31 31 30 31 30 31];

% Factor mm -> m
Factor      = 1/1000;

% States Variables Floodplains Models
Ql          = zeros(length(Vh),1);
Rl          = zeros(length(Vh),1);

% [Vh] mm -> m3
Vh          = (Vh.*Factor).*FloodArea;

% [V_Umb] mm -> m3
V_Umb       = (V_Umb.*Factor).*FloodArea;

%% MODEL PARAMETERS
nTime       = length(Date);
nBasin      = length(ArcID);
nDemand     = length(DemandSup(1,1,:));
nReturn     = length(Returns(1,1,:));

% streamflo Storage 
Esc        = zeros(nTime,nBasin);

% Actual Evapotranspiration Storage
ETR         = zeros(nTime,nBasin);

% States Varibles Thomas Model 
StatesMT    = zeros(nTime,nBasin,6);

% States Varibles Floodplains Model 
StatesMF    = zeros(nTime,nBasin,3);

% Floodplain value b -thomas
b_i         = b;

% 3 = Streamflow + Basin Area + Streamflow
NumberVarAccum  = 0;
VAc             = zeros(nBasin,(3 + nDemand + nReturn + NumberVarAccum), nTime);

for i = 1:nTime
   
    % Precipitation 
    P_i      = P(i,:)';
    
    % Evapotranspiration
    ETP_i    = ETP(i,:)';
    
    %% Thomas Model
    % Esc [mm];  ETR [mm];  States [mm]
    [Esc(i,:), ETR(i,:), StatesMT(i,:,:)] = Thomas(P_i, ETP_i, a, b, c, d, Sw, Sg);
    
    % Volumen Basin mm -> [m^3] 
    Vsim        = (Esc(i,:)'.*Factor) .* (BasinArea);
    
    %% Demand    
    % Total Superficial Demand [m^3]
    DemandSup_i = bsxfun(@times, reshape(DemandSup(i,:,:), nBasin, nDemand) , ParamExtSup);
    
    % Total Superficial Returns [m^3]
    Returns_i   = reshape(Returns(i,:,:), nBasin, nReturn);
    
    %% Model FloodPlains
    % Water avelable [mm]
    Y_i         = StatesMT(i,:,3)';
    
    AccumVar    = [Vsim BasinArea DemandSup_i Returns_i Vsim];
    
    for Dstrem = 1:length(ArcID_Downstream)
        % Id Basin by Arcid Downstream
        PoPo        = zeros(length(ArcID),1); 
        
        [VAcc, Vh_i,Ql_i,Rl_i, PoPo ] =  Network(ArcID,...              % Code Basin - ArcID
                                         Arc_InitNode,...               % From node
                                         Arc_EndNode,...                % To Node
                                         ArcID_Downstream(Dstrem),...   % ArcID Downstream
                                         AccumVar,...                   % AccumVar
                                         AccumVar,...                   % AccumVar
                                         FloodArea,...                  % Area Floodplains
                                         IDExtAgri,...                  % id Extract Agricultural
                                         IDExtDom,...                   % id Extract Domestic
                                         IDExtLiv,...                   % id Extract Livestock
                                         IDExtHy,...                    % id Extract Hydrocarbons
                                         IDExtMin,...                   % id Extract Mining
                                         IDRetAgri,...                  % id Returns Agricultural
                                         IDRetDom,...                   % id Returns Domestic
                                         IDRetLiv,...                   % id Returns Livestock
                                         IDRetHy,...                    % id Returns Hydrocarbons
                                         IDRetMin,...                   % id Returns Mining
                                         P_i,...                        % Precipitation
                                         ETP_i,...                      % Evapotranspiration
                                         Vh,...                         % Volume of the floodplain Initial
                                         Ql,...                         % Thershold between the river and floodplains 
                                         Rl,...                         % Thershold between the floodplains and river
                                         Trp,...                        % Percentage lateral flow between river and floodplain   
                                         Tpr,...                        % Percentage return flow from floodplain to river
                                         Q_Umb,...                      % Threshold lateral flow between river and floodplain
                                         V_Umb,...                      % Threshold return flow from floodplain to river
                                         b_i,...                        % Maximum Capacity of Soil Storage
                                         Y_i,...                        % State Variable Thomas Model
                                         PoPo,...                       % ID Basin
                                         ArcID_Downstream(Dstrem));     % ArcID Downstream


        VAc(PoPo == 1,:,i)      = VAcc(PoPo == 1,:);
        StatesMF(i,PoPo == 1,:) = [Vh_i(PoPo == 1), Ql_i(PoPo == 1), Rl_i(PoPo == 1)];
        
    end
        
    % streamflow m^3/seg;
    if leapyear(year(Date(i))) == 0 
        FactorQ = (DayMothNor(month(Date(i)))*24*3600);
    else 
        FactorQ = (DayMothBis(month(Date(i)))*24*3600);
    end 
    
    % Streamflow m3 -> m3/seg
    VAc(:,1,i)  = VAc(:,1,i)/FactorQ;
    VAc(:,end,i) = VAc(:,end,i)/FactorQ;
    
    DemandSub_i = DemandSub(1,:)';
    
    % Subtract Demands Underground
    id = unique( IDAq );
    for j = 1:length(id)
        Tmp             = find((IDAq  == id(j))) ;
        
        % Verificar las unidades del area que sean en [m^2]
        BasinAreaTmp    = BasinArea( Tmp );
        Rg              = StatesMT(i,Tmp,5)';
        
        % Demand Underground
        VolDemSub       = DemandSub_i( Tmp  );
        VolDemSub       = sum(VolDemSub(isnan(VolDemSub)==0));
        
        % Volumen Aquifer [m^3]
        Vol_Sub         = (Rg / 1000) .* BasinAreaTmp;
        Vol_Sub         = sum( Vol_Sub(isnan(Vol_Sub)==0) )';
        
        % Distribution Basin
        Porc            = Rg /sum(Rg);
        
        % Update State Variable [mm]
        StatesMT(i,Tmp,5)   = ((( Vol_Sub - VolDemSub ) .* Porc)./BasinAreaTmp)*1000;
    end
    
    Sw  = reshape(StatesMT(i,:,1), nBasin, 1);
    Sg  = reshape(StatesMT(i,:,2), nBasin, 1);
    Vh  = Vh_i;
    
end

end

function [ status ] = leapyear( year )
    
if mod(year, 400) == 0
    status = 1;
elseif mod(year, 4) == 0 && mod(year, 100) ~= 0
    status = 1;
else
    status = 0;
end

end


