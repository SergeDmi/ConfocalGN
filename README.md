# ConfocalGN
This code allows the user to generate mock confocal data, in order to test image segmentation programs.
One starts from a a ground truth wich is a 3D image of high resolution. 
This image is convolved and pixelized, after the fashion of a confocal microscope.
The user may add
- Fluorophore stochasticity
- Background fluorescence
- Pixel noise
The code is still a bit slow for high resolution images, this can easily be fixed by proper matlab optimization of the algebra, most specially in the pixelization stage.

The main functions are :
- generate_pts_img  : generate ground truth image from ground truth points
- generate_stacks : generate the confocal stack from the ground truth image
That parts uses gauss3filter, a beautiful 3D Gaussian smoothing from Max W.K. Law

A working example is given in mock_example.m which :
- Generate a ground truth
- Generate a confocal image
- Thresholds the confocal image
- Compares it to the ground truth
