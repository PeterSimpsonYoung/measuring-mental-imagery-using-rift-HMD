
%==============================
%Pearson Lab UNSW
%Code by Franco Caramia, Joel Pearson


clear all
%==============================

%==============================
%Parameters
%==============================
save_data=1; % 1=yes; 0=no
save_directory = '/Users/pearsonlab2/Desktop/Experiments/Data/eye_dom';

if(save_data==1)
     [subName scanNum theDate]=GetUserInfo(); 
end


PsychJavaTrouble

%Trial parametersca
ntrials = 16; % divisible by 4. 
% ntrials = ntrials*2;



% the contrast of the stimulus. range=0:1; 
red_con= 0.4; % 0.3413; % right oreintation, and red  SA usually r = 0.4 and g = .6
green_con= 0.6;%  %0.6911; % left O, and green Aaron 

 

GreenFactor = 0.65;



adapt_time=4; 


con_change_V=.02; 



%Temporal Parameters (all in seconds)

time_ima = 1; % imaginery time
time_resp = 0.75; % response window

time_cue = 1; % letter cue time
time_intratrial = 1; %time between trials



time_stim = .75; % stimuli time






freq=6; % spatial frequency of patterns. 


colorR = [1 0 0]; %RED PATTERN
colorG = [0 1 0]; %GREEN PATTERN


colorG = colorG*GreenFactor;
%==============================
%Psychtoolbox init & screen values
%==============================

% Open onscreen window:
scr_nbr=max(Screen('Screens'));
[w, scr_rect]=Screen('OpenWindow', scr_nbr);
% Coordinates of the centre of the screen
centreX=scr_rect(3)/2;
centreY=scr_rect(4)/2;

shCenter = (scr_rect (3) - scr_rect (1))/2;
svCenter = (scr_rect (4) - scr_rect (2))/2;

%KeyBoard Stuff

% key names
KbName('UnifyKeyNames');
OneKey=KbName('1');
TwoKey=KbName('2');
ThreeKey=KbName('3');
OneUpKey=KbName('1!');
TwoUpKey=KbName('2@');
ThreeUpKey=KbName('3#');

%Response Variables
Same=0;
Different = 0;
GreenOverall=0;
RedOverall=0;
MixedOverall=0;
RR = 0;
GG = 0;
RG = 0;
GR = 0;
RM = 0;
GM = 0;

%Colour calibration


black = BlackIndex(w);  % Retrieves the CLUT color code for black.
white = WhiteIndex(w);  % Retrieves the CLUT color code for white.
grey = (black + white) / 2;  % Computes the CLUT color code for grey.
if round(grey)==white
    grey=black;
end

%General Parameters
background_colour = black; 
text_colour = grey; %colour of cue
text_size = 60; %size of CUE


% Fixation point parameters.

re=6; % external circle radius
ri=4; % internal circle radius

% fixation point colours
fixpt_int=0; % black centre
fixpt_ext=190; % white-ish circle


%Pattern Creation 
% *** To lengthen the period of the grating, increase pixelsPerPeriod.
pixelsPerPeriod = 33; % How many pixels will each period/cycle occupy?
spatialFrequency = .75 / pixelsPerPeriod; % How many periods/cycles are there in a pixel?
radiansPerPixel = spatialFrequency * (2 * pi); % = (periods per pixel) * (2 pi radians per period)
periodsCoveredByOneStandardDeviation = 1.5;
gaussianSpaceConstant = periodsCoveredByOneStandardDeviation  * pixelsPerPeriod;
% *** If the grating is clipped on the sides, increase widthOfGrid.
widthOfGrid = 500;

halfWidthOfGrid = widthOfGrid / 2;

widthArray = (-halfWidthOfGrid) : halfWidthOfGrid;  % widthArray is used in creating the meshgrid.
absoluteDifferenceBetweenWhiteAndGray = abs(white - grey);


