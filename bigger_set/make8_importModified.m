% MAKE STIMULI - 8
% Import images of fake script and save .mat to be used in VisualBraille

clear

% latest step in the non-automatic pipeline
load('word_visualizeStimuli.mat');

% load design matrices
load('../../VisualBraille/inputs/experimentDesignSupplement.mat');

% get images from the stimuli_imgs folder
% those images have to be put manually, at least the first time
files = dir('external_imgs');

for f = 3:size(files,1)
    name = files(f).name;
    condition = name(1:3);
    if length(name) == 10
        number = name([5 6]);
    elseif length(name) == 11
        number = name([5 6 7]);
    end

    % read img
    eval(['thisImg = imread(''external_imgs/' char(name) ''');']);

    % with grayscale, we work on only one layer
    thisImg = im2gray(thisImg);

    % save in variable and write as images 
    eval(['images.' char(condition) '.' char(number) ' = thisImg;']);
    eval(['imwrite(thisImg,''stimuli_imgs/' char(name) ''');']); 

    % Only for task variants (comment if not necessary): 
    % add extra space to the sides of the image, so we can add full letter
    % shifts
    extraSpace = zeros(200, 30);
    extraImg = horzcat(extraSpace, thisImg, extraSpace);

    % 1st variant: move stimuli 50px to the side, either L or R
    horzShift = zeros(200,70);
    toTheRight = horzcat(horzShift, extraImg(:,1:490));
    toTheLeft = horzcat(extraImg(:,71:end), horzShift);

    % 2nd variant: move stimuli horizontally as 1st variant, but add also a
    % vertical shift of 30px
    vertShift = zeros(30,560);
    toTopRight = vertcat(toTheRight(31:end,:), vertShift);
    toTopLeft = vertcat(toTheLeft(31:end,:), vertShift);
    toBottomRight = vertcat(vertShift,toTheRight(1:170,:));
    toBottomLeft = vertcat(vertShift,toTheLeft(1:170,:));

    % save in variable and write as images 
    % original a.k.a. no-dimensional shift
    eval(['nodim.center.' char(condition) '.' char(number) ' = extraImg;']);
    eval(['imwrite(extraImg,''stimuli_imgs/nodim_c_' char(name) ''');']); 

    % one-dimensional shift
    eval(['onedim.center.' char(condition) '.' char(number) ' = extraImg;']);
    eval(['onedim.left.' char(condition) '.' char(number) ' = toTheLeft;']);
    eval(['onedim.right.' char(condition) '.' char(number) ' = toTheRight;']);
    eval(['imwrite(extraImg,''stimuli_imgs/onedim_c_' char(name) ''');']); 
    eval(['imwrite(toTheLeft,''stimuli_imgs/onedim_l_' char(name) ''');']); 
    eval(['imwrite(toTheRight,''stimuli_imgs/onedim_r_' char(name) ''');']); 

    % two-dimensional shift
    eval(['twodim.center.' char(condition) '.' char(number) ' = extraImg;']);
    eval(['twodim.topleft.' char(condition) '.' char(number) ' = toTopLeft;']);
    eval(['twodim.topright.' char(condition) '.' char(number) ' = toTopRight;']);
    eval(['twodim.bottomleft.' char(condition) '.' char(number) ' = toBottomLeft;']);
    eval(['twodim.bottomright.' char(condition) '.' char(number) ' = toBottomRight;']);
    eval(['imwrite(extraImg,  ''stimuli_imgs/twodim_cc_' char(name) ''');']); 
    eval(['imwrite(toTheLeft, ''stimuli_imgs/twodim_tl_' char(name) ''');']); 
    eval(['imwrite(toTheRight,''stimuli_imgs/twodim_tr_' char(name) ''');']); 
    eval(['imwrite(toTheLeft, ''stimuli_imgs/twodim_bl_' char(name) ''');']); 
    eval(['imwrite(toTheRight,''stimuli_imgs/twodim_br_' char(name) ''');']); 

end

%% Include matrices that specifies where each stimulus goes
% mimick presentation matrix of BlockMvpa and specify
% - left, center, right
% - topleft, topright, bottomleft, bottomright, center
% [in one run there are 648 stimuli]

nomoves = repmat(["center"], 1, 648);
onemove = repmat(["left", "center", "right"], 1, 216);
onemove = shuffle(onemove);
twomoves = repmat(["center", "topleft", "topright", "bottomleft", "bottomright"], 1, 130);
twomoves = shuffle(twomoves);

onedimShifts = string;
twodimShifts = string;
nodimShifts = string;

shiftIndex = 1;

% Go thorugh the presentation matrix, to replicate the position of the
% different zeros indicating the lack of target.
% Put the string relative to the position in that place, will be used to
% know in which struct to look for the stimulus
for i = 1:size(stimOrderMatrix,1)
    for j = 1:size(stimOrderMatrix,2)
        for k = 1:size(stimOrderMatrix,3)
            if stimOrderMatrix(i,j,k) ~= 0
                onedimShifts(i,j,k) = onemove(shiftIndex);
                twodimShifts(i,j,k) = twomoves(shiftIndex);
                nodimShifts(i,j,k) = nomoves(shiftIndex);
                shiftIndex = shiftIndex +1;
            else
                onedimShifts(i,j,k) = "n/a";
                twodimShifts(i,j,k) = "n/a";
                nodimShifts(i,j,k) = "n/a";
            end
        end
    end
end

%% save them into the images struct
save('blockMvpa_stimuli.mat','images','stimuli');
save('taskTrial_stimuli.mat','images','onedim','onedimShifts','twodim','twodimShifts','stimuli')
save('../../VisualBraille/inputs/blockMvpa_stimuli.mat','images','stimuli');
save('../../VisualBraille/inputs/taskTrial_stimuli.mat',...
     'images','nodim','nodimShifts','onedim','onedimShifts','twodim','twodimShifts','stimuli')






