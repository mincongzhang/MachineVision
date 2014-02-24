function r= drawLine(lines,imX,imY,lineStyleIn);
%subroutine to draw lines
%lines is a list of 1x3 lines imX, imY is dimensions of image on which to draw
%=======================================================================

if (~exist('lineStyleIn'))
    lineStyleIn = 'r-';
end;

%count number of lines
nLine = size(lines,1);

%define equation of x,y borders
borderLines = [1 0 -1; 1 0 -imX; 0 1 -1; 0 1 -imY];

%main loop
for (cLine = 1:nLine)
    %extract this Line
    thisLine = repmat(lines(cLine,:),4,1);
    %find where it meets border lines
    meetingPoints = (cross(thisLine,borderLines))';
    %normalize lines
    meetingPoints = meetingPoints./repmat(meetingPoints(3,:),3,1);
    %extract points to keep that are in image
    toKeep = find(inImage(meetingPoints,imX,imY));
    meetingPoints = meetingPoints(:,toKeep);
    %plot in red
    hold on; plot(meetingPoints(1,:),meetingPoints(2,:),lineStyleIn);
end;

%======================================================================

function r = inImage(points,imX,imY)
%returns 1 where points are in image and zero where not
%============================================================

r = ((points(1,:)>0)&(points(1,:)<=imX)&(points(2,:)<=imY)&(points(2,:)>0));