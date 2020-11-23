      program read_netcdf
c
c This program provides a simple example of how to read
c   TAO netcdf files using the EPSLIB library, which also
c   includes routines for converting the time array to 
c   month-day-year-hour-minute-second. If you have programming
c   skills, it should be straightforward to extend this code
c   as you need to.
c
c Compile and link like this:
c
c  f77 read_netcdf.f -o read_netcdf.x -leps -lnetcdf
c
c You will need to have installed the netcdf library
c  and EPSLIB. You can get these here:
c
c http://www.epic.noaa.gov/epic/download/
c
c and there is a pretty good manual for EPSLIB.
c
      implicit none
c
      integer nx, ny, nz, nt
      parameter(nx = 1, ny = 1, nz = 1, nt = 10000) ! daily surface data
c
      real d(nx,ny,nz,nt), lon(nx), lat(ny), depth(nz)
      integer itime(2,nt), nlon, nlat, ndep, ntim
c
      integer iyr, imon, iday, ihr, imin
      real sec
c
      integer ivar

      character*80 infile
c
c................................................................
c
      write(*,*) 'Enter the name of the input netcdf file'
      read(*,'(a)') infile
c
      write(*,*) 'Enter the variable code you wish to extract'
      read(*,*) ivar
c
      call rdcdf(ivar, infile, d, lon, lat, depth, itime,
     .                   nlon, nlat, ndep, ntim,
     .                       nx, ny, nz, nt)
c
c this converts from the double integer to calendar time
c mdyhms is a pnemonic for month-day-year-hour-minute-second
c
c write first time to standard output
c
      call eptimetomdyhms(itime(1,1),imon,iday,iyr,ihr,imin,sec)
      write(*,*) ' First time in file', 
     .            iyr, imon, iday, ihr, imin, sec
c last time
      call eptimetomdyhms(itime(1,ntim),imon,iday,iyr,ihr,imin,sec)
      write(*,*) ' Last time in file', 
     .            iyr, imon, iday, ihr, imin, sec
c
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
       subroutine rdcdf(varid, infile, data, lon, lat, depth, itime,
     .                           nlon, nlat, ndep, ntim,
     .                               nx, ny, nz, nt)
c
c Read in an entire variable from a netcdf file of up to 4 dimensions.
c  Can also be used to read 1-D classic EPIC time series files with 
c    dimensions set to {nx=1,ny=1,nz=1,nt=N}, and EPIC hydrographic
c    files with dimensions set to {nx=1,ny=1,nz=M,nt=1}.
c
c Programmed by Dai McClurg, NOAA/PMEL/OCRD, Aug 1993
c
c -------------------------------------------------------------------
c
c I/O	name		description
c
c  I	varid		integer EPIC key code for variable to be read
c  I	infile		character file name
c  O	data		real array containing variable
c  O	lon		real longitude axis dimensioned to nx
c  O	lat		real latitude axis dimensioned to ny
c  O	depth 		real depth axis dimcensioned to nz
c  O	itime		integer EPIC time axis dimensioned to (2,nt)
c  O	nlon, nlat, ndep, ntim:	shape of variable contained in data
c  I	nx, ny, nz, nt:	dimensions of data and axes declared in main 
c
c -------------------------------------------------------------------
c
       include '/usr/local/include/epsystem.fh'
c
       integer nlon, nlat, ndep, ntim
       integer nx, ny, nz, nt
c
       real data(nx,ny,nz,nt), lon(nx), lat(ny), depth(nz)
c
       integer epf, itime(2,nt)
       integer lci(4), uci(4), dims(4), varid, istd
       parameter(istd = 6)
c
       character infile*(*), cdffil*80
c
c ...................................................................
c
       call epsetindx(nx, ny, nz, nt, dims)
c
       call epopen(epf, infile, EPREAD)
c
       call epmesgdo(epf, istd, EPSTOP)
c
       call epsetnext(epf, cdffil)
c
       call epgetvarshap(epf, varid, lci, uci)
c
       nlon = uci(1)
       nlat = uci(2)
       ndep = uci(3)
       ntim = uci(4)
c
       call epgetaxis(epf, varid, 1, lci, uci, lon, nx)
c
       call epgetaxis(epf, varid, 2, lci, uci, lat, ny)
c
       call epgetaxis(epf, varid, 3, lci, uci, depth, nz)
c       
       call epgettaxis(epf, varid, lci, uci, itime, nt)
c
       call epgetvar(epf, varid, lci, uci, data, dims)
c
       call epclose(epf)
c
       return
c
       end
