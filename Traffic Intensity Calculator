clc;
clear;

% Input values
C = input('Enter number of channels: ');
GOS = input('Enter GOS as a number (e.g., 0.02 for 2%): ');

% Check GOS
if GOS <= 0 || GOS >= 1
    error('GOS must be between 0 and 1. Example: 0.02 for 2%%');
end

% Erlang-B function
erlangB = @(A) ...
    (A^C / factorial(C)) / sum(arrayfun(@(k) A^k / factorial(k), 0:C));

% Find traffic intensity A
A = fzero(@(A) erlangB(A) - GOS, [0.0001, 10*C]);

% Display result
fprintf('\nNumber of channels = %d\n', C);
fprintf('GOS = %.4f\n', GOS);
fprintf('Traffic intensity = %.4f Erlangs\n', A);
