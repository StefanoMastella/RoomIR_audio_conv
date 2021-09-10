%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Room impulse response and audio signal convolution
%
% Guilherme Rosenthal and Stéfano Mastella Corrêa
%
% Last update: Septrember 8th, 2021.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; clc; close all;

%% Loading room impulse respone and audio track
IR = audioread ('Room_IR.wav');
[song, fs] = audioread('audio_track.wav'); 

%Obs: Both signals must have the same sample rate
 
%% Convolve music and Room Impulse Response
nfft = length(song)+length(IR)-1;
band_fft = fft(song,nfft);
conv_room_music_freq = band_fft .* fft(IR,nfft);
conv_room_music_time = real(ifft(conv_room_music_freq,nfft));

output = conv_room_music_time./max(abs(conv_room_music_time(:)))*0.95;
audiowrite('convolved_song.wav', output, fs);

%% Plot 
t = 0:1/fs:length(output)/fs-1/fs; % Time vector
N = length(song)+length(IR)-1;
freq = linspace(0, ((N-1)/N)*fs, N);

band_fft_mag = normalize(2*abs(band_fft)/N); % Symmetry effect correction
room_music_freq = normalize(2*abs(conv_room_music_freq)/N);

figure(1) 
semilogx(freq, band_fft_mag(:,1),freq, room_music_freq(:,1)); grid on; %Plot only one channel
xlim([20 5000]); ylim([0 85]); 
xlabel('Frequency [Hz]'); ylabel('Aplitude [-]');
title('Original signal and convolved signal comparison') 
legend('Original signal','Convolved signal')

% Uncomment to save figure
% set(gcf,'Units','inches'); screenposition = get(gcf,'Position');  
% set(gcf,'PaperPosition',[0 0 screenposition(3:4)],'PaperSize',[screenposition(3:4)]);
% print -dpdf -painters conv_compar
