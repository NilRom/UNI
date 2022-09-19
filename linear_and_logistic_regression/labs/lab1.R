install.packages("tidyverse")
install.packages("ggplot2")
library(ggplot2)
library(tidyverse) 
load("data/Pb_Norrbotten.rda")
summary(Pb_Norrbotten)
head(Pb_Norrbotten)
ggplot(data = Pb_Norrbotten, aes(x = I(year - 1975), y = Pb)) +
  geom_point(size = 2) +
  #geom_line(color = "red") +
  labs(title = "A small example")


model_0 <- lm(Pb ~ I(year - 1975), data = Pb_Norrbotten)
confint(model_0)
lm(Pb ~ I(year - 1975), data = Pb_Norrbotten)
predict(model_0, newdata = data.frame(year=c(2013)), interval = 'prediction')
res <- resid(model_0)
plot(fitted(model_0), res)
qqnorm(res)
qqline(res)
plot(density(res))
##B
model_1 <- lm(log(Pb) ~ I(year - 1975), data = Pb_Norrbotten)
lm(log(Pb) ~ I(year - 1975), data = Pb_Norrbotten)
confint(model_1)
predict(model_1, newdata = data.frame(year=c(2013)), interval = 'confidence')
predict(model_1, newdata = data.frame(year=c(2013)), interval = 'prediction')
res <- resid(model_1)
plot(fitted(model_1), res)
qqnorm(res)
qqline(res)
plot(density(res))
##C
model_2 <- lm(log(Pb) ~ I(year - 1975), data = Pb_Norrbotten)
lm(log(Pb) ~ I(year - 1975), data = Pb_Norrbotten)
exp(coef(model_2))
exp(confint(model_2))
exp(predict(model_1, newdata = data.frame(year=c(2013)), interval = 'confidence'))
exp(predict(model_1, newdata = data.frame(year=c(2013)), interval = 'prediction'))
res <- resid(model_1)
plot(fitted(model_1), res)
qqnorm(res)
qqline(res)
plot(density(res))


###lab 2
load("data/Pb_all.rda")
ggplot(data = Pb_all, aes(x = I(year - 1975), y = Pb)) +
  geom_point(size = 2) +
  geom_line(color = "red") +
  labs(title = "A small example")
model_2 <- lm(log(Pb) ~ I(year - 1975), data = Pb_all)
summary(model_2)
exp(predict(model_2, newdata = data.frame(year=c(2013)), interval = 'confidence'))
exp(predict(model_2, newdata = data.frame(year=c(2013)), interval = 'prediction'))
res <- resid(model_2)
plot(fitted(model_2), res)
qqnorm(res)
qqline(res)
#b
ggplot(data = Pb_all, aes(x = I(year - 1975), y = Pb)) +
  geom_point(size = 2) +
  #geom_line(color = "red") +
  labs(title = "A small example") +
  facet_wrap(~ region)
Pb_all$region <- relevel(Pb_all$region, "Norrbotten")
model_3 <- lm(log(Pb) ~ I(year - 1975) + region, data = Pb_all)

exp(coef(model_3))
exp(confint(model_3))
exp(predict(model_3, newdata = data.frame(year=c(2013), region = "Norrbotten"), interval = 'confidence'))
exp(predict(model_3, newdata = data.frame(year=c(2013), region = "Norrbotten"), interval = 'prediction'))
exp(predict(model_3, newdata = data.frame(year=c(1975), region = "Orebro"), interval = 'confidence'))

exp(predict(model_3, newdata = data.frame(year=c(2013), region = "Orebro"), interval = 'confidence'))

#
Pb_all$region <- relevel(Pb_all$region, "Norrbotten")
model_3 <- lm(log(Pb) ~ I(year - 1975) + region, data = Pb_all)

reduced = lm(log(Pb) ~ I(year - 1975), data=Pb_all) # Reduced model
full = lm(log(Pb) ~ I(year - 1975) + region, data=Pb_all) # Full Model
anova(full,reduced)
summary(reduced)
summary(full)
anova(full)
summary(anova(full,reduced))
summary(reduced)
summary(full)

res <- resid(model_3)
plot(fitted(full), res) +
  facet_wrap(~ region)
qqnorm(res) 
qqline(res) +
  facet_wrap(~ region)
plot(density(res)) +
  facet_wrap(~ region)

### Lab 3
m1 = lm(Pb ~ I(year - 1975), data=Pb_all) # Reduced model
m2 = lm(log(Pb) ~ I(year - 1975), data=Pb_all) # Full Model
summary(m1)
plot(hatvalues(m1))
plot(hatvalues(m2))
leverages = influence(m1)$hat
ggplot(data = Pb_all, aes(x= year, y = hatvalues(m1))) +
  geom_jitter(width = 1)
ggplot(data = Pb_all, aes(x = year, y = hatvalues(m2))) +
  geom_point(size = 2) +
  geom_hline(yintercept=1/1231) +
  geom_hline(yintercept=min(hatvalues(m2))) +
  geom_vline(xintercept=which.min(hatvalues(m2)) + 1975)
  



which.min(hatvalues(m2))
df <- data.frame(Pb_all)
df[c(which(hatvalues(m1) == min(hatvalues(m1)))),]
which.min(hatvalues(m2))
which.min(hatvalues(m2))
min(hatvalues(m2))
year[which.min(hatvalues(m1))]
which.min(hatvalues(m1))
mean(df[,c('year')])

Pb_all$region <- relevel(Pb_all$region, "Norrbotten")
m2 <- lm(log(Pb) ~ I(year - 1975) + region, data = Pb_all)
ggplot(data = Pb_all, aes(x = year, y = hatvalues(m2), color = region)) +
  geom_point(size = 2) +
  geom_hline(yintercept=1/523) +
  geom_hline(yintercept=1/305) +
  geom_hline(yintercept=min(hatvalues(m2))) 

Pb_all$r.lin <- rstudent(m2)
ggplot(data = Pb_all, aes(x = year, y = r.lin)) +
  geom_point(size = 3) +
  geom_smooth(color = "red") +
  geom_hline(yintercept = c(-2, 0, 2)) +
  geom_hline(yintercept = c(-3, 3), linetype = 2) +
  xlab("Predicted log-weight (ln g)") +
  ylab("Studentized residual") +
  labs(title = "Studentized residuals vs predicted values Y-hat") +
  theme(text = element_text(size = 18)) +
  facet_wrap(~region)

cooks.distance(m2)



###B
m0 <- lm(log(Pb) ~ I(year - 1975), data = Pb_all)
m1 <- lm(log(Pb) ~ I(year - 1975)+region, data = Pb_all)
m2 <- lm(log(Pb) ~ I(year - 1975)*region, data = Pb_all)
summary(m2)
summary(m0)$r.squared
summary(m1)$r.squared
summary(m2)$r.squared
summary(m0)$adj.r.squared
summary(m1)$adj.r.squared
summary(m2)$adj.r.squared
anova(m0)
AIC(m0)
AIC(m1)
AIC(m2)
BIC(m0)
BIC(m1)
BIC(m2)
summary(m2)
