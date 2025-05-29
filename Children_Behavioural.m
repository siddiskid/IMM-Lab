filenames = {'VML_MEG_002_Final_Results.mat','VML_MEG_003_Final_Results.mat','VML_MEG_004_Final_Results.mat','VML_MEG_006_Final_Results.mat','VML_MEG_009_Final_Results.mat','VML_MEG_010_Final_Results.mat','VML_MEG_015_Final_Results.mat','VML_MEG_016_Final_Results.mat','VML_MEG_027_Final_Results.mat','VML_MEG_028_Final_Results.mat','VML_MEG_029_Final_Results.mat'};  

S = zeros(130, 3);

for i = 1:numel(filenames)
    to_add = getfield(load(filenames{i}), 'EA');
    S(:, i) = to_add;
end

S(isnan(S)) = 0;

child_avgs = zeros(130, 1);

for i = 1:130
    child_avgs(i, 1) = mean(S(i, :));
end

plot(child_avgs)