program mars_thermal2p
!****************************************************************************
!   mars_thermal2p: program to calculate the temperature on a planar slope on 
!                   Mars based on direct solar irradiance, subsurface heat
!                   conduction, sky irradiance, and terrain irradiance;
!                   a second 1d thermal model is run to obtain an approximate
!                   terrain irradiance 
!
!   Eqn: T_t = (D*T_z)_z   where D=k/(rho*c)
!   BC (z=0): Q(t) + k*T_z = em*sig*T^4 + L*dm/dt
!   BC (z=L): geothermal flux
!
!   Grid: surface is at z=0; T(i) is at z(i)
!****************************************************************************
  implicit none
  integer, parameter :: NMAX=1000  ! assumed size in tridag
  real(8), parameter :: sigSB=5.6704d-8
  real(8), parameter :: pi=3.1415926535897932, d2r=pi/180.
  real(8), parameter :: earthDay=86400., marsDay=88775.244, solsy=668.59
  real(8), parameter :: Lco2frost=6.0e5
  real(8), parameter :: zero=0.
  
  integer nz, nsteps, n, i, nm, k
  integer iyr, imm, iday
  real(8) tmax, time, dt, zmax, zfac, tdays, dtsec
  real(8) T(NMAX,2), Told(NMAX)
  real(8) latitude, thermalInertia, emiss0
  real(8), dimension(2) :: albedo, emiss, Qn, Qnp1
  real(8) fracIR, fracDust, rhoc, delta
  real(8) marsR, marsLs, marsDec, HA
  real(8) surfaceSlope, azFac, Fgeotherm
  real(8) jd, temp1, dcor, dt0_j2000, jd_end
  real(8) ti(NMAX,2), rhocv(NMAX,2), z(NMAX), albedo0, dE
  real(8), dimension(2) :: Tsurf, Fsurf, m, zdepth
  real(8) co2albedo, co2emiss, Tco2frost, htopo, patm
  real(8) Tsurfold, Fsurfold, Tinit, Tmean, Tmean2, geof
  real(8) skyviewfactor, Qdir(2), Qscat, Qlw
  real(8) longitude, LTST, lonW, buf
  character(100) dum1
  integer, external :: julday
  real(8), external :: psurf_season, tfrostco2
  
