clear
clc

% Neurons | trials | reachDirections
%    95   |   182  |      8
%     1   |    2   |      3      <-- dimensions
% 182 trials for each neuron-direction	combination
% divide trials in half

data = load("firingrate.mat");
firing_rate = data.firingrate;
half = ceil(size(firing_rate,2)/2);
training_data = firing_rate(:,1:half,:);
testing_data = firing_rate(:,half+1:end,:);

% neuron 1, first 2 reach directions
figure;
hold on
for i=1:2 %size(data_for_training,3)
    plot(training_data(1,:,i))
end
hold off

lambda = squeeze(mean(training_data, 2));
[accuracy, real, predicted] = my_NaiveBayes(testing_data, training_data, lambda);
% 0.9739

%create fabricated dataset
%classifier should fail badly
x = size(testing_data, 1);
y = size(testing_data, 2);
z = size(testing_data, 3);
mean_firingrates_all = mean(firing_rate,'all');
spoof_firingrates_testing = poissrnd(mean_firingrates_all, x, y, z);
spoof_firingrates_training = poissrnd(mean_firingrates_all, x, y, z);

lambda2 = squeeze(mean(spoof_firingrates_training, 2));
accuracy2 = my_NaiveBayes(spoof_firingrates_testing, spoof_firingrates_training, lambda2);
% 0.1264

%---------------FUNCTIONS-----------------%

function [accuracy real_answer, predicted_answer] = my_NaiveBayes(testing_data, training_data, lambda)
    real_answer = [];
    predicted_answer = [];
    num_neurons = size(testing_data,1);
    num_trials = size(testing_data,2);
    num_directions = size(testing_data,3);
    num_predictions = num_trials*num_directions;

    for i=1:num_trials
        disp(i)
        for j=1:num_directions
            y_feature = testing_data(:,i,j);
            real_answer = [real_answer j];
            %loop through 8 probabliities again
            prob_density = zeros(num_directions,1);
            for k=1:num_directions    
                for z=1:num_neurons
                    prob_density(k) = prob_density(k) + log(poisspdf(y_feature(z), lambda(z,k)));
                end
            end
            max_prob = max(prob_density);
            class = find(prob_density==max_prob);
            predicted_answer = [predicted_answer class];
        end
    end
    disp(accuracy)
end