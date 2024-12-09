# This overwrites and passes on options:
# make FC=pgfortran FFLAGS=-fast LFLAGS=-fast
# make FC=ifort FFLAGS='-O2 -warn all' LFLAGS='-O2 -warn all'

FC = gfortran
FFLAGS = -O2 -Wall
LFLAGS = -O2 -Wall

#FC = ifort
#FFLAGS = -O2 #-warn all -warn notruncated_source -nogen-interface
#LFLAGS = -O2 -warn all

#FC = pgfortran
#FFLAGS = -fast
#LFLAGS = -fast


SR = ../Common/

exper_thermal: exper_thermal1d.o vapordiffusioni.o makefile
	make -C $(SR) common-mars
	$(FC) $(LFLAGS) exper_thermal1d.o $(SR)conductionT.o $(SR)tridag.o \
	vapordiffusioni.o $(SR)psv.o $(SR)grids.o $(SR)soilthprop_mars.o

mars_thermal mars_thermal1d: mars_thermal1d.o makefile
	make -C $(SR) common-mars
	$(FC) $(LFLAGS) mars_thermal1d.o $(SR)julday.o $(SR)marsorbit.o \
	$(SR)flux_mars.o $(SR)conductionQ.o $(SR)tridag.o $(SR)conductionT.o \
	$(SR)grids.o $(SR)soilthprop_mars.o $(SR)psv.o

mars_thermal2p mars2p: mars_thermal2p.o makefile
	make -C $(SR) common-mars
	$(FC) $(LFLAGS) mars_thermal2p.o $(SR)julday.o $(SR)marsorbit.o \
	$(SR)flux_mars.o $(SR)conductionQ.o $(SR)tridag.o $(SR)conductionT.o \
	$(SR)grids.o $(SR)soilthprop_mars.o $(SR)psvco2.o

insol_driver: insol_driver.o makefile
	make -C $(SR) common-mars
	$(FC) $(LFLAGS) insol_driver.o $(SR)generalorbit.o $(SR)flux_noatm.o

tempr_driver: tempr_driver.o makefile
	make -C $(SR) common-mars
	$(FC) $(LFLAGS) tempr_driver.o $(SR)generalorbit.o $(SR)flux_mars.o \
	$(SR)conductionQ.o $(SR)tridag.o $(SR)conductionT.o $(SR)grids.o \
	$(SR)psvco2.o




%.o:	%.f makefile
	$(FC) $(FFLAGS) -c $<

%.o:	%.f90 makefile
	$(FC) $(FFLAGS) -c $<


.PHONY: clean 

clean:
	rm -f  *.o  a.out  *.mod \
	z Tsurface Tprofile



