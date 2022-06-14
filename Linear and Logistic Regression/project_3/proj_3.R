library(glmtoolbox)
library(pROC)
library(ResourceSelection)
library(zoo)
library(lmtest)
library(xtable)
library(ggplot2)
library(tidyquant)
library(pscl)
library(DescTools)
library(ggpubr)
plasma <- read.delim("plasma.txt")
PositivePlasma <- plasma[plasma$betaplasma > 0, ]
#Turn categorical variables into factor variables:
PositivePlasma$sex <- factor(PositivePlasma$sex, 
                             levels = c(1, 2),
                             labels = c("Male", "Female"))

PositivePlasma$smokstat <- factor(PositivePlasma$smokstat,
                                  levels = c(1, 2, 3),
                                  labels = c("Never", "Former", "Current"))

PositivePlasma$bmicat <- factor(PositivePlasma$bmicat,
                                levels = c(1,2,3,4),
                                labels = c("Underweight", "Normal", "Overweight", "Obese"))

PositivePlasma$vituse <- factor(PositivePlasma$vituse,
                                levels = c(1, 2, 3),
                                labels = c("Yes, fairly often", "Yes, not often", "No"))

PositivePlasma$sex<-relevel(PositivePlasma$sex, "Female")
PositivePlasma$smokstat<-relevel(PositivePlasma$smokstat, "Never")
PositivePlasma$bmicat <- relevel(PositivePlasma$bmicat,"Normal")
PositivePlasma$vituse <- relevel(PositivePlasma$vituse,"Yes, fairly often")

(Quants=quantile(PositivePlasma$betaplasma))
PositivePlasma$plasmacat <- cut(PositivePlasma$betaplasma, 
                                breaks = c(Quants[1]-1, Quants[2], Quants[3], Quants[4], Quants[5]+1),
                                labels=c("Very Low", "Low", "High", "Very High"))
table(PositivePlasma$plasmacat)
(model.null <- polr(plasmacat ~ 1, data = PositivePlasma))
(sum.null <- summary(model.null))


# full model####
(model.full <- polr(plasmacat ~ vituse+calories+fiber+alcohol+betadiet+fat+cholesterol+age+sex+smokstat+quetelet, data = PositivePlasma))
(sum.full <- summary(model.full))


# stepwise####
(model.final <- step(model.full))
(sum.final <- summary(model.final))

#beta-estimates
cbind(beta = model.final$coefficients, 
      expbeta = exp(model.final$coefficients),
      exp(confint(model.final)))
#zeta-extimates
cbind(zeta = model.final$zeta, 
      expzeta = exp(model.final$zeta))

sum.final$coefficients

#estimated probabilities:
predict(model.final, type = "prob")
#predicted category:
predict(model.final)
predict(model.final, type = "class")

x0 <-data.frame(age = rep(seq(min(PositivePlasma$age), max(PositivePlasma$age)), 2))
x0$vituse <- "Yes, fairly often"
x0$quetelet<- mean(PositivePlasma$quetelet)
x0$fiber<- mean(PositivePlasma$fiber)
x0$betadiet<- mean(PositivePlasma$betadiet)
x0$fat<-mean(PositivePlasma$fat)
x0$smokstat<-"Never"
x0$sex <- c(rep("Male", 83 - 19 + 1), 
             rep("Female", 83 - 19 + 1))
x0$calories = mean(PositivePlasma$calories)

b0 <- data.frame(quetelet = rep(seq(min(PositivePlasma$quetelet), max(PositivePlasma$quetelet)), 2))
b0$vituse <- "Yes, fairly often"
b0$calories<- mean(PositivePlasma$calories)
b0$age<- mean(PositivePlasma$age)
b0$fiber<- mean(PositivePlasma$fiber)
b0$betadiet<- mean(PositivePlasma$betadiet)
b0$sex <- c(rep("Male", 50.40333 - 16.33114 + 1), 
            rep("Female", 50.40333 - 16.33114 + 1))
b0$smokstat<-"Never"

