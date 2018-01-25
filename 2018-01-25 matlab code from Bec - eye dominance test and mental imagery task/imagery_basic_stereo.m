%Program written by Aaron Chang on Dec, 2013 ALTERED BY RK May 2017.
clear all
KbName('UnifyKeyNames');

%SAVE
    save_data=1; % 1=yes; 0=no
    if(save_data==1)
        [subName scanNum theDate]=GetUserInfo;
    end
    
save_directory= 'C:\Users\Desktop\experiment';  %%NEED TO RENAME THIS FOR WHERE/WHAT FOLDER YOU WANT YOUR DATA TO GO

% % GENERAL VARIABLES
hoz_con = .45; %%Contrast of horizontal Grating
vert_con = .65; %Contrast of vertical Grating
GreenFactor = .55; %%Luminace of green image

numSecs = 6; %%Imagery time

BG_LUM = 0; %CHANGES Background lumiance 0 = Black Background, 1 = Yellow Background
trials = 40; %Number of trials %%MUST BE DIVISIBLE BY 40

%X Position of Dual Elements
v1=3;
v2=1.5;

%Bulls Eye Radius
re=6;
ri=4;

%Bullseye Color
bullsEyeColorExt = 255/2;
bullsEyeColorInt = 0;

%Background luminance ramping variables
stepS=1; 
ramp_lin=1:stepS:100; 
ramp_lin=ramp_lin/100; 

%Draw gaussian blob
gaussiansize=200;
X = 1:gaussiansize;
X0 = (X / gaussiansize) - .5;
[Xm Ym] = meshgrid(X0, X0);

%Set up the screen
screen_number=max(Screen('Screens'));
white=WhiteIndex(screen_number);
black=BlackIndex(screen_number);
gray=(white-black)/2;
background_color = black;
[window screenSize]= Screen('OpenWindow', screen_number, background_color);
[width, height]=Screen('WindowSize', window);
HideCursor;

%%imagery_time = 6
ifi = Screen('GetFlipInterval', window);
imagery_time = round(numSecs/ ifi);
%%cue_time = 1
numSecs2 = 1;
ici = round(numSecs2/ ifi); 
%%BR time = 750ms
numSecs3 = .750;
BR_time = round(numSecs3/ ifi);
waitframes = 1; % Numer of frames to wait when specifying good timing. 
topPriorityLevel = MaxPriority(window);
%%Lum_time
numSecs4 = 3.6;
imagery_time_lum = round(numSecs4/ ifi);

% key names
escapeKey = KbName('ESCAPE');
oneKey = KbName('1');
twoKey = KbName('2');
threeKey = KbName('3');
one1Key = KbName('1!');
two2Key = KbName('2@');
three3Key = KbName('3#');

%==============================
%Psychtoolbox init & screen values
%==============================

% Open onscreen window:

% Coordinates of the centre of the screen
centreX=screenSize(3)/2;
centreY=screenSize(4)/2;

shCenter = (screenSize (3) - screenSize (1))/2;
svCenter = (screenSize (4) - screenSize (2))/2;

frameColor = 255/2;
frameSize = 120;
imageSize = 0.275; %0 - 1
fontsize = 18;
fontsize2 = 30;
Screen('TextSize', window, fontsize);
Screen('TextSize', window, fontsize2);

%Keyboard Settings
imageryprimed = 0;
nonimageryprimed = 0;
catchnumber = 0;
key1='1'; %The key to press for green dominance
mixkey='2'; %The key to press for mixed percepts
key2='3'; %The key to press for red dominance

%Pattern Creation 
% *** To lengthen the period of the grating, increase pixelsPerPeriod.

freq=7;
waitFrames=1; % this is for the BR ramps. 
colorR = [1 0 0]; %RED PATTERN
colorG = [0 1 0]; %GREEN PATTERN
colorG = colorG*GreenFactor;
colorR = colorR;

pixelsPerPeriod = 33; % How many pixels will each period/cycle occupy?
spatialFrequency = .75 / pixelsPerPeriod; % How many periods/cycles are there in a pixel?
radiansPerPixel = spatialFrequency * (2 * pi); % = (periods per pixel) * (2 pi radians per period)
periodsCoveredByOneStandardDeviation = 1.5;
gaussianSpaceConstant = periodsCoveredByOneStandardDeviation  * pixelsPerPeriod;
% *** If the grating is clipped on the sides, increase widthOfGrid.
widthOfGrid = 500;

halfWidthOfGrid = widthOfGrid / 2;

widthArray = (-halfWidthOfGrid) : halfWidthOfGrid;  % widthArray is used in creating the meshgrid.

