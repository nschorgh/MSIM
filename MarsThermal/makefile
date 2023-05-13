# This overwrites and passes on options:
# make CC=pgfortran CFLAGS=-fast LFLAGS=-fast
# make CC=ifort CFLAGS='-O2 -warn all' LFLAGS='-O2 -warn all'

CC = gfortran
CFLAGS = -O2 -Wall
LFLAGS = -O2 -Wall

#CC = ifort
#CFLAGS = -O2 #-warn all -warn notruncated_source -nogen-interface
#LFLAGS = -O2 -warn all

#CC = pgfortran
#CFLAGS = -fast
#LFLAGS = -fast


SR = ../Common/

exper_thermal: exper_thermal1d.o vapordiffusioni.o makefile
	make -C $(SR) common-mars
	$(CC) $(LFLAGS) exper_thermal1d.o $(SR)conductionT.o $(SR)tridag.o \
	vapordiffusioni.o $(SR)psv.o $(SR)grids.o $(SR)soilthprop_mars.o

mars_thermal mars_thermal1d: mars_thermal1d.o makefile
	make -C $(SR) common-mars
	$(CC) $(LFLAGS) mars_thermal1d.o $(SR)julday.o $(SR)marsorbit.o \
	$(SR)flux_mars.o $(SR)conductionQ.o $(SR)tridag.o $(SR)conductionT.o \
	$(SR)grids.o $(SR)soilthprop_mars.o $(SR)psv.o

mars_thermal2p mars2p: mars_thermal2p.o makefile
	make -C $(SR) common-mars
	$(CC) $(LFLAGS) mars_thermal2p.o $(SR)julday.o $(SR)marsorbit.o \
	$(SR)flux_mars.o $(SR)conductionQ.o $(SR)tridag.o $(SR)conductionT.o \
	$(SR)grids.o $(SR)soilthprop_mars.o $(SR)psvco2.o

insol_driver: insol_driver.o makefile
	make -C $(SR) common-mars
	$(CC) $(LFLAGS) insol_driver.o $(SR)generalorbit.o $(SR)flux_noatm.o

tempr_driver: tempr_driver.o makefile
	make -C $(SR) common-mars
	$(CC) $(LFLAGS) tempr_driver.o $(SR)generalorbit.o $(SR)flux_mars.o \
	$(SR)conductionQ.o $(SR)tridag.o $(SR)conductionT.o $(SR)grids.o \
	$(SR)psvco2.o




%.o:	%.f makefile
	$(CC) $(CFLAGS) -c $<

%.o:	%.f90 makefile
	$(CC) $(CFLAGS) -c $< 


.PHONY: clean 

clean:
	rm -f  *.o  a.out  *.mod \
	z Tsurface Tprofile