pred <- cbind(
  x0,
  predict(model.final, newdata = x0, type = "prob"),
  yhat = predict(model.final, newdata = x0))

pred_quet<-cbind(b0,
                 predict(model.final, newdata=b0, type = "probs"))
png('outputs/f1.png')
ggplot(pred, aes(x=age))+
  geom_line(aes(y = `Very High`, color = "Very High"), size = 2) +
  geom_line(aes(y = High, color = "High"), size = 2) +
  geom_line(aes(y = Low, color = "Low"), size = 2) +
  geom_line(aes(y = `Very Low`, color = "Very Low"), size = 2) +
  expand_limits(y = c(0, 1)) +
  facet_grid(~sex) +
  labs(y = "probability") +
  theme(text = element_text(size = 14))
dev.off()
png('outputs/f2.png')
ggplot(pred_quet, aes(x=quetelet))+
  geom_line(aes(y = `Very High`, color = "Very High"), size = 2) +
  geom_line(aes(y = High, color = "High"), size = 2) +
  geom_line(aes(y = Low, color = "Low"), size = 2) +
  geom_line(aes(y = `Very Low`, color = "Very Low"), size = 2) +
  expand_limits(y = c(0, 1)) +
  facet_grid(~sex) +
  labs(title = "Multinomial: average patient with varying quetelet and sex",
       y = "probability") +
  theme(text = element_text(size = 14))
dev.off()
png('outputs/f3.png')
ggplot(pred, aes(x = age)) +
  geom_ribbon(aes(ymin = 0, ymax =  `Very Low`, fill = "1.Very Low")) +
  geom_ribbon(aes(ymin = `Very Low`, 
                  ymax = `Very Low` + Low, 
                  fill = "2.Low")) +
  geom_ribbon(aes(ymin = `Very Low` + `Low`, ymax = High + `Very Low` + `Low`,
                  fill = "3.High")) +
  geom_ribbon(aes(ymin = High + `Very Low` + `Low`, ymax = 1,
                  fill = "4.Very High")) +
  labs(fill = "Beta Plasma Levels", title = "Beta Plasma Levels") +
  facet_wrap(~ sex, labeller = "label_both") +
  theme(text = element_text(size = 14))
dev.off()
png('outputs/f4.png')
ggplot(pred_quet, aes(x = quetelet)) +
  geom_ribbon(aes(ymin = 0, ymax =  `Very Low`, fill = "1.Very Low")) +
  geom_ribbon(aes(ymin = `Very Low`, 
                  ymax = `Very Low` + Low, 
                  fill = "2.Low")) +
  geom_ribbon(aes(ymin = `Very Low` + `Low`, ymax = High + `Very Low` + `Low`,
                  fill = "3.High")) +
  geom_ribbon(aes(ymin = High + `Very Low` + `Low`, ymax = 1,
                  fill = "4.Very High")) +
  labs(fill = "Beta Plasma Levels", title = "Beta Plasma Levels") +
  facet_wrap(~ sex, labeller = "label_both") +
  theme(text = element_text(size = 14))
dev.off()

model.final$deviance
model.final$edf
info <- cbind(aic = AIC(model.null, model.final, model.full),
              bic = BIC(model.null, model.final, model.full),
              R2D = 100*c(1 - model.null$deviance/model.null$deviance, 
                          1 - model.final$deviance/model.null$deviance, 
                          1 - model.full$deviance/model.null$deviance),
              R2D.adj = 100*c(1 - (model.null$deviance + model.null$edf - model.null$edf)/
                                model.null$deviance, 
                              1 - (model.final$deviance + model.final$edf - model.null$edf)/
                                model.null$deviance, 
                              1 - (model.full$deviance + model.full$edf - model.null$edf)/
                                model.null$deviance))
round(info, digits = 1)
# LR-test comparing nested models:
anova(model.null, model.final)
anova(model.final, model.full)
pred.final <- cbind(PositivePlasma,
                    yhat = predict(model.final))
