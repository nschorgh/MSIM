FC = gfortran
FFLAGS = -O2 -Wall
LFLAGS = -O2 -Wall

#FC = ifort
#FFLAGS = -O2 -warn all  -warn notruncated_source  -nogen-interface
#LFLAGS = -O2 -warn all

SR = ../



testcrankQ: testcrankQ.o makefile
	make FC='$(FC)' FFLAGS='$(FFLAGS)' -C $(SR) common-mars
	$(FC) $(LFLAGS) testcrankQ.o $(SR)flux_noatm.o $(SR)conductionQ.o \
	$(SR)tridag.o $(SR)grids.o

testcrankT: testcrankT.o makefile
	make FC='$(FC)' FFLAGS='$(FFLAGS)' -C $(SR) common-mars
	$(FC) $(LFLAGS) testcrankT.o $(SR)conductionT.o $(SR)tridag.o $(SR)grids.o



%.o:	%.f makefile
	$(FC) $(FFLAGS) -c $<

%.o:	%.f90 makefile
	$(FC) $(FFLAGS) -c $<


.PHONY: clean cleanrun

clean:
	rm -f  *.o  a.out  *.mod
	rm -f Tprofile z Tsurface



