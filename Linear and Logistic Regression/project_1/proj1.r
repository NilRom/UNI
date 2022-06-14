library(ggplot2)
library(grid)
#install.packages("GGally")
#install.packages("ggpubr")
library(GGally)
library(ggpubr)
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

(betaplasmareduced.model = lm(log(betaplasma) ~ age + sex+ smokstat + quetelet , data = newdata))

anova(betaplasmareduced.model, betaplasmaall.model)

# 2d)

ggplot(data = newdata, aes(x = age, y = log(betaplasma), color = sex)) +
  geom_point()  +
  facet_grid(smokstat ~ relevel(bmicat, "Underweight"))

AverageAgeMale <- round(mean(newdata$age[newdata$sex=="Male"]))
testperson1 <- data.frame(sex = 'Male', smokstat = 'Former', bmicat = 'Underweight', age = AverageAgeMale)

(predict(betaplasmaall.model, testperson1,interval = "confidence"))
(predict(betaplasmaall.model, testperson1,interval = "prediction"))


summary(betaplasmaall.model)
confint(betaplasmaall.model)

# 2e

(betaplasmaquetelet.model = lm(log(betaplasma) ~ age + sex + smokstat + quetelet , data = newdata))
(exp(confint(betaplasmaquetelet.model)))

# bmi 22
testwoman <- data.frame(age = 40, sex = 'Female', smokstat = 'Former', bmicat = 'Normal')
testwomanq <- data.frame(age = 40, sex = 'Female', smokstat = 'Former', quetelet = 22)

testman <- data.frame(age = 40, sex = 'Male', smokstat='Former', bmicat = 'Normal')
testmanq <- data.frame(age = 40, sex = 'Male', smokstat='Former', quetelet = 22)


(predict(betaplasmaall.model, testwoman,interval = "confidence"))
(predict(betaplasmaquetelet.model, testwomanq,interval = "confidence"))
(predict(betaplasmaall.model, testman,interval = "confidence"))
(predict(betaplasmaquetelet.model, testmanq,interval = "confidence"))

# bmi 33

testwoman33 <- data.frame(age = 40, sex = 'Female', smokstat = 'Former', bmicat = 'Obese')
testwomanq33 <- data.frame(age = 40, sex = 'Female', smokstat = 'Former', quetelet = 33)

testman33 <- data.frame(age = 40, sex = 'Male', smokstat='Former', bmicat = 'Obese')
testmanq33 <- data.frame(age = 40, sex = 'Male', smokstat='Former', quetelet = 33)

(predict(betaplasmaall.model, testwoman33,interval = "confidence"))
(predict(betaplasmaquetelet.model, testwomanq33,interval = "confidence"))
(predict(betaplasmaall.model, testman33,interval = "confidence"))
(predict(betaplasmaquetelet.model, testmanq33,interval = "confidence"))

confintfm <- cbind(predict(betaplasmaall.model, testwoman,interval = "confidence"))
confintfm33 <- cbind(predict(betaplasmaall.model, testwoman33,interval = "confidence"))
confintfmq <- cbind(predict(betaplasmaquetelet.model, testwomanq,interval = "confidence"))
confintfmq33 <- cbind(predict(betaplasmaquetelet.model, testwomanq33,interval = "confidence"))

confintm <- cbind(predict(betaplasmaall.model, testman,interval = "confidence"))
confintm33 <- cbind(predict(betaplasmaall.model, testman33,interval = "confidence"))
confintmq <- cbind(predict(betaplasmaquetelet.model, testmanq,interval = "confidence"))
confintmq33 <- cbind(predict(betaplasmaquetelet.model, testmanq33,interval = "confidence"))

(abs(confintfm33-confintfm))/(confintfm) #Female BMI
(abs(confintfmq33-confintfmq))/(confintfmq) #Female Q
(abs(confintm33-confintm))/(confintm) #Male BMI
(abs(confintmq33-confintmq))/(confintmq) #Male Q

# 2f)

