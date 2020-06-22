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


% we  loop through each .csv file

vec_x_left = [];
vec_x_right = [];
vec_y_left = [];
vec_y_right = [];

for ifile = 1:nfiles

	% reads the current csv file
	mat_to_read = readtable(csv_files(ifile).name);
	current_array = table2array(mat_to_read);
		
	for elt = 2:size(current_array, 1)
	
		if current_array(elt - 1, 4) < 225
		
			vec_x_left(length(vec_x_left) + 1) = current_array(elt, 4);
			
			if current_array(elt, 3) == 76
				vec_y_left(length(vec_y_left) + 1) = 0;
			else
				vec_y_left(length(vec_y_left) + 1) = 1;
			end
			
		elseif current_array(elt - 1, 4) > 225
		
			vec_x_right(length(vec_x_right) + 1) = current_array(elt, 4);
			
			if current_array(elt, 3) == 76;
				vec_y_right(length(vec_y_right) + 1) = 0;
			else
				vec_y_right(length(vec_y_right) + 1) = 1;

			end
		end
	end
end

%scatter(vec_x, vec_y, [25], [0 0 0], 'filled')
%title('Response at time n given trial at time (n-1)')
%xlabel('Orientation of the Gabor at trial (n - 1) in degrees')
%ylabel("Subject responses at trial n (0 for left, 1 for right)")
%ylim([-0.1 1.1])
%xlim([204 246])


fixed_params=[0, 1, NaN, NaN]
sigm_fit(vec_x_right, vec_y_right, fixed_params)

hold on

fixed_params=[0, 1, NaN, NaN]
sigm_fit_b(vec_x_left, vec_y_left, fixed_params)
title('Response at time n given orientation of the trial at time (n-1)')
xlabel('Orientation of the Gabor at trial n in degrees')
ylabel("Subject responses at trial n (0 for left, 1 for right)")
ylim([-0.025 1.025])
xlim([204 246])