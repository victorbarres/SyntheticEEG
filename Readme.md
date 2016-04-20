# SynERP 2012
## USC Brain Project
by Victor Barres

Last updated
2015-03-16

## Software dependencies.
### FieldTrip
	
Source: http://fieldtrip.fcdonders.nl/

FieldTrip provides the Matlab environment for EEG processing.

In particular, FieldTrip Matlab functions are used used for:
	* 3D Mesh display
	* As an interface with the OpenMEEG C++ implementation of the forward model.
		
Fieldtrip folder, found in **external/dependencies/**, must be placed on the Matlab path.

### OpenMEEG

Source: http://openmeeg.github.io/

OpenMEEG must be installed and on the system's path in order to be able to use it to compute the
forward model solution using their BEM algorithm.

OpenMEEG in **external/OpenMEEG/**(?)

### SPM
	
SPM has been used mostly through some of the external packages it provides (such as PickAtlas), but also SyntheticEEG 
uses the Colin27MNI head meshes that are provided with SPM in gifti format.
Those are found in 'external/SPM8/gifti/'.

### PickAtlas
	
Pickatlas based on Talairach daemon and provided by ANSIR laboratory is used to extract the masks for brain regions.
http://fmri.wfubmc.edu/software/PickAtlas
Synthetic EEG also uses the wfu_pickatlas matlab function to translate Colin27 bewteen MNI to Cube coordinates.
'external/wfu_pickatlas' folder must be placed on the matlab path.

Other atlases can be used.
The synERP package does not provide direct tools to define the masks. We relied on the above packages.

NOTE: the masks need to be in MNI coordinates.


## Data

### Meshes

Gifti folder provides the meshes associated with Collins20 head model (MNI) in the gifti format.
The current version of the program works with such meshes given in Cubic space.

Meshes folder provides the .mat files associated with the .gii in the gifti folder, after transformation
using gifti_convert.

### Masks
	
We provide a series of masks for brain regions created using wfu pickatlas (see above).
They are given in MNI space, and therefore need to be converted to Cubic space.'
The MNI_T1.mat provides the coordinate transformation matrix MNI_Space -> Cubic_Space

## Install

**Step1**:
	
	Unzip the SyntheticERP folder.

**Step2**:
	
	Install OpenMEEG. Make sure it's 'bin' folder is on your system path.

**Step3**:

	In the SyntheticERP folder, add to your Matlab path: 'external/dependencies/fieldtrip-20120307', 'external/arrow', 'external/OpenMEEG'??, 'external/SPM8', 'external/wfu_pickatlas'

**Step4**:

	Set the SyntheticERP folder as your current workspace.

**Step5**:

	You are ready! Use run.m to load or create a new simulation.

## Create a new simulation

**Step1**:

	Run 'run.m'
	
**Step2**:

	Select 'Create new sim'
	
**Step3**:

	Enter a name for your new simulation. Simulations are stored in a folder within the 'simulations' folder.
	
**Step4**:

	Select 'Select headmesh'. This will create a headmesh for your simulation.
	In the current version a single headmesh is available (ColinsMNI).
    	This creates the 'meshes.mat' file in your simulation folder.
	
**Step5**:

	Select 'Choose conductivities'. Pick the conductivities value you want.
    	This creates the 'cond.mat' file in your simulation folder.
	
**Step6**:

	Select 'Select sensors'. Pick the types of sensors you want to use. 
        	Top-head -> all the vertices on the top of the skin mesh will be used as sensor positions
        	Default -> Offers default electrodes positions.
        	Random -> Randomly picks positions on the skin mesh as sensor positions.
        	Note: In the current version, only top-head and random can be used to then plot the scalp topography of the leadfield.
    	This creates the 'sensors.mat' file in your simulation folder.
	
**Step7**:

	Select 'Define modules'.
    	A module represents a set of brain regions.
    	For a given simulations, there is no limitation in the number of modules that can be created.
    	The brain regions associated with the modules will correspond to the area of the cortex in which electric dipoles sources will be placed.
    	This creates the 'slabs.mat' in the simulation folder.
	
**Step8**:

	Select 'Create dipoles'
    	This generates the electric dipole sources associated with the modules
    	Select the modules for which you would like to generate dipoles.
    	You can either choose to have a single dipole per module or distributed dipoles.
    	Note: Single dipole should be used with caution...Approximation only valid for brain regions where curvature is negligible.
    	For distributed dipoles, based on the density, random vertices in brain regions are chose to position dipoles. A dipole's norm is proportional to the area of the adjacent triangles in the mesh (to check...)
    	This creates the 'dipoles.mat' in the simulation folder.


At this point, the simulation folder contains:
- 'meshes.mat'
- 'cond.mat'
- 'sensors.mat'
- 'slabs.mat'
- 'dipoles.mat'

The key data required to compute the leadfield are: 'meshes.mat', 'cond.mat', 'sensors.mat', 'dipoles.mat'.
Defining modules is an easy way to position dipoles sources, but any other script generating a 'dipoles.mat' file could be used.

**Step9**:

	Select 'Create leadfield'.
    	This generates the leadfield based on the data contained in
        	- 'meshes.mat'
        	- 'cond.mat'
        	- 'sensors.mat'
        	- 'dipoles.mat'
    	It uses the OpenMEEG C++ BEM implementation combined with the Matlab interface provided by FieldTrip.
    	This creates 
        	- the 'cfg.mat' file in the simulation folder that contains the configuration information used by FieldTrip to run the forward model.
        	- the 'grid.mat' file that contains the output of the BEM forward model.
        	- the 'leadfield.mat' which contains the leadfield.
        	- the 'leadFieldDiary.txt' that contains details on the computation.

What is missing is the dipole amplitudes dA(t).
This could be provided directly by the user (NOTE: WRITE FUNCTION TO MAKE THIS EASY!!!)

The model in its current form allows for the simulation of forward activation of modules (see SyntheticERP paper).
- 'Create circuit' -> Allows the user to build a feedforward brain circuit of modules.
- 'Create forward activation values' -> Allows the user, based on the circuit, to define a rudimentary feedforward activation flow pattern.
- 'Create IRF' -> Allows the user to create a impulse response function.
- 'Create boxcar timecourse' -> Uses the feedforward activation flow pattern in modules to generate boxcar dA_boxcar(t) for each dipole.
- 'Create waveform timecourse' -> Computes the convolution dA_boxcar(t)*IRF to generate dipoles final waveform amplitudes timcourses dA(t).


One the leadfield and the dA(t) are available, the final EEG signal can be computed simply by multiplying the leadfield matrix with dA(t).

**Step 10**:

	To create EEG signal from leadfield + dA(t) information, used 'Create EEG data for an electrode'.
    	This requires that a default sensors position has been chosen.
	NOTE: SCRIPT EASY TO MODIFY TO GET THE EEG DATA IN GENERAL! TO DO!
    

## More about run()

- A new simulation can be created or an old one loaded. Once a simulation loaded, any of the previous steps can be re-run to modify the simulation.
- Once a simulation is loaded, all the display option allow the user to visualize the information contained in the simulatoin folder.
- The run module also allows the user to visualize the meshes, conductivity data, electrode options, atlases, as well as some ERP data.

## Scripts

TO BE DONE! (Old...)

**gifti_convert.m**

	This function converts a gifti structure into a triangle mesh structure
	OpenMEEG friendly!!
	A triangle mesh, for OpenMEEG, requires to give the normal of the vertices which is
	defined as the averaged normal of that faces it participates in the
	vertex. The gifti() function from FieldTrip does not return the normals.

	NOTE: The FieldTrip implementation of OpenMEEG does not require the normals and
	therefore, the gifti() function would be enough. A Cpp or Python implementation of OpenMEEG
	requires such conversion. I kept the function so that the core program only works on direct
	Matlab readable formats.


**createMesh.m**

	Input = gifti_mesh_name (no extension)
	Converts a gifti format into a matlab structure.
		If the structure already exists:
			It displays the gifti mesh.
		If the structure does not exists:
			The mesh is created and the gifti is displayed.

	Uses gifti.m from FieldTrip
	Uses a plot(mesh.gii) function from FieldTrip (better quality plot)

	

**getDipoles.m**

	Input = (brain_mesh,mask)
	This function returns the positions and orientations of dipoles for a given
	slab.
	Slabs are defined as .nii masks in cube coordinates from wfu_pickatlas.
	Mesh should be given as the output of the CreateMesh.m script

**forwardModel.m**
	Does everything else!!!
	Needs to be refactored!
