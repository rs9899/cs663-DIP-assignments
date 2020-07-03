function output = NoiseAdder(input)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% output = input;
rand('seed',42);
% 
range = max(input , [] ,'all') - min(input , [] ,'all');
stdev = 0.05 * range;
output = input + stdev *  randn(size(input));
end

