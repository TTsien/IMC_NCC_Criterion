setwd("/Users/terrytsien/Desktop/210126_3ROImerge_analysis")
library(ggplot2)
library(dplyr)
library(RColorBrewer)
library(reshape2)
library(stringr)

tsne <- read.csv("tsne_final.csv")
data <- read.csv("ALL_merge.csv")
data <- data[,4:36]
#抗体强度取log1p(100*),面积取log1p
data[,2:29] <- log1p(100*data[,2:29])
data[,2:29] <- scale(data[,2:29])
data[,colnames(data)=="Area"] <- log1p(data[,colnames(data)=="Area"])
colnames(data)[2:29] <- str_sub(colnames(data)[2:29], start = 6L, end = -12L)


tsne_marker <- left_join(tsne, data, by=c("id" = "id"))
tsne_marker_long <- melt(tsne_marker, id=c("core","CellId","tsne1","tnse2","id"), value.name="Z-score")

mycolors <- brewer.pal(9,"OrRd")

myplot <- function(channel){
  df <- tsne_marker_long[tsne_marker_long$variable==channel,]
  ggplot(data = df, aes(x=tsne1, y=tnse2, color=`Z-score`))+
    geom_point(size=0.2)+
    scale_color_gradient(low = mycolors[1], high = mycolors[length(mycolors)])+
    labs(x="tSNE1", y="tSNE2")+
    theme_bw()+
    facet_wrap( ~ variable, scales="free")
  file_name <- paste0("tsnemarker_",channel,".pdf")
  ggsave(file_name, width = 6, height = 6)
}

marker_list <- unique(tsne_marker_long$variable)
sapply(marker_list, myplot)


# #拼图使用同一强度范围，未采用
# ggplot(data = tsne_marker_long, aes(x=tsne1, y=tnse2, color=intensity))+
#   geom_point(size=0.3)+
#   scale_color_gradient(low = mycolors[1], high = mycolors[length(mycolors)])+
#   labs(x="tSNE1", y="tSNE2")+
#   theme_bw()+
#   facet_wrap( ~ variable, scales="free")
# ggsave("combined.pdf", width = 15, height = 15)
