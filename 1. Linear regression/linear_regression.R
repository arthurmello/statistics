###############################################
###  LINEAR REGRESSION TUTORIAL
###  AUTHOR: Arthur Mello
###  CREATION DATE: 26/05/2019
###############################################
library(rstudioapi)
setwd(dirname(getActiveDocumentContext()$path)) # we set our working directory

# Loading our data
data = read.csv('data/kc_house_data.csv')

# Taking a look at the column names
colnames(data)

# Attaching it means we can access column names directly, without referring to the data frame
attach(data)

# Plotting price against house area
plot(sqft_living, price)

# Creating our first model using these two variables, and analysing it
model1 = lm(price ~ sqft_living, data = data)
summary(model1)

# Adding the regression line to our plot
abline(model1)

# Trying a second model
model2 = lm(price ~ sqft_living + bathrooms, data = data)
summary(model2)

# Our final model
model3 = lm(price ~ sqft_living + floors + yr_built, data = data)
summary(model3)

# Trying a prediction
new_house = data.frame(
  sqft_living = 2080, floors = 1, yr_built = 1997
)
predict(model3,newdata = new_house)

# Looking at the regression plots
plot(model3)

# Breusch-Pagan test
library(lmtest)
bptest(model3)

# Robust regression
library(robust)
model4 = lmRob(price ~ sqft_living + floors + yr_built, data = data)
summary(model4)
plot(model4)

# Multicolinearity
library(car)
vif(model3)

# AIC
AIC(model1, model2, model3)

# Polynomial regression
data$yr_built_2 = data$yr_built^2
model5 = lm(price ~ sqft_living + floors + yr_built + yr_built_2 , data = data)
summary(model5)

# Ridge regression
library(glmnet)
library(tidyverse)

y = data$price
x = data[, names(data) != "price"] %>% data.matrix()

model6 = glmnet(x, y, alpha = 0)

lambdas = 10^seq(10, -10, by = -.2)
cv_fit = cv.glmnet(x, y, alpha = 0, lambda = lambdas)
plot(cv_fit)

opt_lambda = cv_fit$lambda.min
opt_lambda

model6 = cv_fit$glmnet.fit
plot(model6, xvar = "lambda")
legend("left", lwd = 1, col = 1:6, legend = colnames(x), cex = .5)

# LASSO regression
cv_fit = cv.glmnet(x, y, alpha = 1, lambda = lambdas)
opt_lambda = cv_fit$lambda.min

model7 = cv_fit$glmnet.fit
plot(model7, xvar = "lambda")
legend("left", lwd = 1, col = 1:6, legend = colnames(x), cex = .5)

# Elastic net regression
library(caret)
set.seed(111)
model8 = train(
  price ~., data = data, method = "glmnet",
  trControl = trainControl("cv", number = 10),
  tuneLength = 10
)

model8$bestTune

# Stepwise regression
library(MASS)
model8 = lm(price~., data = data)
model8 = stepAIC(model8, direction = "both", 
                 trace = FALSE)
summary(model8)