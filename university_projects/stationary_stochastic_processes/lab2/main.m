%% 3 The periodogram
clear all
clc
load unknowndata.mat
%plot(data)
% Mean does not seem to be zero we need to subtract it
x = data - mean(data);
plot(x)
X = fft(x);

n=length(x);
Rhat=(X.*conj(X))/n; 
f=[0:n-1]/n;
figure
%Plot makeshift periodogram
plot(f-0.5,fftshift(Rhat))
%What do you see? Answer: The power of the signal is centered at 0,2
%frequency. However it could have components of other freqs but these are
%hidden due to leakage
N = 4096;
X=fft(x,N);
Rhat=(X.*conj(X))/n;
f=[0:N-1]/N;
figure
plot(f,Rhat)
%Q. How does the use of zero-padding change your spectral estimate? The
%unknown signal is a realization of a cosine function process, what should
%the actual covariance function look like? Can you identify the frequency?
%A. It improves the spectral resolution. A decreasing sinusoidal signal
%with frequency 0,2

rhat=ifft(Rhat);
figure
plot([0:15],rhat(1:16))


%Q. Can you explain the shape of the estimate from theory?
%A. As expected the covariance function is a sinusoidal signal with period
%time T = 1/0,2 = 5. 

%% 4. Investigation of Spectral Estimate Techniques
clear all
clc

e = randn(500,1);
modell.A=[1 -2.39 3.35 -2.34 0.96];
modell.C=[1 0 1];
x = filter(modell.C, modell.A, e);
figure
plot(x)

figure
[H,w]=freqz(modell.C,modell.A,2048);
R=abs(H).^2;
plot(w/2/pi,10*log10(R))

figure
periodogram(x,[],4096)

figure
periodogram(x,hanning(500),4096)

%Q. How does the periodogram and the Hanning windowed periodogram differ? Sketch the estimates and explain.
%A. Hanning window gives less noisy signal. The frequency dip at 0,25 is
%not visible using the rectangular (fejer) window It is drowned by the
%leakage caused by the large amplitude of the sidelobes. Using the Hanning window one can see this dip, however the
%resolution at the other peaks is diminished due to the wider mainlobe.
%Using hanning window the periodogram is less biased due to the higher drop
%in amplitude for the sidelobes. The variance is the same for both windows
%(high)


[Rhat,f]=periodogram(x,[],4096,1);
figure
plot(f,Rhat) % Linear scale
figure
semilogy(f,Rhat) % Logarithmic scale

n = length(x);
K = 10;
L = round(2*n /(K+1));
figure
pwelch(x,hanning(L),[],4096)

%Q. What are the differences using the Welch estimator compared to the periodogram? Sketch and explain.
%A. The variance is smaller. Bias is larger since main lobe is larger of
%the many hanning windows that we have averaged over. 

Rhate=periodogram(e,[],4096);
Rhatew=pwelch(e,hanning(L),[],4096);

var(Rhate)/var(Rhatew)

%Q. What is the average relation between the two variances? Is this in concordance with theory?
%A. The periodogram has approximately double the variance of the welch one.
%Sould differ by a factor of K = 10 according to theory
figure
pmtm(x,(10-1)/2,[],4096)



%% 5. EEG
clear all
clc
load eegdata12.mat
spekgui
%Q. Which sequence is most likely to come from the 12 Hz flickering light?
%A. Data2 Strong peak at 12Hz

%% 
clear all
clc
load eegdatax.mat
spekgui
%Q. Can you judge which frequency it has and which sequence it is intro- duced into?
%A. Data 3. It is the only one with a clear peak at 16 Hz 


%% Gaussian Processes
clear all
clc
load threeprocessdata.mat

figure
plot(y1)
figure
plot(y2)
figure
plot(y3)
%%
figure
plot(xcov(y1))
figure
plot(xcov(y2))
figure
plot(xcov(y3))
%%
figure
periodogram(y1,[],4096,1)
figure
periodogram(y2,[],4096,1)
figure
periodogram(y3,[],4096,1)

%%
n = length(y1);
K = 10;
L = round(2*n /(K+1));
figure
pwelch(y1,hanning(L),[],4096);
figure
pwelch(y2,hanning(L),[],4096);
figure
pwelch(y3,hanning(L),[],4096);
%Q. Compare your periodograms and Welch spectra and the true spectral
%densities of Figure 2. Identify which sequence that belongs to each of the
%spectral densities, A, B and C. Sketch and explain.
%y1:A, y2:C, y3:B

% 2:C Obvious since we have the clear plateau. B and A hard difficult to
% distinguish howver looking at the number of peaks using the welch method
% one arrives at the conclusion above.


%% 6.2 Coherance spectrum
clear all
clc
load threeprocessdata.mat
n = length(y1);
K = 10;
L = round(2*n /(K+1));
figure
mscohere(x1,y1,hanning(L),[],4096);
figure
mscohere(x3,y1,hanning(L),[],4096)

%
%The coherance spectrum is a measurement for linear dependance of the amplitude
%between the two SVs. If it is unitary they are directly proportional at
%that frequency. Looks like the samples have been mixed up. X3 is
%proportional to y1 except for at certain frequencies. Perhaps the filter
% is restricted to these frequencies. 


