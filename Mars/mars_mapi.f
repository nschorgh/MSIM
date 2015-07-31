      program mars_mapi
C***********************************************************************
C   mars_mapi: program to calculate depth to equilibrium ice table for
C              a list of input parameters (can be the entire globe)
C
C              output can be used as input for mars_mapt
C   
C   written by Norbert Schorghofer, 2003-2004
C***********************************************************************

      implicit none
      integer NMAX
      real*8 pi, d2r, marsDay, NULL
      parameter (NMAX=1000)
      parameter (pi=3.1415926535897932, d2r=pi/180., marsDay=88775.244)
      parameter (NULL=0.)  ! n/a

      integer nz, j
      real*8 dt, zmax, zfac, zdepth, icefrac, zacc
      real*8 latitude, thIn, albedo0, fracIR, fracDust, delta
      real*8 Fgeotherm, rhoc, lon, Tfrost, pfrost, slp, azFac
      real*8 avdrho, junk, Tb, p0 !, htopo
      real*8 psv, rtbis, frostpoint
      external psv, rtbis, frostpoint

C-----set input parameters
      !dt=0.01
      dt=0.02
      nz=80; zfac=1.05;
      fracIR=0.04; fracDust=0.01
      !Fgeotherm=0.028
      Fgeotherm=0.0
      icefrac = 0.4  ! porosity for layertype 1
      !icefrac = 0.97  ! layertype 2

      zacc=0.1   ! desired min. relative accuracy of ice table depth
      slp=0.; azFac=0.
      p0 = 600.

      print *,'RUNNING MARS_MAP-ICE TABLE'
      write(*,*) 'Global model parameters'
      write(*,*) 'nz=',nz,' zfac=',zfac,' dt=',dt
      write(*,*) 'fracIR=',fracIR,' fracDust=',fracDust
      write(*,*) 'ice fraction=',icefrac
      write(*,*) 'Fgeotherm=',Fgeotherm
      write(*,*) 'Minimum ice depth accuracy dz/z=',zacc
      write(*,*) 'Slope=',slp/d2r,' azimuth=',azFac/d2r
      write(*,*) 'Atmospheric pressure=',p0

      open(unit=20,file='mapgrid.dat',status='old') ! the only input

      open(unit=30,file='z',status='unknown');
c      open(unit=31,file='Tpeak',status='unknown')
c      open(unit=32,file='Tlow',status='unknown')
      open(unit=33,file='mapgrid2.dat',status='unknown')
      open(unit=34,file='means',status='unknown')
c      open(unit=35,file='rhosatav',status='unknown')

      do j=1,10000  ! maximum list length
         read(20,*,end=80) lon,latitude,albedo0,thIn,Tfrost,zdepth
         !read(20,*,end=80) lon,latitude,albedo0,thIn,pfrost,p0

         !p0=520.*exp(-htopo/10800.)
         fracIR=0.04*p0/600.; fracDust=0.02*p0/600.  ! use if p0 is available

         !Tfrost = frostpoint(pfrost)
         pfrost = psv(Tfrost)

         print *,lon,latitude,albedo0,thIn,Tfrost
         if (albedo0==-9999..or.thIn==-9999..or.Tfrost==-9999.) cycle
