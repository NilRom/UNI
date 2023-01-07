addpath Code/project/custom_functions/
clear 
clc
df = loadCleanValidate(0);
start_date = '1994-10-01';
[df_train,df_val, df_test] = trainValTestSplit(df, start_date, 1);


%%
writetable(df,'Code/project/projectDataClean.csv','Delimiter',',','QuoteStrings',true)
writetable(df_train,'Code/project/train.csv','Delimiter',',','QuoteStrings',true)
writetable(df_val,'Code/project/val.csv','Delimiter',',','QuoteStrings',true)
writetable(df_test,'Code/project/test.csv','Delimiter',',','QuoteStrings',true)