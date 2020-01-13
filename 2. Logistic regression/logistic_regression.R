###############################################
###  LOGISTIC REGRESSION TUTORIAL
###  AUTHOR: Arthur Mello
###  CREATION DATE: 06/01/2020
###############################################
library(rstudioapi)
setwd(dirname(getActiveDocumentContext()$path)) # we set our working directory

# Loading our data
data = read.csv('data/train.csv')

# Taking a look at the column names
colnames(data)

# Attaching it means we can access column names directly, without referring to the data frame
attach(data)

# Cleaning our data
data$Age[is.na(data$Age)] = median(data$Age,na.rm=T) # replace missing values with the median
data$Pclass = as.factor(data$Pclass)

# Train/test split
train = data[1:700,]
test = data[701:889,]

# Trying our first model
model = glm(Survived ~ Pclass + Sex + Age,
             family = binomial(link = 'logit'), data = train)
summary(model)

# Trying our second model
model2 = glm(Survived ~ Pclass + Sex + Age + Fare,
            family = binomial(link = 'logit'), data = train)
summary(model2)

# Trying our third model
model3 = glm(Survived ~  Sex + Age + Fare,
             family = binomial(link = 'logit'), data = train)
summary(model3)

# Testing our model
predictions = ifelse(predict(model, newdata = test) > 0.5, 1, 0)

accuracy = mean(predictions == test$Survived)
print(paste('Accuracy :', accuracy))

# ROC
library(ROCR)

probabilities = predict(model, newdata = test)
prediction_object = prediction(probabilities, test$Survived)
roc = performance(prediction_object, measure = "tpr", x.measure = "fpr")
plot(roc)

# AUC
perf_auc = performance(prediction_object, measure = "auc")
auc = perf_auc@y.values[[1]]
print(paste('AUC :', auc))