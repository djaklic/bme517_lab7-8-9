clear
clc

% average power vals from 0.5s pre movement
% to 1.5s post movement
% 39 trials
% 27 electrode pairs
% 5 classes! k = 5
% 1 = rest
% 2 = thumb
% 3 = index
% 4 = middle
% 5 = ring/pinkie
data = load("ecogclassifydata.mat");
group = data.group;
powervals = data.powervals;

N = size(group, 1);
num_classes = 5;
Y = zeros(N, num_classes);

for i=1:N
    for j=1:num_classes
        if(group(i)==j)
            Y(i,j) = 1;
        end
    end
end

predictions_linear = zeros(N, num_classes);
%scores = zeros(N);
for i=1:num_classes
    y = Y(:,i);
    SVMmodel_linear = fitcsvm(powervals, y, 'KernelFunction', 'linear', 'Leaveout', 'on');
    [predictions_linear(:,i), scores] = kfoldPredict(SVMmodel_linear);
end
[percCorrect_linear, percCorrect_linear_total] = evaluateSVM(predictions_linear, Y, num_classes, N);

predictions_rbf = zeros(N, num_classes);
for i=1:num_classes
    y = Y(:,i);
    SVMmodel_rbf = fitcsvm(powervals, y, 'KernelFunction', 'rbf', 'Leaveout', 'on');
    predictions_rbf(:,i) = kfoldPredict(SVMmodel_rbf);
end
[percCorrect_rbf, percCorrect_rbf_total] = evaluateSVM(predictions_rbf, Y, num_classes, N);

predictions_poly = zeros(N, num_classes);
for i=1:num_classes
    y = Y(:,i);
    SVMmodel_poly = fitcsvm(powervals, y, 'KernelFunction', 'polynomial', 'Leaveout', 'on');
    predictions_poly(:,i) = kfoldPredict(SVMmodel_poly);
end
[percCorrect_poly, percCorrect_total] = evaluateSVM(predictions_poly, Y, num_classes, N);

%-------------------FUNCTIONS---------------------%

function [percCorrect, total_percCorrect] = evaluateSVM(predictions, Y, num_classes, N)
    eval = predictions - Y;
    percCorrect = zeros(num_classes,1);
    total_incorrect = 0;
    for i=1:num_classes
        incorrect = sum(abs(eval(:,i)));
        percCorrect(i) = (N-incorrect)/N;
        total_incorrect = total_incorrect + incorrect;
    end
    total_N = num_classes*N;
    total_percCorrect = (total_N-total_incorrect)/total_N;
end