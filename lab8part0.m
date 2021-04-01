clear
clc

data = load("contdata95.mat");
positionAndSpeeds = data.X;
firingrates = data.Y;

samples = size(firingrates,1);
additional_features = 10;
features = [];
features = [features ones(samples, 1)];
for i=1:size(firingrates,2)
    disp(i)
    this_neuron = firingrates(:,i);
    features = [features this_neuron];
    for j=1:additional_features-1
        this_neuron_shifted = circshift(this_neuron,j);
       features = [features this_neuron_shifted];
    end
end

samples_half = ceil(samples/2);
firingrates_training = features(1:samples_half,:);
firingrates_testing = features(samples_half+1:end,:);
positionAndSpeeds_training = positionAndSpeeds(1:samples_half,:);
positionAndSpeeds_testing = positionAndSpeeds(samples_half+1:end,:);

save('firingrates_training.mat', 'firingrates_training');
save('firingrates_testing.mat', 'firingrates_testing');
save('positionAndSpeeds_training.mat', 'positionAndSpeeds_training');
save('positionAndSpeeds_testing.mat', 'positionAndSpeeds_testing');