[x y] = meshgrid(widthArray, widthArray);

 % cardinals
 grat_angle1=pi/2; % left. 
 grat_angle2=2*pi ;
 
 deg45_angle = 3.9270;
  
 % circularGaussianMaskMatrix = exp(-((x .^ 2) + (y .^ 2)) / (gaussianSpaceConstant ^ 2.3));%2.3 
  
 %%%%%%%%%% 
  gratingMatrix1 =(sin(freq*2*pi/halfWidthOfGrid*(x.*sin(grat_angle1)+y.*cos(grat_angle1))-0));
  gratingMatrix2 =(sin(freq*2*pi/halfWidthOfGrid*(x.*sin(grat_angle2)+y.*cos(grat_angle2))-0));
  
  gratingMatrix1= ((gratingMatrix1*vert_con)*127)+(127); 
  gratingMatrix2=((gratingMatrix2*hoz_con)*127)+(127); 
  
  circularGaussianMaskMatrix = exp(-((x .^ 2) + (y .^ 2)) / (gaussianSpaceConstant ^ 2.3));%2.3
  imageMatrixG = gratingMatrix1 .* circularGaussianMaskMatrix;
  imageMatrixR = gratingMatrix2 .* circularGaussianMaskMatrix;


% mock pattern, half red_half green:
mock_right=imageMatrixR;
mock_left=imageMatrixG;
amp=27;
    EE=smooth((smooth(amp*randn(1, widthOfGrid), 35))+250); % was 100 at the end 

% makes the appropriate sections value of 0; so the two images can be added
% together. 
EE=round(EE); 

for loop=1:widthOfGrid
    
mock_right(1:(EE(loop)), loop)=0;
mock_left((EE(loop)):widthOfGrid, loop)=0;
    
end 

%%%%%%%%%%%%

pattern1 = zeros([size(imageMatrixR) 3]);
pattern2 = zeros([size(imageMatrixR) 3]);

Mock_patternLeft = zeros([size(mock_left) 3]);
Mock_patternRight = zeros([size(mock_left) 3]);

pattern1(:,:,1)=colorR(1)*abs(imageMatrixR);
pattern1(:,:,2)=colorR(2)*abs(imageMatrixR);
pattern1(:,:,3)=colorR(3)*abs(imageMatrixR);

pattern2(:,:,1)=colorG(1)*abs(imageMatrixG);
pattern2(:,:,2)=colorG(2)*abs(imageMatrixG);
pattern2(:,:,3)=colorG(3)*abs(imageMatrixG);

Mock_patternRight(:,:,1)=colorG(1)*abs(mock_left);
Mock_patternRight(:,:,2)=colorG(2)*abs(mock_left);
Mock_patternRight(:,:,3)=colorG(3)*abs(mock_left);

Mock_patternLeft(:,:,1)=colorR(1)*abs(mock_right);
Mock_patternLeft(:,:,2)=colorR(2)*abs(mock_right);
Mock_patternLeft(:,:,3)=colorR(3)*abs(mock_right);

meanRED=(max(max(pattern1(:,:,1))))/2;
meanGREEN=(max(max(pattern2(:,:,2))))/2;

meanRED=(meanRED*BG_LUM)*1.4;
meanGREEN=(meanGREEN*BG_LUM)*1.4;

%pattern = pattern1*.5 + pattern2*.5; % + pattern1b*.5+pattern1c*.5;

pattern = pattern1 + pattern2; 

Pattern_Mock= Mock_patternRight + Mock_patternLeft; 

[Y X Z]= size(pattern);
side(1)=centreX-X/2;
side(2)=centreY-Y/2;
side(3)=centreX+X/2;
side(4)=centreY+Y/2;
patch_sizeS(1)=0;
patch_sizeS(2)=0; 
patch_sizeS(3)=X;
patch_sizeS(4)=Y;

mockBR_counter=1;

texture_red = Screen('MakeTexture', window, pattern1);
texture_green = Screen('MakeTexture', window, pattern2);
texture_BR=Screen('MakeTexture', window, pattern); %% Mocks of both images- lattice
texture_Mock=Screen('MakeTexture', window, Pattern_Mock); %%Mocks of spatial half half

% %INSTRUCTION PHASE
Screen('DrawText', window, 'The first section of the experiment will now begin. During this section', (screenSize(3)/2)-(fontsize*20), (screenSize(4)/4), [255 255 255]);
Screen('DrawText', window, 'you will be asked to imagine a GREEN or RED image', (screenSize(3)/2)-(fontsize*20), (screenSize(4)/4+25), [255 255 255]);
Screen('DrawText', window, 'Press any key to continue reading instructions.', (screenSize(3)/2)-(fontsize*10), (screenSize(4)/1.25), [255 255 255]);
Screen('Flip', window);

while 1
    [keyIsDown,timeSecs,keyCode] = KbCheck;
    if keyIsDown
        break
    end
end

