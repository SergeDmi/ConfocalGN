# ConfocalGN
This code allows the user to generate mock confocal data, in order to test image segmentation programs.
One starts from a a ground truth wich is a 3D image of high resolution. 
This image is convolved and pixelized, after the fashion of a confocal microscope.
A sample confocal image can be provided for the program to mimick the confocal imageing.

The user may add
- Fluorophore stochasticity
- Background fluorescence
- Pixel (sensor) noise 

# Operation
To operate ConfocalGN, firt run startup.m 
To use the confocal generator, the user must provide :
- A ground truth image IMG (a 3D matrix or a tiff file)
- Microscope properties CONF, containing 
	-- CONF.pix : voxel size (in units of the pixel size of IMG), a 3x1 vector
	-- CONF.psf : point spread funciton (in units of the pixel size of IMG), a 3x1 vector ; the psf is assumed gaussian, with a deviation CONF.psf.
- A noise distribution NOISE and a signal value SIG 
OR
- A sample image (array or image name) SAMPLE for the program to derive NOISE and SIG

Additionally, the user can specify
- Sampling and segmentation options by edition the file confocal_options.m
- Custom segmentation program by replacing the file segment_image.m by his own segmentation method

The user can then call the function

	[stacks,offset,acheived_sig,achieved_noise,im]=confocal_generator(IMG,CONF,SAMPLE);
or 
	[stacks,offset,achieved_sig,achieved_noise,im]=stack_generator(IMG,CONF,NOISE,SIG);
	
Where "stacks" is the simulated image, "offset" is the translation needed to align with IMG,
"achieved_sig" is the mean signal value in the experiment, im is the post-segmentation image of stack.

# Typical usage :
To see an operational example of ConfocalGN, first run startup.m 
Then run usage_example.m

# Credits & Licence
Code is distributed under GPL3.0 Licence (see LICENCE.md)
This code includes the librairies :
- tiffread Copyright (C) 1999-2010 Francois Nedelec
- gausss3filter Copyright (C) Max W.K. Law
- Octave code (Copyright (C) 2006-2015 John W. Eaton), under GPL licence


Code modified from Octave's : 
- randg
- gamrnd

See tiffread.m ; octave_randg.m ; gamrnd_simpl.m for licencing information.

This code was developped by Serge Dmitrieff in 2016 in EMBL, with the support of François Nédélec.
http://biophysics.fr

# Changelog
-June 2016 : initial minimal version
-July 2016 : correction of stacking
-July 2016 : major overhaul for easier use, and usage of sample image

# Source for gauss3filter 
Max W. K. Law and Albert C. S. Chung, "Efficient Implementation for Spherical Flux Computation and Its Application to Vascular Segmentation",
IEEE Transactions on Image Processing, 2009, Volume 18(3), 596�V612
