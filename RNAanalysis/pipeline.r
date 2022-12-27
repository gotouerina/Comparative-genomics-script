#######@FPKM count in linux#############
#--------------------------------------#
#######make by Kogoori Masaki###########
#--------------------------------------#
##########r-base version > 4.2.2########
##Usage:Rscript pipeline.r input.csv experiment_rownumber control_rownumber total_number experiment_name control_name title_name
library(tidyverse,quietly = TRUE)
library(DESeq2, quietly = TRUE)
library(ggplot2)
library(pheatmap)
library(FactoMineR)
##工作目录自己设置,linux中不需要
#setwd("D:/工作文档/RNA")
#使用外部传参,a为输入问文件名，b和c是实验组和对照组的数量,d是output前缀
#name1为实验组名称，name2为对照组名称，titlename为输出的图的标题名称
argv<-commandArgs(TRUE)
a <- argv[1]
b <- argv[2]
c <- argv[3]
d <- argv[4]
name1 <- argv[5]
name2 <- argv[6]
titlename <- argv[7]
##读取CSV文件，stringtie跑完后用prep.py处理得到的gene_table
file <- read.csv(a,header = TRUE,row.names = 1)
#输入数据
count <- file[1:d]
count <- as.matrix(count)
sample <- as.data.frame(colnames(file))
##添加factor
sample$deal <- c(rep(name1,b),rep(name2,c))
names(sample) <- c("sam","condition")
rownames(sample) <- sample$sam
sample %>% select(-1) -> sample
##计算差异表达
dds <- DESeqDataSetFromMatrix(countData = count,colData = sample,design = ~ condition)
dds1 <- DESeq(dds, fitType = 'mean', minReplicatesForReplace = 7, parallel = FALSE)
##name1在前name2在后，是说name1实验组相对于name2对照组有哪些基因上调/下调
res <- results(dds1, contrast = c('condition', name1, name2))
res1 <- data.frame(res, stringsAsFactors = FALSE, check.names = FALSE)
##输出差异表达分析文件diffselect.txt
write.table(res1, "diffselect.txt", col.names = NA, sep = '\t', quote = FALSE)
##去除basemean=0的行用于后续分析
res1<-res1[complete.cases(res1),]

##筛选差异表达基因
res1 <- res1[order(res1$padj, res1$log2FoldChange, decreasing = c(FALSE, TRUE)), ]
res1[which(res1$log2FoldChange >= 1 & res1$padj < 0.01),'sig'] <- 'up'
res1[which(res1$log2FoldChange <= -1 & res1$padj < 0.01),'sig'] <- 'down'
res1[which(abs(res1$log2FoldChange) <= 1 | res1$padj >= 0.01),'sig'] <- 'none'
res1_select <- subset(res1, sig %in% c('up', 'down'))
##输出差异表达分析文件上调下调统计文件updownselect.txt
write.table(res1_select, file = 'updownselect.txt', sep = '\t', col.names = NA, quote = FALSE)

##ggplot2绘制火山图
p <- ggplot(data = res1, aes(x = log2FoldChange, y = -log10(padj), color = sig)) +
  geom_point(size = 1) +  #绘制散点图
  scale_color_manual(values = c('red', 'gray', 'green'), limits = c('up', 'none', 'down')) +  #自定义点的颜色
  labs(x = 'log2 Fold Change', y = '-log10 adjust p-value', title = titlename, color = '') +  #坐标轴标题
  theme(plot.title = element_text(hjust = 0.5, size = 14), panel.grid = element_blank(), #背景色、网格线、图例等主题修改
        panel.background = element_rect(color = 'black', fill = 'transparent'), 
        legend.key = element_rect(fill = 'transparent')) +
  geom_vline(xintercept = c(-1, 1), lty = 3, color = 'black') +  #添加阈值线
  geom_hline(yintercept = 2, lty = 3, color = 'black') +
  xlim(-15, 15) + ylim(0, 500)  #定义刻度边界
ggsave(p,filename = "vocalno.pdf",width = 12,height = 9)

##ggplot 绘制PCA图
vsd <- varianceStabilizingTransformation(dds)
data <- plotPCA(vsd, intgroup=c("condition"), returnData=TRUE)
percentVar <- round(100 * attr(data, "percentVar"))
q <- ggplot(data, aes(PC1, PC2, color = condition)) + 
  geom_point(size=3) + xlab(paste0("PC1: ",percentVar[1],"% variance")) + 
  ylab(paste0("PC2: ",percentVar[2],"% variance")) + 
  labs(title = titlename ) + theme_bw()
ggsave(q,filename = "pca.pdf",width = 12,height = 9)

##ggplot 绘制热图
ddCor <- cor(count, method = "spearman")
pheatmap(file="pheatmap.pdf",ddCor, clustering_method = "average", 
         display_numbers = F,legend=TRUE,show_rownames=F,show_colnames=F,border = F,
         treeheight_row=50)