WaitSecs (0.25)
% Use Mirror Setup
Screen('FrameRect', window, frameColor, [width/v1-frameSize height/2-frameSize width/v1+frameSize height/2+frameSize]);
Screen('FrameRect', window, frameColor, [width/v2-frameSize height/2-frameSize width/v2+frameSize height/2+frameSize]);
Screen('FillOval', window, bullsEyeColorExt,[width/v1-re height/2-re width/v1+re height/2+re]);
Screen('FillOval', window, bullsEyeColorExt,[width/v2-re height/2-re width/v2+re height/2+re]);
Screen('FillOval', window, bullsEyeColorInt,[width/v1-ri height/2-ri width/v1+ri height/2+ri]);
Screen('FillOval', window, bullsEyeColorInt,[width/v2-ri height/2-ri width/v2+ri height/2+ri]);
Screen('DrawText', window, 'Prepare the mirror setup and begin using it now.', (screenSize(3)/2)-(fontsize*20), (screenSize(4)/4), [255 255 255]);
Screen('DrawText', window, 'Press any key to begin the experiment.', (screenSize(3)/2)-(fontsize*8), (screenSize(4)/1.25), [255 255 255]);
Screen('Flip', window);

while 1
    [keyIsDown,timeSecs,keyCode] = KbCheck;
    if keyIsDown
        break
    end
end

Screen('FrameRect', window, frameColor, [width/v1-frameSize height/2-frameSize width/v1+frameSize height/2+frameSize]);
Screen('FrameRect', window, frameColor, [width/v2-frameSize height/2-frameSize width/v2+frameSize height/2+frameSize]);
Screen('FillOval', window, bullsEyeColorExt,[width/v1-re height/2-re width/v1+re height/2+re]);
Screen('FillOval', window, bullsEyeColorExt,[width/v2-re height/2-re width/v2+re height/2+re]);
Screen('FillOval', window, bullsEyeColorInt,[width/v1-ri height/2-ri width/v1+ri height/2+ri]);
Screen('FillOval', window, bullsEyeColorInt,[width/v2-ri height/2-ri width/v2+ri height/2+ri]);
Screen('Flip', window);
WaitSecs (0.5)

%%Parameters of experimental set up

array1 = 1:trials;
array2 = mod(array1, 40);
orient_array = Shuffle(array2) +1; %%gives shuffeld variables for experiment
condition_array = zeros (1,(length(orient_array))); %% Real or mock BR, 1 = real, 2 & 0 = mock
cue_array = zeros (1,(length(orient_array))); %%red or green cue
record_response = zeros (1,(length(orient_array))); %%responses (whether they saw red = 3, green = 1 or mixed = 2)

%% cue_array 1 = red, 2 = Green
%% condition_array 1 = realBR, 2 = MockBR, 3 = MockBR
for i = 1:(length(orient_array))
    
%%real_BR_red Left
    if orient_array(i) == 1
        
        real_fake_BR = 1;
        cue_cue = 1;             
   
        
        condition_array(i) = real_fake_BR;
        cue_array (i) = cue_cue;

       
 
%%real_BR_green   left    
    elseif orient_array(i) == 2
        
        real_fake_BR = 1;
        cue_cue = 2;
       
        
        condition_array(i) = real_fake_BR;
        cue_array (i) = cue_cue;
        
        
%%real_BR_red right
    elseif orient_array(i) == 3
        
        real_fake_BR = 1;
        cue_cue = 1;                  
       
        
        condition_array(i) = real_fake_BR;
        cue_array (i) = cue_cue;
     
        
%%real_BR_green right      
    elseif orient_array(i) == 4
        
        real_fake_BR = 1;
        cue_cue = 2;
       
               
        condition_array(i) = real_fake_BR;
        cue_array (i) = cue_cue;
     
        
        
 %%real_BR_red left 
    elseif orient_array(i) == 5
        
        real_fake_BR = 1;
        cue_cue = 1;         
     
        
        condition_array(i) = real_fake_BR;
        cue_array (i) = cue_cue;
     
        
%%real_BR_green left      
    elseif orient_array(i) == 6
        
        real_fake_BR = 1;
        cue_cue = 2;
     
        
        condition_array(i) = real_fake_BR;
        cue_array (i) = cue_cue;
     
        
%%real_BR_red right
    elseif orient_array(i) == 7
        
        real_fake_BR = 1;
        cue_cue = 1;         
       
        
        condition_array(i) = real_fake_BR;
        cue_array (i) = cue_cue;
     
        
%%real_BR_green  right     
    elseif orient_array(i) == 8
        
        real_fake_BR = 1;
        cue_cue = 2;
      
         
         
        condition_array(i) = real_fake_BR;
        cue_array (i) = cue_cue;  
     
        
 %%real_BR_red left
    elseif orient_array(i) == 9
        
        real_fake_BR = 1;
        cue_cue = 1;         
     
        
        condition_array(i) = real_fake_BR;
        cue_array (i) = cue_cue;
     
        
%%real_BR_green  left     
    elseif orient_array(i) == 10
        
        real_fake_BR = 1;
        cue_cue = 2;
      
         
        condition_array(i) = real_fake_BR;
        cue_array (i) = cue_cue;
     
        
  %% real_BR_red right
        
    elseif orient_array(i) == 11
        
        real_fake_BR = 1;
        cue_cue = 1;         
       
        
        condition_array(i) = real_fake_BR;
        cue_array (i) = cue_cue;
     
        
