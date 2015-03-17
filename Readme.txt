----------------------- SynERP 2012 -----------------------------------
-------------------- USC Brain Project --------------------------------
by Victor Barres

Last updated
2012-05-15

1. Softaware prerequisite

	1.1. FieldTrip
FieldTrip must be installed.
http://fieldtrip.fcdonders.nl/
FieldTrip provides the Matlab environment for EEG processing

	1.2. OpenMEEG
OpenMEEG must be installed in order to be able to use it to compute the
forward model solution using their BEM algorithm.
http://fieldtrip.fcdonders.nl/

	1.3. PickAtlas
Pickatlas based on Talairach daemon and provided by ANSIR laboratory is used to extract the masks for brain regions.
http://fmri.wfubmc.edu/software/PickAtlas
It requires the installation of SPM.
http://www.fil.ion.ucl.ac.uk/spm/

Other atlases can be used.
The synERP package does not provide direct tools to define the masks. We relied on the above packages.

NOTE: the masks need to be in MNI coordinates.


2. Data

	2.1.Meshes

Gifti folder provides the meshes associated with Collins20 head model (MNI) in the gifti format.
The current version of the program works with such meshes given in Cubic space.

Meshes folder provides the .mat files associated with the .gii in the gifti folder, after transformation
using gifti_convert.

	2.2 Masks
We provide a series of masks for brain regions created using wfu pickatlas (see above).
They are given in MNI space, and therefore need to be converted to Cubic space.'
The MNI_T1.mat provides the coordinate transformation matrix MNI_Space -> Cubic_Space

3. Scripts

	3.1.Functions

gifti_convert.m
	This function converts a gifti structure into a triangle mesh structure
	OpenMEEG friendly!!
	A triangle mesh, for OpenMEEG, requires to give the normal of the vertices which is
	defined as the averaged normal of that faces it participates in the
	vertex. The gifti() function from FieldTrip does not return the normals.

	NOTE: The FieldTrip implementation of OpenMEEG does not require the normals and
	therefore, the gifti() function would be enough. A Cpp or Python implementation of OpenMEEG
	requires such conversion. I kept the function so that the core program only works on direct
	Matlab readable formats.


createMesh.m
	Input = gifti_mesh_name (no extension)
	Converts a gifti format into a matlab structure.
		If the structure already exists:
			It displays the gifti mesh.
		If the structure does not exists:
			The mesh is created and the gifti is displayed.

	Uses gifti.m from FieldTrip
	Uses a plot(mesh.gii) function from FieldTrip (better quality plot)

	

getDipoles.m
	Input = (brain_mesh,mask)
	This function returns the positions and orientations of dipoles for a given
	slab.
	Slabs are defined as .nii masks in cube coordinates from wfu_pickatlas.
	Mesh should be given as the output of the CreateMesh.m script

forwardModel.m
	Does everything else!!!
	Needs to be refactored!



TENTATIVE HOW TO:

1. Create a subject folder in data/
2. Create a subject head mesh (I think at this point it is just manually copy-pasted....)
3. Create slabs: use data_AtlasSlabs.m
4. Create dipoles: use data_dipoles.m
4. Create circuits: use data_CircuitsNet.m
5. Choose condictivities: use data_cond.m
6. Create forward activation values for the various slabs in the circuits (I guess this could be bypassed by entering manually activation values for each slabs): use data_fwdActTimes.m
This defines boxcar activation functions for each slabs.
7. Create an IRF function: use data_IRF.m
8. I think then create boxcar function for each dipole: use data_dipBoxcar.m
9. Then I think create a source waveform function for each dipole based on the convolution of their boxcar function and the IRF: use data_sourceWave.m
10. Define the sensors: use: data_sensors.m
11. Compute the leadfield for static normal dipoles: use data_leadFieldGenerator.m (uses FieldTrip)
12. Compute the final leadfield timecourse based on dipole amplitude timecourse: use data_leadfield.m

All the disp_*.m functions are there for display.

What is cfg.mat in a subject folder? -> The input to fieldTrip.

Important: The code uses triplot function -> This is the fieldtrip/private function and not the default matlab function!
-> So make sure Fieldtrip is on the Matlab path.

Issue with biograph... But really using the module system should be optional..


Use run() to call the function

The version of Fieldtrip found in 'external' folder needs to be added to Matlab path.
The BEM leadfield computation method relies on OpenMEEG. OpenMEEG needs to be installed.
http://openmeeg.github.io/