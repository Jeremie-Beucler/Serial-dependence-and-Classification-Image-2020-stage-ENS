close all;
clearvars;
sca;

prompt = 'Enter the subject number : ';
subject_number = input(prompt);
subject_number = num2str(subject_number);

% setting the screen used to display the stimulus
prepScreen;
global scr;
scr.main;
KbName('UnifyKeyNames');
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
gabortex = CreateProceduralGabor(scr.main, width_gab, heigth_gab,...
nonSymmetric, backgroundOffset, disableNorm, preContrastMultiplier);


% we define the orientation of the gabor 
%(integers ranging from 245° to 205°)
% and then shuffle the trials
orientation_tot = [(base_orientation - 20):(base_orientation + 20)];
nb_trials = size(orientation_tot, 2); % nb of trials in the vector
nb_rounds = 3; % each round consists in 41 trials


% define the keyboard keys for the answer (left/right)
% and for the exit/escape
escapeKey = KbName('ESCAPE');
leftKey = KbName('LeftArrow');
rightKey = KbName('RightArrow');

% setting up the fixation cross
% by defining the size of the arms of our fixation cross
fixCrossDimPix = 25;
% we set the coordinates (relative to zero we will let
% the drawing routine center the cross in the center of our monitor)
Cross_Coords = [-fixCrossDimPix fixCrossDimPix 0 0; 0 0 -fixCrossDimPix fixCrossDimPix];
% we set the line width for our fixation cross
lineWidthPix = 2.5;



% INSTRUCTION PART WITH TWO EXAMPLES (LEFT/RIGHT)

Screen('Preference','TextEncodingLocale','UTF-8');
Screen('Preference','TextRenderer', 1);

Screen('TextSize', scr.main, 25);
DrawFormattedText(scr.main, 'Vous allez devoir discriminer l''orientation de barres par rapport à  une orientation de base que vous allez \n \n devoir mémoriser. À chaque essai, après la présentation d''une croix de fixation, vous devrez indiquer si \n \n les barres présentées se trouvent à droite ou à gauche de cette orientation de base en appuyant sur la \n \n                                                flèche gauche ou la flèche droite de votre clavier.',...
'centerblock', 'center', [255 255 255]);
DrawFormattedText(scr.main, '[Appuyez sur une touche pour continuer]', 'center', screenYpixels * 0.7, [255 255 255]);
Screen(scr.main,'Flip');
KbStrokeWait;

DrawFormattedText(scr.main, 'Les barres seront présentées à des orientations diverses, de façon brève. \n \n Vous devez essayer de répondre du mieux que vous pouvez même lorsque vous n''êtes pas sûr de vous.',...
'center', 'center', [255 255 255]);
DrawFormattedText(scr.main, '[Appuyez sur une touche pour continuer]', 'center', screenYpixels * 0.7, [255 255 255]);
Screen(scr.main,'Flip');
KbStrokeWait;

% exemple orientation de base (1/2)
DrawFormattedText(scr.main, 'Vous allez maintenant voir l''orientation de base selon laquelle vous devrez évaluer \n \n l''orientation des autres barres. Veuillez la regarder attentivement pour la mémoriser.',...
'centerblock', 'center', [255 255 255]);
DrawFormattedText(scr.main, '[Appuyez sur une touche pour continuer]', 'center', screenYpixels * 0.7, [255 255 255]);
Screen(scr.main,'Flip');
KbStrokeWait;

% drawing the stimulus and flipping it to the Screen
Screen('DrawTexture', scr.main, gabortex, [],...
[], base_orientation, [], [], [],...
[], kPsychDontDoRotation, [phase, freq,...
sigma, contrast, aspectRatio, 0, 0, 0]);
Screen('TextSize', scr.main, 20);
DrawFormattedText(scr.main, '[Appuyez sur une touche pour continuer]', 'center', screenYpixels * 0.8, [255 255 255]);
Screen(scr.main,'Flip');
KbStrokeWait;

% exemple essai gauche
Screen('TextSize', scr.main, 25);
DrawFormattedText(scr.main, 'Vous allez maintenant voir un exemple d''essai pour lequel il vous faudrait appuyer sur \n \n                                       la flèche GAUCHE de votre clavier.',...
'centerblock', 'center', [255 255 255]);
DrawFormattedText(scr.main, '[Appuyez sur une touche pour continuer]', 'center', screenYpixels * 0.7, [255 255 255]);
Screen(scr.main,'Flip');
KbStrokeWait;

% drawing the stimulus and flipping it to the Screen
Screen('DrawTexture', scr.main, gabortex, [],...
[], (base_orientation + 20), [], [], [],...
[], kPsychDontDoRotation, [phase, freq,...
sigma, contrast, aspectRatio, 0, 0, 0]);
Screen('TextSize', scr.main, 20);
DrawFormattedText(scr.main, '[Appuyez sur la flèche GAUCHE de votre clavier pour continuer]', 'center', screenYpixels * 0.8, [255 255 255]);
Screen('Flip', scr.main);


LEFT_to_press = true;
while LEFT_to_press == true
	[~, ~, keyCode] = KbCheck;
	if keyCode(leftKey)
		LEFT_to_press = false;
	end
end

% exemple orientation de base (2/2)
Screen('TextSize', scr.main, 25);
DrawFormattedText(scr.main, 'Vous allez voir une seconde fois l''orientation de base à mémoriser selon laquelle vous devrez \n \n                                          évaluer l''orientation des autres barres.',...
'centerblock', 'center', [255 255 255]);
DrawFormattedText(scr.main, '[Appuyez sur une touche pour continuer]', 'center', screenYpixels * 0.7, [255 255 255]);
Screen(scr.main,'Flip');
KbStrokeWait;

