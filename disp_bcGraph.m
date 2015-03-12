% 05-2012
% Victor Barres
% USC Brain Project
% Display Brain circuits graph


function disp_bcGraph(varargin)

if isempty(varargin)
    subjName = getSubjName();
else
    subjName = varargin{1};
end

load(sprintf('data\\%s\\bcGraph',subjName));

bcGraph.view;
end