(conf.matrix <- table(pred.final$plasmacat, pred.final$yhat))
auc <- multiclass.roc(pred.final$plasmacat, pred.final$yhat)
(sens <- 100*(diag(conf.matrix)/table(pred.final$plasmacat)))
(prec <- 100*(diag(conf.matrix)/table(pred.final$yhat)))
(acc <- 100*sum(diag(conf.matrix)/sum(conf.matrix)))
temp<-predict(model.final, type = "probs")
multiclass.roc(pred.final$plasmacat ~temp)
roc.full <- multiclass.roc(pred.final$plasmacat ~temp, plot = TRUE)
plot(roc.full, col="red", lwd=3, main="ROC Curve")

pred.phat <- cbind(
  PositivePlasma,
  p.0 = predict(model.null, type = "probs"),
  p.1 = predict(model.full, type = "probs"),
  p.2 = predict(model.final, type = "probs"))

(roc.0 <- roc(plasmacat ~ p.0, data = pred.phat))
roc.df.0 <- coords(roc.0, transpose = FALSE)
roc.df.0$model <- "NULL"
roc.1 <- roc(hosp ~ p.1, data = pred.phat)
roc.df.1 <- coords(roc.1, transpose = FALSE)
roc.df.1$model <- "Full"
roc.2 <- roc(hosp ~ p.2, data = pred.phat)
roc.df.2 <- coords(roc.2, transpose = FALSE)
roc.df.2$model <- "Final"

#mnomial
library(MASS)
library(nnet)
(model.null.mnomial <- multinom(plasmacat ~ 1, data = PositivePlasma))
(model.full.mnomial <- multinom(plasmacat ~ vituse+calories+fiber+alcohol+betadiet+fat+cholesterol+age+sex+smokstat+quetelet, data = PositivePlasma))
model.aic.mnomial = step(model.null.mnomial, scope = list(lower = model.null.mnomial, upper = model.full.mnomial), direction = "both", criterion = 'AIC')
model.bic.mnomial = step(model.null.mnomial, scope = list(lower = model.null.mnomial, upper = model.full.mnomial), direction = "both", criterion = 'BIC')
info <- cbind(aic = AIC(model.full.mnomial, model.null.mnomial, model.aic.mnomial, model.bic.mnomial),
              bic = BIC(model.full.mnomial, model.null.mnomial, model.aic.mnomial, model.bic.mnomial))
info$r2.adj <- round(100*c(
  1 - (model.full.mnomial$deviance + (model.null.mnomial$edf - model.null.mnomial$edf))/model.null.mnomial$deviance,
  1 - (model.full.mnomial$deviance + (model.full.mnomial$edf - model.null.mnomial$edf))/model.null.mnomial$deviance,
  1 - (model.aic.mnomial$deviance + (model.aic.mnomial$edf - model.null.mnomial$edf))/model.null.mnomial$deviance,
  1 - (model.bic.mnomial$deviance + (model.bic.mnomial$edf - model.null.mnomial$edf))/model.null.mnomial$deviance),
  digits = 1)

pred.full <- cbind(PositivePlasma,
                    predict(model.full.mnomial, type = "probs"),
                    yhat = predict(model.full.mnomial))
(conf.matrix <- table(pred.final$plasmacat, pred.full$yhat))
(sens <- 100*(diag(conf.matrix)/table(pred.final$plasmacat)))
(prec <- 100*(diag(conf.matrix)/table(pred.final$yhat)))
(acc <- 100*sum(diag(conf.matrix)/sum(conf.matrix)))
temp<-predict(model.full.mnomial, type = "probs")
roc.full <- multiclass.roc(pred.full$plasmacat ~temp, plot = TRUE)
plot(roc.full, col="red", lwd=3, main="ROC Curve")
plot(hej, col="red", lwd=3, main="ROC Curve")
auc(roc.full)

temp<-predict(model.aic.mnomial, type = "probs")
multiclass.roc(pred.full$plasmacat ~temp)
temp<-predict(model.bic.mnomial, type = "probs")
hej <- multiclass.roc(pred.full$plasmacat ~temp, plot = TRUE)
plot(hej, col="red", lwd=3, main="ROC Curve")
auc(hej)