(betaplasmabmiq.model = lm(log(betaplasma) ~ age + sex + smokstat + bmicat + quetelet , data = newdata))
anova(betaplasmareduced.model, betaplasmabmiq.model)




# 3
# a)
sum_bmi <- summary(betaplasmaall.model)
sum_q <- summary(betaplasmaquetelet.model)

# the larger the better
(R2_bmi = sum_bmi$r.squared)
(R2_q = sum_q$r.squared)

(R_adj_bmi = sum_bmi$adj.r.squared)
(R_adj_q = sum_q$adj.r.squared)

# the smaller the better
AIC(betaplasmaall.model)
AIC(betaplasmaquetelet.model)

BIC(betaplasmaall.model)
BIC(betaplasmaquetelet.model)

# b)

contx <- plasma[, c("age", "quetelet", "calories", "fat", "fiber",
                    "alcohol", "cholesterol", "betadiet")]
cor(contx)
pairs(contx)

ggplot(data = plasma, aes(x = fat, y = calories)) + geom_point() + xlab("Fat Intake [g/day]") +
  ylab("Caloric Intake [Cal/day]") 

ggplot(data = plasma, aes(x = fat, y = cholesterol)) + geom_point() + xlab("Fat Intake [g/day]") +
  ylab("Cholesterol Intake [mg/day]") 

table(plasma$vituse)

# c)

(betaplasmadietary.model = lm(log(betaplasma) ~ vituse+calories+fat+fiber+alcohol+cholesterol+betadiet, data = newdata))
(influence(betaplasmadietary.model)$hat)

table(plasma$alcohol)

ggplot(data = plasma, aes(x = fat, y = alcohol)) + geom_point() + xlab("Fat Intake [g/day]") +
  ylab("Alcohol Intake [drinks/week]") 

ggplot(data = plasma, aes(x = fat, y = cholesterol)) + geom_point() + xlab("Fat Intake [g/day]") +
  ylab("Alcohol Intake [drinks/week]") 

ggplot(data = plasma, aes(x = fat, y = )) + geom_point() + xlab("Fat Intake [g/day]") +
  ylab("Alcohol Intake [drinks/week]") 


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

# 2d)

ggplot(data = newdata, aes(x = age, y = log(betaplasma), color = sex)) +
  geom_point()  +
  facet_grid(smokstat ~ relevel(bmicat, "Underweight"))

AverageAgeMale <- round(mean(newdata$age[newdata$sex=="Male"]))
testperson1 <- data.frame(sex = 'Male', smokstat = 'Former', bmicat = 'Underweight', age = AverageAgeMale)

(predict(betaplasmaall.model, testperson1,interval = "confidence"))
(predict(betaplasmaall.model, testperson1,interval = "prediction"))


summary(betaplasmaall.model)
confint(betaplasmaall.model)

# 2e

(betaplasmaquetelet.model = lm(log(betaplasma) ~ age + sex + smokstat + quetelet , data = newdata))
(exp(confint(betaplasmaquetelet.model)))

# bmi 22
testwoman <- data.frame(age = 40, sex = 'Female', smokstat = 'Former', bmicat = 'Normal')
testwomanq <- data.frame(age = 40, sex = 'Female', smokstat = 'Former', quetelet = 22)

testman <- data.frame(age = 40, sex = 'Male', smokstat='Former', bmicat = 'Normal')
testmanq <- data.frame(age = 40, sex = 'Male', smokstat='Former', quetelet = 22)


(predict(betaplasmaall.model, testwoman,interval = "confidence"))
(predict(betaplasmaquetelet.model, testwomanq,interval = "confidence"))
(predict(betaplasmaall.model, testman,interval = "confidence"))
(predict(betaplasmaquetelet.model, testmanq,interval = "confidence"))

# bmi 33

testwoman33 <- data.frame(age = 40, sex = 'Female', smokstat = 'Former', bmicat = 'Obese')
testwomanq33 <- data.frame(age = 40, sex = 'Female', smokstat = 'Former', quetelet = 33)

