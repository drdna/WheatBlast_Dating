# R
library(ape)
library(scales)

# Load ML tree
t=read.tree("AllClust.snps.filtered.fullinfo.fasta_out.labelled_tree.newick")

# Compute pairwise cophenetic / patristic distances and select distances to T25 - the oldest sample
distances <- cophenetic(t)
colnames(distances) = gsub("_.*", "", colnames(distances))
#rownames(distances) = gsub("_.*", "", rownames(distances))

dist_to_T25 <- distances[colnames(distances) == 'T25', ]
#dist_to_T25 <- distances[ , rownames(distances) != 'T25']

# Load the collection dates and match them with the distances
dt <- read.table('FullDataset.dates', header = FALSE)
dts <- c()
for(n in names(dist_to_T25)){dts <- c(dts, dt[dt[,1] == n, 2])}
m <- data.frame(Coll_Year = dts, Patr_dist_to_T25 = dist_to_T25)
m <- m[rownames(m) != "T25", ]  # remove self comparison
plot(m)
legend('topright', paste("Pearson\'s r =", round(cor(m$Coll_Year, m$Patr_dist_to_T25), 2)), bty = 'n')
abline(lm(m$Patr_dist_to_T25 ~ m$Coll_Year), lty = 2)
cor.test(m$Coll_Year, m$Patr_dist_to_T25)
