###############################################
#
#     Topic Modeling program
#
#   Reference: https://eight2late.wordpress.com/2015/09/29/a-gentle-introduction-to-topic-modeling-using-r/
#
#   
#
#
###############################################

library(tm)
library(topicmodels)
library(SnowballC)

#load data from previous scripit
load("data.RData")

#Format Data
docs <- Corpus(VectorSource(paste(df$desc,df$overview,sep=" ")))
docs <-tm_map(docs,content_transformer(tolower))

#Replace useless characters
toSpace <- content_transformer(function(x, pattern) { return (gsub(pattern, " ", x))})
docs <- tm_map(docs, toSpace, "-")
docs <- tm_map(docs, toSpace, "’")
docs <- tm_map(docs, toSpace, "‘")
docs <- tm_map(docs, toSpace, "•")
docs <- tm_map(docs, toSpace, "”")
docs <- tm_map(docs, toSpace, "“")

docs <- tm_map(docs, removePunctuation)
docs <- tm_map(docs, removeNumbers)
docs <- tm_map(docs, removeWords, stopwords("english"))
docs <- tm_map(docs, stripWhitespace)
docs <- tm_map(docs,stemDocument)

#More Formatting
docs <- tm_map(docs, content_transformer(gsub),
               pattern = "organiz", replacement = "organ")
docs <- tm_map(docs, content_transformer(gsub),
               pattern = "organis", replacement = "organ")
docs <- tm_map(docs, content_transformer(gsub),
               pattern = "andgovern", replacement = "govern")
docs <- tm_map(docs, content_transformer(gsub),
               pattern = "inenterpris", replacement = "enterpris")
docs <- tm_map(docs, content_transformer(gsub),
               pattern = "team-", replacement = "team")
#define and eliminate all custom stopwords
myStopwords <- c("can", "say","one","way","use",
                 "also","howev","tell","will",
                 "much","need","take","tend","even",
                 "like","particular","rather","said",
                 "get","well","make","ask","come","end",
                 "first","two","help","often","may",
                 "might","see","someth","thing","point",
                 "post","look","right","now","think","‘ve ",
                 "‘re ","anoth","put","set","new","good",
                 "want","sure","kind","larg","yes,","day","etc",
                 "quit","sinc","attemp","lack","seen","awar",
                 "littl","ever","moreov","though","found","abl",
                 "enough","far","earli","away","achiev","draw",
                 "last","never","brief","bit","entir","brief",
                 "great","lot","inform","pend")
docs <- tm_map(docs, removeWords, myStopwords)

dtm <- DocumentTermMatrix(docs)
rownames(dtm) <- df$id
freq <- colSums(as.matrix(dtm))

ord <- order(freq,decreasing=TRUE)

#LDA Gibbs topic modeling information
burnin <- 2000
iter <- 1000
thin <- 500
seed <-list(2003,5,63,100001,765) # important for getting consistant results
nstart <- 5
best <- TRUE
k <- 52    #Number of topics
keep <- 50

#Run the LDA Gibbs algorithm 99 times using 2 -> 100 topics
seqk <- seq(2, 100, 1)

rowTotals <- apply(dtm , 1, sum)
dtm   <- dtm[rowTotals> 0, ]

harmonicMean <- function(logLikelihoods, precision = 2000L) {
  llMed <- median(logLikelihoods)
  as.double(llMed - log(mean(exp(-mpfr(logLikelihoods,
                                       prec = precision) + llMed))))
}


#Ignore these lines two lines
#ldaOut <-LDA(dtm,k, method="Gibbs", control=list(nstart=nstart, seed = seed, best=best, burnin = burnin, iter = iter, thin=thin))
#ldaOut.topics <- as.matrix(topics(ldaOut))

#Run LDA Gibbs algorithm and get harmonic mean
system.time(fitted_many <- lapply(seqk,function(k) LDA(dtm,k=k,method="Gibbs",control=list(burnin=burnin,iter=iter,keep=keep))))
logLiks_many <- lapply(fitted_many, function(L)  L@logLiks[-c(1:(burnin/keep))])
hm_many <- sapply(logLiks_many, function(h) harmonicMean(h))
ldaplot <- ggplot(data.frame(seqk, hm_many), aes(x=seqk, y=hm_many)) + geom_path(lwd=1.5) +
  theme(text = element_text(family= NULL),
        axis.title.y=element_text(vjust=1, size=16),
        axis.title.x=element_text(vjust=-.5, size=16),
        axis.text=element_text(size=16),
        plot.title=element_text(size=20)) +
  xlab('Number of Topics') +
  ylab('Harmonic Mean') +
  annotate("text", x = 25, y = -80000, label = paste("The optimal number of topics is", seqk[which.max(hm_many)])) +
  ggtitle(expression(atop("Latent Dirichlet Allocation Analysis of NEN LLIS", atop(italic("How many distinct topics in the abstracts?"), ""))))
ldaplot