testman33 <- data.frame(age = 40, sex = 'Male', smokstat='Former', bmicat = 'Obese')
testmanq33 <- data.frame(age = 40, sex = 'Male', smokstat='Former', quetelet = 33)

(predict(betaplasmaall.model, testwoman33,interval = "confidence"))
(predict(betaplasmaquetelet.model, testwomanq33,interval = "confidence"))
(predict(betaplasmaall.model, testman33,interval = "confidence"))
(predict(betaplasmaquetelet.model, testmanq33,interval = "confidence"))

confintfm <- cbind(predict(betaplasmaall.model, testwoman,interval = "confidence"))
confintfm33 <- cbind(predict(betaplasmaall.model, testwoman33,interval = "confidence"))
confintfmq <- cbind(predict(betaplasmaquetelet.model, testwomanq,interval = "confidence"))
confintfmq33 <- cbind(predict(betaplasmaquetelet.model, testwomanq33,interval = "confidence"))

confintm <- cbind(predict(betaplasmaall.model, testman,interval = "confidence"))
confintm33 <- cbind(predict(betaplasmaall.model, testman33,interval = "confidence"))
confintmq <- cbind(predict(betaplasmaquetelet.model, testmanq,interval = "confidence"))
confintmq33 <- cbind(predict(betaplasmaquetelet.model, testmanq33,interval = "confidence"))

(abs(confintfm33-confintfm))/(confintfm) #Female BMI
(abs(confintfmq33-confintfmq))/(confintfmq) #Female Q
(abs(confintm33-confintm))/(confintm) #Male BMI
(abs(confintmq33-confintmq))/(confintmq) #Male Q

# 2f)

(betaplasmabmiq.model = lm(log(betaplasma) ~ age + sex + smokstat + bmicat + quetelet , data = newdata))
anova(betaplasmareduced.model, betaplasmabmiq.model)


# 3
# a)
sum_bmi <- summary(betaplasmaall.model)
sum_q <- summary(betaplasmaquetelet.model)

# the larger the better
(R2_bmi = sum_bmi$r.squared)
(R2_q = sum_q$r.squared)

(R_adj_bmi = sum_bmi$adj.r.squared)
(R_adj_q = sum_q$adj.r.squared)

# the smaller the better
AIC(betaplasmaall.model)
AIC(betaplasmaquetelet.model)

BIC(betaplasmaall.model)
BIC(betaplasmaquetelet.model)

# b)

contx <- plasma[, c("age", "quetelet", "calories", "fat", "fiber",
                    "alcohol", "cholesterol", "betadiet")]
cor(contx)
pairs(contx)

ggplot(data = plasma, aes(x = fat, y = calories)) + geom_point() + xlab("Fat Intake [g/day]") +
  ylab("Caloric Intake [Cal/day]") 

ggplot(data = plasma, aes(x = fat, y = cholesterol)) + geom_point() + xlab("Fat Intake [g/day]") +
  ylab("Cholesterol Intake [mg/day]") 

table(plasma$vituse)

# c)

newdata$vituse <- factor(newdata$vituse,
                         levels = c(1, 2, 3),
                         labels = c("Yes, fairly often", "Yes, not often", "No"))

(betaplasmadietary.model = lm(log(betaplasma) ~ vituse+calories+fat+fiber+alcohol+cholesterol+betadiet, data = newdata))
(influence(betaplasmadietary.model)$hat)

table(plasma$alcohol)

ggplot(data = plasma, aes(x = alcohol, y = fat)) + geom_point() + ylab("Fat Intake [g/day]") +
  xlab("Alcohol Intake [drinks/week]") 

ggplot(data = plasma, aes(x = alcohol, y = cholesterol)) + geom_point() + xlab("Alcohol Intake [drinks/week]") +
  ylab("Cholesterol Intake [mg/day]") 

ggplot(data = plasma, aes(x = alcohol, y = vituse)) + geom_point() + xlab("Alcohol Intake [drinks/week]") +
  ylab("Vitamine Intake") 

