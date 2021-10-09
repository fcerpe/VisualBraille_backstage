%% scramble images on the spot for the retreat presentation

clear
load('inputs/localizer_sota0907.mat');

% 550x300 -> squares of 10, or 25, or 50 px
%
%       X X X X X X X X X X X X X X X X X X X X X X 
%       X X X X X X X X X X X X X X X X X X X X X X 
%       X X X X X X X X X X X X X X X X X X X X X X 
%       X X X X X X X X X X X X X X X X X X X X X X 
%       X X X X X X X X X X X X X X X X X X X X X X (X=25px)
%       X X X X X X X X X X X X X X X X X X X X X X total = 264 squares

ld = images.ld.balai;
fw = images.fw.balai;

% fw
[xFW,yFW] = size(fw,1,2);
[xLD,yLD] = size(ld,1,2);

nbX = 10;
nbY = 10;

newFW = randperm(100);
newLD = randperm(100);



sfw=zeros(xFW,yFW,3);
k = 1;

for i = 1:10:100
    for j = 1:32:320
        x = (mod(newFW(k),10)*32)+1-32;
        if mod(newFW(k),10) == 0
            x = 289;
        end
        y = (floor(newFW(k)/10))*10 + 1;
        if newFW(k) == 100
            y = 91;
        end
        sfw(i:i+9,j:j+31,:) = fw(y:y+9,x:x+31,:);
        k = k+1;
    end
end

sfw = uint8(sfw);

sld=zeros(xLD,yLD,3);
k = 1;

for i = 1:20:200
    for j = 1:65:650
        x = (mod(newLD(k),10)*65)+1-65;
        if mod(newLD(k),10) == 0
            x = 586;
        end
        y = (floor(newLD(k)/10))*20 + 1;
        if newLD(k) == 100
            y = 181;
        end
        sld(i:i+19,j:j+64,:) = ld(y:y+19,x:x+64,:);
        k = k+1;
    end
end

sld = uint8(sld);