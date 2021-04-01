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

lambda = 0.02143;

%Can you only use 1-d vector at a time?
disp("Calculating LASSO...")
disp("xpos")
%[B1 STATS1] = lasso(firingrates_training, positionAndSpeeds_training(:,1), 'Lambda', lambda);
%save('B1.mat','B1');
B1 = load("B1.mat").B1;
disp("ypos")
%[B2 STATS2] = lasso(firingrates_training, positionAndSpeeds_training(:,2), 'Lambda', lambda);
%save('B2.mat','B2');
B2 = load("B2.mat").B2;
disp("xvel")
%[B3 STATS3] = lasso(firingrates_training, positionAndSpeeds_training(:,3), 'Lambda', lambda);
%save('B3.mat','B3');
B3 = load("B3.mat").B3;
disp("yvel")
%[B4 STATS4] = lasso(firingrates_training, positionAndSpeeds_training(:,4), 'Lambda', lambda);
%save('B4.mat','B4');
B4 = load("B4.mat").B4;
B = [B1 B2 B3 B4];
save('B_fromLASSO.mat','B');
disp("Calculation Done.")

disp("Plotting LASSO xpos...")

figure;
positionAndSpeeds_prediction = firingrates_testing*B;
hold on
scatter(positionAndSpeeds_testing(1:500,1),positionAndSpeeds_prediction(1:500,1))
plot(positionAndSpeeds_testing(1:500,1),positionAndSpeeds_testing(1:500,1))
xlabel('Actual')
ylabel('Predicted')
hold off

figure;
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
%saveas_ = '../figures/lab8part2_positions';
%savefig(append(saveas_, '.fig'))
%saveas(f, append(saveas_, '.jpg'))

disp("Plotting Done.")

%LASSO B matrix has only 1 dimension (append).
%Also contains zeros (ridge does not). What is the significance?

corr = corr2(positionAndSpeeds_prediction, positionAndSpeeds_testing);
corr_xpos = corr2(positionAndSpeeds_prediction(:,1), positionAndSpeeds_testing(:,1));
corr_ypos = corr2(positionAndSpeeds_prediction(:,2), positionAndSpeeds_testing(:,2));
corr_xvel = corr2(positionAndSpeeds_prediction(:,3), positionAndSpeeds_testing(:,3));
corr_yvel = corr2(positionAndSpeeds_prediction(:,4), positionAndSpeeds_testing(:,4));

mse = immse(positionAndSpeeds_prediction, positionAndSpeeds_testing);
mse_xpos = immse(positionAndSpeeds_prediction(:,1), positionAndSpeeds_testing(:,1));
mse_ypos = immse(positionAndSpeeds_prediction(:,2), positionAndSpeeds_testing(:,2));
mse_xvel = immse(positionAndSpeeds_prediction(:,3), positionAndSpeeds_testing(:,3));
mse_yvel = immse(positionAndSpeeds_prediction(:,4), positionAndSpeeds_testing(:,4));

