##split csv file 
##脚本中命令行根据需求使用，可能用不到
##提取对应特征的部分 example command line
awk -F ',' '{OFS=",";{for(i = 11; i <= 19; i++) printf("%s,", $i); printf("\n")}}' ear_gene_count_matrix.csv > aco10day.csv
##提取列头
awk -F ',' '{OFS=",";{for(i =1; i <= 1; i++) printf("%s,", $i); printf("\n")}}' ear_gene_count_matrix.csv > rowhead.csv
##根据需要粘合文件
paste -d '' rowhead.csv mus20day.csv mus15day.csv > mus20dayvs15day.csv 
##去除粘合后每行末端的逗号
sed -i 's/\,$//g' filename
##去除^M
cat -v filename | sed 's/\^M//g' > filename.csv