ggplot(data = plasma, aes(x = alcohol, y = fiber)) + geom_point() + xlab("Alcohol Intake [drinks/week]") +
  ylab("Fiber Intake [g/day]") 

ggplot(data = plasma, aes(x = alcohol, y = betadiet)) + geom_point() + xlab("Alcohol Intake [drinks/week]") +
  ylab("Beta-carotene Intake [μg/day]") 

ggplot(data = plasma, aes(x = alcohol, y = calories)) + geom_point() + xlab("Alcohol Intake [drinks/week]") +
  ylab("Calorie Intake [Cal/day]") 


# leverage



diet.betas <- cbind(summary(betaplasmadietary.model)$coefficients,ci =confint(betaplasmadietary.model))
diet.pred <- cbind(
  newdata, 
  fit = predict(betaplasmadietary.model),
  r = rstudent(betaplasmadietary.model))
diet.pred$v <- influence(betaplasmadietary.model)$hat

highlev <- 2*length(betaplasmadietary.model$coefficients)/nrow(newdata)
Alcoholic<-which(newdata$alcohol==max(newdata$alcohol))


p1<-ggplot(diet.pred, aes(x = vituse, y = v)) +
  geom_point(size = 2)  +
  geom_point(data = diet.pred[abs(diet.pred$v) > highlev,], 
             color = "red", size = 3)+
  geom_point(data = diet.pred[Alcoholic, ], 
             color = "blue", shape = 24, size = 3) +
  geom_hline(yintercept = 1/nrow(newdata)) +
  geom_hline(yintercept = highlev, 
             color = "red") +
  theme(axis.title.y=element_blank())+
  labs(x = "Vitamin Usage") +
  theme(text = element_text(size = 18))

p2<-ggplot(diet.pred, aes(x = calories, y = v)) +
  geom_point(size = 2)  +
  geom_point(data = diet.pred[abs(diet.pred$v) > highlev,], 
             color = "red", size = 3)+
  geom_point(data = diet.pred[Alcoholic, ], 
             color = "blue", shape = 24, size = 3) +
  geom_hline(yintercept = 1/nrow(newdata)) +
  geom_hline(yintercept = highlev, 
             color = "red") +
  theme(axis.title.y=element_blank())+
  labs(x = "Caloric Intake [Cal/day]") +
  theme(text = element_text(size = 18))

p3<-ggplot(diet.pred, aes(x = fat, y = v)) +
  geom_point(size = 2)  +
  geom_point(data = diet.pred[abs(diet.pred$v) > highlev,], 
             color = "red", size = 3)+
  geom_point(data = diet.pred[Alcoholic, ], 
             color = "blue", shape = 24, size = 3) +
  geom_hline(yintercept = 1/nrow(newdata)) +
  geom_hline(yintercept = highlev, 
             color = "red") +
  theme(axis.title.y=element_blank())+
  labs(x = "Fat Intake [mg/day]") +
  theme(text = element_text(size = 18))

p4<-ggplot(diet.pred, aes(x = fiber, y = v)) +
  geom_point(size = 2)  +
  geom_point(data = diet.pred[abs(diet.pred$v) > highlev,], 
             color = "red", size = 3)+
  geom_point(data = diet.pred[Alcoholic, ], 
             color = "blue", shape = 24, size = 3) +
  geom_hline(yintercept = 1/nrow(newdata)) +
  geom_hline(yintercept = highlev, 
             color = "red") +
  theme(axis.title.y=element_blank())+
  labs(x = "Dietary Fiber Intake [g/day]") +
  theme(text = element_text(size = 18))