[x y] = meshgrid(widthArray, widthArray);


 % cardinals
 grat_angle1=pi/2; % left. 
  grat_angle2=2*pi ;
  
 % circularGaussianMaskMatrix = exp(-((x .^ 2) + (y .^ 2)) / (gaussianSpaceConstant ^ 2.3));%2.3 
  
 
 
 %%%%%%%%%% 
  gratingMatrix1 =(sin(freq*2*pi/halfWidthOfGrid*(x.*sin(grat_angle1)+y.*cos(grat_angle1))-0));
  gratingMatrix2 =(sin(freq*2*pi/halfWidthOfGrid*(x.*sin(grat_angle2)+y.*cos(grat_angle2))-0));
  
  
    gratingMatrix2=((gratingMatrix2*red_con)*127)+(127); 
    gratingMatrix1= ((gratingMatrix1*green_con)*127)+(127); 
    
   % mesh(gratingMatrix1)
    
  
  circularGaussianMaskMatrix = exp(-((x .^ 2) + (y .^ 2)) / (gaussianSpaceConstant ^ 2.3));%2.3
  imageMatrixG = gratingMatrix1 .* circularGaussianMaskMatrix;
  imageMatrixR = gratingMatrix2 .* circularGaussianMaskMatrix;


% mock pattern:
% mock_right=imageMatrixR;
% mock_left=imageMatrixG;
% amp=27;
%     EE=smooth((smooth(amp*randn(1, widthOfGrid), 35))+250); % was 100 at the end 
% 
% % makes the appropriate sections value of 0; so the two images can be added
% % together. 
% EE=round(EE); 
% 
% for loop=1:widthOfGrid
%     
% mock_right(1:(EE(loop)), loop)=0;
% mock_left((EE(loop)):widthOfGrid, loop)=0;
%     
% end 

%%%%%%%%%%%%




pattern1 = zeros([size(imageMatrixR) 3]);
pattern2 = zeros([size(imageMatrixR) 3]);


% Mock_patternLeft = zeros([size(imageMatrixR) 3]);
% Mock_patternRight = zeros([size(imageMatrixR) 3]);


pattern1(:,:,1)=1*abs(imageMatrixR);
pattern1(:,:,2)=0*abs(imageMatrixR);
pattern1(:,:,3)=0*abs(imageMatrixR);

pattern2(:,:,1)=0*abs(imageMatrixG);
pattern2(:,:,2)=1*abs(imageMatrixG);
pattern2(:,:,3)=0*abs(imageMatrixG);

% Mock_patternRight(:,:,1)=colorG(1)*abs(mock_right);
% Mock_patternRight(:,:,2)=colorG(2)*abs(mock_right);
% Mock_patternRight(:,:,3)=colorG(3)*abs(mock_right);
% 
% Mock_patternLeft(:,:,1)=colorR(1)*abs(mock_left);
% Mock_patternLeft(:,:,2)=colorR(2)*abs(mock_left);
% Mock_patternLeft(:,:,3)=colorR(3)*abs(mock_left);



%pattern = pattern1*.5 + pattern2*.5; % + pattern1b*.5+pattern1c*.5;

pattern = pattern1*1 + pattern2*1; 




%Pattern_Mock= Mock_patternRight*.5 + Mock_patternLeft*.5; 

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


texture_BR=Screen('MakeTexture', w, pattern);

texture_pat1=Screen('MakeTexture', w, pattern1);
texture_pat2=Screen('MakeTexture', w, pattern2);

% texture_Mock=Screen('MakeTexture', w, Pattern_Mock);

%Test cases matrix

cases = zeros(ntrials,1); %trials * R & G



array1=1:ntrials;

%%%%%

 
 array8=1:round((ntrials)*.75);
 cue_array=mod(array8, 2); 
 
 cue_array=shuffle(cue_array);
 
 
 
 
 
 array8=1:round((ntrials)*.25);
 
 
mock_cue_array =mod(array8, 2); 
 
 mock_cue_array=shuffle(mock_cue_array);
 
 
 
 
 % phase jitter. 
 array2=mod(array1, 10); 
phase_array= shuffle(array2)*4;

