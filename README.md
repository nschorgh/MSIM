Mars Subsurface Ice Model (MSIM)
================================

*by Norbert Schorghofer*


The MSIM program collection contains:

* One-dimensional thermal model for the surface of Mars (Crank-Nicolson solver with Stefan-Boltzmann radiation upper boundary condition)  
* Subsurface vapor diffusion and ice deposition model (1D diffusion, sublimation, adsorption)  
* Equilibrium ice table on Mars (for horizontal surfaces and planar slopes)  
* Asynchronously coupled method for subsurface-atmosphere vapor exchange on Mars (non-equilibrium ice table and ice content)  


### Mars Thermal Model

This model calculates realistic surface temperatures for Mars. The heat equation is solved in the top few meters of the subsurface, using direct solar energy and sky irradiance as energy inputs.  The surface energy balance also includes the latent heat of CO<sub>2</sub> frost. 
The finite-difference method is flux-conservative even on an irregularly spaced grid and the thermal properties of the soil can vary with depth and time.
The solver for the one-dimensional heat equation is semi-implicit, which implies that the size of the time step is not limited by the spatial discretization, as it would be for simpler heat equation solvers.
As far as I am aware, it is still the fastest Mars thermal model available. 
The orbit of Mars can be for the present-day or the past. The standard configuration is for a horizontal unobstructed surface, but planar slopes can also be modeled.  

In folder `MarsThermal/`  
`MarsThermal/MilankOutput/` contains surface temperatures from last 21Myr.  
*Documentation: [MSIM_Methods](https://raw.githubusercontent.com/nschorgh/MSIM/main/MSIM_Methods.pdf) Part 1*  
*Documentation: [Schörghofer & Khatiwala (2024)](https://doi.org/10.3847/PSJ/ad4351)*


### Vapor Diffusion Model

This model solves the one-dimensional vapor diffusion equation in a porous medium, including phase transitions (sublimation and adsorption).  Specifically, it simulates H<sub>2</sub>O vapor diffusion through the CO<sub>2</sub>-filled pore spaces in martian regolith. Diffusion can be outward or inward.
The phase transitions make the partial differential equation non-linear, so an explicit time step is used. The same model can also be used (and has been used) for laboratory experiments in physically analogous environments.  

In folder `MarsThermal/`   
`MarsThermal/Misc/` contains an animation of "vapor pumping" for illustration.  
*Documentation: [MSIM_Methods](https://raw.githubusercontent.com/nschorgh/MSIM/main/MSIM_Methods.pdf) Part 2  
Documentation: [Schorghofer & Aharonson (2005), Appendix B](https://doi.org/10.1029/2004JE002350)*


### Equilibrium Ice Table

The theory of subsurface-atmosphere vapor exchange leads to the concept of an equilibrium ice table, a depth where the (time-averaged) saturation vapor pressure of H<sub>2</sub>O matches the (time-averaged) vapor density in the atmosphere immediately above the surface. A Mars thermal model is run until equilibrated, and then annual mean vapor densities are evaluated to determine whether and at what depth a vapor equilibrium exists. Ice changes the thermal properties of the ground, so the thermal model is re-run multiple times to determine the final depth of the equilibrium ice table.  

In folder `IceTable/`  
`IceTable/EqualMaps/` contains data produced with this model.  
*Documentation: [Schorghofer & Aharonson (2005)](https://doi.org/10.1029/2004JE002350)*  


### Fast (asynchronously-coupled) Method for Subsurface Ice Dynamics

This dynamical model of ice evolution goes beyond the concept of the equilibrium ice table and calculates the amount of ice lost from or gained within the porous subsurface as a result of vapor exchange with the atmosphere. To accomplish that, without the computationally slow approach of explicitly solving the nonlinear vapor transport equations, it uses time-averaged transport equations. This numerical method involves some complexities and is described in a dedicated paper by [Schorghofer (2010)](http://dx.doi.org/10.1016/j.icarus.2010.03.022).  

In folder `NonEquilibrium/`  


---

### History

Most of the MSIM program collection was written 2001-2009, as part of a series of papers about subsurface-atmosphere vapor exchange on Mars. It was then hosted on a website and moved to GitHub in 2015 as part of the [Planetary-Code-Collection](https://github.com/nschorgh/Planetary-Code-Collection). Since 2022, MSIM has its own [GitHub repository](https://github.com/nschorgh/MSIM).


### Notes

For thermal and ice evolution models of airless bodies see the [Planetary-Code-Collection](https://github.com/nschorgh/Planetary-Code-Collection). A three-dimensional surface energy balance model for Mars and airless bodies is also found in that repository.  

Most of the code was developed with a `gfortran` compiler. The non-portable `real(8)` and `real*8` are meant to correspond to an 8-byte floating point number.  


### Acknowledgments

2006: Troy Hudson discovered a grid-point offset in conductionT and conductionQ, which has been corrected.

2005: Thanks to Oded Aharonson for improvements on mars_mapi2p.

2005: Thanks to Mischa Kreslavsky for providing formulas for energy balance on a planar slope.

Many Thanks to Andy Vaught for developing an open-source Fortran 95 compiler (G95).  The early versions of this code were developed with this compiler.

2001: Samar Khatiwala invented an elegant implementation of the upper radiation boundary condition for the Crank-Nicolson method.

SUPPORT: This code development was supported mainly by NASA, and in smaller parts by Caltech and the University of Hawaii. Undoubtedly, some parts were written in my spare time.

