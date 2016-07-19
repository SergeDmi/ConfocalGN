function [ RR ] = bbseam_points(b,dt)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
t=0:dt:2*pi;

X=(1 - b)*sin(t)+b*sin(3*t);
Y=(1 - b)*cos(t)-b*cos(3*t); 
Z=2*sqrt((1-b)*b)*cos(2*t);

RR=[X',Y',Z'];
end