%%real_BR_green right       
    elseif orient_array(i) == 12
        
        real_fake_BR = 1;
        cue_cue = 2;
       
                
        condition_array(i) = real_fake_BR;
        cue_array (i) = cue_cue;
     
        
        
%%real_BR_red left
    elseif orient_array(i) == 13
        
        real_fake_BR = 1;
        cue_cue = 1;         
     
        
        condition_array(i) = real_fake_BR;
        cue_array (i) = cue_cue;
     
        
%%real_BR_green left       
    elseif orient_array(i) == 14
        
        real_fake_BR = 1;
        cue_cue = 2;
          
        
        condition_array(i) = real_fake_BR;
        cue_array (i) = cue_cue;
     
        
        
 %%real_BR_red right       
    elseif orient_array(i) == 15
        
        real_fake_BR = 1;
        cue_cue = 1;         
       
        
        condition_array(i) = real_fake_BR;
        cue_array (i) = cue_cue;
     
        
        
%%real_BR_green  right     
    elseif orient_array(i) == 16
        
        real_fake_BR = 1;
        cue_cue = 2;
       
        
        condition_array(i) = real_fake_BR;
        cue_array (i) = cue_cue;
     
        
%%real_BR_red left
    elseif orient_array(i) == 17
        
        real_fake_BR = 1;
        cue_cue = 1;         
     
        
        condition_array(i) = real_fake_BR;
        cue_array (i) = cue_cue;
     
        
%%real_BR_green   left    
    elseif orient_array(i) == 18
        
        real_fake_BR = 1;
        cue_cue = 2;
      
        
        condition_array(i) = real_fake_BR;
        cue_array (i) = cue_cue;  
     
        
 %%real_BR_red right
    elseif orient_array(i) == 19
        
        real_fake_BR = 1;
        cue_cue = 1;         
       
        
        condition_array(i) = real_fake_BR;
        cue_array (i) = cue_cue;
      
        
%%real_BR_green  right     
    elseif orient_array(i) == 20
        
        real_fake_BR = 1;
        cue_cue = 2;
       
                
        condition_array(i) = real_fake_BR;
        cue_array (i) = cue_cue;     
     
        
  %%real_BR_Red left
        
    elseif orient_array(i) == 21
        
        real_fake_BR = 1;
        cue_cue = 1;         
     
        
        condition_array(i) = real_fake_BR;
        cue_array (i) = cue_cue;
     
        
%%real_BR_green   left    
    elseif orient_array(i) == 22
        
        real_fake_BR = 1;
        cue_cue = 2;
     
                
        condition_array(i) = real_fake_BR;
        cue_array (i) = cue_cue;
     
        
%%real_BR_red right
    elseif orient_array(i) == 23
        
        real_fake_BR = 1;
        cue_cue = 1;         
       
        
        condition_array(i) = real_fake_BR;
        cue_array (i) = cue_cue;
     
        
%%real_BR_green   right    
    elseif orient_array(i) == 24
        
        real_fake_BR = 1;
        cue_cue = 2;
       
                
        condition_array(i) = real_fake_BR;
        cue_array (i) = cue_cue;
     
        
  %%real_BR_red left
        
    elseif orient_array(i) == 25
        
        real_fake_BR = 1;
        cue_cue = 1;         
     
        
        condition_array(i) = real_fake_BR;
        cue_array (i) = cue_cue;
     
        
%%real_BR_green  left
    elseif orient_array(i) == 26
        
        real_fake_BR = 1;
        cue_cue = 2;
        
        
        condition_array(i) = real_fake_BR;
        cue_array (i) = cue_cue;
     
        
%%real_BR_red right
    elseif orient_array(i) == 27
        
        real_fake_BR = 1;
        cue_cue = 1;         
       
        
        condition_array(i) = real_fake_BR;
        cue_array (i) = cue_cue;
     
        
%%real_BR_green    right   
    elseif orient_array(i) == 28
        
        real_fake_BR = 1;
        cue_cue = 2;
       
        
        condition_array(i) = real_fake_BR;
        cue_array (i) = cue_cue;  
     
        
 %%real_BR_red left
    elseif orient_array(i) == 29
        
        real_fake_BR = 1;
        cue_cue = 1;         
     
        
        condition_array(i) = real_fake_BR;
        cue_array (i) = cue_cue;
     
        
%%real_BR_green    left   
    elseif orient_array(i) == 30
        
        real_fake_BR = 1;
        cue_cue = 2;
     
          
        condition_array(i) = real_fake_BR;
        cue_array (i) = cue_cue;  
     
        
 %% real BR red right
        
    elseif orient_array(i) == 31
        
        real_fake_BR = 1;
        cue_cue = 1;         
       
        
        condition_array(i) = real_fake_BR;
        cue_array (i) = cue_cue;
     
        