p5<-ggplot(diet.pred, aes(x = cholesterol, y = v)) +
  geom_point(size = 2)  +
  geom_point(data = diet.pred[abs(diet.pred$v) > highlev,], 
             color = "red", size = 3)+
  geom_point(data = diet.pred[Alcoholic, ], 
             color = "blue", shape = 24, size = 3) +
  geom_hline(yintercept = 1/nrow(newdata)) +
  geom_hline(yintercept = highlev, 
             color = "red") +
  theme(axis.title.y=element_blank())+
  labs(x = "Cholesterol Intake [mg/day]") +
  theme(text = element_text(size = 18))

p6<-ggplot(diet.pred, aes(x = alcohol, y = v)) +
  geom_point(size = 2)  +
  geom_point(data = diet.pred[abs(diet.pred$v) > highlev,], 
             color = "red", size = 3)+
  geom_point(data = diet.pred[Alcoholic, ], 
             color = "blue", shape = 24, size = 3) +
  geom_hline(yintercept = 1/nrow(newdata)) +
  geom_hline(yintercept = highlev, 
             color = "red") +
  theme(axis.title.y=element_blank())+
  labs(x = "Alcohol Intake [drinks/week]") +
  theme(text = element_text(size = 18))

p7<-ggplot(diet.pred, aes(x = betadiet, y = v)) +
  geom_point(size = 2)  +
  geom_point(data = diet.pred[abs(diet.pred$v) > highlev,], 
             color = "red", size = 3)+
  geom_point(data = diet.pred[Alcoholic, ], 
             color = "blue", shape = 24, size = 3) +
  geom_hline(yintercept = 1/nrow(newdata)) +
  geom_hline(yintercept = highlev, 
             color = "red") +
  theme(axis.title.y=element_blank())+
  labs(x = "Dietary beta-carotene Intake [\U03BCg/day]") +
  theme(text = element_text(size = 18))


plots <- ggarrange(p1, p2, p3, p4, p5, p6, p7, labels="AUTO")
annotate_figure(plots, 
                top = text_grob("Leverage", color = "black", face = "bold", size = 14))


# 3d)

ggplot(betaplasmadietary.model,aes(x=fit,y=r))+geom_point()+ ylab("Studentized Residuals") + xlab("Predicted \U03B2-carotene plasma levels [ng/ml]") + geom_smooth()+ geom_hline(yintercept = c(-2, 0, 2)) +
  geom_hline(yintercept = c(-3, 3), linetype = 2)+geom_point(data = diet.pred[abs(diet.pred$r) > 3,], color = "red")

MaxRes<-which(diet.pred$r==max(abs(diet.pred$r)))

# 3e)

# cooks
diet.pred$D <- cooks.distance(betaplasmadietary.model)
head(diet.pred)

# Plot against r*
(f1.pike <- length(betaplasmadietary.model$coefficients))
(f2.pike <- betaplasmadietary.model$df.residual)
(cook.limit.pike <- qf(0.5, f1.pike, f2.pike))
ggplot(diet.pred, aes(fit, D)) + 
  geom_point(size = 3) +
  #geom_hline(yintercept = cook.limit.pike, color = "red") +
  geom_hline(yintercept = 4/nrow(diet.pred), linetype = 2, color = "red") +
  geom_point(data = diet.pred[Alcoholic, ], 
             color = "blue", shape = 24, size = 3)+
  geom_point(data = diet.pred[abs(diet.pred$r) > 3,], color = "forestgreen", fill="forestgreen", shape=23 ,size = 3)+
  geom_point(data = diet.pred[MaxRes, ], 
             color = "black", shape = 9, size = 3)+
  xlab("Fitted values") +
  ylab("Distance") +
  labs(title = "\U03B2-carotene plasma levels: Cook's D") +
  theme(text = element_text(size = 18))

# dfbetas