C        zdepth input is ignored
C        Empirical relation from Mellon & Jakosky:
         rhoc = 800.*(150.+100.*sqrt(34.2+0.714*thIn))
         delta=thIn/rhoc*sqrt(marsDay/pi) ! diurnal skin depth
         zmax=5.*26.*delta 
         Tb = -1.e32

         call jsub(zmax, latitude*d2r, albedo0, thIn, pfrost,
     &        nz/2, rhoc, fracIR, fracDust, Fgeotherm, 4.*dt, zfac, 
     &        icefrac, slp, azFac, 1, junk, Tb, p0)
         call jsub(zmax, latitude*d2r, albedo0, thIn, pfrost,
     &        nz,   rhoc, fracIR, fracDust, Fgeotherm,    dt, zfac,
     &        icefrac, slp, azFac, 0, avdrho, Tb, p0)
         print *, zmax,avdrho
         if (avdrho>=0.) then 
            zdepth=-9999.
         else  
            zdepth=rtbis(delta/2.,zmax,zacc,avdrho,
     &           latitude*d2r,albedo0,thIn,pfrost,nz,rhoc,fracIR,
     &           fracDust,Fgeotherm,dt,zfac,icefrac,slp,azFac,p0)
            print *,'Equilibrium ice table depth= ',zdepth
         endif
         write(33,'(f7.2,1x,f7.3,2x,f5.3,2x,f5.1,1x,f7.1,2x,f10.4)') 
     &        lon,latitude,albedo0,thIn,Tfrost,zdepth
      enddo

 80   continue
      close(20)
      close(30)
      close(33)
      end


      


      FUNCTION rtbis(x1,x2,xacc,fmid,
     &     latitude,albedo0,thIn,pfrost,nz,rhoc,fracIR,fracDust,
     &     Fgeotherm,dt,zfac,icefrac,surfaceSlope,azFac,patm)
C     finds root with bisection method a la Numerical Recipes (C)
      implicit none
      INTEGER JMAX
      REAL*8 rtbis,x1,x2,xacc
      PARAMETER (JMAX=40)
      INTEGER j
      REAL*8 dx,f,fmid,xmid,Tb,rhoc
      real*8 latitude,albedo0,thIn,pfrost,fracIR,fracDust,Fgeotherm,dt
      real*8 zfac,icefrac,surfaceSlope,azFac,xlower,xupper,fupper,flower
      real*8 patm
      integer nz
!      call jsub(x2,
!     &     latitude,albedo0,thIn,pfrost,nz,fracIR,fracDust,
!     &     Fgeotherm,dt,zfac,icefrac,surfaceSlope,azFac,
!     &     0,fmid,Tb,patm)
!      print *,x2,fmid

      Tb = -1.e32
      call jsub(x1,
     &     latitude,albedo0,thIn,pfrost,nz/2,rhoc,fracIR,fracDust,
     &     Fgeotherm,4.*dt,zfac,icefrac,surfaceSlope,azFac,1,f,Tb,patm)
      call jsub(x1,
     &     latitude,albedo0,thIn,pfrost,nz,rhoc,fracIR,fracDust,
     &     Fgeotherm,dt,zfac,icefrac,surfaceSlope,azFac,0,f,Tb,patm)
      print *,x1,f
      if(f*fmid.ge.0.) stop 'root must be bracketed in rtbis'
      if(f.lt.0.)then
        rtbis=x1
        dx=x2-x1
      else
        rtbis=x2
        dx=x1-x2
      endif
      xupper=x1; fupper=f
      xlower=x2; flower=fmid
      do j=1,JMAX
        dx=dx*.5
        xmid=rtbis+dx
        Tb = -1.e32
        call jsub(xmid,
     &       latitude,albedo0,thIn,pfrost,nz/2,rhoc,fracIR,fracDust,
     &       Fgeotherm,4.*dt,zfac,icefrac,surfaceSlope,azFac,
     &       1,fmid,Tb,patm)
        call jsub(xmid,
     &       latitude,albedo0,thIn,pfrost,nz,rhoc,fracIR,fracDust,
     &       Fgeotherm,dt,zfac,icefrac,surfaceSlope,azFac,
     &       0,fmid,Tb,patm)
        print *,xmid,fmid
        if(fmid.le.0.) then
           rtbis=xmid
           xlower=xmid; flower=fmid
        else
           xupper=xmid; fupper=fmid
        endif
        if(abs(dx/xmid).lt.xacc .or. fmid.eq.0.) then
c----------do linear interpolation at last
           rtbis = (fupper*xlower - flower*xupper)/(fupper-flower)
           return
        endif
      enddo
      stop 'too many bisections in rtbis'
      END


