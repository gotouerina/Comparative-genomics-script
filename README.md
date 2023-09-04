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
        
        perl maf.rename.species.S.pl $sp1.filter.maf $sp1 $sp1.last.maf >$sp1.rename.maf
        perl maf.rename.species.S.pl $sp2.filter.maf $sp2 $sp2.last.maf >$sp2.rename.maf
               
## 03.Multiz (合并)

        ## multiz合并maf(>3个query根据系统发育关系按顺序合并)
        multiz M=1 $sp1.rename.maf $sp2.rename.maf 0 U1 U2 > $sp1-$sp2.ma        

## 04.MAF2LST

        perl 01.convertMaf2List.pl $sp1-$sp2.maf $sp1-$sp2 $sp_ref $sp1,$sp2

## 05.Catch gene regions

        perl 02.lst2gene.pl $sp1-$sp2 $gff

## 06.Uncode Region Filter（去除密码子区域）
The uncode region filter script filter.pl

Usage 

        perl filter.pl [fasta] [filter_file]

## 07.contruct tree + root tree + label tree

        for i in genes/*.filter; do echo -e "iqtree -s $i" >> iqtree.sh; done
        for i in genes/*.treefile; do echo -e "nw_reroot  $i  imhausi > $i.nwk" >> reroot.sh; done
        for i in genes/*.nwk; do echo -e "hyphy label-tree.bf --tree $i --list chr.list --output $i.label" >> label.sh ;done

## 08.PSG(absrel)
        hyphy absrel --alignment genes/evm.model.Contig11.1.fa.filter \
        --tree genes/evm.model.Contig11.1.fa.filter.treefile.tree.nwk \
        --branches Foreground \
        -output genes/evvm.model.Contig11.1.fa.filter.result

## 09.PSG(busted)
        hyphy busted --alignment genes/evm.model.Contig11.1.fa.filter \
        --tree genes/evm.model.Contig11.1.fa.filter.treefile.tree.nwk \
        --branches Foreground \
        -output genes/evvm.model.Contig11.1.fa.filter.result
## 10.RELAX
        hyphy relax --alignment  genes/evm.model.Contig11.1.fa.filter \
        --test Foreground \
        --tree genes/evm.model.Contig11.1.fa.filter.treefile.tree.nwk \
        --output genes/evm.model.Contig11.1.fa.filter.relax

## Scripts

Psg_count.pl realx_count.pl are used for extract messages from hyphy output file.

hyphy: https://github.com/veg/hyphy

 #  RNA analysis (转录组分析)
 
 RNAanalysis need SRA file downloaded from NCBI and analysis by stringtie/prepDE.py
 
 Stringtie : https://github.com/gpertea/stringtie
 
 ## 00.filter
 fastp default parameter
 ## 01.Alignment（比对）

        hisat2 -x ca -p 8 -1 ${f}_clean_1.fastq.gz -2 ${f}_clean_2.fastq.gz  -S ${f}.sam
        samtools view -@ 16 -b -S ${f}.sam -o ${f}.bam
        samtools sort ${f}.bam > ${f}.sort.bam
        # rm ${f}.bam ${f}.sam 
                 
 ## 02.Stringtie

        ## mkdir N1
        stringtie-2.2.1.Linux_x86_64/stringtie  -G $gtf -o ./N1/${f}/${f}.gtf -e -B  -A ./N1/${f}/${f}.gene.tab N1/${f}.sort.bam

# SD counts

Using biser : https://github.com/0xTCG/biser

                pip install biser
                biser -o <output> -t <threads> <genome.fa>

# Software WGSP for analysis

install :

                wget https://github.com/gotouerina/Comparative-genomics-script/releases/download/v2.0/WGSP-Base.zip
                unzip WGSP-Base.zip; cd WGSP-Base
                perl  Makefile.PL;
                make

Manual is still need updated.


#        CNE estimator

Software : CLAPACK and PHAST, mafSplit、wigToBigWig and bigWigAverageOverBed

ClAPAC download :

                wget http://www.netlib.org/clapack/clapack.tgz
                tar zxf clapack.tgz
                cd CLAPACK-3.2.1/
                cp make.inc.example make.inc && make f2clib && make blaslib && make lib

PHAST download:

                wget https://github.com/CshlSiepelLab/phast/archive/v1.5.tar.gz
                tar zxf v1.5.tar.gz
                cd phast-1.5/src/
                make CLAPACKPATH=/path/CLAPACK-3.2.1

Others:

                wget https://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/mafSplit
                wget https://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/wigToBigWig
                wget https://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/bigWigAverageOverBed
                chmod +x *


CNE保守性是MAF下游分析。假设已有MAF文件,这一步生成模型文件phyloFit.mod

                phyloFit -i MAF $MAF_FILE（如果大于三个物种需要提供物种树）
                phyloFit -i MAF $MAF_FILE --tree $TREE

切分MAF：

                mafSplit _.bed maf/  $MAF_FILE -byTarget -useFullSequenceName

MAF位点排序：

                maf-sort $MAF_FILE > $MAF_SORT>FILE

PHAST保守性计算，以染色体LG19.maf为例

                 phastCons LG19.maf phyloFit.mod --target-coverage 0.25 --expected-length 12 --rho 0.4 --msa-format MAF --seqname cahirinus.LG19 --most-conserved bed/LG19.bed > wig/LG19.wig; done

the bed file and wig file are result file.

保守元件去掉编码区的之后，就得到了保守的非编码元件（Conserved noncoding DNA elements，CNEs）
根据注释提取CDS和基因:

              for i in *.bed ; do cat $i | sed 's/cahirinus\.//g' > $i.bed2 ; done
              for i in LG{01..19}; do grep "$i" cishu.gff > $i.bed; done
              for i in *.bed ; do cat $i | grep "CDS " | awk '{OFS="\t"; print $1,$4,$5,$9 }' > $i.bed3 ; done
              for i in *.bed ; do cat $i | grep "gene " | awk '{OFS="\t"; print $1,$4,$5,$9 }' > $i.bed3 ; done


根据注释过滤：

                bedtools subtract  -a $i.bed.bed2 -b $i.bed.bed3 

寻找最近的基因：

                bedtools closest  -a $i.CNE.bed -b $i.bed.bed4


                