diet.pred$df0 <- dfbetas(betaplasmadietary.model)[, "(Intercept)"]
diet.pred$df1 <- dfbetas(betaplasmadietary.model)[, "vituseYes, not often"]
diet.pred$df2 <- dfbetas(betaplasmadietary.model)[, "vituseNo"]
diet.pred$df3 <- dfbetas(betaplasmadietary.model)[, "calories"]
diet.pred$df4 <- dfbetas(betaplasmadietary.model)[, "fat"]
diet.pred$df5 <- dfbetas(betaplasmadietary.model)[, "fiber"]
diet.pred$df6 <- dfbetas(betaplasmadietary.model)[, "alcohol"]
diet.pred$df7 <- dfbetas(betaplasmadietary.model)[, "cholesterol"]
diet.pred$df8 <- dfbetas(betaplasmadietary.model)[, "betadiet"]

pdf0<-ggplot(diet.pred, aes(x = fit, y = df0)) +
  geom_point(size = 2) +
  geom_hline(yintercept = 0) +
  geom_hline(yintercept = sqrt(cook.limit.pike)*c(-1, 1), color = "red") +
  geom_hline(yintercept = 2/sqrt(nrow(newdata))*c(-1, 1), color = "red", linetype = "dashed") +
  geom_point(data = diet.pred[Alcoholic, ], 
             color = "blue", shape = 24, size = 3)+
  geom_point(data = diet.pred[abs(diet.pred$r) > 3,], color = "forestgreen", fill="forestgreen", shape=23 ,size = 3)+
  geom_point(data = diet.pred[MaxRes, ], 
             color = "black", shape = 9, size = 3)+
  ylab("DFBETAS_0(i)") +
  xlab("Fitted values") +
  labs(title = "Intercept") +
  #labs(caption = "y = sqrt(F_0.5) and 2/sqrt(n)") +
  theme(text = element_text(size = 18))


pdf1<-ggplot(diet.pred, aes(x = fit, y = df1)) +
  geom_point(size = 2) +
  geom_hline(yintercept = 0) +
  geom_hline(yintercept = sqrt(cook.limit.pike)*c(-1, 1), color = "red") +
  geom_hline(yintercept = 2/sqrt(nrow(newdata))*c(-1, 1), color = "red", linetype = "dashed") +
  geom_point(data = diet.pred[Alcoholic, ], 
             color = "blue", shape = 24, size = 3)+
  geom_point(data = diet.pred[abs(diet.pred$r) > 3,], color = "forestgreen", fill="forestgreen", shape=23 ,size = 3)+
  geom_point(data = diet.pred[MaxRes, ], 
             color = "black", shape = 9, size = 3)+
  ylab("DFBETAS_2(i)") +
  xlab("Fitted values") +
  labs(title = "Vitamin use Yes, not often") +
  #labs(caption = "y = sqrt(F_0.5) and 2/sqrt(n)") +
  theme(text = element_text(size = 18))

pdf2<-ggplot(diet.pred, aes(x = fit, y = df2)) +
  geom_point(size = 2) +
  geom_hline(yintercept = 0) +
  geom_hline(yintercept = sqrt(cook.limit.pike)*c(-1, 1), color = "red") +
  geom_hline(yintercept = 2/sqrt(nrow(newdata))*c(-1, 1), color = "red", linetype = "dashed") +
  geom_point(data = diet.pred[Alcoholic, ], 
             color = "blue", shape = 24, size = 3)+
  geom_point(data = diet.pred[abs(diet.pred$r) > 3,], color = "forestgreen", fill="forestgreen", shape=23 ,size = 3)+
  geom_point(data = diet.pred[MaxRes, ], 
             color = "black", shape = 9, size = 3)+
  ylab("DFBETAS_2(i)") +
  xlab("Fitted values") +
  labs(title = "Vitamin use No") +
  #labs(caption = "y = sqrt(F_0.5) and 2/sqrt(n)") +
  theme(text = element_text(size = 18))