% drawing the stimulus and flipping it to the Screen
Screen('DrawTexture', scr.main, gabortex, [],...
[], base_orientation, [], [], [],...
[], kPsychDontDoRotation, [phase, freq,...
sigma, contrast, aspectRatio, 0, 0, 0]);
Screen('TextSize', scr.main, 20);
DrawFormattedText(scr.main, '[Appuyez sur une touche pour continuer]', 'center', screenYpixels * 0.8, [255 255 255]);
Screen(scr.main,'Flip');
KbStrokeWait;

% exemple essai droite
Screen('TextSize', scr.main, 25);
DrawFormattedText(scr.main, 'Vous allez maintenant voir un exemple d''essai pour lequel il vous faut appuyer sur \n \n                                     la flèche DROITE de votre clavier.',...
'centerblock', 'center', [255 255 255]);
DrawFormattedText(scr.main, '[Appuyez sur une touche pour continuer]', 'center', screenYpixels * 0.7, [255 255 255]);
Screen(scr.main,'Flip');
KbStrokeWait;

%drawing the stimulus and flipping it to the Screen
Screen('DrawTexture', scr.main, gabortex, [],...
[], (base_orientation - 20), [], [], [],...
[], kPsychDontDoRotation, [phase, freq,...
sigma, contrast, aspectRatio, 0, 0, 0]);
Screen('TextSize', scr.main, 20);
DrawFormattedText(scr.main, '[Appuyez sur la flèche DROITE de votre clavier pour continuer]', 'center', screenYpixels * 0.8, [255 255 255]);
Screen('Flip', scr.main);

RIGHT_to_press = true;
while RIGHT_to_press == true
	[~, ~, keyCode] = KbCheck;
	if keyCode(rightKey)
		RIGHT_to_press = false;
	end
end	

% dernières consignes
Screen('TextSize', scr.main, 25);
DrawFormattedText(scr.main, 'L''expérience peut commencer. Veuillez placer vos doigts sur les flèches droite et gauche du clavier.',...
'center', 'center', [255 255 255]);
DrawFormattedText(scr.main, '[Appuyez sur une touche pour continuer]', 'center', screenYpixels * 0.7, [255 255 255]);
Screen(scr.main,'Flip');
KbStrokeWait;

%loops through all the rounds (1 round = 41 trials)
for a_round = 0:(nb_rounds - 1)

	trials_shuffled = Shuffle(orientation_tot); % 1 x 41 trials vector shuffled in each round
	
	
		
	% loops through the 41 shuffled trials
	for trial = 1:nb_trials
	
	% codes for a break at the 61th trial
		if a_round == 1
			if trial == 20
				DrawFormattedText(scr.main, 'PAUSE \n \n Vous pourrez reprendre l''expérience dès que vous serez prêts.',...
				'center', 'center', [255 255 255]);
				DrawFormattedText(scr.main, '[Appuyez sur une touche pour continuer]', 'center', screenYpixels * 0.7, [255 255 255]);
				Screen(scr.main,'Flip');
				WaitSecs(2);
				KbStrokeWait;
			end
		end		
		
		% fixation cross puis 500ms puis stimulus
		Screen('DrawLines', scr.main, Cross_Coords,lineWidthPix, [255 255 255], [screenXpixels/2 screenYpixels/2]);
		Screen('Flip', scr.main);
		WaitSecs(1);
			
		orientation_gabor = trials_shuffled(1, trial);
	
		%defines the type of trial
		if trials_shuffled(1, trial) > base_orientation
			% 99 for left
			type_trial = 99
		elseif trials_shuffled(1, trial) < base_orientation
			% 101 for right
			type_trial = 101
		else
			% 100 for base_orientation (= 225°)
			type_trial = 100
		end
	
		%drawing the stimulus
		Screen('DrawTexture', scr.main, gabortex, [],...
		[], orientation_gabor, [], [], [],...
		[], kPsychDontDoRotation, [phase, freq,...
		sigma, contrast, aspectRatio, 0, 0, 0]);

		%flips to the screen
		Screen('Flip', scr.main);
		
		% presentation of 250ms
		WaitSecs(0.25);
		
		% then a grey screen
		Screen('Flip', scr.main);
		
	
		%loops until an answer is given
		resp_to_be_made = true;
		while resp_to_be_made == true	
	
			%checking the keyboard
			[~, ~, keyCode] = KbCheck;
	
			if keyCode(escapeKey)
				ShowCursor;
				sca;
				return
		
			elseif keyCode(leftKey)
				resp = 'L'; % for left
				resp_to_be_made = false;
				
			elseif keyCode(rightKey)
				resp = 'R'; % for right
				resp_to_be_made = false;
			end
		
		end
	
		%save the answer of the subject for the trial in the data matrix
	
		resp_mat((trial + a_round * nb_trials), 1) = (trial + a_round * nb_trials); % num of trial
		resp_mat((trial + a_round * nb_trials), 2) = type_trial; % 99 left, 101 right, 100 base_orientation
		resp_mat((trial + a_round * nb_trials), 3) = resp; % the key pressed by the subject 
															% (L/R => converted to 76 for L and 82 for R)
		resp_mat((trial + a_round * nb_trials), 4) = - orientation_gabor; % orientation of the gabor (anchor = 225)
	
	end
end

% consignes fin expérience
DrawFormattedText(scr.main, 'Merci pour votre participation.',...
'center', 'center', [255 255 255]);
DrawFormattedText(scr.main, '[Appuyez sur une touche pour continuer]', 'center', screenYpixels * 0.7, [255 255 255]);
Screen(scr.main,'Flip');
KbStrokeWait;
sca;

% save the data (trial number, left/right/base orientation, answer 
% and orientation of the gabor into a csv file
name_file = sprintf('results_%s.mat', subject_number);
csvwrite(name_file, resp_mat);
