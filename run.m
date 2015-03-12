% 06-2012
% Victor Barres
% USC Brain Project
% Run simulation

function run()
%Parameters
data_path = 'data';

% Create simulation folder
sim_name = inputSimName('Enter simulation name:');
sim_folder = sprintf('%s\\%s',data_path,sim_name);
while isequal(exist(sim_folder, 'dir'),7)
    sim_name = inputSimName('Name already exist, enter another simulation name:');
    sim_folder = sprintf('%s\\%s',data_path,sim_name);
end
mkdir(sim_folder);
fprintf('Simulation name: %s\n',sim_name);

% Select headmesh
mesh_name = 'MNI_Colin27';
mesh_path = sprintf('data\\%s\\meshes.mat',mesh_name);
copyfile(mesh_path,sprintf('%s\\meshes.mat',sim_folder));
fprintf('headmesh selected: %s\n',mesh_name);

pause

% Choose conductivities
fprintf('Choosing conductivities\n');
data_cond(sim_name);
pause

% Choose sensors
fprintf('Choosing sensors\n');
data_sensors(sim_name);
pause

% Create slabs (modules)
fprintf('Creating modules\n');
data_atlasSlab(sim_name);
pause

% Create dipoles
fprintf('Creating dipoles\n');
data_dipoles(sim_name);

% Create circuits
fprintf('Creating circuits\n');
data_circuitsNet(sim_name);
pause

% Create forward activation values
fprintf('Create forward activation values\n');
data_fwdActTimes(sim_name);
pause

% Create impulse response function (IRF)
fprintf('Creating IRF\n');
data_IRF(sim_name);
pause

% Generate dipoles' amplitude boxcar timecourse
fprintf('Generating boxcar timecourse\n');
data_dipBoxcar(sim_name);
pause

% Generate dipoles' amplitude waveform timecourse
fprintf('Generating waveform timecourse\n');
data_sourceWave(sim_name);
pause

% % Generate leadfield for dipoles of amplitude 1
% fprintf('Generating leadfield\n');
% data_leadFieldGenerator(sim_name);
% 
% % Generate EEG signal based on dipoles amplitudes timecourses
% fprintf('Generating EEG signal\n');
% data_leadfield(sim_name);
% 
% % Create EEG data for an electrode
% fprintf('Generate EEG data for an electrode\n');
% data_elecEEG(); % Check what is the difference with data_elecEEG2()
end


%% Functions
function name = inputSimName(prompt)
s = {};
while size(s)==0
    prompt = {prompt};
    dlg_title = 'Sim name';
    num_lines = 1;
    def = {''};
    options.Resize='on';
    options.WindowStyle='normal';
    s = inputdlg(prompt,dlg_title,num_lines,def,options);
end
name = s{1};
end



