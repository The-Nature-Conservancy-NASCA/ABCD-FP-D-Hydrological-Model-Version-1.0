function [PoPo] = GetNetwork( ArcID, Arc_InitNode, Arc_EndNode, ArcID_Downstream, PoPo)
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
% INPUT DATA
% -------------------------------------------------------------------------
%   ArcID               [n,1] = ID of each section of the network                                                   [Ad]
%   Arc_InitNode        [n,1] = Initial node of each section of the network                                         [Ad]
%   Arc_EndNode         [n,1] = End node of each section of the network                                             [Ad]
%   ArcID_Downstream    [n,1] = ID of the end node of accumulation                                                  [Ad]
%   PoPo                [n,1] = ID of each section of the network upstream of the ArcID_Downstream                  [Ad]
%   PoPoFlood           [n,1] = ID of each section of the network upstream of the ArcID_Downstream with floodplains [Ad]
%   IDFlood             [n,1] = ID of the section of the network with floodplain                                    [Ad]
%
% -------------------------------------------------------------------------
% OUTPUT DATA
% -------------------------------------------------------------------------
%   PoPo                [n,1] = ID of each section of the network upstream of the ArcID_Downstream                  [Ad]
%   PoPoFlood           [n,1] = ID of each section of the network upstream of the ArcID_Downstream with floodplains [Ad]

current_id      = ArcID_Downstream;
Posi            = find(ArcID == current_id);
PoPo(Posi)      = 1;
NumberBranches  = 1;

while NumberBranches == 1
    Posi            = find(Arc_EndNode == Arc_InitNode( Posi)); 
    NumberBranches  = length(Posi);

    if NumberBranches > 1           
        for i = 1:NumberBranches 
            start_sub_id        = ArcID( Posi(i));
            [PoPo]   = GetNetwork( ArcID, Arc_InitNode, Arc_EndNode, start_sub_id, PoPo);
            
        end
    end
    
end  