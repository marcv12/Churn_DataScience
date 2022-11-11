##PART 2

#This is a customer segmentation problem

#Start by installing/requiring packages
require(tidyverse)
require(factoextra)
require(GGally)


#Start by loading file
dat <- read.csv(file = "purchases.csv", 
                     header=T,
                     sep=",",
                     dec=".",
                     stringsAsFactors = T)


#QUESTION 7
# Let's select only numerical data (exclude region and channel)
datCl <- dat %>% dplyr::select(where(is.numeric))
str(datCl)

# Let's look at the distributions
ggpairs(datCl)

#We notice that the plots for all the variables are extremely asymmetrical to 
#the right. It would be best to apply log scaling

datCl <- datCl %>% mutate(across(.cols=everything(),function(x)log1p(x-min(x))))
ggpairs(datCl)

# We find extremely low log-milk and log-grocery: let's exclude them
excIdx <- datCl$Grocery<3
datCl <- datCl %>% filter(!excIdx)
dat <- dat %>% filter(!excIdx)

excIdx2 <- datCl$Milk<3
datCl <- datCl %>% filter(!excIdx2)
dat <- dat %>% filter(!excIdx2)

ggpairs(datCl)

# Scale data and visualize distributions
datCl <- datCl %>% scale() %>% as_tibble()
ggpairs(datCl)

# What are the possible distances we can choose from (among others)?

# Euclidean distance
dissEu <- get_dist(datCl, method = "euclidean")
fviz_dist(dissEu) # 3 groups?

# Pearson correlation
dissPe <- get_dist(datCl, method = "pearson")
fviz_dist(dissPe)  # Harder


#Let's start with hierarchical clustering
#Euclidian distance
# EUCLIDEAN

# WSS(elbow method)
fviz_nbclust(datCl, FUNcluster = hcut, diss = dissEu, method = "wss", k.max = 20)
#2-3-4 seem a good K on euclidian

# Silouhette
fviz_nbclust(datCl, FUNcluster = hcut, diss = dissEu, method = "silhouette", 
             k.max = 20)

# Silouhette finds  2 groups on Euclidean

#gap statistic method (even though we did not see in class)
fviz_nbclust(datCl, hcut, nstart = 25, diss = dissEu, method = "gap_stat", nboot = 50)+
  labs(subtitle = "Gap statistic method")
#also finds 2 clusters as optimal


#We take 2 as optimal number of clusters k
hierEu <- hcut(x = dissEu, isdiss = T, k = 2, hc_method = "ward.D2") 
#visualization will come later on

#Let's now use PEARSON instead of Euclidian. I personally would have chosen this 
#method to start with because when we are customer profiling, euclidian distance 
#looks at distances on axes between points (how far away are they) and this is
#not representative most of the time. Meanwhile Pearson focuses more on the 
#alignment of the points, which I think is more useful and accurate for this pb.

# PEARSON
#elbow method(WSS)
fviz_nbclust(datCl, FUNcluster = hcut, diss = dissPe, method = "wss", k.max = 20)
#With elbow method, 2 to 5 seem a good K on euclidian

# Silouhette
fviz_nbclust(datCl, FUNcluster = hcut, diss = dissPe, method = "silhouette", 
             k.max = 20)

#gap statistic method (even though we did not see in class)
fviz_nbclust(datCl, hcut, nstart = 25,  diss = dissPe, method = "gap_stat", nboot = 50)+
  labs(subtitle = "Gap statistic method")
#also finds 2 clusters as optimal

#so once again we get same as euclidian and choose 2 clusters
hierPe <- hcut(x = dissPe, isdiss = T, k = 2, hc_method = "ward.D2") 

#we'll visualize it later when comparing k means to hierarchichal clustering



#Let's go from hierarchical clustering to K-Means (also unsupervised algo)
fviz_nbclust(datCl, FUNcluster = kmeans, method = "wss")
fviz_nbclust(datCl, FUNcluster = kmeans, method = "silhouette")
fviz_nbclust(datCl, kmeans, nstart = 25,  diss = dissPe, method = "gap_stat", nboot = 50)+
  labs(subtitle = "Gap statistic method")
# All methods on k-means find 2 clusters

#let's visualize this
km2 <- kmeans(datCl, centers = 2)
fviz_cluster(object=km2, datCl) + theme_bw()

# Compare clusterings

#We can compare the agreement between different clustering using different methods
# Let's comapre the 2 groups HCut Pearson and the 2 groups kmeans
mclust::adjustedRandIndex(km2$cluster==1, hierPe$cluster)

# This value leans more towards an almost perfect agreement (closer to 1 than 0)
# but we'll consider it as a random agreement

#We now visualize the results we got from selecting optimal number of clusters 
#both for k means and for hierarchical clustering
p1 <- fviz_cluster(object=km2, datCl) + theme_bw() +
  labs(subtitle = "Kmeans")
p2 <- fviz_cluster(object=hierPe, datCl) + theme_bw() +
  labs(subtitle = "Hierarchical clustering(Pearson)")
p3 <- fviz_cluster(object=hierEu, datCl) + theme_bw() +
  labs(subtitle = "Hierarchical clustering(Euclidian)")

gridExtra::grid.arrange(p1, p2, p3, ncol=3) 



#QUESTION 8
#We almost made it! Last question
#In this last question, we want to see the association with a known channel,
#which is Channel

# Let's see if the clustering on the considered numerical variables agrees 
#with one of the original categorical covariates: channel
# Let us consider km2
datWC <- dat %>% mutate(clust=km2$cluster)

# We can show a contingency table
(contTable <- datWC %>% dplyr::select(Channel, clust) %>% table())

chisq.test(contTable) 
# The ChiSquare test shows dependence at 95% confidence (because p-value < 0.05) 
#so partition is not random w.r.t the channel!
# The partition is not random with respect to the channel variable

prop.table(contTable, margin=1)
#We observe that people who use Food service as a channel tend to be in the 
#first cluster (approx 94%), while people who use Food service tend to be in the 
#second cluster (approx 82%). We can thus conclude that indeed, units in the
#same business sector tend to have similar spending profiles.


#THE END, HOPE IT WAS ENJOYABLE!