# correlated-data

Dataset for "New generation of effective core potentials from correlated calculations: 3d transition metal series"

Included are various directories including atomic and molecular data for various ECPs. Gaussian and Molpro include input and output files for each code respectively. Each code directory is divided into atoms and molecules, containing individual directories for each species (e.g. Molpro/atoms/Fe or Gaussian/molecules/ZnO). Within each atom or molecule directory, we include data for the all-electron, uncorrelated core, and various ECPs considered in the paper. For the Gaussian molecular calculations, the molecular geometries are separated into individual directories, whereas for Molpro there is only one directory which contains one input file to calculate all geometries. 

Additionally, there are two separate directories "spectra" and "csv" which contain the atomic spectra and molecular binding curves for a given basis set as csv files. Each directory also contains the python scripts for generating the figures included in the paper. 