!-read input
  open(unit=20,file='input_slope.par',status='old')
  read(20,'(a)') dum1
  read(20,*) dt, tmax
  read(20,'(a)') dum1
  read(20,*) nz, zmax, zfac
  read(20,'(a)') dum1
  read(20,*) latitude, albedo0, emiss0, longitude
  read(20,'(a)') dum1
  read(20,*) thermalInertia, rhoc, zdepth(2)
  read(20,'(a)') dum1
  read(20,*) fracIR, fracDust, Fgeotherm
  read(20,'(a)') dum1
  read(20,*) htopo, co2albedo, co2emiss
  read(20,'(a)') dum1
  read(20,*) surfaceSlope, azFac
  read(20,'(a)')dum1
  read(20,*) iyr, imm, iday
  close(20)

  ! set some constants
  nsteps = nint(tmax/dt)     ! calculate total number of timesteps
  emiss(:) = emiss0 ! emissivity
  albedo(:) = albedo0
  dtsec = dt*marsDay
  delta = thermalInertia/rhoc*sqrt(marsDay/pi)  ! skin depth
  !zdepth = (/ -9999., 0.1 /)
  !zdepth(:) = -9999.
  zdepth(1) = -9999.

  fracIR = fracIR*exp(-htopo/10800.)
  fracDust = fracDust*exp(-htopo/10800.)
  patm = 520.*exp(-htopo/10800.)
  Tco2frost = tfrostco2(patm)
  
  !jd = dble(julday(imm,iday,iyr)) + 0.250  !  JD for noon UTC on iyear/imm/iday
  jd_end = dble(julday(imm,iday,iyr)) + 1
  jd = jd_end - tmax*marsDay/earthDay
        
  temp1 = (jd-2451545.d0)/36525.d0
  dcor = (64.184d0 + 95.*temp1 + 35.*temp1**2) ! correction in sec
  ! All time is referenced to dt0_j2000
  dt0_j2000 = jd + dcor/earthDay - 2451545.d0 
  !call marsorbit(dt0_j2000,0.d0,marsLs,marsDec,marsR)

  lonW = mod(360.-longitude,360.)
  call marsclock24(jd,buf,marsLs,marsDec,marsR,lonW,LTST)
  HA = 2.*pi*mod(LTST+12,24.d0)/24.
  
  write(*,*) 'Model parameters'
  write(*,*) 'Time step=',dt,' Max number of steps=',nsteps
  write(*,*) 'zmax=',zmax,' zfac=',zfac
  write(*,*) 'Thermal inertia=',thermalInertia,' rho*c=',rhoc
  write(*,*) 'Diurnal skin depth=',delta,' Geothermal flux=',Fgeotherm
  write(*,*) 'albedo=',albedo0,' emissivity=',emiss0
  write(*,*) 'fracIR=',fracIR,' fracDust=',fracDust
  write(*,*) 'Target date is noon UTC ',iyr,'/',imm,'/',iday
  write(*,*) 'Julian day ',jd
  write(*,*) 'Initial Mars orbit parameters: '
  write(*,*) 'Ls(deg)=',marsLs/d2r,' declination(deg)=',marsDec/d2r
  write(*,*) 'r (AU)=',marsR
  write(*,*) 'Calculations performed for latitude=',latitude
  write(*,*) 'Elevation (m)=',htopo,' patm (Pa)=',patm
  write(*,*) 'CO2 albedo=',co2albedo,' CO2 frostpoint=',Tco2frost, &
       & ' CO2 emissivity=',co2emiss
  write(*,*) 'Surface slope=',surfaceSlope,' surface azimuth=',azFac
  write(*,*) 'lontitudeE',longitude,'longitudeW',lonW
  write(*,*) 'Depth of ice tables',zdepth(:)
  
  !-Initialize
  Tinit = 210.15     ! black-body temperature of planet
  geof = cos(latitude*d2r)/pi
  Tinit = (589.*(1.-albedo0)*geof/sigSB)**0.25  ! better estimate
  T(1:nz,:) = Tinit
  Tsurf(:) = Tinit
  latitude = latitude*d2r
  Tmean=0.; Tmean2=0.; nm=0 
  
  call setgrid(nz,z,zmax,zfac)
  if (z(6)>delta) then
     print *,'WARNING: fewer than 6 points within diurnal skin depth'
  endif
  do i=1,nz
     if (z(i)<delta) cycle
     print *,i-1,' grid points within diurnal skin depth'
     exit
  enddo
  if (z(1)<1.e-5) print *,'WARNING: first grid point is too shallow'

  do k=1,2
     do i=1,nz  ! assign thermal properties
        ti(i,k) = thermalInertia
        rhocv(i,k) = rhoc
        if (zdepth(k)>=0. .and. z(i)>zdepth(k)) then 
           call soilthprop(0.4d0,1.d0,rhoc,thermalInertia,1,rhocv(i,k),ti(i,k))
           ! call soilthprop(zero,zero,zero,zero,3,rhocv(i,k),ti(i,k),zero)
        endif
     enddo
  enddo
  open(unit=30,file='z',status='unknown')
  write(30,*) (z(i),i=1,nz)
  close(30)

  time=0.
  m=0.; Fsurf=0.
  open(unit=21,file='Tsurface',status='unknown') ! surface temperature
  open(unit=22,file='Tprofile',status='unknown') ! temperature profile
  !HA = 2.*pi*time   ! hour angle

  call flux_mars2(marsR,marsDec,latitude,HA,fracir,fracdust, &
       &          zero,zero,zero,Qdir(1),Qscat,Qlw)
  Qn(1) = (1-albedo(1))*(Qdir(1)+Qscat) + emiss(1)*Qlw
  skyviewfactor = cos(surfaceSlope*d2r/2.)**2
  call flux_mars2(marsR,marsDec,latitude,HA,fracir,fracdust, &
       &          surfaceSlope*d2r,azFac*d2r,zero,Qdir(2),Qscat,Qlw)
  Qn(2) = (1-albedo(2))*(Qdir(2)+Qscat*skyviewfactor) + emiss(1)*Qlw*skyviewfactor
    
  
  !-loop over time steps 
  do n=0,nsteps-1
     time = (n+1)*dt   !   time at n+1 
     !  Solar insolation and IR at future time step
     tdays = time*(marsDay/earthDay)  ! parenthesis may improve roundoff
     
     !call marsorbit(dt0_j2000,tdays,marsLs,marsDec,marsR)
     !HA = 2.*pi*mod(time,1.d0)    ! hour angle
     !print *,'Ls1=',marsLs,'HA1=',HA
     
     call marsclock24(jd+tdays,buf,marsLs,marsDec,marsR,lonW,LTST)
     HA = 2.*pi*mod(LTST+12,24.d0)/24. ! hour angle
     !print *,'Ls2=',marsLs,'HA2=',HA
     
     patm = exp(-htopo/10800.) * psurf_season(520d0,marsLs)
     Tco2frost = tfrostco2(patm)
     
     ! direct and sky irradiance on horizontal unobstructed surface
     call flux_mars2(marsR,marsDec,latitude,HA,fracir,fracdust, &
          &          zero,zero,zero,Qdir(1),Qscat,Qlw)
     Qnp1(1) = (1-albedo(1))*(Qdir(1)+Qscat) + emiss(1)*Qlw
     ! direct and sky irradiance on slope
     call flux_mars2(marsR,marsDec,latitude,HA,fracir,fracdust, &
          &          surfaceSlope*d2r,azFac*d2r,zero,Qdir(2),Qscat,Qlw)
     Qnp1(2) = (1-albedo(2))*(Qdir(2)+Qscat*skyviewfactor) + emiss(1)*Qlw*skyviewfactor
     ! terrain irradiance on slope
     Qnp1(2) = Qnp1(2) + (1.-skyviewfactor)*sigSB*emiss(1)*Tsurf(1)**4
     Qnp1(2) = Qnp1(2) + (1.-skyviewfactor)*albedo(1)*Qdir(1)
     
     do k=1,2
        Tsurfold = Tsurf(k)
        Fsurfold = Fsurf(k)
        Told(1:nz) = T(1:nz,k)
        
        if (Tsurf(k)>Tco2frost .or. m(k)<=0.) then
           call conductionQ(nz,z,dtsec,Qn(k),Qnp1(k),T(:,k),ti(:,k),rhocv(:,k), &
                &           emiss(k),Tsurf(k),Fgeotherm,Fsurf(k))
        endif
     
        if (Tsurf(k)<Tco2frost .or. m(k)>0.) then   ! CO2 frost
           T(1:nz,k) = Told(1:nz)
           call conductionT(nz,z,dtsec,T(:,k),Tsurfold,Tco2frost, &
                &           ti(:,k),rhocv(:,k),Fgeotherm,Fsurf(k)) 
           Tsurf(k) = Tco2frost
           dE = (- Qn(k) - Qnp1(k) + Fsurfold + Fsurf(k) + &
                &  emiss(k)*sigSB*(Tsurfold**4+Tsurf(k)**4))/2.
           m(k) = m(k) + dtsec*dE/Lco2frost
        endif
        
        if (Tsurf(k)>Tco2frost .or. m(k)<=0.) then
           albedo(k) = albedo0
           emiss(k) = emiss0
        else
           albedo(k) = co2albedo
           emiss(k) = co2emiss
        endif
        
     enddo
     
     Qn(:) = Qnp1(:)
     
     !-only output and diagnostics below this line
     if (time>=tmax-solsy) then  ! last solar year
        Tmean = Tmean + Tsurf(2)
        Tmean2 = Tmean2 + T(nz,2)
        nm = nm+1
     endif
     if (time >= tmax-2.) then ! last two sols
        !write(21,'(f12.6,4f10.4)') time,marsLs/d2r,Tsurf(2),m(2),Tsurf(1)
        write(21,'(f9.5,2x,f6.3,2x,f6.2,2x,f8.3,1x,f6.2)') &
             & marsLs/d2r,LTST,Tsurf(2),max(m(2),0.d0),Tsurf(1)
     endif
     if (time>=tmax-solsy .and. mod(n,nint(solsy/dt/40.))==0) then
        write(22,'(f12.4,*(1x,f6.2))') time,(T(i,2),i=1,nz)
     endif
     
  enddo                     ! end the time loop
  
  close(21)
  close(22)
  
  print *,Tmean/nm,Tmean2/nm

end program mars_thermal2p
