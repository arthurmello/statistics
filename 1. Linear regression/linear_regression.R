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