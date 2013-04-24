coords_add=`v.out.ascii Boundary_points@Boundary |cut -d "|" -f1,2 | tr "|" ","`
 
 for i in $coords_add ; do
     v.edit Boundary@Boundary tool=vertexadd coor=$i
 done
