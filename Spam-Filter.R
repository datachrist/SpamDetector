# setting input directory
setwd("D:/Projects/Spam-Filter-Project/dataset")
dataset <- read.csv("data.csv",header = FALSE, sep = ";")
names <= read.csv("names.csv",header = FALSE, sep = ";")
names(dataset) <- sapply((1:nrow(names)),function(i)toString(names[i,1]))
sapply(dataset$y,typeof)
dataset$y <- as.factor(dataset$y)
sample <- dataset[sample(nrow(dataset),1000),]
install.packages("caret")
require(caret)
install.packages("kernlab")
require(kernlab)
#install.packages("doMC")  not available
install.packages("doParallel")
require(doParallel)
registerDoParallel(cores = 2)
signDist <- sigest(y ~ .,data = dataTrain, frac =1)
signDist[1]
svmTuneGrid <- data.frame(.sigma = signDist[1], .C= 2^(-2:7))
# train function of caret package used by all models
x <- train(y ~ ., data = dataTrain,
           method = "svmRadial",
           preProcess = c("center", "scale"),
           tuneGrid = svmTuneGrid,
           trControl = trainControl(method = "repeatedcv", repeats =2,classProbs = TRUE))

sapply(dataset,typeof)
dataset$y <- as.factor(dataset$y)
pred <- predict(x,dataTest[,1:57])
acc <- confusionMatrix(pred,dataTest$y)
