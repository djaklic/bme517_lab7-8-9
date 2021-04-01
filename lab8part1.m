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

B = inv(firingrates_training'*firingrates_training)*firingrates_training'*positionAndSpeeds_training;

positionAndSpeeds_prediction = firingrates_testing*B;

mse = immse(positionAndSpeeds_prediction, positionAndSpeeds_testing);
mse_xpos = immse(positionAndSpeeds_prediction(:,1), positionAndSpeeds_testing(:,1));
mse_ypos = immse(positionAndSpeeds_prediction(:,2), positionAndSpeeds_testing(:,2));
mse_xvel = immse(positionAndSpeeds_prediction(:,3), positionAndSpeeds_testing(:,3));
mse_yvel = immse(positionAndSpeeds_prediction(:,4), positionAndSpeeds_testing(:,4));

corr_total = corr2(positionAndSpeeds_prediction, positionAndSpeeds_testing);
%corr = .8593
corr_xpos = corr2(positionAndSpeeds_prediction(:,1), positionAndSpeeds_testing(:,1));
corr_ypos = corr2(positionAndSpeeds_prediction(:,2), positionAndSpeeds_testing(:,2));
corr_xvel = corr2(positionAndSpeeds_prediction(:,3), positionAndSpeeds_testing(:,3));
corr_yvel = corr2(positionAndSpeeds_prediction(:,4), positionAndSpeeds_testing(:,4));

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
saveas_ = '../figures/lab8part1_positions';
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
saveas_ = '../figures/lab8part1_velocities';
savefig(append(saveas_, '.fig'))
saveas(f, append(saveas_, '.jpg'))