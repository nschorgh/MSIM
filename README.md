Mars Subsurface Ice Model (MSIM)
================================

*by Norbert Schorghofer*


The MSIM program collection contains:

* Semi-implicit one-dimensional thermal model for the surface of Mars (Crank-Nicolson solver with Stefan-Boltzmann radiation us upper boundary condition)  
* Explicit subsurface vapor diffusion and ice deposition model (1D diffusion, sublimation, adsorption)  
* Equilibrium ice table on Mars
* Asynchronously coupled method for subsurface-atmosphere vapor exchange on Mars



### Mars Thermal Model

This thermal model solves the heat equation in the top few meters of the subsurface, using direct solar energy and atmospheric irradiance as energy input on the surface.  It also includes CO<sub>2</sub> frost.  

The solver for the one-dimensional heat equation is semi-implicit, which implies that the size of the time step is not limited by the size of the spatial grid, as it would be for simpler heat equation solvers.
The finite-difference method is flux conservative even on an irregularly spaced grid and the thermal properties of the soil can vary spatially and with time.  

The standard configuration is for a horizontal unobstructed surface, but planar slopes can also be modeled.
The orbit of Mars can be the present-day orbit or a past configuration.  

*Documentation: User Guide Part 1*  


### Vapor Diffusion Model

This model solves the one-dimensional vapor diffusion equation in a porous medium, such as water vapor diffusion through the CO2-filled pore spaces in martian regolith, including phase transitions (sublimation and adsorption), which implies the equation is non-linear. The same model can also be used (and has been used) for laboratory setups under analogous environments.  

*Documentation: User Guide Part 2  
Documentation: Schorghofer, N. & Aharonson, O. (2005) J. Geophys. Res. 110, E05003, Appendices*  
Mars/Misc/  (an animation for illustration)  


### Equilibrium Ice Table

The theory of subsurface-atmosphere vapor exchange leads to the concept of an equilibrium ice table, a depth where the (time-averaged) saturation vapor pressure of H<sub>2</sub>O matches the (time-averaged) vapor density in the atmosphere immediately above the surface.  

The Mars thermal model is run until it is thermally equilibrated, and then annual-mean vapor densities are evaluated to determine whether and at what depth a vapor equilibrium is reached. Since ice changes the thermal properties of the ground, the thermal model needs to be re-run to iteratively determine the true depth of the equilibrium ice table.  

*Documentation: User Guide Section 3.1  
Documentation: Schorghofer, N. & Aharonson, O. (2005) J. Geophys. Res. 110, E05003*  


### Mars Long-Term Thermal Model

This is also a Mars thermal model, but it is typically re-run every 1000 years over millions of years as the orbital and spin configuration of Mars changes.
`insol_driver.f90` only evaluates annual mean insolation (incoming solar radiation) whereas
`tempr_driver.f90` also calculates temperatures by solving the heat equation in the subsurface.  

The latter is a simple example of an asynchronously-coupled model, because small and large time steps are involved.  

Mars/MilankOutput/  (surface temperatures from last 21Myr)  


### Fast (asynchronously-coupled) Method for Subsurface Ice Dynamics

This dynamical model of ice evolution goes beyond the concept of the equilibrium ice table and calculates the amount of ice lost from or gained within the porous subsurface on Mars. To accomplish that, without explicitly solving the nonlinear vapor transport equations, which would be computationally far too slow, it uses time-averaged equation and interfaces. The method involves some sophistication and is described in a dedicated paper by [Schorghofer (2010)](http://dx.doi.org/10.1016/j.icarus.2010.03.022).  A thermal model run with typically 50 steps per sol is coupled with an ice evolution run typically in steps of 1000 years.  

A variant of this model `exper_fast.f90` is designed for laboratory experiment.  

*Documentation: Schorghofer, N. (2010) Icarus 208, 598-607*  


---

### Notes

Third party source code from Numerical Recipes is covered by a separate copyright. These are files ending with .for.  A few code snippets from other sources are also used, as documented in the source code.


### History

Most of this program collection was written 2001-2009, as part of a series of papers about subsurface-atmosphere vapor exchange on Mars. It was then hosted on a website and later moved to GitHub as part of the [Planetary-Code-Collection](https://github.com/nschorgh/Planetary-Code-Collection). Since 2022 MSIM has its own GitHub repository.


### Acknowledgments

2010, 2005: Thanks to Oded Aharonson for improvements on mars_mapi2p and a better treatment of the frost/no-frost surface boundary condition.

2006: Troy Hudson discovered a grid-point offset in conductionT and conductionQ, which has been corrected.

2005: Thanks to Mischa Kreslavsky for providing formulas for energy balance on a planar slope.

Many Thanks to Andy Vaught for developing an open-source Fortran 95 compiler (G95).  The early versions of this code were developed with this compiler.

2001: Samar Khatiwala invented an elegant implementation of the upper radiation boundary condition for the Crank-Nicolson method.

SUPPORT: This code development was supported mainly by NASA, and in smaller parts by Caltech and the University of Hawaii. Undoubtedly, some parts were written in my spare time.

