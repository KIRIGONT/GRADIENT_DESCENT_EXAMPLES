clc; close all; clear all;

%% 1. Optimization Setup
x = [4; 4]; % Starting point as a column vector [x1; x2]

f = @(x) (x(1)^2 + 3*x(2)^2);   % Objective function
grad = @(x) [2*x(1); 6*x(2)];    % Gradient vector
H = [2, 0; 0, 6];               % Constant Hessian matrix

% History tracking for plotting
path = x; 

%% 2. Newton's Method Step
fprintf('Starting Point: (%f, %f)\n', x(1), x(2));

% Newton's update: x_next = x - inv(H) * grad
% Note: In MATLAB, use H \ grad instead of inv(H)*grad for better numerical stability
step = -H \ grad(x); 
x = x + step;

path = [path, x]; % Record the new position

fprintf('Optimization finished in 1 iteration.\n');
fprintf('Final Minimum Point: (%f, %f)\n', x(1), x(2));

%% 3. Visualization
[X1, X2] = meshgrid(-5:0.05:5);
Z = X1.^2 + 3*X2.^2;
contour(X1, X2, Z, 20);
hold on; grid on;

% Plot the trajectory (It will just be a straight line from start to finish)
plot(path(1,:), path(2,:), 'r-o', 'LineWidth', 2, 'MarkerFaceColor', 'r');
plot(path(1,end), path(2,end), 'gx', 'MarkerSize', 12, 'LineWidth', 2);

xlabel('X1'); ylabel('X2');
title('Newton''s Method: Universal Convergence in 1 Step');