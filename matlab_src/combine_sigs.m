clc
clear all
path = "C:\Users\JimG9\Desktop\neuromorphic_photonics\data\lidar_interference\stuff yang collected\Collect\29G\";

out_fq = 2e10;
out_size = 400000;
whole = [];
for a = 1:10
    disp(a)
    file = readtable(strcat(path, string(a), '.csv'));
    piece = table2array(file(3:end,2));
    timescale = table2array(file(3:end,1));
    
    offset = length(whole);
    c = 1;
    for b = 1:length(piece)
        if mod(timescale(b), (1/out_fq)) < 1e-15
            whole(c+offset) = piece(b);
            c = c + 1;
        end
    end
end

if length(whole) < out_size
    duplicates = out_size/length(whole);
    copy = whole;
    for a = 1:(duplicates-1)
        whole = [whole copy];
    end
end

time = 0:1/out_fq:(1/out_fq)*(length(whole)-1);
writematrix([whole' time'], "interference_2.9.csv", 'Delimiter',',');
    