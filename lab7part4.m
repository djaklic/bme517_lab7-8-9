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

SVMmodel_oneVsAll = fitcecoc(powervals, group, 'Leaveout', 'on', 'Coding', 'onevsall');
[predictions_oneVsAll, scores_oneVsAll] = kfoldPredict(SVMmodel_oneVsAll);
createConfusionChart(group, predictions_oneVsAll, 'onevsall');
SVMmodel_oneVsAll_overallcorrect = 27/39;

SVMmodel_oneVsOne = fitcecoc(powervals, group, 'Leaveout', 'on', 'Coding', 'onevsone');
[predictions_oneVsOne, scores_oneVsOne] = kfoldPredict(SVMmodel_oneVsOne);
createConfusionChart(group, predictions_oneVsOne, 'onevsone');
SVMmodel_oneVsOne_overallcorrect = 31/39;

SVMmodel_ternary = fitcecoc(powervals, group, 'Leaveout', 'on', 'Coding', 'ternarycomplete');
[predictions_ternary, scores_ternary] = kfoldPredict(SVMmodel_ternary);
createConfusionChart(group, predictions_ternary, 'ternarycomplete');
SVMmodel_ternary_overallcorrect = 31/39;

SVMmodel_ordinal = fitcecoc(powervals, group, 'Leaveout', 'on', 'Coding', 'ordinal');
[predictions_ordinal, scores_ordinal] = kfoldPredict(SVMmodel_ordinal);
createConfusionChart(group, predictions_ordinal, 'ordinal');
SVMmodel_ordinal_overallcorrect = 31/39;

%remember to create confusion matrices for each method
%report classification accuracy

%-----------FUNCTIONS-----------%
function [] = createConfusionChart(real, predicted, title)
    f = figure;
    c = confusionmat(real, predicted);
    c_chart = confusionchart(c);
    c_chart.RowSummary = 'row-normalized';
    c_chart.Title = title;
    saveas_ = '../figures/lab7part4_';
    savefig(append(saveas_, title, '.fig'))
    saveas(f, append(saveas_, title, '.jpg'))
end