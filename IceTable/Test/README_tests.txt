Examples for validation
=======================

1. Equilibrium ice table for a list of sites:

make mars_mapi

./a.out

reads inputs from 'mapgrid.dat' and outputs 'mapgrid2.dat', which contains the
depths of the equilibrium ice table.

make mars_mapt

./a.out

reads 'mapgrid2.dat' and outputs 'mapgrid3.dat', which should be identical to
'mapgrid2.dat', as well as 'means'.



2. Equilibrium ice table for a list of sites using mars_mapii:

make mars_mapii

./a.out

reads inputs from 'mapgrid.dat' and outputs 'mapgrid2.dat';
compare with 'mapgrid2.ii'



3. Equilibrium ice table depths for various slopes:

make mars_mapi2p

mars_mapi2p_go.cmd

reads inputs from mapgrid.slp and outputs 'mapgrid2.1' and 'mapgrid2.2'
the merged output is provided under the filename 'mapgrid2.slp'

