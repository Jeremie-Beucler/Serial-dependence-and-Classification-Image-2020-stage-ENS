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
	
	% index_to_add = 390 * (ifile - 1);
	% corrects the trial number for the final file (if we want to create a supersubject with all the data
	% but we are not doing that at the moment
	
	
	% we put the results of each subject in a big table
	for elt = 1:size(table_to_read, 1)
		summary_mat(elt, 1) = table_to_read{elt, 4};
		summary_mat(elt, 2) = table_to_read{elt, 18};
		summary_mat(elt, 3) = table_to_read{elt, 19};
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
	
	% we create two vectors with the n-1 orientations
	% for all the resp left, and for all the resp right

	vec_resp_left = [];
	vec_resp_right = [];

	for elt = 2:size(final_array, 1)
	
		if final_array(elt, 2) == 1
			vec_resp_right(length(vec_resp_right) + 1) = -final_array(elt - 1, 1);
		else
			vec_resp_left(length(vec_resp_left) + 1) = -final_array(elt - 1, 1);
		end
	end
	
	% setting the screen used to display the stimulus
	prepScreen;
	global scr;
	
	[screenXpixels, screenYpixels] = Screen('WindowSize', scr.main);

	% setting the parameters of the Gabor
	width_gab = 225;
	heigth_gab = 450;
	sigma = width_gab / 7; %sigma of the gaussian in pixels

	base_orientation = -225; %because we do not want the gabor to be cardinal
	contrast = 0.9;
	aspectRatio = 1.0;
	phase = 0;
	numCycles = 6;
	freq = numCycles / width_gab; %pour simplifier: nombre de barres; si 0: tache blanche
	nonSymmetric = 1; %for an ovale shap

	backgroundOffset = [0.75 0.75 0.75 0.75]; %to match the light-grey background
	disableNorm = 1;
	preContrastMultiplier = 0.5;

	% creating the texture
	gaborid = CreateProceduralGabor(scr.main, width_gab, heigth_gab,...
	nonSymmetric, backgroundOffset, disableNorm, preContrastMultiplier);

	% position of the Gabor (A CHANGER POUR ADAPTER AUX AUTRES ECRANS)
	%pos_rec = [570  260  795  495];
	
	left = screenXpixels / 2 - 150;
	up = screenYpixels / 2 - 150;
	right = screenXpixels / 2 + 150;
	down = screenYpixels / 2 + 150;
	
	
	pos_rec = [left up right down];
	
	% cells where we store the matrices of pixels
	Image_Array_Left = {};

	% we get all the gabors
	for elt = 1:1:length(vec_resp_left)

		Screen('DrawTexture', scr.main, gaborid, [],...
		[], vec_resp_left(elt), [], [], [],...
		[], kPsychDontDoRotation, [phase, freq,...
		sigma, contrast, aspectRatio, 0, 0, 0]);
			
		Image_Array_Left{1, elt} = Screen('GetImage', scr.main, pos_rec, 'drawBuffer', [], []);
	
	end
	
	% we put all the cells in a big matrix with cat and then
	% we do the mean of all the n-1 gabors for the left responses
	all_arrays_left = cat(3, Image_Array_Left{:});
	meanMatrixleft = mean(all_arrays_left, 3);
	
	% same process for the right answers
	Image_Array_Right = {};

	for elt = 1:length(vec_resp_right)

		Screen('DrawTexture', scr.main, gaborid, [],...
		[], vec_resp_right(elt), [], [], [],...
		[], kPsychDontDoRotation, [phase, freq,...
		sigma, contrast, aspectRatio, 0, 0, 0]);
			
		Image_Array_Right{1, elt} = Screen('GetImage', scr.main, pos_rec, 'drawBuffer', [], []);
	
	end

	all_arrays_right = cat(3, Image_Array_Right{:});
	meanMatrixright = mean(all_arrays_right, 3);

	% we compute the classification images and save them
	% as a jpg file for each subject
	class_image_left = meanMatrixleft - meanMatrixright;
	class_image_right = meanMatrixright - meanMatrixleft;
	
	shorter_name = current_name((length(current_name) - 7) : (length(current_name) - 4));
	
	
	% before saving the CI, we save the image of the two matrices (mean for left answers, and mean for right answers).
	name_left_mean = sprintf('%s_mean_left.jpg', shorter_name);
	name_right_mean = sprintf('%s_mean_right.jpg', shorter_name);
	imwrite(uint8(meanMatrixleft), name_left_mean)
	imwrite(uint8(meanMatrixright), name_right_mean)
	
	name_left_CI = sprintf('%s_CI_left.jpg', shorter_name);
	name_right_CI = sprintf('%s_CI_right.jpg', shorter_name);
	imwrite(class_image_left, name_left_CI)
	imwrite(class_image_right, name_right_CI)
	
	% we then continue to the next subject
	clearvars -except csv_files nfiles

end

sca