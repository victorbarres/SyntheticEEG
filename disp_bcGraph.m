% 05-2012
% Victor Barres
% USC Brain Project
% Display Brain circuits graph


function disp_bcGraph(varargin)

if isempty(varargin)
    simName = getSimName();
else
    simName = varargin{1};
end

load(sprintf('simulations\\%s\\bcGraph',simName));

bcGraph.view;
end
