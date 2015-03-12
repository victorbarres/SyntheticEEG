% 06-2012
% Victor Barres
% USC Brain Project
% Run simulation

function run()
%Parameters
data_path = 'data';

% Create or load simulation
listOption = {'Create new sim', 'Load sim', 'Display conductivities options', 'Display electrodes options', 'Display atlases', 'Display ERP empirical data', 'Done!'};
prompt = 'Select option';
mode = 'single'

done_run = false;
while ~done_run
    option = getOption(listOption,prompt,mode);
    switch option.ind
        case 1
            sim_name = getInput('Enter simulation name:','Sim name','');
            sim_folder = sprintf('%s\\%s',data_path,sim_name);
            while isequal(exist(sim_folder, 'dir'),7)
                sim_name = inputSimName('Name already exist, enter another simulation name:');
                sim_folder = sprintf('%s\\%s',data_path,sim_name);
            end
            mkdir(sim_folder);
            fprintf('Simulation name: %s\n',sim_name);
            done_sim = false;
            sim_choice(sim_name, sim_folder, done_sim);
        case 2
            sim_name = getSubjName();
            sim_folder = sprintf('%s\\%s',data_path,sim_name);
            done_sim = false;
            sim_choice(sim_name, sim_folder, done_sim);
        case 3
            % Display conductivities options
            disp_conductivities();
        case 4
            % Display electrodes options
            disp_elec();
        case 5
            % Display atlases
            disp_atlas();
        case 6
            % Display ERP empirical data
            sed_ERP();
        case 7
            % DONE!
            done_run = true;
    end
    pause;
end
end

%%Function
function sim_choice(sim_name, sim_folder, done_sim)

while ~done_sim
    listOption = {'Select headmesh','Choose conductivities', 'Choose sensors', 'Create modules',...
                  'Create dipoles', 'Create circuits', 'Create forward activation values'...
                  'Create IRF', 'Generate boxcar timecourse', 'Generating waveform timecourse',...
                  'Generate leadfield', 'Generate EEG signal', 'Create EEG data for an electrode',...
                  'Display mesh', 'Display conductivities', 'Display sensors', 'Display modules',... 
                  'Display dipoles', 'Display IRF', 'Display brain circuit graph', 'Display dipoles boxcar', 'Display dipoles waveform',...
                  'Display area activity', 'Display leadfield', 'Done!'};
    prompt = 'Select option';
    mode = 'single';
    option = getOption(listOption,prompt,mode);
    switch option.ind
        case 1
            % Select headmesh
            mesh_name = 'MNI_Colin27';
            mesh_path = sprintf('data\\%s\\meshes.mat',mesh_name);
            copyfile(mesh_path,sprintf('%s\\meshes.mat',sim_folder));
            fprintf('headmesh selected: %s\n',mesh_name);
        case 2
            % Choose conductivities
            fprintf('Choosing conductivities\n');
            data_cond(sim_name);
        case 3
            % Choose sensors
            fprintf('Choosing sensors\n');
            data_sensors(sim_name);
        case 4
            % Create slabs (modules)
            fprintf('Creating modules\n');
            done_module = false;
            while ~done_module
                data_atlasSlab(sim_name);
                a =  input('Enter another module (yes/no)?\n','s');
                if strcmp(a,'yes')
                    done_module = false;
                elseif strcmp(a,'no')
                    done_module = true;
                else
                    error('incorrect entry');
                end
            end
        case 5
            % Create dipoles
            fprintf('Creating dipoles\n');
            data_dipoles(sim_name);
        case 6
            % Create circuits
            fprintf('Creating circuits\n');
            data_circuitsNet(sim_name);
        case 7
            % Create forward activation values
            fprintf('Create forward activation values\n');
            data_fwdActTimes(sim_name);
        case 8
            % Create impulse response function (IRF)
            fprintf('Creating IRF\n');
            data_IRF(sim_name);
        case 9
            % Generate dipoles' amplitude boxcar timecourse
            fprintf('Generating boxcar timecourse\n');
            data_dipBoxcar(sim_name);
        case 10
            % Generate dipoles' amplitude waveform timecourse
            fprintf('Generating waveform timecourse\n');
            data_sourceWave(sim_name);
        case 11
            % Generate leadfield for dipoles of amplitude 1
            fprintf('Generating leadfield\n');
            data_leadFieldGenerator(sim_name);
        case 12
            % Generate EEG signal based on dipoles amplitudes timecourses
            fprintf('Generating EEG signal\n');
            data_leadfield(sim_name);
        case 13
            % Create EEG data for an electrode
            fprintf('Generate EEG data for an electrode\n');
            data_elecEEG(); % Check what is the difference with data_elecEEG2()
        case 14
            % Display meshes
            disp_mesh(sim_name);
        case 15
            % Display conductivities
            disp_cond(sim_name);
        case 16
            % Display sensors
            disp_sensors(sim_name);
        case 17
            % Display modules
            disp_slab(sim_name);
        case 18
            % Display dipoles
            disp_dipoles(sim_name);
        case 19
            % Display IRF
            disp_IRF(sim_name);
        case 20
            % Display brain circuits graph
            disp_bcGraph(sim_name);
        case 21
            % Display dipoles boxcar
            disp_dBoxcar(sim_name);
        case 22
            % Display dipoles waveform
            disp_wave(sim_name);
        case 23
            % Display area activities
            disp_areadA(sim_name);
        case 24
            % Display leadfield
            disp_leadfield(sim_name)
        case 26
            % DONE!
            done_sim = true;
    end
    pause
end
end



