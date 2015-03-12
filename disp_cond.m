% 05-2012
% Victor Barres
% USC Brain Project
% Script to display the conductivities chosend for a subject

function disp_cond(varargin)

if isempty(varargin)
    subjName = getSubjName();
else
    subjName = varargin{1};
end

subjPath = sprintf('data\\%s',subjName);
load(sprintf('%s\\cond',subjPath));
fprintf('Cond name: %s\n',cond.name);
fprintf('CondValues:\n');
disp(cond.vals);


end
