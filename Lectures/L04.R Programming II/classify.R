# classify-glm.R
# Example script demonstrating basic data management.
# Learn R! workshop series

data(mtcars)  # Motor Trend Cars Data
names(mtcars) # inspect variable names
head(mtcars)  # view first few observations

# build a simple linear model
model1 <- glm(mpg ~ hp, data=mtcars)
summary(model1)  # horsepower and mpg are inversely related
# view our model fit
plot(mtcars$hp,mtcars$mpg)
abline(model1,col="red")

# classify horsepower as above/below 150
hp150 <- (mtcars$hp>150)
# inspect
table(hp150)


# use in a linear regression
model2 <- glm(mtcars$mpg ~ hp150)
summary(model2)





