% 05-2012
% Victor Barres
% USC Brain Project
% Checks the size of the brain mesh and offers the possibility to down
% sample if num vertices >10000 (OpenMEEG limitations).

function downSample(meshes,subjName,folder)


 n = getVertNum(meshes);
    nBrain = n(1);
    nTot = n(length(n));
    lim = 10000;
    fprintf('Total number of vertices: %i\n',nTot);
    save(sprintf('%s\\meshes',folder),'meshes');
    disp_mesh(subjName,'cortex');
    
    
    % Offering possibility to downsample the brain mesh if necessary
    flag = true;
    while nTot>lim && flag
        fprintf('The maximum number of vertices allowed by OpenMEEG is 10000!\n');
        answer = input('Would you like to reduce the size of the brain mesh?(yes/no)\n','s');
        if strcmp(answer,'yes')
            r = downSampling(nBrain,nTot,lim);
            fprintf('Suggested reduction fraction: %f\n',r);
            answer = input('Would you like to use this ratio?(yes/no)\n','s');
            if strcmp(answer,'no')
                r = input('ratio: ');
            end            
            p = patch('Faces',meshes.mesh(1).Faces,'Vertices',meshes.mesh(1).Vertices,'FaceColor','w');
            nfv = reducepatch(p,r);
            meshes.mesh(1).Faces = nfv.faces;
            meshes.mesh(1).Vertices = nfv.vertices;
            normals = defineNorm(meshes.mesh(1));
            meshes.mesh(1).vertNorm = normals;
            n = getVertNum(meshes);
            nBrain = n(1);
            nTot = n(length(n));
            fprintf('Total number of vertices: %i\n',nTot);
            save(sprintf('%s\\meshes',folder),'meshes');
            disp_mesh(subjName,'cortex');
        else
            flag = false;
        end      
    end
    
    answer = input('Would you like to reduce the size of the other meshes?(yes/no)\n','s');
    if strcmp(answer,'yes')
        for m =2:length(meshes.mesh)
            name = meshes.mesh(m).Comment;
            fprintf('%s:\n',name);
            n = getVertNum(meshes);
            fprintf('# vertices: %i\n',n(m));
            
            disp_mesh(subjName,name);        
            r = input('ratio: ');
            
            p = patch('Faces',meshes.mesh(m).Faces,'Vertices',meshes.mesh(m).Vertices,'FaceColor','w');
            nfv = reducepatch(p,r);
            meshes.mesh(m).Faces = nfv.faces;
            meshes.mesh(m).Vertices = nfv.vertices;
            normals = defineNorm(meshes.mesh(m));
            meshes.mesh(m).vertNorm = normals;
            n = getVertNum(meshes);
            fprintf('# vertices: %i\n',n(m));
            save(sprintf('%s\\meshes',folder),'meshes');
            disp_mesh(subjName,name);
        end
    end
    
    n = getVertNum(meshes);
    nTot = n(length(n));
    fprintf('Total number of vertices: %i\n',nTot);
    disp_mesh(subjName,'fullhead');

end

% This calculates the number of vertices in the head model
function n = getVertNum(meshes)
numMeshes = length(meshes.mesh);
n = zeros(numMeshes+1,1);
tot = 0;
for i=1:numMeshes
    n(i) = size(meshes.mesh(i).Vertices,1);
    tot = tot + n(i);
end
n(i+1) = tot;
end

function r = downSampling(nBrain,nTot,lim)
nOther = nTot-nBrain;
target = lim-nOther;
r = round(10*target/nBrain)/10;
end