%%real_BR_green     right  
    elseif orient_array(i) == 32
        
        real_fake_BR = 1;
        cue_cue = 2;
       
        
        condition_array(i) = real_fake_BR;
        cue_array (i) = cue_cue;
     
             
           
  %%mock_BR_red %%HALF HALF left
    elseif orient_array(i) == 33
        
        real_fake_BR = 0;
        cue_cue = 1;         
     
        
        condition_array(i) = real_fake_BR;
        cue_array (i) = cue_cue;
     
        
        
%%mock_BR_green %% HALF HALF     left 
    elseif orient_array(i) == 34
        
        real_fake_BR = 0;
        cue_cue = 2;
     
        
        condition_array(i) = real_fake_BR;
        cue_array (i) = cue_cue;        
     
        
    %%mock_BR_red %%HALF HALF right
    elseif orient_array(i) == 35
        
        real_fake_BR = 0;
        cue_cue = 1;         
       
        
        condition_array(i) = real_fake_BR;
        cue_array (i) = cue_cue;
     
        
        
%%mock_BR_green %% HALF HALF   right   
    elseif orient_array(i) == 36
        
        real_fake_BR = 0;
        cue_cue = 2;
       
        
        condition_array(i) = real_fake_BR;
        cue_array (i) = cue_cue;             
     
        
                  
         %%mock_BR_red %% PLAID left
    elseif orient_array(i) == 37
        
        real_fake_BR = 2;
        cue_cue = 1;         
     
        
        condition_array(i) = real_fake_BR;
        cue_array (i) = cue_cue;
     
        
        
%%mock_BR_green %% PLAID   left 
    elseif orient_array(i) == 38
        
        real_fake_BR = 2;
        cue_cue = 2;
     
        
        condition_array(i) = real_fake_BR;
        cue_array (i) = cue_cue;   
     
        
        
                 %%mock_BR_red %% PLAID right
    elseif orient_array(i) == 39
        
        real_fake_BR = 2;
        cue_cue = 1;         
       
        
        condition_array(i) = real_fake_BR;
        cue_array (i) = cue_cue;
     
        
%%mock_BR_green %% PLAID    
    elseif orient_array(i) == 40
        
        real_fake_BR = 2;
        cue_cue = 2;
       
        
        condition_array(i) = real_fake_BR;
        cue_array (i) = cue_cue;   
     
        
        
    end
end




%%%%%---------------------------EXPERIMENT LOOP---------------------------%%%%%
%%%%%---------------------------------------------------------------------%%%%%

