%% Introduction
% This file is intended to batch extract frames from a video.
% Prepared by DingLingGuangLang.
%% Function
InputPath = 'D:\SUN-Matlab\videos\';
OutputPath = 'D:\SUN-Matlab\screen shots\';
video = VideoReader([InputPath,'Elden.mp4']);
N_frames = video.NumFrames;
N_saveings = 500; % Number of photos to be saved
NameNumber = 1;
for ii = 1:floor(N_frames/N_saveings):N_frames
    frame = read(video,ii);
    Name = num2str(NameNumber);
    NameNumber = NameNumber+1;
    imwrite(frame,[OutputPath,Name,'.jpg']);
end
