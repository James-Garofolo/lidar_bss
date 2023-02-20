clc
clear all % if you want to use workspace values as signals, comment this out
close all

%% file imports and user-defined values

% this is just what i do, you can import a file somehow else if you like
file = readtable('noisy29.csv'); 
sig = table2array(file(:,2)); % sig is the signal you want the eye diagram of
time = table2array(file(:,1))'; % time is the timescale over which it was sampled

% here i specify the desired number of samples per bit in the output figure
% input sample rate does not matter
samples_per_bit = 500; 

% this is the desired number of bits to be shown in the output figure
% the program will always try to do half a bit on the left, then however 
% many full bits, then one more half bit on the right. 
bits_per_window = 2;

% here i specify the interpolation style. the options are 'linear', 
% 'nearest', 'next', 'previous', 'pchip' (shape-preserving piece wise
% cubic), 'makima' (akima cubic hermite, modified to reduce overshoot), or
% 'spline' (thrice differentiable cubic splines)
interp_style = 'spline';

% this number will bethe number of vertical bins shown in the figure, 
% regardless of signal amplitude. 
ares = 500;

% specify the bit rate explicitly here if you wish to. if you'd rather let
% the algorithm find it by itself, set this value to -1
bit_rate = 2.9e9;

% this is the precision in bits/second in auto-detect mode (i.e. 1e6 means
% accurate to the nearest Mbps). this value goes unused in explicit mode
bit_rate_precision = 10e7;

% these two are thresholds that set the high and low levels in terms of the
% signal's peak-to-peak amplitude. i find the best results when these are
% close to 0.5, but different signals work different so play around until
% you get one that works. they also don't have to be the same if you want
% to do hysteresis bit detection
lo_thr = 0.4;
hi_thr = 0.4;

% this term adds a constant time shift to the figure. this will help if the
% auto-centering algorithm doesn't work right. if the algorithm is working
% correctly on your data, the eye will be centered when this number is zero
shift = 5/(bit_rate*10);

% this is the color multiplier from the old code, just moved up to the top
% for convenience
darkness = 20;

disp("imported")

%% identify bit rate
amax = max(sig);
amin = min(sig);
height = amax-amin;
mid = (amax + amin)/2;
hi_thr = hi_thr*(height+amin);
lo_thr = lo_thr*(height+amin);

if sig(1) < lo_thr
    lvl = 1; % starts on a "0"
elseif sig(1) > hi_thr
    lvl = 1; % starts on a "1"
elseif sig(2) > sig(1)
    lvl = 0;
else
    lvl = 1;
end
start = 1;

sbc = 1; % signle bit counter
for a = 2:length(sig)
    if lvl == 0
        if sig(a) > hi_thr
            lvl = 1;
            t1 = time(a-1) + (((hi_thr - sig(a-1))*(time(a)-time(a-1)))/(sig(a)-sig(a-1)));
            if start == 1
                start = 0;
            else
                if (t1-t2) > (1e-10) % this stops accidental crossings from making the bit rate higher than we can measure
                    t(sbc) = t1-t2;
                    if sbc == 1
                        tstart = (t(1)/2) + t2;
                    else
                        % this will be correct when the loop finishes
                        tend = (t(sbc)/2) + t2; 
                    end
                    sbc = sbc + 1;
                end
            end

        end
    else
        if sig(a) < lo_thr
            lvl = 0;
            t2 = time(a-1) + (((lo_thr - sig(a-1))*(time(a)-time(a-1)))/(sig(a)-sig(a-1)));
            if start == 1
                start = 0;
            else
                if (t2-t1) > (1e-10) % this stops accidental crossings from making the bit rate higher than we can measure
                    t(sbc) = t2-t1;
                    if sbc == 1
                        tstart = (t(1)/2) + t1;
                    else
                        % this will be correct when the loop finishes
                        tend = (t(sbc)/2) + t1; 
                    end
                    sbc = sbc + 1;
                end
            end
        end
    end
end

if bit_rate == -1
    tmin = min(t);
    tavg = 0;
    sbc = 0;
    tmax = 0;
    for a = 1:length(t)
        if sbc == 0
            if abs(t(a)-tmin) < abs(t(a)-(2*tmin))
                tavg = tavg + t(a);
                if t(a) > tmax
                    tmax = t(a);
                end
                sbc = sbc + 1;
            end
        else
           if abs(t(a)-(tavg/sbc)) <  abs(t(a)-(2*tavg/sbc))
               tavg = tavg + t(a);
                if t(a) > tmax
                    tmax = t(a);
                end
                sbc = sbc + 1;
           end
        end
    end

    tavg = tavg / sbc; % average bit width in seconds
    disp("bit width found:")
    fq = round(1/(tavg*bit_rate_precision))*bit_rate_precision
    tavg = 1/fq;
else
    tavg = 1/bit_rate;
end

%% interpolate and stack
sr = tavg/samples_per_bit;
interp_time = tstart:sr:tend;
y4f = interp1(time, sig, interp_time, interp_style);
y4f = y4f(1:floor(length(y4f)/(samples_per_bit*bits_per_window))*(samples_per_bit*bits_per_window));

t0=0:interp_time(2)-interp_time(1):(interp_time(2)-interp_time(1))*(samples_per_bit*bits_per_window-1);  %time
t0 = mod(t0-shift, max(t0));
tmp = repmat(t0, length(y4f)/(bits_per_window*samples_per_bit), 1); 
tmp=tmp';
t01=reshape(tmp, 1, []);

disp("prepped")

%% plot the histogram

yrange = round(1.4*height, 3, 'significant');

N = hist3([t01', y4f'],'Edges',...
    {0:sr:bits_per_window*samples_per_bit*sr mid-(yrange/2):height/ares:mid+(yrange/2)},...
    'CdataMode','auto');
disp("histed")

N = darkness*N;
[XX,YY] = meshgrid(0:sr:bits_per_window*samples_per_bit*sr, mid-(yrange/2):height/ares:mid+(yrange/2));
 
 
ZZ=N';
 
surf(XX,YY,ZZ,'EdgeColor','none','FaceColor','interp');
%xlim([0 140]);
%ylim([0 125]);
 
caxis([0 200]);
 
colormap('parula');
 
%% draw gridlines
 hold on
 spacing =floor((length(XX(:,1)))/10);  % play around so it fits the size of your data set
 for i = 1 : spacing : length(XX(:,1))
     plot3(XX(i,:), YY(i,:), ZZ(i,:),':w','Linewidth',1);
 end
 
 spacing2 =(length(XX(1,:))-1)/10;%floor((length(XX(1,:))-1)/10);
 for j = 1:spacing2:length(XX(1,:))
     plot3(XX(:,j), YY(:,j), ZZ(:,j),':w','Linewidth',1);
 end
 
 axis square
 axis off
 view(2)

Timescale = round(max(t0),3,'significant')/10
Vscale = yrange/10