pdf3<-ggplot(diet.pred, aes(x = fit, y = df3)) +
  geom_point(size = 2) +
  geom_hline(yintercept = 0) +
  geom_hline(yintercept = sqrt(cook.limit.pike)*c(-1, 1), color = "red") +
  geom_hline(yintercept = 2/sqrt(nrow(newdata))*c(-1, 1), color = "red", linetype = "dashed") +
  geom_point(data = diet.pred[Alcoholic, ], 
             color = "blue", shape = 24, size = 3)+
  geom_point(data = diet.pred[abs(diet.pred$r) > 3,], color = "forestgreen", fill="forestgreen", shape=23 ,size = 3)+
  geom_point(data = diet.pred[MaxRes, ], 
             color = "black", shape = 9, size = 3)+
  ylab("DFBETAS_3(i)") +
  xlab("Fitted values") +
  labs(title = "Calories") +
  #labs(caption = "y = sqrt(F_0.5) and 2/sqrt(n)") +
  theme(text = element_text(size = 18))

pdf4<-ggplot(diet.pred, aes(x = fit, y = df4)) +
  geom_point(size = 2) +
  geom_hline(yintercept = 0) +
  geom_hline(yintercept = sqrt(cook.limit.pike)*c(-1, 1), color = "red") +
  geom_hline(yintercept = 2/sqrt(nrow(newdata))*c(-1, 1), color = "red", linetype = "dashed") +
  geom_point(data = diet.pred[Alcoholic, ], 
             color = "blue", shape = 24, size = 3)+
  geom_point(data = diet.pred[abs(diet.pred$r) > 3,], color = "forestgreen", fill="forestgreen", shape=23 ,size = 3)+
  geom_point(data = diet.pred[MaxRes, ], 
             color = "black", shape = 9, size = 3)+
  ylab("DFBETAS_4(i)") +
  xlab("Fitted values") +
  labs(title = "Fat") +
  #labs(caption = "y = sqrt(F_0.5) and 2/sqrt(n)") +
  theme(text = element_text(size = 18))

pdf5<-ggplot(diet.pred, aes(x = fit, y = df5)) +
  geom_point(size = 2) +
  geom_hline(yintercept = 0) +
  geom_hline(yintercept = sqrt(cook.limit.pike)*c(-1, 1), color = "red") +
  geom_hline(yintercept = 2/sqrt(nrow(newdata))*c(-1, 1), color = "red", linetype = "dashed") +
  geom_point(data = diet.pred[Alcoholic, ], 
             color = "blue", shape = 24, size = 3)+
  geom_point(data = diet.pred[abs(diet.pred$r) > 3,], color = "forestgreen", fill="forestgreen", shape=23 ,size = 3)+
  geom_point(data = diet.pred[MaxRes, ], 
             color = "black", shape = 9, size = 3)+
  ylab("DFBETAS_5(i)") +
  xlab("Fitted values") +
  labs(title = "Fiber") +
  #labs(caption = "y = sqrt(F_0.5) and 2/sqrt(n)") +
  theme(text = element_text(size = 18))

pdf6<-ggplot(diet.pred, aes(x = fit, y = df6)) +
  geom_point(size = 2) +
  geom_hline(yintercept = 0) +
  geom_hline(yintercept = sqrt(cook.limit.pike)*c(-1, 1), color = "red") +
  geom_hline(yintercept = 2/sqrt(nrow(newdata))*c(-1, 1), color = "red", linetype = "dashed") +
  geom_point(data = diet.pred[Alcoholic, ], 
             color = "blue", shape = 24, size = 3)+
  geom_point(data = diet.pred[abs(diet.pred$r) > 3,], color = "forestgreen", fill="forestgreen", shape=23 ,size = 3)+
  geom_point(data = diet.pred[MaxRes, ], 
             color = "black", shape = 9, size = 3)+
  ylab("DFBETAS_6(i)") +
  xlab("Fitted values") +
  labs(title = "Alcohol") +
  #labs(caption = "y = sqrt(F_0.5) and 2/sqrt(n)") +
  theme(text = element_text(size = 18))

