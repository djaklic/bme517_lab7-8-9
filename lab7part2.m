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

my_size = size(group,1);
testClass = zeros(my_size,1);
results = zeros(my_size,3);
for i=1:size(group,1)
    group_test = group(i,:);
    group_training = [group(1:i-1,:); group(i+1:end,:)];
    powervals_test = powervals(i,:);
    powervals_training = [powervals(1:i-1,:); powervals(i+1:end,:)];

    testClass(i) = classify(powervals_test, powervals_training, group_training, 'linear');
    results(i,1) = group_test;
    results(i,2) = testClass(i);
    x=0;
    if(group_test==testClass(i));x=1;else;x=0;end
    results(i,3) = x;
end

accuracy = sum(results(:,3));
accuracy = accuracy/my_size;
%should have accuracy of about 72%

%part 6 - create confusion matrix
c = confusionmat(results(:,1), results(:,2));
f = figure;
c_chart = confusionchart(c);
c_chart.RowSummary = 'row-normalized';
saveas_ = '../figures/lab7part2_CM';
savefig(append(saveas_, '.fig'))
saveas(f, append(saveas_, '.jpg'))


