%% Task 7
[denoised] = lasso_denoise(Ttest, Xaudio, lambdaopt);
%%
save('outputs/denoised_audio','denoised','fs') 

%% Playing around
[denoised_005] = lasso_denoise(Ttest, Xaudio, 0.05);
[denoised_01] = lasso_denoise(Ttest, Xaudio, 0.1);
[denoised_05] = lasso_denoise(Ttest, Xaudio, 0.5);

%% Original
soundsc(Ttest,fs)

%% Optimal
soundsc(denoised,fs)

%% Lambda 0.1
soundsc(denoised_01,fs)

%% Lambda 05
soundsc(denoised_05,fs)