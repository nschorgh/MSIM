FC = gfortran
FFLAGS = -O3 -Wall -Wno-integer-division

#FC = ifort
#FFLAGS = -O2 #-warn all -warn notruncated_source -nogen-interface

#FC = pgfortran
#FFLAGS = -fast


common-mars: generalorbit.o flux_noatm.o conductionQ.o conductionT.o tridag.o \
	grids.o psv.o psvco2.o julday.o derivs.o flux_mars.o marsorbit.o \
	soilthprop_mars.o makefile 

%.o:	%.f makefile
	$(FC) $(FFLAGS) -c $<

%.o:	%.for makefile
	$(FC) $(FFLAGS) -c $<

%.o:	%.f90 makefile
	$(FC) $(FFLAGS) -c $<



.PHONY: clean

clean:
	rm -f  *.o  *.mod 



