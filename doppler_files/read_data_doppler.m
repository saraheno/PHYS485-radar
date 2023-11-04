%MIT IAP Radar Course 2011
%Resource: Build a Small Radar System Capable of Sensing Range, Doppler, 
%and Synthetic Aperture Radar Imaging 
%
%Gregory L. Charvat

%Process Doppler vs. Time Intensity (DTI) plot

%NOTE: set Vtune to 3.2V to stay within ISM band and change fc to frequency
%below

clear all;
close all;

%read the raw data .wave file here
[Y,FS] = audioread('Off of Newton Exit 17.wav');
%[Y,FS] = audioread('Recording.wav');
disp("FS is");
disp(FS);
disp("number of data is ");
aaa=size(Y,1);
disp(aaa);
figure(50);
plot(Y(1:aaa/4,1));  % synch signal
figure(51);
plot(Y(1:aaa/4,2));  % waveform
hold on;


%constants
c = 3E8; %(m/s) speed of light

%radar parameters
Tp=0.5;  % a time in which to get the average velocity
N = Tp*FS; %# of samples per pulse
fc = 2590E6; %(Hz) Center frequency (connected VCO Vtune to +5 for example)
%fc = 2495E6; %(Hz) Center frequency within ISM band (VCO Vtune to +3.2V)

%the input appears to be inverted
s = -1*Y(:,2);
%clear Y;

%creat doppler vs. time plot data set here
for ii = 1:round(size(s,1)/N)-1
    sif(ii,:) = s(1+(ii-1)*N:ii*N);
end

%subtract the average DC term here
sif = sif - mean(s);

zpad = 8*N/2;

%doppler vs. time plot:
figure(77);
v = dbv(ifft(sif,zpad,2));
v = v(:,1:size(v,2)/2);
mmax = max(max(v));
%calculate velocity
delta_f = linspace(0, FS/2, size(v,2)); %(Hz)
lambda=c/fc;
velocity = delta_f*lambda/2;
%calculate time
time = linspace(1,Tp*size(v,1),size(v,1)); %(sec)
%plot
imagesc(velocity,time,v-mmax,[-35, 0]);
colorbar;
xlim([0 20]); %limit velocity axis
xlabel('Velocity (m/sec)');
ylabel('time (sec)');