% mock BR trail array. 
 array2=mod(array1, 4); 
condition_array=shuffle(array2); 
 
 real_BR_counter=1; 

% aux_cont=1;
% 
% for i=1:ntrials/2
%     for j=1:2
%         cases(aux_cont) = j ;
%         aux_cont = aux_cont+1;
%     end
% end
% cases = shuffle(cases);

FlushEvents;
 HideCursor;
%==============================
%First Screen
%==============================
Screen('FillRect', w, background_colour);

Screen('TextSize',w, 40);
Screen('DrawText', w, 'Press any key to begin ', centreX/3,centreY/3, [255 255 255]);
Screen('FillOval', w, fixpt_ext, [centreX-re centreY-re centreX+re centreY+re]);
Screen('FillOval', w, fixpt_int, [centreX-ri centreY-ri centreX+ri centreY+ri]);

Screen('Flip',w);

FlushEvents;
 while getchar==0 end  %

%kbwait;


%==============================
%Trial begins 
%==============================

for t=1:ntrials
    
    HideCursor;
    
    FlushEvents;
%==============================
%Letter Cue
%==============================
   
   
    
    
%     Screen('FillRect', w, background_colour);
%     Screen('TextSize',w, text_size);
%     TextWidth = Screen (w,'TextBounds', cue);
%     Screen (w, 'DrawText', cue,shCenter-(TextWidth(3)/2), svCenter-(TextWidth(4)/2),text_colour);
% 
%     Screen('FillOval', w, fixpt_ext, [centreX-re centreY-re centreX+re centreY+re]);
%     Screen('FillOval', w, fixpt_int, [centreX-ri centreY-ri centreX+ri centreY+ri]);
%      Screen('Flip',w);
     
     
%     auxTime=getsecs;
%     while(getsecs<=auxTime+time_cue)end
    
    
%==============================
%Imaginary Time
%==============================
    Screen('FillRect', w, background_colour);
    Screen('FillOval', w, fixpt_ext, [centreX-re centreY-re centreX+re centreY+re]);
    Screen('FillOval', w, fixpt_int, [centreX-ri centreY-ri centreX+ri centreY+ri]);

    Screen('Flip',w);
    auxTime=getsecs;
    while(getsecs<=auxTime+time_ima)end
    
    
%==============================
%Stimuli
%==============================

    %Screen('FillRect', w, background_colour);
   
        Screen('DrawTexture', w, texture_BR, patch_sizeS,side);

    Screen('FillOval', w, fixpt_ext, [centreX-re centreY-re centreX+re centreY+re]);
    Screen('FillOval', w, fixpt_int, [centreX-ri centreY-ri centreX+ri centreY+ri]);
    
    Screen('Flip',w);
    
     Snd('Play',sin(100:1000));
    
    auxTime=getsecs;
    while(getsecs<=auxTime+time_stim)end
    
    
