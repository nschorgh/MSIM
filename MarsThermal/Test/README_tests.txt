Examples for validation
=======================

1. Basic thermal model for Mars

make mars_thermal

./a.out

reads input.par and produces outputs 'Tprofile', 'Tsurface', and 'z'

 Ten Mars years of thermal calculations in one second: As specified in
 'input.par', this calculaction performs 100 steps per sol over 6686
 sols (10 Mars years), using 80 vertical grid points. If I comment out
 the write statement for 'Tsurface' (the largest of the output files),
 compile with Gnu Fortran and run the executable on a 3.6 GHz Intel
 Xeon CPU, it finishes in 1.0 seconds.




2. Thermal model on slope on Mars

make mars_thermal2p

./a.out

reads input_slope.par, and the output files should match Tprofile.slope,
Tsurface.slope, and z.slope
