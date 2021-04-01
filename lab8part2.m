clear
clc

data = load("positionAndSpeeds_training.mat");
positionAndSpeeds_training = data.positionAndSpeeds_training;
data = load("firingrates_training.mat");
firingrates_training = data.firingrates_training;

data = load("positionAndSpeeds_testing.mat");
positionAndSpeeds_testing = data.positionAndSpeeds_testing;
data = load("firingrates_testing.mat");
firingrates_testing = data.firingrates_testing;

% SWEEP USING TEST DATA
% need to multiply the lambda values given by the number of points in your training data
% N*lambda*I in regression equation
% CORRELATIONS should all be above 0.85 or so
% MSE = ?
% use mse or correlation to evaluate

num_l = 15;
lambda = linspace(0,0.1,num_l);
num_samples = size(firingrates_training,1);
num_features = size(firingrates_training,2);
errors = zeros(1,num_l);
correlations = zeros(1,num_l);
for i=1:num_l
    disp(i)
    B = inv(firingrates_training'*firingrates_training + num_samples*lambda(i)*eye(num_features))*firingrates_training'*positionAndSpeeds_training;
    positionAndSpeeds_prediction = firingrates_testing*B;
    errors(i) = immse(positionAndSpeeds_prediction, positionAndSpeeds_testing);
    correlations(i) = corr2(positionAndSpeeds_prediction, positionAndSpeeds_testing);
end

%lambda(4) = best, lambda = 0.02143
best_lambda = 0.02143
B = inv(firingrates_training'*firingrates_training + num_samples*best_lambda*eye(num_features))*firingrates_training'*positionAndSpeeds_training;
save('B_fromRidge.mat','B');
positionAndSpeeds_prediction = firingrates_testing*B;
mse = immse(positionAndSpeeds_prediction, positionAndSpeeds_testing);
corr = corr2(positionAndSpeeds_prediction, positionAndSpeeds_testing);
%corr = 0.8596

mse_xpos = immse(positionAndSpeeds_prediction(:,1), positionAndSpeeds_testing(:,1));
mse_ypos = immse(positionAndSpeeds_prediction(:,2), positionAndSpeeds_testing(:,2));
mse_xvel = immse(positionAndSpeeds_prediction(:,3), positionAndSpeeds_testing(:,3));
mse_yvel = immse(positionAndSpeeds_prediction(:,4), positionAndSpeeds_testing(:,4));

corr_xpos = corr2(positionAndSpeeds_prediction(:,1), positionAndSpeeds_testing(:,1));
corr_ypos = corr2(positionAndSpeeds_prediction(:,2), positionAndSpeeds_testing(:,2));
corr_xvel = corr2(positionAndSpeeds_prediction(:,3), positionAndSpeeds_testing(:,3));
corr_yvel = corr2(positionAndSpeeds_prediction(:,4), positionAndSpeeds_testing(:,4));

[max,ind_max]=max(corr);
f = figure;
hold on
plot(lambda, correlations);
plot(best_lambda,max,'or')
title('lambda sweep')
xlabel('lambda')
ylabel('correlation coefficient')
hold off
saveas_ = '../figures/lab8part2_sweep';
savefig(append(saveas_, '.fig'))
saveas(f, append(saveas_, '.jpg'))

f = figure;
subplot(2,1,1)
hold on
plot(positionAndSpeeds_prediction(1:500,1))
plot(positionAndSpeeds_testing(1:500,1))
hold off
legend('predicted position', 'actual position')
%xlabel('sample #')
ylabel('X position')
subplot(2,1,2)
hold on
plot(positionAndSpeeds_prediction(1:500,2))
plot(positionAndSpeeds_testing(1:500,2))
hold off
legend('predicted position', 'actual position')
xlabel('sample # (100 ms bins)')
ylabel('Y position')
saveas_ = '../figures/lab8part2_positions';
savefig(append(saveas_, '.fig'))
saveas(f, append(saveas_, '.jpg'))

f = figure;
subplot(2,1,1)
hold on
plot(positionAndSpeeds_prediction(1:500,3))
plot(positionAndSpeeds_testing(1:500,3))
hold off
legend('predicted velocity', 'actual velocity')
%xlabel('sample #')
ylabel('X velocity')
subplot(2,1,2)
hold on
plot(positionAndSpeeds_prediction(1:500,4))
plot(positionAndSpeeds_testing(1:500,4))
hold off
legend('predicted velocity', 'actual velocity')
xlabel('sample # (100 ms bins)')
ylabel('Y velocity')
saveas_ = '../figures/lab8part2_velocities';
savefig(append(saveas_, '.fig'))
saveas(f, append(saveas_, '.jpg'))