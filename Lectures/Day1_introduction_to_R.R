
##################################################################
##           Networks and Innovation training programme 
##                             Day 1
##
##################################################################

# Getting us started
# a first simple function


######
######
# Life, the Universe and the Rest
######

forty_two <- function(x){
  if (x=="Don't panic"){
    cat("You have your towel, right?\n")
    system("C:\\Users\\avernet\\AppData\\Local\\Google\\Chrome\\Application\\chrome.exe http://www.youtube.com/v/C2kKdNBbz2M?enablejsapi=1&version=3&playerapiid=ytplayer&autoplay=1&start=18&end=29")
      #"C:\\Users\\avernet\\AppData\\Local\\Google\\Chrome\\Application\\chrome.exe ")
  }else{
    cat("Don't panic and try again")
  }
}

forty_two("Towel")

forty_two("Don't panic")


# But this is pretty useless.
# Using the same exact concepts, you can do this:


autoSetWD <- function(filename){
  wd <- shell(paste("dir /S /b", filename), inter=TRUE)
  setwd(substr(as.character(wd), 1,nchar(wd)-nchar(filename)))
}

# This will automatically set the working directory to where the file with the name you have specified as an argument is located.
# Warning: this only works on Windows.
setwd("C:\\Users\\avernet\\Desktop\\data")
getwd()
autoSetWD("Day1_introduction_to_R.R")
getwd()



#############
# Revisions on R
#
##############

# R is your regular calculator

# Addition

2+2

# Division

5/3

2/Inf

#########################
#########################
# But R does a bit more
#########################
#########################


# graphs

x <- seq(-5, 5, 1)
y <- seq(0, 10, 1)
z <- c(1,2,3,4,5)


# x <- c("for", 2,3)
# x
plot(x,y^2, type="p")


# nicer graphs
library(ggplot2)

plot <- ggplot(diamonds, aes(carat, price, colour=color, shape=cut))
plot <- plot + geom_point() + labs(title="Diamonds price by carat, cut and colour")
plot

# ggplot2 is more complex than the standard plot function but it is also far more flexible.


# fun stuff
demo(persp)
# demo is a good function to get an idea of what a function does.
# however, not every function has a demo.



####################
# regression
####################

#datasets mtcars

# Data on cars' gas consumption

# The function str gives you an overview of a dataframe.
# mtcars is the name of a dataframe that is readily available in R for teaching purposes.
str(mtcars)

# str() has been voted the single most useful command in R by the Stack Overflow community.
# you definitely want to try str() on an object when you are trying to do something with it that does not work. More often that not, you will realise that this object is not exactly what you thought it was.


# summary is a function that gives you some numeric information on the data in a dataframe (or in a lot of other R objects, like regression models).

summary(mtcars)



# A personal function to do (or try hard to do) nice correlation tables
#setwd("C:\\Users\\avernet\\Dropbox\\NITP\\NITP_Scripts_and_Exercises")
source("./cor.mat.R") #put this one as a gist online

correlationTable <- cortab(mtcars[,c("mpg", "cyl", "wt", "am", "hp", "gear")])

correlationTable

# So, as you can see, there is quite a lot of high correlations, not ideal for a regression, but let's ignore it and go forward anyway:

carsMpg <- lm(mpg~ cyl + wt + am + log(hp) + gear, data=mtcars)

summary(carsMpg)

# Not surprisingly, it seems that the weight of the car and it's overall horsepower are the two main reason cars don't perform well on consumption.



####################################################################
# Let's have a bit of a look at how R loads data and stores it. ####
####################################################################


# Loading data


# set the directory to where the files are

setwd("C:\\Users\\avernet\\Dropbox\\NITP\\Participants folder\\Exercises\\Day 1 Exercise")

getwd()

#######################
# Loading text files: #
#######################

# tab delimited:

forum_txt <- read.table("forum1.txt",sep="\t", comment.char="")
forum_txt

# csv files

forum_csv <- read.csv("forum1.csv", row.names=1) #We need to specify that there are row names for the function to consider them as such and not as data
forum_csv

########################
# Loading binary files #
########################

# Loading RData format:

load("forum1.RData")
forum1

### You don't have to specify a destination object, because the .RData format encapsulate some metadata already, including the name of the object that was saved.
### The drawback of binary files is that you cannot access it visualy with a text editor or run any version control on it.
### The big advantage is that the data being compressed takes less space on the disk and loads faster in memory.


# Loading excel files:
# for the following, you will need the package "xlsx"

library(xlsx)

forum_xlsx <- read.xlsx("forum1.xlsx", sheetIndex=1)
forum_xlsx

# Loading stata files:
# for the following, you will need the package "foreign"

library(foreign)

read_dta <- read.dta("forum1.dta")

read_dta
# If you don't read files (except for the native R format) into objects, they appear in the console but don't get loaded in the workspace



###########################################################################
###########################################################################
##     Data Structures                                                   ##
##                                                                       ##
###########################################################################


# Vectors

v <- c(1,2,3)
v

# append to a vector
v[4] <- 8
v

# select a subset from a vector

v[3:4]


