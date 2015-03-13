% 05-2012
% Victor Barres
% USC Brain Project
% Script to create the source boxcar function for the dipoles from the
% slabs activation windows.

function data_dipBoxcar(varargin)

if isempty(varargin)
    simName = getSimName();
else
    simName = varargin{1};
end

simPath = sprintf('simulations\\%s',simName);
load(sprintf('%s\\dipoles',simPath));
load(sprintf('%s\\fwdActiv',simPath));

dip2slab = dipoles.dip2slab;
numPoints = length(fwdActiv.time);
bcNames = {fwdActiv.brainCircuit.name};
time = fwdActiv.time;

for d=1:length(dip2slab)
    list = dip2slab(d).names;
    dBoxcar(d).brainCircuits = list;
    dBoxcar(d).time = time;
    dBoxcar(d).boxcar = zeros(numPoints,1);
    for l=1:length(list)
        f = strcmp(bcNames,list{l});
        if ~isempty(f==1)
            dBoxcar(d).boxcar = dBoxcar(d).boxcar + fwdActiv.brainCircuit(f).boxcar;
        end
    end  
end


save(sprintf('%s\\dBoxcar',simPath),'dBoxcar');
disp_dBoxcar(simName);
end