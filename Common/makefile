CC = gfortran
CFLAGS = -O3 -Wall -Wno-integer-division

#CC = ifort
#CFLAGS = -O2 #-warn all -warn notruncated_source -nogen-interface

#CC = pgfortran
#CFLAGS = -fast


common-mars: generalorbit.o flux_noatm.o conductionQ.o conductionT.o tridag.o \
	grids.o psv.o psvco2.o julday.o derivs.o flux_mars.o marsorbit.o \
	soilthprop_mars.o makefile 

%.o:	%.f makefile
	$(CC) $(CFLAGS) -c $<

%.o:	%.for makefile
	$(CC) $(CFLAGS) -c $<

%.o:	%.f90 makefile
	$(CC) $(CFLAGS) -c $< 



.PHONY: clean

clean:
	rm -f  *.o  *.mod 



