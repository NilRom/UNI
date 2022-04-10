library(ggplot2)

plasma <- read.delim("plasma.txt")
head(plasma)
summary(plasma)

# b) the linear plot
newdata <- plasma[plasma$betaplasma > 0, ]
(betaplasma.model = lm(betaplasma ~ age, data = newdata))
(x0 <- data.frame(age = c(76)))
(predict(betaplasma.model, newdata = x0,interval = "confidence"))
(confint(betaplasma.model))

temp_var <- predict(betaplasma.model, interval="prediction")
new_df <- cbind(newdata, temp_var)
ggplot(new_df, aes(x = age, y=betaplasma)) + geom_point() + geom_line(aes(y=lwr), color = "red", linetype = "dashed")+
  geom_line(aes(y=upr), color = "red", linetype = "dashed") + geom_smooth(data = new_df, aes(x = age , y = betaplasma), method = lm) 

# b) the log plot
(betaplasma.logmodel = lm(log(betaplasma) ~ age, data = newdata))

temp_var <- predict(betaplasma.logmodel, interval="prediction")
new_df <- cbind(newdata, temp_var)
ggplot(new_df, aes(x = age, y=log(betaplasma))) + geom_point() + geom_line(aes(y=lwr), color = "red", linetype = "dashed")+
  geom_line(aes(y=upr), color = "red", linetype = "dashed") + geom_smooth(data = new_df, aes(x = age , y = log(betaplasma)), method = lm) 


# QQ-plot
ggplot(newdata, aes(sample= betaplasma)) +stat_qq() + stat_qq_line(color=2) 
ggplot(newdata, aes(sample= log(betaplasma))) +stat_qq() + stat_qq_line(color=2) 

res <- resid(betaplasma.logmodel)
plot(fitted(betaplasma.logmodel), res)


plot(fitted(betaplasma.logmodel), newdata$age)

# Part 2
# a) sex, smokstat, bmicat factors and their frequency tables
newdata$sex <- factor(newdata$sex,
                     levels = c(1, 2),
                     labels = c("Male", "Female"))
table(newdata$sex)

newdata$smokstat <- factor(newdata$smokstat,
                     levels = c(1, 2, 3),
                     labels = c("Never", "Former", "Current"))
table(newdata$smokstat)

newdata$bmicat <- factor(newdata$bmicat,
                     levels = c(1, 2, 3, 4),
                     labels = c("Underweight", "Normal", "Overweight", "Obese"))
table(newdata$bmicat)

# b) beta estimates, std errors & confint for linear model with:

# Underweight as reference variable
newdata$bmicat <- relevel(newdata$bmicat, "Underweight")
(betaplasmabmi.model = lm(log(betaplasma) ~ bmicat , data = newdata))
confint(betaplasmabmi.model)
summary(betaplasmabmi.model)

# Normal as reference variable 
newdata$bmicat <- relevel(newdata$bmicat, "Normal")
(betaplasmabmi.model = lm(log(betaplasma) ~ bmicat , data = newdata))
confint(betaplasmabmi.model)
summary(betaplasmabmi.model)

# c) model: plasma beta-carotene depends on age, sex, smokstat & bmicat

(betaplasmaall.model = lm(log(betaplasma) ~ age + sex + smokstat + bmicat , data = newdata))
exp(betaplasmaall.model$coefficients)
exp(confint(betaplasmaall.model))
summary(betaplasmaall.model)

anova(betaplasma.logmodel, betaplasmaall.model)


(betaplasmareduced.model = lm(log(betaplasma) ~ age + sex+ smokstat + bmicat , data = newdata))

anova(betaplasmareduced.model, betaplasmaall.model)
