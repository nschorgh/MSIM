Examples for validation
=======================

1. Basic thermal model for Mars

make mars_thermal

./a.out

reads input.par and produces outputs 'Tprofile', 'Tsurface', and 'z'



2. Thermal model on slope on Mars

make mars_thermal2p

./a.out

reads input_slope.par, and the output files should match Tprofile.slope,
Tsurface.slope, and z.slope
