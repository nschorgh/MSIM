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


mars_mapt: mars_mapt.o jsub.o makefile
	make -C $(SR) common-mars
	$(FC) $(LFLAGS) mars_mapt.o jsub.o $(SR)julday.o $(SR)marsorbit.o \
	$(SR)flux_mars.o $(SR)conductionQ.o $(SR)tridag.o $(SR)conductionT.o \
	$(SR)grids.o $(SR)soilthprop_mars.o $(SR)psv.o $(SR)psvco2.o

mars_mapi: mars_mapi.o jsub.o makefile
	make -C $(SR) common-mars
	$(FC) $(LFLAGS) mars_mapi.o $(SR)julday.o $(SR)marsorbit.o \
	$(SR)flux_mars.o $(SR)conductionQ.o $(SR)tridag.o $(SR)conductionT.o \
	$(SR)grids.o jsub.o $(SR)soilthprop_mars.o $(SR)psv.o $(SR)psvco2.o

mars_mapii: mars_mapii.o jsub.o makefile
	make -C $(SR) common-mars
	$(FC) $(LFLAGS) mars_mapii.o $(SR)julday.o $(SR)marsorbit.o \
	$(SR)flux_mars.o $(SR)conductionQ.o $(SR)tridag.o $(SR)conductionT.o \
	$(SR)grids.o jsub.o $(SR)soilthprop_mars.o $(SR)psv.o $(SR)psvco2.o

mars_mapi2p: mars_mapi2p.o jsubv.o makefile
	make -C $(SR) common-mars
	$(FC) $(LFLAGS) mars_mapi2p.o $(SR)julday.o $(SR)marsorbit.o \
	$(SR)flux_mars.o $(SR)conductionQ.o $(SR)tridag.o $(SR)conductionT.o \
	$(SR)grids.o jsubv.o $(SR)soilthprop_mars.o $(SR)psv.o $(SR)psvco2.o



%.o:	%.f makefile
	$(FC) $(FFLAGS) -c $<

%.o:	%.f90 makefile
	$(FC) $(FFLAGS) -c $<


.PHONY: clean 

clean:
	rm -f  *.o  a.out  z means Tsurface Tprofile



