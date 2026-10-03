clear;
clc;
close all;

[x,fs] = audioread('test.wav');

if size(x,2) == 2
    x = mean(x,2);
end

x = x/max(abs(x));

N = length(x);

t = (0:N-1)'/fs;

Ac = 4;

fc = 10000;

SNR = 10;

mu_values = [0.2 0.5 0.8 1.0 1.2 1.5];

[b,a] = butter(6,5000/(fs/2),'low');

figure;

subplot(7,1,1);
plot(t,x);
title('Original Audio');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

for k = 1:length(mu_values)

    mu = mu_values(k);

    carrier = cos(2*pi*fc*t);

    AM = Ac*(1+mu*x).*carrier;

    signal_power = mean(AM.^2);

    noise_power = signal_power/(10^(SNR/10));

    noise = sqrt(noise_power)*randn(size(AM));

    received = AM + noise;

    mixed = received.*carrier;

    filtered = filtfilt(b,a,mixed);

    demodulated = filtered-Ac/2;

    demodulated = (2/(Ac*mu))*demodulated;

    demodulated = demodulated/max(abs(demodulated));

    MSE = mean((x-demodulated).^2);

    x1 = x-mean(x);

    x2 = demodulated-mean(demodulated);

    correlation = sum(x1.*x2)/sqrt(sum(x1.^2)*sum(x2.^2));

    fprintf('\nModulation Index = %.1f\n',mu);
    fprintf('MSE = %.6f\n',MSE);
    fprintf('Correlation = %.4f\n',correlation);

    subplot(7,1,k+1);
    plot(t,demodulated);
    title(['Demodulated Audio, \mu = ',num2str(mu)]);
    xlabel('Time (s)');
    ylabel('Amplitude');
    grid on;

end
