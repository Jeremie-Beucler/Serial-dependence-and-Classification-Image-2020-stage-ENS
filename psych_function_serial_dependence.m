%{

1) Reads csv files from the online experiment
Organisation of the results :
- 4ème colonne = orientation (test_250) par exemple
- 18ème colonne = réponse (right / left)
- 19ème colonne = RT (inclut les 500ms de prés du stimulus durant lesquelles peuvet pas répondre)

2) Make a CI bien extracting all the n-1 orientations for left and right answers at time n, and 
save it into a file.

%}

sca;
close all;
clearvars;



% creates a structure with the names of the .csv files in the current folder
csv_files = dir('./*.csv');
nfiles = length(csv_files);

% we loop through the .csv files

for ifile = 1:nfiles

	% reads the current csv file
	
	current_name = csv_files(ifile).name;
	opts = detectImportOptions(current_name);
	opts.VariableTypes{19} = 'char';
	table_to_read = readtable(current_name,opts);
	
	index_to_add = 390 * (ifile - 1);
	% corrects the trial number for the final file (if we want to create a supersubject with all the data
	% but we are not doing that at the moment
	
	
	% we put the results of each subject in a big table
	for elt = 1:size(table_to_read, 1)
		summary_mat(elt + index_to_add, 1) = table_to_read{elt, 4};
		summary_mat(elt + index_to_add, 2) = table_to_read{elt, 18};
		summary_mat(elt + index_to_add, 3) = table_to_read{elt, 19};
	end
end
	
% we replace orientations (test_250 => 250)
% and answers (right => 1; left => 0)
% so that we can analyze the data and put them in a mat (final_array)

for elt = 1:size(summary_mat, 1)
	
	old_string = (summary_mat{elt, 1});
	new_string = strrep(old_string,'test_','');
	final_array(elt, 1) = str2num(new_string);
	
	if summary_mat(elt, 2) == "right"
		summary_mat(elt, 2) = num2cell(1);
	else
		summary_mat(elt, 2) = num2cell(0);
	end
	final_array(elt, 2) = summary_mat{elt, 2};
	final_array(elt, 3) = str2num(summary_mat{elt, 3});
	
end

vec_x_left = [];
vec_x_right = [];
vec_y_left = [];
vec_y_right = [];

for elt = 2:size(final_array, 1)
	
	if final_array(elt - 1, 1) < 225
		
		vec_x_left(length(vec_x_left) + 1) = final_array(elt, 1);
		vec_y_left(length(vec_y_left) + 1) = final_array(elt, 2);
			
	elseif final_array(elt - 1, 1) > 225
		
		vec_x_right(length(vec_x_right) + 1) = final_array(elt, 1);
		vec_y_right(length(vec_y_right) + 1) = final_array(elt, 2);
	end
end

fixed_params=[0, 1, NaN, NaN];
sigm_fit(vec_x_right, vec_y_right, fixed_params)

hold on

fixed_params=[0, 1, NaN, NaN];
sigm_fit_b(vec_x_left, vec_y_left, fixed_params)
title('Response at time n given orientation of the trial at time (n-1)')
xlabel('Orientation of the Gabor at trial n in degrees')
ylabel("Subject responses at trial n (0 for left, 1 for right)")
ylim([-0.025 1.025])
xlim([204 246])