%==============================
%Response Collection 
%==============================


    Screen('FillRect', w, background_colour);
    Screen('FillOval', w, fixpt_ext, [centreX-re centreY-re centreX+re centreY+re]);
    Screen('FillOval', w, fixpt_int, [centreX-ri centreY-ri centreX+ri centreY+ri]);
    Screen('Flip',w);
    
    
    
    auxTime=getsecs;
    resp=0;
 
        %KbWait;
   
       
        [ch, when] = getChar;
        %tt=find(keyCode);    
        if (ch=='1')
            response_array(t)=1;
        elseif     (ch=='2')
            response_array(t)=2;
        elseif     (ch=='3')
            response_array(t)=3;
        end  
  %ch
         
       FlushEvents('keyDown');
        FlushEvents;
    
    %end

    
    
      if  response_array(t)==1
          
          
          
        Screen('DrawTexture', w, texture_pat2, patch_sizeS,side);
        Screen('FillOval', w, fixpt_ext, [centreX-re centreY-re centreX+re centreY+re]);
        Screen('FillOval', w, fixpt_int, [centreX-ri centreY-ri centreX+ri centreY+ri]);
        Screen('Flip',w);
          
          
      elseif response_array(t)==3
          
           Screen('DrawTexture', w, texture_pat1, patch_sizeS,side);
        Screen('FillOval', w, fixpt_ext, [centreX-re centreY-re centreX+re centreY+re]);
        Screen('FillOval', w, fixpt_int, [centreX-ri centreY-ri centreX+ri centreY+ri]);
        Screen('Flip',w);
          
      elseif response_array(t)==2
          
          if t>1
              
                          if  response_array(t-1)==1
                              Screen('DrawTexture', w, texture_pat2, patch_sizeS,side);
                              Screen('FillOval', w, fixpt_ext, [centreX-re centreY-re centreX+re centreY+re]);
                              Screen('FillOval', w, fixpt_int, [centreX-ri centreY-ri centreX+ri centreY+ri]);
                              Screen('Flip',w);

                          elseif response_array(t-1)==3
                              Screen('DrawTexture', w, texture_pat1, patch_sizeS,side);
                              Screen('FillOval', w, fixpt_ext, [centreX-re centreY-re centreX+re centreY+re]);
                              Screen('FillOval', w, fixpt_int, [centreX-ri centreY-ri centreX+ri centreY+ri]);
                              Screen('Flip',w);

                          end
          else
              
                              Screen('DrawTexture', w, texture_pat1, patch_sizeS,side);
                              Screen('FillOval', w, fixpt_ext, [centreX-re centreY-re centreX+re centreY+re]);
                              Screen('FillOval', w, fixpt_int, [centreX-ri centreY-ri centreX+ri centreY+ri]);
                              Screen('Flip',w);      
                          
              
          end 
          
          
      end 
    
     auxTime=getsecs;
    while(getsecs<=auxTime+adapt_time)end
    
    
     Screen('FillRect', w, background_colour);
    Screen('FillOval', w, fixpt_ext, [centreX-re centreY-re centreX+re centreY+re]);
    Screen('FillOval', w, fixpt_int, [centreX-ri centreY-ri centreX+ri centreY+ri]);
    Screen('Flip',w);
    
%==============================
%Intra Trial Time 
%==============================
    
    
    auxTime=getsecs;
    while(getsecs<=auxTime+time_intratrial) end 
        
        
        
        
        
        if t >1
      
      if response_array(t)==1 % greens
          
          

                         

          
          
      
             if  response_array(t)==response_array(t-1) % two greens in a row. 
                 
                 
                         if     red_con<1
                             red_con=red_con+(red_con*(con_change_V*2));
                             green_con=green_con-(green_con*(con_change_V*2));

                         else
                             red_con=1;
                             green_con=green_con-(green_con*(con_change_V*2));
                         end
                
                
             else
                 
                          if     red_con<1
                              red_con=red_con+(red_con*con_change_V);
                              green_con=green_con-(green_con*con_change_V);

                          else
                              red_con=1;
                              green_con=green_con-(green_con*con_change_V);
                          end
                 
             end 
      
      elseif response_array(t)==2 % mixed       
          
          
             if  response_array(t-1)==3 % check the trial before if it was red 
                 
                 
                 if     green_con<1
                     red_con=red_con-(red_con*con_change_V);
                     green_con=green_con+(green_con*con_change_V);

                 else
                     red_con=red_con-(red_con*con_change_V);
                     green_con=1;
                 end
                 
             elseif response_array(t-1)==1 % check the trial before if it was green
                 
                 if     red_con<1
                     red_con=red_con+(red_con*con_change_V);
                     green_con=green_con-(green_con*con_change_V);

                 else
                     red_con=1;
                     green_con=green_con-(green_con*con_change_V);
                 end
        % elseif response_array(t-1)==2 % 
                
             end 
             
             
      elseif response_array(t)==3 % Reds
          
                         
          
 
          if  response_array(t)==response_array(t-1) % 
              
                      if     green_con<1
                          red_con=red_con-(red_con*(con_change_V*2));
                          green_con=green_con+(green_con*(con_change_V*2));

                      else
                          red_con=red_con-(red_con*(con_change_V*2));
                          green_con=1;
                      end
                         
          else
              
                         if     green_con<1
                              red_con=red_con-(red_con*con_change_V);
                              green_con=green_con+(green_con*con_change_V);

                          else
                              red_con=red_con-(red_con*con_change_V);
                              green_con=1;
                          end
              
              
          end
          
  end 
      
      
 end 
        
        
        
        
 red_contrasts(t)= red_con;
 green_contrasts(t)=green_con; 
        
        
        
        
    
    % redraw stimuli. 
    
    
 %%%%%%%%%% 
  gratingMatrix1 =(sin(freq*2*pi/halfWidthOfGrid*(x.*sin(grat_angle1)+y.*cos(grat_angle1))-phase_array(t)));
  gratingMatrix2 =(sin(freq*2*pi/halfWidthOfGrid*(x.*sin(grat_angle2)+y.*cos(grat_angle2))-phase_array(t)));
  
      gratingMatrix2=((gratingMatrix2*red_con)*127)+(127); 
    gratingMatrix1= ((gratingMatrix1*green_con)*127)+(127); 
  
  %circularGaussianMaskMatrix = exp(-((x .^ 2) + (y .^ 2)) / (gaussianSpaceConstant ^ 2.3));%2.3
  imageMatrixG = gratingMatrix1 .* circularGaussianMaskMatrix;
  imageMatrixR = gratingMatrix2 .* circularGaussianMaskMatrix;


