addpath Code/project/custom_functions/
clear 
clc
df = loadCleanValidate(0);
start_date = '1994-10-01';
trainValTestSplit(df, start_date, 1)