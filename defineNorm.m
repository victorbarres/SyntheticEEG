% 05-2012
% Victor Barres
% USC Brain Project
% Return the normal vectors for every vertex of a mesh
% Orientation = mean orientation
% Norm = Sum(area of the triangular faces it belongs to)
% Normals are given as oriented inward

function [vertNorm,faceNorm,barycenters] = defineNorm(mesh)

vertices = mesh.Vertices;
faces = mesh.Faces;

[faceNorm,barycenters] = normDef(faces,vertices);
vertNorm = zeros(size(vertices)); % To keep the normal of the vertices
for vertex = 1:size(vertices,1)
    vertFaces = findFaces(faces,vertex); % look for the faces using this vertex
    N = zeros(length(vertFaces),3);
    areas = zeros(length(vertFaces),1);
    for i=1:length(vertFaces)
        a = norm(faceNorm(vertFaces(i),:));
        N(i,:) = faceNorm(vertFaces(i),:)/norm(faceNorm(vertFaces(i),:));
        areas(i) = 1/3*a;
    end
    orientation = mean(N,1);
    area = sum(areas,1);
    normal = orientation*area;
    vertNorm(vertex,:) = normal; % Each triangular face contribute to the normal of the vertex for a third of its area only!
end

end

% This function returns the value of the normal vector to all the
% faces define as cross product (length  = area of the face). It also returns the barycenters of the faces
function [normVec,barycenters] = normDef(faces,vertices)
    normVec = zeros(size(faces));
    barycenters = zeros(size(faces));
    for i=1:size(normVec,1)
        face = faces(i,:);
        p1 = vertices(face(1),:);
        p2 = vertices(face(2),:);
        p3 = vertices(face(3),:);
        barycenters(i,:) = (p1+p2+p3)/3;
        n = cross(p2-p1,p3-p1); % I assumed that the triangular meshes were defined in a rather clever way!!!!
        normVec(i,:) = n/2; % Area triangle ABC = ABxAC/2
    end
end


% This function returns all the indices of all the faces that contain the
% given vertex
function faceList = findFaces(faces,vertex)
    sidesNum = size(faces,2);
    
    faceList = [];
    
    for i=1:sidesNum
        indices = find(faces(:,i)==vertex)';
        faceList = [faceList,indices];
    end
end