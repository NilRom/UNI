%% Run this script to reproduce all the results in the report :)
% You might have to change some paths to make it work 

%% Preamble
rng(0)
clear
clc
addpath Code/functions
addpath Code/project
addpath Code/project/projDatafiles
addpath Code/project/custom_functions/
addpath Code/project/models/
addpath Code/project/figs/
%% Run the Naive Predictor
run task_naive.m

%% Run the task A
run task_a.m

%% Run the task B
run task_b.m

%% Run the task C
run task_c.m

%% Run the reduced model in task C
run task_c_simplified.m

%% Run the Kalman filter for model A
run task_c_a.m

%% Run the Prophet model
%Cant run from matlab file. Go to task_prophet.ipynb to run the Prophet
%forecaster

%% Test All models
run test_all_models.m

