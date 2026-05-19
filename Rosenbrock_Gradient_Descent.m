clc; close all; clear all;

%% 1. Optimization Setup
x10 = -1.2; % Classic textbook starting point for Rosenbrock
x20 = 1.0;  % Classic textbook starting point for Rosenbrock

% Objective function
f = @(x1,x2) (1 - x1).^2 + 100*(x2 - x1.^2).^2;   

% Gradients
delfx = @(x1,x2) (-2*(1 - x1) - 400*x1.*(x2 - x1.^2));             
delfy = @(x1,x2) (200*(x2 - x1.^2));             

thresh = 1e-5;   
max_iter = 5000; % Set high because GD moves incredibly slow here
alpha = 0.001;   % Small learning rate to prevent exploding/divergence

%% 2. Optimization Loop
ii = 1;
deltaf(ii) = 1;
x1(ii) = x10;
x2(ii) = x20;
fval(ii) = f(x1(ii), x2(ii));

while (ii <= max_iter) && (deltaf(ii) >= thresh)
    % Compute step vector using constant learning rate
    step = -alpha * [delfx(x1(ii), x2(ii)); delfy(x1(ii), x2(ii))];
    
    ii = ii + 1;
    x1(ii) = x1(ii-1) + step(1);
    x2(ii) = x2(ii-1) + step(2);
    
    fval(ii) = f(x1(ii), x2(ii));
    deltaf(ii) = abs(fval(ii) - fval(ii-1));
end

%% 3. Contour Plot Setup
figure('Position', [200, 200, 700, 600]);
[X1, X2] = meshgrid(-2:0.05:2);           
Z = f(X1, X2);

% Logarithmic spacing for contours because Rosenbrock climbs incredibly fast
contour(X1, X2, Z, logspace(-1, 3, 30));                  
hold on; grid on;

% Plot the overall trajectory path
plot(x1, x2, 'b--', 'LineWidth', 1); 

% Initialize animated components
h1 = plot(x1(1), x2(1), 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 6);
xlabel('X1')
ylabel('X2')
title('Gradient Descent on Rosenbrock (Banana) Function')

%% 4. Animation Loop
% Skipping frames (step by 10) because it takes thousands of iterations
for g = 2:10:length(x1)
    set(h1, 'XData', x1(g), 'YData', x2(g));
    drawnow;
    pause(0.01); 
end

% Visual final marker
plot(x1(end), x2(end), 'gx', 'MarkerSize', 12, 'LineWidth', 2); 
% Target minimum marker
plot(1, 1, 'ks', 'MarkerSize', 10, 'LineWidth', 2); 

fprintf('Optimization stopped after %d iterations.\n', length(x1)-1);
fprintf('Final Position: (%f, %f)\n', x1(end), x2(end));
fprintf('True Global Minimum is at: (1.000000, 1.000000)\n');