% % mock pattern:
% mock_right=imageMatrixR;
% mock_left=imageMatrixG;
% amp=27;
%     EE=smooth((smooth(amp*randn(1, widthOfGrid), 35))+250); % was 100 at the end 
% 
% % makes the appropriate sections value of 0; so the two images can be added
% % together. 
% EE=round(EE); 
% 
% for loop=1:widthOfGrid
%     
% mock_right(1:(EE(loop)), loop)=0;
% mock_left((EE(loop)):widthOfGrid, loop)=0;
%     
% end 


pattern1(:,:,1)=colorR(1)*abs(imageMatrixR);
pattern1(:,:,2)=colorR(2)*abs(imageMatrixR);
pattern1(:,:,3)=colorR(3)*abs(imageMatrixR);

pattern2(:,:,1)=colorG(1)*abs(imageMatrixG);
pattern2(:,:,2)=colorG(2)*abs(imageMatrixG);
pattern2(:,:,3)=colorG(3)*abs(imageMatrixG);

% Mock_patternRight(:,:,1)=colorG(1)*abs(mock_right);
% Mock_patternRight(:,:,2)=colorG(2)*abs(mock_right);
% Mock_patternRight(:,:,3)=colorG(3)*abs(mock_right);
% 
% Mock_patternLeft(:,:,1)=colorR(1)*abs(mock_left);
% Mock_patternLeft(:,:,2)=colorR(2)*abs(mock_left);
% Mock_patternLeft(:,:,3)=colorR(3)*abs(mock_left);

pattern = pattern1 + pattern2; 
% Pattern_Mock= Mock_patternRight + Mock_patternLeft; 
    
texture_BR=Screen('MakeTexture', w, pattern);
% texture_Mock=Screen('MakeTexture', w, Pattern_Mock);
    
    
    
    end % inter trail waiting period. 

    % counters
    
 
  
    
    if condition_array(t)==1 % 25% of trials are mock.
        mockBR_counter=mockBR_counter+1;
        
    else
        real_BR_counter=real_BR_counter+1;
    end
    
    
    



%Screen('Close' ,texture);
Screen('CloseAll');
ShowCursor;



    
 

 plot(response_array, '-o')
figure
  
  plot(red_contrasts, 'r')
 hold on
 plot(green_contrasts, 'g')
 
 red_con
 green_con






if save_data==1
    cd(save_directory)
    outfilename=['eye_dom_test' subName scanNum '_'  theDate '_.mat'];
    aa=num2str(outfilename);
    save(aa); % saves everything
end


    