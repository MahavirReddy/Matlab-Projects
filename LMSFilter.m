clc;
clear;
close all;

%% 1. Read the original speech signal
[x, Fs] = audioread(['test.wav']);

% Convert stereo to mono
if size(x,2) > 1
    x = mean(x,2);
end

% Normalize
x = x / max(abs(x));

%% 2. Generate noise
t = (0:length(x)-1)' / Fs;

% Sinusoidal noise
f_noise = 1000;                 % Noise frequency = 1 kHz
noise = 0.4 * sin(2*pi*f_noise*t);

%% 3. Create noisy speech
d = x + noise;

%% 4. LMS Adaptive Filter parameters
M = 32;                         % Filter length
mu = 0.001;                    % Step size

% Initialize filter coefficients
w = zeros(M,1);

% Input vector
u = zeros(M,1);

% Output and error
y = zeros(length(x),1);
e = zeros(length(x),1);

%% 5. LMS algorithm
for n = M:length(x)

    % Reference noise samples
    u = noise(n:-1:n-M+1);

    % Estimated noise
    y(n) = w' * u;

    % Error = noisy signal - estimated noise
    e(n) = d(n) - y(n);

    % Update filter coefficients
    w = w + mu * e(n) * u;

end

%% 6. Calculate SNR before filtering

signal_power = mean(x.^2);
noise_before = d - x;

SNR_before = 10*log10( ...
    signal_power / mean(noise_before.^2) );

%% 7. Calculate SNR after filtering

noise_after = e - x;

SNR_after = 10*log10( ...
    signal_power / mean(noise_after.^2) );

%% 8. Calculate MSE

MSE = mean((x - e).^2);

%% 9. Display results

fprintf('-------------------------------------\n');
fprintf(' LMS Adaptive Noise Cancellation\n');
fprintf('-------------------------------------\n');

fprintf('Filter length       = %d\n', M);
fprintf('Step size (mu)      = %.5f\n', mu);
fprintf('SNR before filtering = %.2f dB\n', SNR_before);
fprintf('SNR after filtering  = %.2f dB\n', SNR_after);
fprintf('SNR improvement      = %.2f dB\n', ...
    SNR_after - SNR_before);
fprintf('MSE                  = %.6f\n', MSE);

%% 10. Time-domain plots

time = (0:length(x)-1)/Fs;

figure;

subplot(3,1,1);
plot(time,x);
title('Original Speech');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(3,1,2);
plot(time,d);
title('Noisy Speech');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(3,1,3);
plot(time,e);
title('Filtered Speech');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

%% 11. Frequency-domain analysis

N = length(x);

X = fft(x);
D = fft(d);
E = fft(e);

f = (0:N-1)*(Fs/N);

figure;

subplot(3,1,1);
plot(f(1:N/2),abs(X(1:N/2)));
title('Spectrum of Original Speech');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
grid on;

subplot(3,1,2);
plot(f(1:N/2),abs(D(1:N/2)));
title('Spectrum of Noisy Speech');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
grid on;

subplot(3,1,3);
plot(f(1:N/2),abs(E(1:N/2)));
title('Spectrum after LMS Filtering');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
grid on;

%% 12. Spectrogram comparison

figure;

subplot(2,1,1);
spectrogram(d,256,200,256,Fs,'yaxis');
title('Noisy Speech Spectrogram');

subplot(2,1,2);
spectrogram(e,256,200,256,Fs,'yaxis');
title('Filtered Speech Spectrogram');

%% 13. Play the signals

%disp('Playing original speech...');
%sound(x,Fs);
%pause(length(x)/Fs + 1);

%disp('Playing noisy speech...');
%sound(d,Fs);
%pause(length(d)/Fs + 1);

disp('Playing filtered speech...');
sound(e,Fs);
