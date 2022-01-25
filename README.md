Mars Subsurface Ice Model (M-SIM)
=================================

*by Norbert Schorghofer*


This program collection contains:

* Semi-implicit one-dimensional thermal model for planetary surfaces (Crank-Nicolson with nonlinear b.c.)  
* Explicit subsurface vapor diffusion and ice deposition model (1D diffusion, sublimation, adsorption)  
* Equilibrium ice table on Mars
* Asynchronously coupled method for subsurface-atmosphere vapor exchange on Mars




### Mars Thermal Model

Mars/mars_thermal1d.f (main program)  
Mars/flux_mars.f90  
Mars/marsorbit.f90  
Mars/soilthprop_mars.f90  
Common/conductionQ.f90  
Common/conductionT.f90  
Common/grids.f90  
Common/julday.for  
Common/psvco2.f  
Common/tridag.for  
*Documentation: User Guide Part 1*  


### Vapor Diffusion Model

Mars/exper_thermal1d.f (main program)  
Mars/vapordiffusioni.f  
Mars/adsorption.f  
*Documentation: User Guide Part 2  
Documentation: Schorghofer, N. & Aharonson, O. (2005) J. Geophys. Res. 110, E05003, Appendices*  
Mars/Misc/  (an animation for illustration)  


### Equilibrium Ice Table

Mars/mars_mapi.f (main program)  
Mars/mars_mapii.f90 (main program)  
Mars/mars_mapt.f (main program)  
Mars/mars_mapi2p.f90 (main program)  
Mars/jsub.f90    
Mars/jsubv.f90  
Mars/marsorbit.f90  
Mars/flux_mars.f90  
Mars/soilthprop_mars.f90  
Common/conductionQ.f90  
Common/conductionT.f90  
Common/grids.f90  
Common/julday.for  
Common/psv.f  
Common/psvco2.f  
Common/tridag.for  
*Documentation: User Guide Section 3.1  
Documentation: Schorghofer, N. & Aharonson, O. (2005) J. Geophys. Res. 110, E05003*  


### Mars Long-Term Thermal Model

Mars/insol_driver.f90 (main program)  
Mars/tempr_driver.f90 (main program)  
Mars/flux_mars.f90  
Mars/soilthprop_mars.f90  
Common/conductionQ.f90  
Common/conductionT.f90
Common/generalorbit.f  
Common/grids.f90  
Common/psvco2.f  
Common/tridag.for  
Mars/MilankOutput/  (surface temperatures from last 21Myr)  


### Fast (asynchronously-coupled) Method for Subsurface Ice Dynamics

Mars/stabgrow_fast.f90 (main program)  
Mars/exper_fast.f90 (main program)  
Mars/mars_fast.f90 (main program)  
Mars/fast_modules.f90  
Mars/fast_subs_exper.f90  
Mars/fast_subs_mars.f90  
Mars/fast_subs_univ.f90  
Mars/soilthprop_mars.f90  
Common/conductionQ.f90  
Common/conductionT.f90  
Common/derivs.f90  
Common/generalorbit.f  
Common/grids.f90  
Common/psv.f  
Common/psvco2.f  
Common/tridag.for  
*Documentation: Schorghofer, N. (2010) Icarus 208, 598-607*  


---

NOTE: Third party source code from Numerical Recipes is covered by a separate copyright. These are files ending with .for.  A few code snippets from other sources are also used, as documented in the source code.


### ACKNOWLEDGMENTS

2010, 2005: Thanks to Oded Aharonson for improvements on mars_mapi2p and a better treatment of the frost/no-frost surface boundary condition.

2006: Troy Hudson discovered a grid-point offset in conductionT and conductionQ, which has been corrected.

2005: Thanks to Mischa Kreslavsky for providing formulas for energy balance on a planar slope.

Many Thanks to Andy Vaught for developing an open-source Fortran 95 compiler (G95).  The early versions of this code were developed with this compiler.

2001: Samar Khatiwala invented an elegant implementation of the upper radiation boundary condition for the Crank-Nicolson method.

SUPPORT: This code development was supported mainly by NASA, and in smaller parts by Caltech and the University of Hawaii. Undoubtedly, some parts were written in my spare time.

