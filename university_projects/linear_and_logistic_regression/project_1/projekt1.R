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

library(xtable)
print(xtable(summary(betaplasma.model), type = "latex"))
confint(betaplasma.model)
print(xtable(summary(betaplasma.logmodel), type = "latex"))
confint(betaplasma.logmodel)


temp_var <- predict(betaplasma.model, interval="prediction")
new_df <- cbind(newdata, temp_var)
png('outputs/pred_conf_linear.png')
ggplot(new_df, aes(x = age, y=betaplasma)) +
  geom_point() +
  geom_line(aes(y=lwr), color = "red", linetype = "dashed") +
  geom_line(aes(y=upr), color = "red", linetype = "dashed") + 
  geom_smooth(data = new_df, aes(x = age , y = betaplasma), method = lm) + labs(title="")
dev.off()

# b) the log plot
(betaplasma.logmodel = lm(log(betaplasma) ~ age, data = newdata))

temp_var <- predict(betaplasma.logmodel, interval="prediction")
new_df <- cbind(newdata, temp_var)

png('outputs/pred_conf_log.png')
ggplot(new_df, aes(x = age, y=log(betaplasma))) + 
  geom_point() + geom_line(aes(y=lwr), color = "red", linetype = "dashed") +
  geom_line(aes(y=upr), color = "red", linetype = "dashed") +
  geom_smooth(data = new_df, aes(x = age , y = log(betaplasma)), method = lm)
dev.off()

exp(confint(betaplasma.logmodel))
exp(coef(betaplasma.logmodel))
# QQ-plot
png('outputs/qq_plot_a_linear.png')
ggplot(newdata, aes(sample= betaplasma)) +stat_qq() + stat_qq_line(color=2) 
dev.off()
png('outputs/qq_plot_a_log.png')
ggplot(newdata, aes(sample= log(betaplasma))) +stat_qq() + stat_qq_line(color=2) 
dev.off()

res <- resid(betaplasma.logmodel)
plot(fitted(betaplasma.logmodel), res)
png('outputs/residual_density_log.png')
plot(density(res))
dev.off()


res <- resid(betaplasma.model)
plot(fitted(betaplasma.logmodel), res)
plot(fitted(betaplasma.logmodel), newdata$age)
png('outputs/residual_density_lin.png')
plot(density(res))
dev.off()

#c)
temp_0 = data.frame(age=c(25, 75))
exp(predict(betaplasma.logmodel, newdata = temp_0, interval="prediction"))

temp_0 = data.frame(age=c(26, 76))
exp(predict(betaplasma.logmodel, newdata = temp_0, interval="prediction"))



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
print(xtable(summary(betaplasmabmi.model), type = "latex"))

# Normal as reference variable 
newdata$bmicat <- relevel(newdata$bmicat, "Normal")
(betaplasmabmi.model = lm(log(betaplasma) ~ bmicat , data = newdata))
confint(betaplasmabmi.model)
summary(betaplasmabmi.model)
print(xtable(summary(betaplasmabmi.model), type = "latex"))

# c) model: plasma beta-carotene depends on age, sex, smokstat & bmicat

(betaplasmaall.model = lm(log(betaplasma) ~ age + sex + smokstat + bmicat , data = newdata))
exp(betaplasmaall.model$coefficients)
exp(confint(betaplasmaall.model))
summary(betaplasmaall.model)

anova(betaplasma.logmodel, betaplasmaall.model)


(betaplasmareduced.model = lm(log(betaplasma) ~ age + sex+ smokstat + bmicat , data = newdata))

anova(betaplasmareduced.model, betaplasmaall.model)


# d)
temp_var <- predict(betaplasmaall.model, interval="prediction")
temp_var_2 <- predict(betaplasmaall.model, interval="confidence")
new_df <- cbind(newdata, temp_var,temp_var_2)

new_df<-cbind(newdata,
        fit=predict(betaplasmaall.model),
        conf=predict(betaplasmaall.model, interval="confidence"),
        pred=predict(betaplasmaall.model, interval="prediction"))

#png('hi.png')
ggplot(data = new_df, aes(x = age, y = log(betaplasma), color = sex)) +
  geom_point(size = 1)  +
  geom_line(aes(y=fit)) +
  geom_line(aes(y=pred.lwr) , linetype = "dashed") +
  geom_line(aes(y=pred.upr) , linetype = "dashed") + 
  geom_ribbon(aes(ymin = conf.lwr, ymax = conf.upr), alpha = 0.2) +
  facet_grid(smokstat ~ relevel(bmicat, "Underweight"))
dev.off()

AverageAgeMale <- round(mean(newdata$age[newdata$sex=="Male"]))
testperson1 <- data.frame(sex = 'Male', smokstat = 'Former', bmicat = 'Underweight', age = AverageAgeMale)

(predict(betaplasmaall.model, testperson1,interval = "confidence"))
(predict(betaplasmaall.model, testperson1,interval = "prediction"))


summary(betaplasmaall.model)
confint(betaplasmaall.model)


# e

cont_bmi_model <- lm(log(betaplasma)~age+quetelet+smokstat+sex, data=newdata)
BetaQuet.coef <- cbind(summary(cont_bmi_model)$coefficients,ci =confint(cont_bmi_model))
##Beta's and exponentiated betas: There is no significant change in the other variables' parameters
print(xtable(BetaQuet.coef[, c(1, 5,6)]))


(exp((BetaQuet.coef[, c(1, 5,6)])))


##Predictions for man and woman 30 yr old, former smokers, normal bmi of 20
F30B20Disc<-data.frame(sex = "Female", age = 30, smokstat = "Former", bmicat = "Normal")
(confint2eDF<-cbind(F30B20Disc,round(predict(Q2c.model, newdata = F30B20Disc, interval = "confidence"),digits = 12)))


