% 05-2012
% Victor Barres
% USC Brain Project
% Script to display the conductivity values

function disp_conductivities()
load('data\\conductivities\\conduct.mat')

fprintf('%s\n',conduct.comment)
fprintf('Unit: %s\n\n',conduct.unit);
for i=1:length(conduct.cond)
    fprintf('Reference: %s\n',conduct.cond(i).ref);
    fprintf('Compartment\t\tminCond\tmaxCond\n');
    for j=1:length(conduct.cond(i).compartment)
        fprintf('%s\t\t%f\t%f\n',conduct.cond(i).compartment{j},conduct.cond(i).val(j,1),conduct.cond(i).val(j,2));
    end
    fprintf('\n\n');
end

end