% To pick the electrode associated with the ELAN, N400 and P600.

function TEST_lfTimeCourse()
subjName = 'Subj_Friederici_N100_3';
subjPath = sprintf('data\\%s',subjName);
load(sprintf('%s\\leadfield',subjPath));
load(sprintf('%s\\waveform',subjPath));

time = waveform(1).time;
lf = zeros(length(leadfield.lf),length(time));
for t =1:length(time)
    locLF = zeros(length(leadfield.lf),1);
    for d = 1:length(leadfield.dipLF)
        dipLF = leadfield.dipLF{d};
        locLF = locLF+dipLF*waveform(d).dA(t);
    end
    lf(:,t) =locLF;
end

save(sprintf('%s\\LFtimecourse',subjPath),'lf');
end