for i=1:trials
    %PRIME: Mental Imagery Cue
    sound (sin((1:500)./3)) %%Beep 
    
    %%Sets up box and bullseye
    Screen('FrameRect', window, frameColor, [width/v1-frameSize height/2-frameSize width/v1+frameSize height/2+frameSize]);
    Screen('FrameRect', window, frameColor, [width/v2-frameSize height/2-frameSize width/v2+frameSize height/2+frameSize]);
    Screen('FillOval', window, bullsEyeColorExt,[width/v1-re height/2-re width/v1+re height/2+re]); %%Draws bullseye
    Screen('FillOval', window, bullsEyeColorExt,[width/v2-re height/2-re width/v2+re height/2+re]); %%Draws bullseye
    Screen('FillOval', window, bullsEyeColorInt,[width/v1-ri height/2-ri width/v1+ri height/2+ri]); %%Draws bullseye
    Screen('FillOval', window, bullsEyeColorInt,[width/v2-ri height/2-ri width/v2+ri height/2+ri]); %%Draws bullseye
    vbl = Screen('Flip', window);
    
    %%-------------Draws Cue--------------%%
    for frame = 1:ici - 1 
        if cue_array(i) == 1;
                    Screen('DrawText', window, ' R', (screenSize(3)/v1)-(fontsize2*0.5), (screenSize(4)/2)-(fontsize2*0.5), [255 255 255]) %%Draws R cue
                    Screen('DrawText', window, ' R', (screenSize(3)/v2)-(fontsize2*0.5), (screenSize(4)/2)-(fontsize2*0.5), [255 255 255]) %%Draws R cue
                    
                elseif cue_array(i) == 2 ;
                    Screen('DrawText', window, ' G', (screenSize(3)/v1)-(fontsize2*0.5), (screenSize(4)/2)-(fontsize2*0.5), [255 255 255]) %%Draws G cue
                    Screen('DrawText', window, ' G', (screenSize(3)/v2)-(fontsize2*0.5), (screenSize(4)/2)-(fontsize2*0.5), [255 255 255]) %%Draws G cue
                  
        end
        
    Screen('FrameRect', window, frameColor, [width/v1-frameSize height/2-frameSize width/v1+frameSize height/2+frameSize]); %%Draws box
    Screen('FrameRect', window, frameColor, [width/v2-frameSize height/2-frameSize width/v2+frameSize height/2+frameSize]); %%Draws box
    vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
    
    end
    
    %%Draws box and bullseye   
    Screen('FrameRect', window, frameColor, [width/v1-frameSize height/2-frameSize width/v1+frameSize height/2+frameSize]);
    Screen('FrameRect', window, frameColor, [width/v2-frameSize height/2-frameSize width/v2+frameSize height/2+frameSize]);
    Screen('FillOval', window, bullsEyeColorExt,[width/v1-re height/2-re width/v1+re height/2+re]); %%Draws bullseye
    Screen('FillOval', window, bullsEyeColorExt,[width/v2-re height/2-re width/v2+re height/2+re]); %%Draws bullseye
    Screen('FillOval', window, bullsEyeColorInt,[width/v1-ri height/2-ri width/v1+ri height/2+ri]); %%Draws bullseye
    Screen('FillOval', window, bullsEyeColorInt,[width/v2-ri height/2-ri width/v2+ri height/2+ri]); %%Draws bullseye
    vbl = Screen('Flip', window);
    
    %%--------Imagery_time------- %%
    
    if BG_LUM==1
    
 
      % Ramp the lum up 
            
            for lumL=1:length(ramp_lin) % ramps up over 100 frames 
                Screen('FillRect', window, [meanRED*ramp_lin(lumL) meanGREEN*ramp_lin(lumL) 0], [width/v1-frameSize height/2-frameSize width/v1+frameSize height/2+frameSize]);
                Screen('FillRect', window, [meanRED*ramp_lin(lumL) meanGREEN*ramp_lin(lumL) 0], [width/v2-frameSize height/2-frameSize width/v2+frameSize height/2+frameSize]);
                Screen('FrameRect', window, frameColor, [width/v1-frameSize height/2-frameSize width/v1+frameSize height/2+frameSize]);
                Screen('FrameRect', window, frameColor, [width/v2-frameSize height/2-frameSize width/v2+frameSize height/2+frameSize]);
                Screen('FillOval', window, bullsEyeColorExt,[width/v1-re height/2-re width/v1+re height/2+re]); %%Draws bullseye
                Screen('FillOval', window, bullsEyeColorExt,[width/v2-re height/2-re width/v2+re height/2+re]); %%Draws bullseye
                Screen('FillOval', window, bullsEyeColorInt,[width/v1-ri height/2-ri width/v1+ri height/2+ri]); %%Draws bullseye
                Screen('FillOval', window, bullsEyeColorInt,[width/v2-ri height/2-ri width/v2+ri height/2+ri]); %%Draws bullseye
                Screen('Flip', window, waitFrames);
            end 
             
                % wait at full lum
                for frame = 1:imagery_time_lum - 1  %% imagery time 6 sec
                Screen('FillRect', window, [meanRED*ramp_lin(lumL) meanGREEN*ramp_lin(lumL) 0], [width/v1-frameSize height/2-frameSize width/v1+frameSize height/2+frameSize]);
                Screen('FillRect', window, [meanRED*ramp_lin(lumL) meanGREEN*ramp_lin(lumL) 0], [width/v2-frameSize height/2-frameSize width/v2+frameSize height/2+frameSize]);
                Screen('FrameRect', window, frameColor, [width/v1-frameSize height/2-frameSize width/v1+frameSize height/2+frameSize]);
                Screen('FrameRect', window, frameColor, [width/v2-frameSize height/2-frameSize width/v2+frameSize height/2+frameSize]);
                Screen('FillOval', window, bullsEyeColorExt,[width/v1-re height/2-re width/v1+re height/2+re]); %%Draws bullseye
                Screen('FillOval', window, bullsEyeColorExt,[width/v2-re height/2-re width/v2+re height/2+re]); %%Draws bullseye
                Screen('FillOval', window, bullsEyeColorInt,[width/v1-ri height/2-ri width/v1+ri height/2+ri]); %%Draws bullseye
                Screen('FillOval', window, bullsEyeColorInt,[width/v2-ri height/2-ri width/v2+ri height/2+ri]); %%Draws bullseye
                vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
    
            end
                       
            % ramp the lum back down. 
            for lumL=1:length(ramp_lin)
                Screen('FillRect', window, [meanRED*ramp_lin(round(101-lumL)) meanGREEN*ramp_lin(round(101-lumL)) 0],[width/v1-frameSize height/2-frameSize width/v1+frameSize height/2+frameSize]);
                Screen('FillRect', window, [meanRED*ramp_lin(round(101-lumL)) meanGREEN*ramp_lin(round(101-lumL)) 0],[width/v2-frameSize height/2-frameSize width/v2+frameSize height/2+frameSize]);
                Screen('FrameRect', window, frameColor, [width/v1-frameSize height/2-frameSize width/v1+frameSize height/2+frameSize]);
                Screen('FrameRect', window, frameColor, [width/v2-frameSize height/2-frameSize width/v2+frameSize height/2+frameSize]);
                Screen('FillOval', window, bullsEyeColorExt,[width/v1-re height/2-re width/v1+re height/2+re]); %%Draws bullseye
                Screen('FillOval', window, bullsEyeColorExt,[width/v2-re height/2-re width/v2+re height/2+re]); %%Draws bullseye
                Screen('FillOval', window, bullsEyeColorInt,[width/v1-ri height/2-ri width/v1+ri height/2+ri]); %%Draws bullseye
                Screen('FillOval', window, bullsEyeColorInt,[width/v2-ri height/2-ri width/v2+ri height/2+ri]); %%Draws bullseye
                Screen('Flip', window, waitFrames);
            end 
         
    else 
        
    for frame = 1:imagery_time - 1  %% imagery time 6 sec
  
    Screen('FrameRect', window, frameColor, [width/v1-frameSize height/2-frameSize width/v1+frameSize height/2+frameSize]);
    Screen('FrameRect', window, frameColor, [width/v2-frameSize height/2-frameSize width/v2+frameSize height/2+frameSize]);
    Screen('FillOval', window, bullsEyeColorExt,[width/v1-re height/2-re width/v1+re height/2+re]); %%Draws bullseye
    Screen('FillOval', window, bullsEyeColorExt,[width/v2-re height/2-re width/v2+re height/2+re]); %%Draws bullseye
    Screen('FillOval', window, bullsEyeColorInt,[width/v1-ri height/2-ri width/v1+ri height/2+ri]); %%Draws bullseye
    Screen('FillOval', window, bullsEyeColorInt,[width/v2-ri height/2-ri width/v2+ri height/2+ri]); %%Draws bullseye
    vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
    
    end
    
    end
    %%Sets up box and bullseye
    Screen('FrameRect', window, frameColor, [width/v1-frameSize height/2-frameSize width/v1+frameSize height/2+frameSize]);
    Screen('FrameRect', window, frameColor, [width/v2-frameSize height/2-frameSize width/v2+frameSize height/2+frameSize]);
    Screen('FillOval', window, bullsEyeColorExt,[width/v1-re height/2-re width/v1+re height/2+re]); %%Draws bullseye
    Screen('FillOval', window, bullsEyeColorExt,[width/v2-re height/2-re width/v2+re height/2+re]); %%Draws bullseye
    Screen('FillOval', window, bullsEyeColorInt,[width/v1-ri height/2-ri width/v1+ri height/2+ri]); %%Draws bullseye
    Screen('FillOval', window, bullsEyeColorInt,[width/v2-ri height/2-ri width/v2+ri height/2+ri]); %%Draws bullseye
    vbl = Screen('Flip', window);
    
 
    %% ----- Draws Binoclaulr Rivalry Display ------ %%
    for frame = 1:BR_time - 1 
  
    if condition_array(i) == 1; %%Real BR
            Screen('Drawtexture', window, texture_red, [], [width/v1-gaussiansize height/2-gaussiansize width/v1+gaussiansize height/2+gaussiansize]);
            Screen('Drawtexture', window, texture_green, [], [width/v2-gaussiansize height/2-gaussiansize width/v2+gaussiansize height/2+gaussiansize]);
    elseif condition_array(i) == 0; %%Mock BR
            Screen('Drawtexture', window, texture_BR, [], [width/v1-gaussiansize height/2-gaussiansize width/v1+gaussiansize height/2+gaussiansize]);
            Screen('Drawtexture', window, texture_BR, [], [width/v2-gaussiansize height/2-gaussiansize width/v2+gaussiansize height/2+gaussiansize]);
    elseif  condition_array(i) == 2; %%Mock BR
            Screen('Drawtexture', window, texture_BR, [], [width/v1-gaussiansize height/2-gaussiansize width/v1+gaussiansize height/2+gaussiansize]);
            Screen('Drawtexture', window, texture_BR, [], [width/v2-gaussiansize height/2-gaussiansize width/v2+gaussiansize height/2+gaussiansize]);       
            
            
    end 
                Screen('FrameRect', window, frameColor, [width/v1-frameSize height/2-frameSize width/v1+frameSize height/2+frameSize]);
                Screen('FrameRect', window, frameColor, [width/v2-frameSize height/2-frameSize width/v2+frameSize height/2+frameSize]);
                Screen('FillOval', window, bullsEyeColorExt,[width/v1-re height/2-re width/v1+re height/2+re]);
                Screen('FillOval', window, bullsEyeColorExt,[width/v2-re height/2-re width/v2+re height/2+re]);
                Screen('FillOval', window, bullsEyeColorInt,[width/v1-ri height/2-ri width/v1+ri height/2+ri]);
                Screen('FillOval', window, bullsEyeColorInt,[width/v2-ri height/2-ri width/v2+ri height/2+ri]);
                vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
    
    end
                        
    
    %%Sets up box and bullseye    
    Screen('FrameRect', window, frameColor, [width/v1-frameSize height/2-frameSize width/v1+frameSize height/2+frameSize]);
    Screen('FrameRect', window, frameColor, [width/v2-frameSize height/2-frameSize width/v2+frameSize height/2+frameSize]);
    Screen('FillOval', window, bullsEyeColorExt,[width/v1-re height/2-re width/v1+re height/2+re]);
    Screen('FillOval', window, bullsEyeColorExt,[width/v2-re height/2-re width/v2+re height/2+re]);
    Screen('FillOval', window, bullsEyeColorInt,[width/v1-ri height/2-ri width/v1+ri height/2+ri]);
    Screen('FillOval', window, bullsEyeColorInt,[width/v2-ri height/2-ri width/v2+ri height/2+ri]);
    Screen('Flip', window);
    
    
    %%--------------RECORD RESPONSE------------%%
    %%Will wait til response%%
    
    answer = 0;
        
        while (answer == 0)  
            [keyIsDown,secs, keyCode] = KbCheck;
            
        if keyCode(escapeKey)
            ShowCursor;
            sca;
            return
        elseif keyCode(oneKey) %%Left/green
            record_response(i)= 1;
            answer = 1;
        elseif keyCode(twoKey) %%Middle/mixed
            record_response(i) = 2;
            answer = 1;
        elseif keyCode(threeKey) %%Right/red
           record_response(i) = 3;
            answer = 1;    
        end
        end
  
    %%Sets up box and bullseye        
    Screen('FrameRect', window, frameColor, [width/v1-frameSize height/2-frameSize width/v1+frameSize height/2+frameSize]);
    Screen('FrameRect', window, frameColor, [width/v2-frameSize height/2-frameSize width/v2+frameSize height/2+frameSize]);
    Screen('FillOval', window, bullsEyeColorExt,[width/v1-re height/2-re width/v1+re height/2+re]); %%Draws bullseye
    Screen('FillOval', window, bullsEyeColorExt,[width/v2-re height/2-re width/v2+re height/2+re]); %%Draws bullseye
    Screen('FillOval', window, bullsEyeColorInt,[width/v1-ri height/2-ri width/v1+ri height/2+ri]); %%Draws bullseye
    Screen('FillOval', window, bullsEyeColorInt,[width/v2-ri height/2-ri width/v2+ri height/2+ri]); %%Draws bullseye
    vbl = Screen('Flip', window);
    
    %%------ Interstimulus Interval ------%%
    %% One second %%
    for frame = 1:ici - 1 
      
    Screen('FrameRect', window, frameColor, [width/v1-frameSize height/2-frameSize width/v1+frameSize height/2+frameSize]);
    Screen('FrameRect', window, frameColor, [width/v2-frameSize height/2-frameSize width/v2+frameSize height/2+frameSize]);
    Screen('FillOval', window, bullsEyeColorExt,[width/v1-re height/2-re width/v1+re height/2+re]);
    Screen('FillOval', window, bullsEyeColorExt,[width/v2-re height/2-re width/v2+re height/2+re]);
    Screen('FillOval', window, bullsEyeColorInt,[width/v1-ri height/2-ri width/v1+ri height/2+ri]);
    Screen('FillOval', window, bullsEyeColorInt,[width/v2-ri height/2-ri width/v2+ri height/2+ri]);
    vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
    
    end
              
    
    end
    

