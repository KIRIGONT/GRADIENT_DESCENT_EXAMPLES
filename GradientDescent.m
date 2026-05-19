clc; close all; clear all;

%% 1. Optimization Setup
x10 = 4; % Starting point x1
x20 = 4; % Starting point x2

f = @(x1,x2) (x1.^2 + 3*x2.^2);   % Objective function (vectorized with .^)
delfx = @(x1) (2*x1);             % Gradient w.r.t x1
delfy = @(x2) (6*x2);             % Gradient w.r.t x2

thresh = 1e-3;   % Convergence threshold
max_iter = 100;  % Iteration limit

%% 2. Optimization Loop (Gradient Descent with Exact Line Search)
ii = 1;
deltaf(ii) = 1;
x1(ii) = x10;
x2(ii) = x20;
fval(ii) = f(x1(ii), x2(ii));

% Pre-allocate an array to store the optimal step sizes for visualization later
alpha_history(ii) = 0; 

while (ii <= max_iter) && (deltaf(ii) >= thresh)
    % Calculate analytically optimal step size (alpha) for this specific quadratic function
    a = (x1(ii)^2 + 9*x2(ii)^2) / (2*x1(ii)^2 + 54*x2(ii)^2);
    alpha_history(ii) = a; % Save alpha for plotting
    
    % Compute step vector: -alpha * gradient
    step = -a * [delfx(x1(ii)); delfy(x2(ii))];
    
    ii = ii + 1;
    % Update positions
    x1(ii) = x1(ii-1) + step(1);
    x2(ii) = x2(ii-1) + step(2);
    
    % Track progress
    fval(ii) = f(x1(ii), x2(ii));
    deltaf(ii) = abs(fval(ii) - fval(ii-1));
end

%% 3. Contour Plot Setup
figure('Position', [200, 200, 700, 600]); % Set explicit window size
[X1, X2] = meshgrid(-5:0.05:5);           % Marginally larger step for faster rendering
Z = f(X1, X2);
contour(X1, X2, Z, 20);                  % Draw 20 contour levels
hold on;
grid on;

% Plot the final full path as a dashed line so you can see the overall trajectory
plot(x1, x2, 'b--', 'LineWidth', 1); 

% Initialize animated elements
h1 = plot(x1(1), x2(1), 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 8);

% FIXED: Calculating the initial vector length accurately using pre-calculated values
init_step = -alpha_history(1) * [delfx(x1(1)); delfy(x2(1))];
h2 = line([x1(1), x1(1) + init_step(1)], [x2(1), x2(1) + init_step(2)], ...
          'Color', 'k', 'LineWidth', 2);

xlabel('X1')
ylabel('X2')
title('Gradient Descent Optimization: f(x_{1},x_{2}) = x_{1}^{2} + 3x_{2}^{2}')
pause(1);

%% 4. Animation Loop
for g = 2:length(x1)
    % Move the current position marker
    set(h1, 'XData', x1(g), 'YData', x2(g));
    
    % FIXED: Direction vector length now accurately reflects the actual optimization step size
    if g < length(x1)
        next_step = -alpha_history(g) * [delfx(x1(g)); delfy(x2(g))];
        set(h2, 'XData', [x1(g), x1(g) + next_step(1)], ...
                'YData', [x2(g), x2(g) + next_step(2)]);
    else
        % On the very last step, hide or zero out the direction vector
        set(h2, 'XData', x1(g), 'YData', x2(g));
    end
    
    drawnow;
    pause(0.3); % Adjusted slightly faster (0.3s) for a smoother feel
end

% Visual indicator that the algorithm finished
plot(x1(end), x2(end), 'gx', 'MarkerSize', 12, 'LineWidth', 2); 
fprintf('Optimization finished in %d iterations.\n', length(x1)-1);
fprintf('Final Minimum Point: (%f, %f)\n', x1(end), x2(end));