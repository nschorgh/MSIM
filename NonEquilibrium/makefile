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


stabgrow_fast: fast_modules.o fast_subs_exper.o stabgrow_fast.o \
	fast_subs_univ.o makefile
	make -C $(SR) common-mars
	$(FC) $(LFLAGS) stabgrow_fast.o fast_subs_univ.o fast_subs_exper.o \
	$(SR)tridag.o $(SR)conductionT.o $(SR)grids.o $(SR)soilthprop_mars.o \
	$(SR)psv.o $(SR)derivs.o -o $@

exper_fast: fast_modules.o exper_fast.o fast_subs_univ.o fast_subs_exper.o \
	makefile
	make -C $(SR) common-mars
	$(FC) $(LFLAGS) exper_fast.o $(SR)tridag.o $(SR)conductionT.o \
	$(SR)grids.o $(SR)soilthprop_mars.o $(SR)psv.o $(SR)derivs.o \
	fast_subs_univ.o fast_subs_exper.o -o $@

mars_fast: fast_modules.o mars_fast.o fast_subs_univ.o fast_subs_mars.o \
	makefile
	make -C $(SR) common-mars
	$(FC) $(LFLAGS) mars_fast.o $(SR)tridag.o $(SR)conductionT.o \
	$(SR)grids.o $(SR)soilthprop_mars.o $(SR)psv.o $(SR)derivs.o \
	fast_subs_univ.o $(SR)flux_mars.o $(SR)conductionQ.o $(SR)psvco2.o \
	$(SR)generalorbit.o fast_subs_mars.o -o $@



%.o:	%.f makefile
	$(FC) $(FFLAGS) -c $<

%.o:	%.f90 makefile
	$(FC) $(FFLAGS) -c $<


.PHONY: clean 

clean:
	rm -f  *.o  a.out  *.mod \
	z exper_fast mars_fast stabgrow_fast 



