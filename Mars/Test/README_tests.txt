Examples for validation:
========================

1. Basic thermal model for Mars

make mars_thermal

./a.out

reads input.par and produces outputs 'Tprofile', 'Tsurface', and 'z'



2a. Equilibrium ice table for a list of sites:

make mars_mapi

./a.out

reads inputs from 'mapgrid.dat' and outputs 'mapgrid2.dat', which contains the
depths of the equilibrium ice table.

make mars_mapt

./a.out

reads 'mapgrid2.dat' and outputs 'mapgrid3.dat', which should be idential to
'mapgrid2.dat', as well as 'means'.



2b. Equilibrium ice table for a list of sites using mars_mapii:

make mars_mapi

./a.out

reads inputs from 'mapgrid.dat' and outputs 'mapgrid2.dat';
compare with 'mapgrid2.ii'



3. Ice retreat at Phoenix Landing site over the last 2000 years:

make mars_fast

./mars_fast ph

This will read input file 'lats.ph' and produce output files 'depths.ph' and
'depthF.ph'.



4. Equilibrium ice table depths for various slopes:

make mars_mapi2p

mars_mapi2p_go.cmd

reads inputs from mapgrid.slp and outputs 'mapgrid2.1' and 'mapgrid2.2'
the merged output is provided under the filename 'mapgrid2.slp'

