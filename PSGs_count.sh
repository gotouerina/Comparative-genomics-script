for i in *.fa.filter.result; do perl PSGs_count.pl $i >> PSGs.count ; done
perl -F'\t' -alne 'print if $F[4]<0.05 && $F[2]>1' PSGs.count > PSGs.list
