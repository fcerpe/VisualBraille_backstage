function positions = vbs_determine_dot_positions(stimuli, screen)

% if positions already exist, load and return file
if  exist('vbs_fs_positions.mat', 'file') == 2

    positions = load('vbs_fs_positions.mat');

% if positions don't exist yet, compute them
else

    % Init struct to contain the lists of positions
    fakescript = struct();

    % get frame in which to print words
    width = 1228-204;
    height = 756-561;
    diameter = 49;
    xCenter = screen.rect(3)/2;
    yCenter = screen.rect(4)/2;

    % List containing the number of dots for each Braille character
    %       a B C D e F G H i J K L M N o P Q R S T u V W X Y Z
    dots = [0,2,2,3,0,3,4,3,0,3,5,3,3,4,0,4,5,4,3,4,0,4,5,4,5,4];

    % Each string in the requested list is processed and added to the array of
    % stimulis dots
    for iS = 1:length(stimuli)

        % Specify which stimulus
        stim = stimuli{iS};

        % get the number of dots for this stimulus
        num_dots = 0;
        for iC = 1:length(stim), num_dots = num_dots + dots(int8(stim(iC)-96));
        end

        % Arrange dots in the area

        % Reduce drawing area to avoid drawing outside margins
        drawableX = width - diameter;
        drawableY = height - diameter;

        % Make rectangle with the actual drawing area and center it to the
        % center of the final screen, to have an easier translation later on
        baseArea = [0 0 drawableX drawableY];
        centeredArea = CenterRectOnPointd(baseArea, xCenter, yCenter);

        % Array to store previously drawn dots, to calculate distances
        dot_positions = [];

        % Generate printing coordinates for each dot
        for l = 1:num_dots

            % Plot random coordinates and check for overlapping
            % Assume this is the center of the dot
            this_x = randi(drawableX);
            this_y = randi(drawableY);


            while ~checkProximity([this_x,this_y], dot_positions, 75, 60)
                this_x = randi(drawableX);
                this_y = randi(drawableY);
            end

            % Save this dot coordinates
            dot_positions = vertcat(dot_positions,[this_x this_y]);
        end

        % After getting all the coords, collect the positions in a single variable
        % original position (center)    +
        % radius (pos or neg)           +
        % center coordinates            + 
        % 22 pixels offest (for y axis) =
        % -------------------------------
        % final position on the screen
        startX = dot_positions(:,1)' - diameter/2 + (1920/2 - drawableX/2);
        startY = dot_positions(:,2)' - diameter/2 + (1080/2 - drawableY/2) - 22;
        endX = dot_positions(:,1)' + diameter/2 + (1920/2 - drawableX/2);
        endY = dot_positions(:,2)' + diameter/2 + (1080/2 - drawableY/2) -22;


        positions = [startX; 
                     startY;
                     endX;
                     endY];

        % Save in the struct
        fakescript.(stim) = positions;

    end

    % Save struct as .mat
    save('vbs_fs_positions.mat','fakescript');

end

end