# Dataframe
# Think about your traditional excel spreadsheet...
# In reality, for R (the way the software stores and accesses it) it is a list of columns


dataframe1 <- data.frame(c(1:10), c(rep(1, 10)), c(11:20))
names(dataframe1) <- c("Numbers", "One", "MoreNumbers")

dataframe1

summary(dataframe1)

## create a dataframe by stitching vectors together

V1 <- c("a", "b", "c", "d", "e")
V2 <- c(1:5)

Df <- cbind(V1, V2)
Df

# It is a matrix
# Be careful: a matrix can only be of one data type (logical, factor, integer, numeric, character).
# R will automatically use the type of the most space consuming type present in the vectors you are binding (here, factor).

# Df is a matrix, to turn it into a dataframe:
Df <- as.data.frame(Df)
Df

str(Df)
# once you have a dataframe, you can change the types of columns independently.

Df[,"V2"] <- as.integer(Df[,"V2"])

str(Df)

# And of course, R does networks.

# before we do that, let's clean up
rm(list=ls())

ls()


# the function rm() removes objects from memory.
# you can pass it a list of objects.
# ls() is a function that list all the objects in memory.

######################
##### Network descriptive statistics
#####
###############


#### Let's load some data

load("forums.RData")


save(forum1, forum2, forum3, file="test_forum.RData")
rm(list=ls())
load("test_forum.RData")
# let's select one of those forum and turn it into a network

build_net <- forum1[,c("msg_id", "posted_by", "is_followup_to")]
build_net <- merge(build_net, forum1[,c("msg_id", "posted_by")], by.x="is_followup_to", by.y="msg_id", all.x=TRUE)


senders_receivers <- build_net[,3:4]
names(senders_receivers) <- c("senders", "receivers")

senders_receivers


# now we load a network library

library(igraph)

graph.edgelist(as.matrix(senders_receivers), directed=TRUE)

# It breaks because we have NAs (messages that don't have a receiver, because they are at the top of a thread)
# We can fix that by assuming that they reply to themselves, or by simply taking that initial link out of the network

# Let's do the former
senders_receivers <- senders_receivers[!is.na(senders_receivers[,"receivers"]),]

senders_receivers[1,]

# also, we have to be careful of igraph thinking we give id numbers from 0.
# the easy work around is not to feed it numbers

senders_receivers[,"senders"] <- as.factor(senders_receivers[,"senders"]) 
senders_receivers[,"receivers"] <- as.factor(senders_receivers[,"receivers"]) 

net1 <- graph.edgelist(as.matrix(senders_receivers), directed=TRUE)

summary(net1)

plot(net1, layout=layout.kamada.kawai, vertex.label=get.vertex.attribute(net1, "name"))

# ignore the warning, it occurs because of multiple links.
# the underlying structure of our network is a forum, so it is not unlikely that people will send each other multiple messages at different times.
# let's ignore that in our case (to make our lives simpler).

#########################################################################
# A bit of descriptive statistics on this network and on a bigger one: ##
#########################################################################

#Let's reload our networks
load("forums.RData")


# preparing the bigger network
bn <- forum9[,c("msg_id", "posted_by", "is_followup_to")]
bn <- merge(bn, forum9[,c("msg_id", "posted_by")], by.x="is_followup_to", by.y="msg_id", all.x=TRUE)


sr <- bn[,3:4]
names(sr) <- c("senders", "receivers")

sr <- sr[!is.na(sr[,"receivers"]),]

# also, we have to be careful of igraph thinking we give id numbers from 0.
# the easy work around is not to feed it numbers

sr[,"senders"] <- as.factor(sr[,"senders"]) 
sr[,"receivers"] <- as.factor(sr[,"receivers"]) 

net2 <- graph.edgelist(as.matrix(sr), directed=TRUE)

summary(net2)

plot(net2, layout=layout.kamada.kawai, vertex.label=get.vertex.attribute(net2, "name"))



average.path.length(net1) # This is the mean number of steps to get from one node to the next
average.path.length(net2)


transitivity(net1) # this is a clustering coefficient algorithm
transitivity(net2)


# This gives a census of the 16 different types of triads in a directed graph

triad.census(net1)
triad.census(net2)

# look at the help file to see to which type of triad each number corresponds.

# This is the diameter of the graph

diameter(net1)
diameter(net2)

# gives the id of the two furthest nodes (still, there might be more) and the diameter
farthest.nodes(net1)
farthest.nodes(net2)


# This is a measure of homophily based on degree (can be calculated on any node level statistics), even for categorical variables (use assortativity.nominal())
assortativity(net1, (degree(net1)))
assortativity(net2, (degree(net2)))

assortativity(net1, (degree(net1, mode = "out")))
assortativity(net2, (degree(net2, mode = "out")))

# All the previous were graph level statistics.
# Let's have a look at node level stats now.

##################
# Centrality  ####
##################

degree(net1)
degree(net2)

degree(net1, mode="out")
degree(net2, mode="out")

betweenness(net1)
betweenness(net2)

closeness(net1)
closeness(net2)


evcent(net1)
evcent(net2)

