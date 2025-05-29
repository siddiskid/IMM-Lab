filenames = {'VML_MEG_011_Final_Results.mat','VML_MEG_012_2_Final_Results.mat','VML_MEG_013_Final_Results.mat','VML_MEG_014_Final_Results.mat','VML_MEG_018_Final_Results.mat','VML_MEG_019_Final_Results.mat','VML_MEG_021_Final_Results.mat','VML_MEG_022_Final_Results.mat','VML_MEG_025_Final_Results.mat','VML_MEG_026_Final_Results.mat','VML_MEG_030_Final_Results.mat','VML_MEG_031_Final_Results.mat'};  

S = zeros(130, 3);

for i = 1:numel(filenames)
    to_add = getfield(load(filenames{i}), 'EA');
    S(:, i) = to_add;
end

S(isnan(S)) = 0;

adult_avgs = zeros(130, 1);

for i = 1:130
    adult_avgs(i, 1) = mean(S(i, :));
end

plot(adult_avgs)