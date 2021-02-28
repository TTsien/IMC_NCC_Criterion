library(ggplot2)
setwd("/Users/terrytsien/Desktop/210126_3ROImerge_analysis")
data <- read.csv("ALL_merge_split.csv")
phen_table <- read.csv("pheno_final.csv")

#data transform(log1p)
channels <- c("CD45","CD3","CD4","Foxp3","CD8","CD11b","CD11c",
              "CD14","CD15","CD16","CD19","CD33","CD56","CD68",
              "IFN_g","HLA_DR","PD_1","PD_L1","PD_L2","TGF_b",
              "CK_AE1AE3","TNF_a","aSMA","collagen1","E_cadherin","vimentin","Ki_67","b_catenin")
data[data$channel%in%channels,]$mc_counts <- log1p(1000*data[data$channel%in%channels,]$mc_counts)
data[data$channel=="Area",]$mc_counts <- log1p(data[data$channel=="Area",]$mc_counts)

#需要将数据分为特定亚组和其他亚组
grouping <- function(X){
  d1 <- phen_table[phen_table$PhenoGraphBasel==X,]
  data_sub <- data[data$id%in%phen_table[phen_table$PhenoGraphBasel==X,]$id,]
  data_exclude_sub <- data[data$id%in%phen_table[phen_table$PhenoGraphBasel!=X,]$id,]
  data_sub$group <- "sub"
  data_exclude_sub$group <- "nonsub"
  data2 <- rbind(data_sub, data_exclude_sub)
  return(data2)
}

myplot <- function(ch){
  dat_grouped <- grouping(ch)
  
  dat_grouped$group <- factor(dat_grouped$group, levels = c("nonsub","sub"), labels = c("other", ch))
  dat_grouped$channel <- factor(dat_grouped$channel,
                                levels = c("CD45","CD3","CD4","Foxp3","CD8","CD11b","CD11c",
                                           "CD14","CD15","CD16","CD19","CD33","CD56","CD68",
                                           "IFN_g","HLA_DR","PD_1","PD_L1","PD_L2","TGF_b",
                                           "CK_AE1AE3","TNF_a","aSMA","collagen1","E_cadherin","vimentin","Ki_67","b_catenin",
                                           "Area","Eccentricity","Extent","Number_Neighbors"),
                                labels = c("CD45","CD3","CD4","Foxp3","CD8","CD11b","CD11c",
                                           "CD14","CD15","CD16","CD19","CD33","CD56","CD68",
                                           "IFN-gamma","HLA-DR","PD-1","PD-L1","PD-L2","TGF-beta",
                                           "CKAE1/AE3","TNF-alpha","alpha-SMA","collagen-I","E-cadherin","vimentin","Ki-67","beta-catenin",
                                           "Area","Eccentricity","Extent","Num of Neighbors"))
  
  p <- ggplot(dat_grouped, aes(x=mc_counts))+
    geom_density(kernel ="epanechnikov", aes(fill = group), alpha=0.5)+
    #scale_x_continuous(trans = "sqrt")+
    scale_fill_manual(values = c("grey10", "red"))+
    labs(x = "Marker Counts (log)", y = "Density")+
    theme(panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"),
          axis.text = element_text(color = "black", size = 10),
          axis.title = element_text(color = "black", size = 12),
          legend.text = element_text(color = "black", size = 10),
          strip.text = element_text(color = "black", size = 10, face = "bold"))+
    facet_wrap( ~ channel, scales="free")
  
  ggsave(paste0("densplot_", ch, ".pdf"), plot = p, width = 15, height = 10)
  return(NULL)
}

group_list <- unique(phen_table$PhenoGraphBasel)
sapply(group_list, myplot)
