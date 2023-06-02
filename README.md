# Whole Genome analysis

The pipeline for genome ananlysis

## 01.Alignment（比对）

Lastal was used to align. Install:

        conda install -c bioconda last
        
Asuming you have 3 genomes, you should choose a ref FASTA Format genome and 2 query genome:

        ##参考建库
        lastdb -P8 -uMAM8 myDB $ref
        ##第一个Query比对参考
        last-train -P40 --revsym -E0.05 -C2 myDB $query1 >$sp1.train
        lastal -k32 -p $sp1.train myDB $query1 | last-split -fMAF+ >$sp1.maf
        maf-swap $sp1.maf |last-split |maf-swap |maf-sort > $sp1.filter.maf
        ##第二个query比对参考
        last-train -P40 --revsym -E0.05 -C2 myDB $query2 >$sp2.train
        lastal -k32 -p $sp2.train myDB $query2 | last-split -fMAF+ >$sp2.maf
        maf-swap $sp2.maf |last-split |maf-swap |maf-sort > $sp2.filter.maf
        
So you can get 2 MAF FORMAT files.

## 02.Rename (重命名)

## 03.Multiz (合并)

## 04.MAF2LST

## 05.Catch gene regions

## 06.Uncode Region Filter（去除密码子区域）
The uncode region filter script filter.pl

Usage 

    perl filter.pl [fasta] [filter_file]

## 07.PSG

## 08.RELAX

Psg_count.pl realx_count.pl are used for extract messages from hyphy output file.

RNAanalysis need SRA file downloaded from NCBI and analysis by stringtie/prepDE.py

Stringtie : https://github.com/gpertea/stringtie

hyphy: https://github.com/veg/hyphy

 #  RNA analysis (转录组分析)
 
 