%%%% ----------- CALCULATES PRIMING ------------------ %%%%

    primed = zeros (1,(length(orient_array)));
    
  for i=1:length(orient_array)  
    
    if record_response (i) == 1 && cue_array(i) == 2 
        
       primed(i) = 1;
       
       
    elseif record_response (i) == 3 && cue_array(i) == 1
        
          primed(i) = 1;
        
    end
  end
    
     count_real_BR = zeros (1,(length(orient_array))); %%gets rid of trials in which the participant reported mixed trials (when not a mock trial)
    
  for i=1:length(orient_array)  
    
    if condition_array (i) == 1 && record_response(i) ~= 2
        
       count_real_BR(i) = 1;   
    
    end
  
  end
  
       count_mock_BR = zeros (1,(length(orient_array)));
    
  for i=1:length(orient_array)  
    
    if condition_array (i) ~= 1 
        
       count_mock_BR(i) = 1;   
    
    end
  
  end
  
  
  prime_real  = zeros (1,(length(orient_array)));
  
  for i=1:length(orient_array)  
    
    if primed (i) == 1 && count_real_BR (i) == 1
        
       prime_real (i) = 1;   
    
    end
  
  end
  
  
   prime_mock  = zeros (1,(length(orient_array)));
  
  for i=1:length(orient_array)  
    
    if primed (i) == 1 && count_mock_BR (i) == 1
        
       prime_mock (i) = 100;   
       
    elseif count_mock_BR (i) == 1 && primed (i) == 0 && record_response(i) == 2
        
       prime_mock (i) = 50;  
       
     elseif count_mock_BR (i) == 1 && primed (i) == 0 
        
       prime_mock (i) = 0;        
    
    end
  
  end
  
  Imagery_Prime = (sum(prime_real)/sum(count_real_BR))*100
  
  mock_primed = (sum(prime_mock)/sum(count_mock_BR))
  
  num_trals = sum(count_real_BR)
  
  
%%%% ---------Saves Data --------- %%%%
if save_data==1
    cd(save_directory)
    outfilename=['basic_imagery' subName scanNum '_'  theDate '_.mat'];
    aa=num2str(outfilename);
    save(aa); % saves everything in memory
end


ShowCursor;
Screen('CloseAll');

