close all;
clearvars;

%{

This program reads .csv files originated from the experiment_serial_dependence file;

For now, the .csv files are organized as follows (each hyphen represents a column in the .csv file):

- number of the trial
- orientation at trial n (99 left, 100 base, 101 right)
- response at trial n (76 left, 82 right)
- orientation of the gabor at trial n in degrees

%}

% creates a structure with the names of the .csv files in the current folder
csv_files = dir('./*.csv');
nfiles = length(csv_files);

% we loop through the .csv files

for ifile = 1:nfiles

	% reads the current csv file
	mat_to_read = readtable(csv_files(ifile).name);
	
	% corrects the trial number for the final file
	index_to_add = 123 * (ifile - 1);
	
	for elt = 1:size(mat_to_read, 1)
		summary_mat(elt + index_to_add, 1) = mat_to_read(elt, 1);
		summary_mat(elt + index_to_add, 2) = mat_to_read(elt, 2);
		summary_mat(elt + index_to_add, 3) = mat_to_read(elt, 3);
		summary_mat(elt + index_to_add, 4) = mat_to_read(elt, 4);
	end
end

% converts the table to an array to perform operations on it (statistics...)

summary_array = table2array(summary_mat);


% we can begin at the first trial because here we do not look at the n - 1 trial
for elt = 1:size(summary_array, 1)
	% we put the orientation in a vector
	vec_x(elt) = summary_array(elt, 4);
	% we put the response of the subject in another vector
	if summary_array(elt, 3) == 76
		vec_y(elt) = 0;
	else
		vec_y(elt) = 1;
	end
end


%scatter( vec_x, vec_y, [25], [0 0 0], 'filled')
%title('Response at time n given the orientation of the Gabor at trial n')
%xlabel('Orientation of the Gabor at trial n in degrees')
%ylabel('Subject responses (0 for left, 1 for right)')
%ylim([-0.1 1.1])
%xlim([204 246])

fixed_params=[0, 1, NaN , NaN]
sigm_fit(vec_x, vec_y, fixed_params)
title('Response at time n given trial at time n)')
xlabel('Orientation of the Gabor at trial n in degrees')
ylabel("Subject responses at trial n (0 for left, 1 for right)")
ylim([-0.025 1.025])
xlim([204 246])
