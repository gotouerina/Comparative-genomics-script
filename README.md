# Cactus比对流程 2024.9.4

## 重复序列屏蔽
Cactus比对的基因组必须经过软屏蔽（即将重复序列中大写的ATCG改为小写的atcg）。这一步主要通过repeatModerer和repeatmasker进行。

    BuildDatabase  -name $i $i.fasta
    RepeatModeler -pa 20 -database $i -LTRStruct
    RepeatMasker $i.fasta -lib $i-families.fa  -e rmblast -xsmall -s -gff -pa 12

得到$.fasta.masked即为软屏蔽基因组。

在NCBI下载的基因组默认为软屏蔽，使用前需要确认。

## Mashtree构建、定根

使用mashtree建树用于比对的输入；

    mashtree *.fasta > results.dnd #构建系统发育树
    nw_reroot results.dnd > rooted.results.dnd  #定根

常规安装有困难可以使用singualrity容器

    singularity exec /home/106public/software/mashtree_latest.sif    mashtree
    

## 配置文件书写

cactus需要配置文件，第一行为定根过的系统发育树；第二行起需要两列，tab键分隔（\t）; 第一列为系统发育树中的名字，第二列为基因组路径

例：

    (Sorex:0.0544,(Uropsilus:0.07434,(Condylura:0.06856,((((Urotrichus:0.01627,Dymecodon:0.01474):0.04239,Scaptonyx:0.05570):0.00322,((Toccidentalis:0.00592,Teuropaea:0.00685):0.02124,((((Scaptochirus:0.00304,Scapanulus:0.00348):0.01420,Parascaptor:0.01605):0.00210,Euroscaptor:0.01915):0.00302,Mogera:0.02491):0.00933):0.02453):0.00061,(Galemys:0.06160,(((Scapanus:0.00190,Neurotrichus:0.00162):0.01527,Scalopus:0.02044):0.01619,Parascalops:0.03749):0.02099):0.00061):0.00092):0.01560):0.0544);
    Condylura       Condylura_cristata.rename.fa
    Dymecodon       Dymecodon.softmask.fa
    Euroscaptor     Euroscaptor.softmask.fa
    Galemys Galemys_pyrenaicus.rename.fa
    Neurotrichus    Neurotrichus.softmask.fa
    Parascalops     Parascalops.v3.softmask.fa
    Parascaptor     Parascaptor.softmask.fa
    Scalopus        Scalopus_aquaticus.softmask.fa
    Scapanulus      Scapanulus_oweni.softmask.fa
    Scapanus        Scapanus_orarius.softmask.fa
    Scaptochirus    Scaptochirus.softmask.fa  
    Scaptonyx       Scaptonyx.softmask.fa
    Sorex   Sorex_araneus.softmask.fa
    Teuropaea       Talpa_europaea.rename.fa
    Toccidentalis   Talpa_occidentalis.rename.fa
    Uropsilus       Uropsilus_gracilis.rename.fa
    Mogera  Mogera.v2.softmask.fa
    Urotrichus      Urotrichus.softmask.fa



    

## 比对

    cactus Align  配置文件  输出文件名 --maxCore=80  --workDir tmp --lastzMemory 16G  --maxDisk  20T

--maxCore CPU数，需要跑快点可以增加，最高不能超过系统核心总数。cactus装不上也可以用singularity拉容器， /home/106public/software/cactus_v2.8.2.sif



旧分析流程已迁移至WIKI，详见 https://github.com/gotouerina/Comparative-genomics-script/wiki

## 提取指定物种

 ~/Repeat/UCSCtools/mafSpeciesSubset Acomys.filter.maf species.lst Only_Acomys.filter.maf 






                



