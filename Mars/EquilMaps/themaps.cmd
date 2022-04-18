#!/bin/csh

# plot map of equilibrium ice table depth for north polar region
# updated to GMT 6.0

# setting gmt defaults
gmt set COLOR_NAN 150
gmt set COLOR_BACKGROUND white
gmt set PROJ_LENGTH_UNIT inch
gmt set FONT_ANNOT_PRIMARY 14p

set BB = -Ba30f15g15/a10g10
set RR = -R-180/180/-90/-45
set JJ = -Js0/-90/2i/-45

cat Data/mapgrid2.6b__40 | awk '{if ($6>0) print $1,$2,$6; else print $1,$2,-9999.}' | awk '{if ($2<-40) print}' >! bd.txt
cat bd.txt | gmt xyz2grd -r -Gbd.grd -I5/1 -R-180/180/-90/0  

# assembling maps
#cat Data/mapgrid2.6b__40 | awk '{if ($2>=65 || ($2<=45 && $2>=-45) || $2<=-65) print $1,$2,$6}' >! bd.txt
#cat Data/mapgrid2.7c__40 | awk '{if (($2<65 && $2>45) || ($2>=-65 && $2<-45)) print $1,$2,$6}' >> bd.txt
#cat bd.txt | awk '{if ($2<75) print}' | gmt nearneighbor -Gbd.grd -I5/0.25 -R-180/180/0/90 -S0.5 -fg -N1 

# create color map
gmt makecpt -Chaxby -Z -T0/0.6/0.02 >! bd.cpt 

# plot map with frame
gmt psbasemap -Y1.5 $RR $JJ $BB -K -P >! bds.ps
gmt grdimage  bd.grd  -Cbd.cpt $RR $JJ -O -K >> bds.ps
gmt psbasemap $RR $JJ $BB -K -O  >> bds.ps

# label latitude rings
echo 90 -90   -90@. >! tmp
echo 90 -80   -80@. >> tmp
echo 90 -70   -70@. >> tmp
echo 90 -60   -60@. >> tmp
echo 90 -50   -50@. >> tmp
gmt pstext tmp $JJ $RR -Xa0 -Ya-0.10 -F+f14+a0 -O -K >> bds.ps
rm -f tmp

# add color bar
gmt psscale -Cbd.cpt -D2/-.4/4/.15h -Ef -B0.1:"Ice Burial Depth (m)":  -O >> bds.ps

rm -f bd.cpt bd.grd bd.txt 
rm -f gmt.conf gmt.history

#gv bds.ps
ps2eps -f bds.ps 
gmt psconvert bds.eps -Tg
rm -f bds.ps bds.eps 
