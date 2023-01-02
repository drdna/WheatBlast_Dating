## Plot the positions of SNPs along the reference chromosomes

library("ggplot2")

df <- read.table("LD_data_distr.txt", col.names = c('chrs', 'pos'), header=F)
chrLines <- data.frame(chrs = c("Chr1", "Chr2", "Chr3", "Chr4", "Chr5", "Chr6", "Chr7"),
                       chrLengths = c(7978604, 8319966, 6606598, 5546968, 4490059, 4133993, 3415785)) # 70-15 reference
chrLines$chrs <- factor(chrLines$chrs)

xlabels <- function(x) { x/1000000 }

#pdf("SNPdistrib.pdf", 8.5, 9.1)
ggplot(data = df, aes(pos)) + geom_histogram(binwidth = 20000, fill = "blue") + facet_grid(rows = vars(chrs)) +
  ylim(-20, 500) +  labs(title = "SNP distribution PY0925 v B71 (Burbano/Latorre data)", size = 10) + 
  xlab("Mb") + ylab("SNPs per 20 kb window") + theme(plot.title = element_text(size = 20)) + 
  geom_segment(data = chrLines, aes(x = 0, y = -20, xend = chrLengths, yend = -20)) +
  scale_x_continuous(breaks = seq(from = 0, to = 8400000, by = 1000000), labels=xlabels)
#dev.off()

