% 05-2012
% Victor Barres
% USC Brain Project
% Script to display a mesh or a full head model

function disp_mesh(varargin)

if isempty(varargin)
    subjName = getSubjName();
    meshType = getMeshType(subjName);
else
    subjName = varargin{1};
    meshType = varargin{2};
end

path = sprintf('data\\%s\\',subjName);
load(sprintf('%s\\meshes.mat',path));
numMeshes = length(meshes.mesh);

if strcmp(meshType,'fullhead')
    
    if numMeshes>4
        error('Number of meshes cannot exceed 4');
    end
    
    for i=1:numMeshes
        bnd(i).pnt = meshes.mesh(i).Vertices;
        bnd(i).tri = meshes.mesh(i).Faces;
    end
    
    figure('name','full head');
    set(gcf,'color','white');
    
    alpha = [1;0.5;0.3;0.1];
    colors = ['r';'b';'g';'w'];
%     alpha = [0.5;0.3;0.2;0];
%     colors = ['k';'k';'k';'w'];
    
    for i=1:numMeshes
        ft_plot_mesh(bnd(i),'facealpha',alpha(i),'facecolor',colors(i));
        light('Position',[100 0 0],'Style','infinite');
        light('Position',[0 0 100],'Style','infinite');
        light('Position',[0 100 0],'Style','infinite');
        lighting gouraud
    end
    
elseif strcmp(meshType,'realbrain')
    
    bnd.pnt = meshes.realMesh(1).Vertices;
    bnd.tri = meshes.realMesh(1).Faces;
    figure('name','real brain');
    set(gcf,'color','white');
    ft_plot_mesh(bnd,'facealpha',1,'facecolor','w');
    light('Position',[100 0 0],'Style','infinite');
    light('Position',[0 0 100],'Style','infinite');
    light('Position',[0 100 0],'Style','infinite');
    lighting gouraud

    
else
    flag = false;
    for i=1:numMeshes
        if strcmp(meshes.mesh(i).Comment,meshType)
            bnd.pnt = meshes.mesh(i).Vertices;
            bnd.tri = meshes.mesh(i).Faces;
            flag = true;
        end
    end
    
    if ~flag
        error('Undefined meshType')
    else
        figure('name',meshType);
        set(gcf,'color','white');
        ft_plot_mesh(bnd,'facealpha',1,'facecolor','r');
        light('Position',[100 0 0],'Style','infinite');
        light('Position',[0 0 100],'Style','infinite');
        light('Position',[0 100 0],'Style','infinite');
        lighting gouraud
    end
    
end

end