pdf7<-ggplot(diet.pred, aes(x = fit, y = df7)) +
  geom_point(size = 2) +
  geom_hline(yintercept = 0) +
  geom_hline(yintercept = sqrt(cook.limit.pike)*c(-1, 1), color = "red") +
  geom_hline(yintercept = 2/sqrt(nrow(newdata))*c(-1, 1), color = "red", linetype = "dashed") +
  geom_point(data = diet.pred[Alcoholic, ], 
             color = "blue", shape = 24, size = 3)+
  geom_point(data = diet.pred[abs(diet.pred$r) > 3,], color = "forestgreen", fill="forestgreen", shape=23 ,size = 3)+
  geom_point(data = diet.pred[MaxRes, ], 
             color = "black", shape = 9, size = 3)+
  ylab("DFBETAS_7(i)") +
  xlab("Fitted values") +
  labs(title = "Cholesterol") +
  # labs(caption = "y = sqrt(F_0.5) and 2/sqrt(n)") +
  theme(text = element_text(size = 18))

pdf8<-ggplot(diet.pred, aes(x = fit, y = df8)) +
  geom_point(size = 2) +
  geom_hline(yintercept = 0) +
  geom_hline(yintercept = sqrt(cook.limit.pike)*c(-1, 1), color = "red") +
  geom_hline(yintercept = 2/sqrt(nrow(newdata))*c(-1, 1), color = "red", linetype = "dashed") +
  geom_point(data = diet.pred[Alcoholic, ], 
             color = "blue", shape = 24, size = 3)+
  geom_point(data = diet.pred[abs(diet.pred$r) > 3,], color = "forestgreen", fill="forestgreen", shape=23 ,size = 3)+
  geom_point(data = diet.pred[MaxRes, ], 
             color = "black", shape = 9, size = 3)+
  ylab("DFBETAS_0(i)") +
  xlab("Fitted values") +
  labs(title = "Dietary beta-carotene") +
  #labs(caption = "y = sqrt(F_0.5) and 2/sqrt(n)") +
  theme(text = element_text(size = 18))



DFBPlots<-ggarrange(pdf0, pdf1, pdf2, pdf3, pdf4, pdf5, pdf6, pdf7, pdf8, labels="AUTO")
annotate_figure(DFBPlots,
                # top = text_grob("DFBetas of the dietary parameters", color = "black", face = "bold", size = 14),
                #bottom = text_grob("y = sqrt(F_0.5) (solid) and 2/sqrt(n) (dashed)", color = "black",
                #                  hjust = 1, x = 1, face = "italic", size = 16),
                #left = text_grob("DFBETAS", color = "black", rot = 90),
)


# 3f)

Dietary.model <- step(betaplasmadietary.model)
(final.model <- cbind(summary(Dietary.model)$coefficients,ci =confint(Dietary.model)))
(final.exp <- exp(final.model[, c(1, 5, 6)]))
(final <- final.model[, c(1, 5, 6)])

# 3g)

min.model <- (lm(log(betaplasma) ~ 1, data = newdata))
max.model <- lm(log(betaplasma) ~ vituse+calories+fiber+alcohol+betadiet+age+quetelet+smokstat+sex, data = newdata)

AIC.model<-step(Dietary.model, 
                scope = list(lower = min.model, upper = max.model),
                direction = "both")

BIC.model<-step(Dietary.model, 
                scope = list(lower = min.model, upper = max.model),
                direction = "both",
                k = log(nrow(newdata)))

# 3h)

sum.0<-summary(betaplasma.logmodel)
sum.1<-summary(betaplasmaquetelet.model)
sum.2<-summary(Dietary.model)
sum.3<-summary(AIC.model)
sum.4<-summary(BIC.model)


(collect.R2s <- data.frame(
  nr = seq(1, 5),
  model = c("Age", "Background", "Dietary", "Step AIC", "Step BIC"),
  R2 = c(sum.0$r.squared,
         sum.1$r.squared,
         sum.2$r.squared,
         sum.3$r.squared,
         sum.4$r.squared),
  R2.adj = c(sum.0$adj.r.squared,
             sum.1$adj.r.squared,
             sum.2$adj.r.squared,
             sum.3$adj.r.squared,
             sum.4$adj.r.squared)))