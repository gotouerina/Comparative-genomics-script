分析流程已迁移至WIKI，详见

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


# Software WGSP for analysis

install :

                wget https://github.com/gotouerina/Comparative-genomics-script/releases/download/v2.0/WGSP-Base.zip
                unzip WGSP-Base.zip; cd WGSP-Base
                perl  Makefile.PL;
                make

Manual is still need updated.





                



