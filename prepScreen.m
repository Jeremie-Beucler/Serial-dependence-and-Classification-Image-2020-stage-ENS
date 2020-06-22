function prepScreen
Screen('Preference', 'SkipSyncTests', 1);
global scr

HideCursor;

scr.subDist = 57;   % subject distance (cm)
scr.colDept = 16;
scr.refRate = 59;
scr.xres    = 1366;
scr.yres    = 768;
scr.width   = 295; % mm
scr.height  = 165;

% If there are multiple displays guess that one without the menu bar is the
% best choice.  Dislay 0 has the menu bar.
scr.allScreens = Screen('Screens');
scr.expScreen  = max(scr.allScreens);

% Open a window.  Note the new argument to OpenWindow with value 2,
% specifying the number of buffers to the onscreen window.
%half = [0 0 scr.xres/2 scr.yres/2];
%bottom = [0 0 scr.xres scr.yres-200];
%[scr.main,scr.rect] = Screen(scr.expScreen,'OpenWindow',[0 0 0],[half],scr.colDept,2);
[scr.main,scr.rect] = Screen('OpenWindow',scr.expScreen,[191 191 191],[0 0 scr.xres scr.yres],[],[],[],[],[],[],[]);

% change frame rate to scr.refRate (mode = 2 allows for rate change)
Screen('FrameRate', scr.main, 2, scr.refRate);

% get information about  screen
%[scr.width, scr.height] = Screen('DisplaySize', scr.expScreen,scr.width, scr.height); % heigth and width of screen [mm]
[scr.xres, scr.yres]    = Screen('WindowSize', scr.main);       % heigth and width of screen [pix]

scr.hz = Screen('FrameRate',scr.main);  % frame rate [Hz]

fprintf(1,'\n\nFrame rate is %.2f Hz.\n\n',scr.hz);

scr.fd   = 1000/scr.hz;                 % frame duration [ms]
scr.hash = scr.fd/2000;                 % hash time [ms]

% determine the main window's center
[scr.centerX, scr.centerY] = WindowCenter(scr.main);



% Give the display a moment to recover from the change of display mode when
% opening a window. It takes some monitors and LCD scan converters a few seconds to resync.
%WaitSecs(2);
