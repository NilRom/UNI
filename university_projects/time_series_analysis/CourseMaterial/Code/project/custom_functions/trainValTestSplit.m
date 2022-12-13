function [df_train,df_val, df_test] = trainValTestSplit(df, start_date, plotIt)
%TRAINVALTESTSPLIT Summary of this function goes here
%   Detailed explanation goes here
start_train = find(df.time == start_date);
end_train= start_train + 10*24*7;

start_val = end_train;
end_val = end_train + 2*24*7;

start_test = end_train + 20*24*7;
end_test = start_test + 2*24*7;


df_train = df(start_train:end_train,:);
df_val = df(start_val:end_val,:);
df_test = df(start_test:end_test,:); %Never touch this :)


if plotIt == 1
    figure
    
    subplot(311)
    plot(df_train.time, df_train.t_sla)
    hold on
    plot(df_val.time, df_val.t_sla)
    plot(df_test.time, df_test.t_sla)
    title('SVEDALA')
    legend(["Train", "Validation", "Test"])
    
    subplot(312)
    
    plot(df_train.time, df_train.tp_stu)
    hold on
    plot(df_val.time, df_val.tp_stu)
    plot(df_test.time, df_test.tp_stu)
    title('STURUP')
    
    legend(["Train", "Validation", "Test"])


    subplot(313)
    
    plot(df_train.time, df_train.tp_vxo)
    hold on
    plot(df_val.time, df_val.tp_vxo)
    plot(df_test.time, df_test.tp_vxo)
    title('VÄXSJÖ')
    
    legend(["Train", "Validation", "Test"])
end
end

