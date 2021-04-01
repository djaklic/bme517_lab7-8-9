clear
clc

data = load("positionAndSpeeds_training.mat");
X = data.positionAndSpeeds_training';
data = load("firingrates_training.mat");
Y = data.firingrates_training';
data = load("positionAndSpeeds_testing.mat");
X_test = data.positionAndSpeeds_testing';
data = load("firingrates_testing.mat");
Y_test = data.firingrates_testing';

%data = load("contdata95.mat");
%positionAndSpeeds = data.X;
%firingrates = data.Y;

%A = load('A.mat').A;
A = computeA(X);
%save('A.mat','A');
C = computeC(X, Y);
save('C.mat','C');
W = computeW(X, A);
save('W.mat','W');
Q = computeQ(X, Y, C);
save('Q.mat','Q');
%kalman = My_Kalman(Y_test, A, C, W, Q, X_test(:,1));
kalman = load('kalman.mat').kalman;

%check_A = firingrates_testing*A;

f = figure;
subplot(2,1,1)
hold on
plot(kalman(1,1:500))
plot(X_test(1,1:500))
%plot(X_test(2,1:50))
ylabel('X position (mm)')
legend('predicted position', 'actual position')
hold off
subplot(2,1,2)
hold on
plot(kalman(2,1:500))
plot(X_test(2,1:500))
hold off
ylabel('Y position (mm)')
xlabel('sample # (100 ms bins)')
hold off
legend('predicted position', 'actual position')
saveas_ = '../figures/lab9part2_positions';
savefig(append(saveas_, '.fig'))
saveas(f, append(saveas_, '.jpg'))


mse_xpos = immse(kalman(1,:), X_test(1,2:end));
mse_ypos = immse(kalman(2,:), X_test(2,2:end));
mse_xvel = immse(kalman(3,:), X_test(3,2:end));
mse_yvel = immse(kalman(4,:), X_test(4,2:end));
mse_total = immse(kalman, X_test(:,2:end));

corr_xpos = corr2(kalman(1,:), X_test(1,2:end));
corr_ypos = corr2(kalman(2,:), X_test(2,2:end));
corr_xvel = corr2(kalman(3,:), X_test(3,2:end));
corr_yvel = corr2(kalman(4,:), X_test(4,2:end));
corr = corr2(kalman, X_test(:,2:end));

%---------------FUNCTIONS------------------%

function [A] = computeA(X)
    disp('Computing A...')
    A = X(:,2:end)*X(:,1:end-1)'*((X(:,1:end-1)*X(:,1:end-1)')^(-1));
    disp('A Complete.')
end

function [C] = computeC(X, Y)
    disp('Computing C...')
    C = Y(:,2:end)*X(:,2:end)'*((X(:,2:end)*X(:,2:end)')^(-1));
    %C = inv(Y'*Y)*Y'*X;
    disp('C Complete.')
end

function [W] = computeW(X, A)
    num_points = size(X, 2);
    disp('Computing W...')
    W = (1/(num_points-1))*(X(:,2:end)-A*X(:,1:end-1))*(X(:,2:end)-A*X(:,1:end-1))';
    disp('W Complete.')
end

function [Q] = computeQ(X, Y, C)
    num_points = size(X, 2);
    disp('Computing Q...')
    Q = (1/num_points)*(Y(:,2:end)-C*X(:,2:end))*(Y(:,2:end)-C*X(:,2:end))';
    disp('Q Complete.')
end

function [x_t] = My_Kalman(Y, A, C, W, Q, first_X)
    disp('Begin Kalman...')
    P_t = W;
    x_t_ = first_X;
    x_t = [];
    for i=2:size(Y,2)
        x_t_1 = A*x_t_;
        P_t_ = A*P_t*A'+W;
        K_t = P_t_*C'*(C*P_t_*C'+Q)^(-1);
        x_t = [x_t (x_t_1 + K_t*(Y(:,i)-C*x_t_))]; %this is the prediction
        P_t = (eye()-K_t*C)*P_t_;
        %P_t = (eye(size(K_t,1), size(C,2))-K_t*C)*P_t_;
        x_t_ = x_t(:,end);
    end
    disp('Kalman Complete')
end