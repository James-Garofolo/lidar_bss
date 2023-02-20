%% Calculate the position of each mic given the distances and reference point
% Use the law of cosines [1] to ...
% ...compute the angle c (between the lines at mic 1,2 and mic 1,3)
a = 10.5; %distance between mic 1,2
b = 11.5;   %distance between mic 1,3
c = 1;  %distance between mic 2,3
d = 18.3098;  %distance between mic 1,4
e = 15.0333;   %distance between mic 3,4
f = 53; % distance between mirror and mic1
g = 53; % distance between mirror and mic2

%...compute the angle c (between the lines at mic 1,2 and mic 1,3)
ang_c = acos((a^2 + b^2 - c^2)/(2*a*b)); %radians

%...compute the angle e (between the lines at mic 1,4 and mic 1,3)
% d = micDists(1,4); %distance between mic 1,4
% e = micDists(4,3); %distance between mic 4,3
ang_e = acos((b^2 + d^2 - e^2)/(2*b*d)); %radians

ang_fa = acos((f^2 + a^2 -g^2)/(2*f*a));

% Define mic position 1 
mic1Pos = [0,0]; 

% Compute position of mic #2 with the following 2 assumptions
% * it shares the same y coordinate as mic 1
% * it's to the right of mic 2 on the graph 
%   You can switch that the 'left' with minimal changes below. 
mic2Pos(1) = 1*(mic1Pos(1) + a) ; 
mic2Pos(2) = 1*(mic1Pos(2)) ; 

% Compute position of mic #3 [2]
mic3Pos(1) = 1*(mic1Pos(1,1) + b * cos(ang_c)); 
mic3Pos(2) = 1*(mic1Pos(1,1) + b * sin(ang_c)); 

% Compute the position of mic #4 [3]
mic4Pos(1) = 1*(mic1Pos(1,1) + d * cos(ang_c + ang_e)); 
mic4Pos(2) = 1*(mic1Pos(1,1) + d * sin(ang_c + ang_e)); 

mirrorPos(1) = mic1Pos(1) + f*sin(ang_fa);
mirrorPos(2) = mic1Pos(2) + f*cos(ang_fa);

x = [mic1Pos(2),mic2Pos(2),mic3Pos(2),mic4Pos(2), mirrorPos(1)];
y = [mic1Pos(1),mic2Pos(1),mic3Pos(1),mic4Pos(1), mirrorPos(2)];
bottom = max(y);
labels = ["LiDAR Tx", "LiDAR"+newline+"Rx", "", "FSO Tx", "Mirror"];

%plot results on top of previous plot
hold on
for a = 1:length(x)
    scatter(x(a), bottom - y(a), 30, "k","v", "filled");
    if a == 2
        text(x(a)-1, bottom - y(a)+1, labels(a))
    else
        text(x(a)+1, bottom - y(a), labels(a))
    end
end
rectangle('Position',[-2 -.5 7.5, 3.25])
hold off
xlabel('Position (cm)')
ylabel('Position (cm)')



 grid on
 xlim ([-3 60])
 ylim ([-1 12.5])
%% Notes 
%[1]Law of cosines:  https://www.mathsisfun.com/algebra/trig-solving-sss-triangles.html
%[2] the angle needed in the 3rd term is the angle that pivots about mic #1 between the x axis and mic #3
%[3] the angle needed in the 3rd term is the angle that pivots about mic #1 between the x axis and mic #4% %% Calculate the position of each mic given the distances and reference point
% % Use the law of cosines [1] to ...
% % ...compute the angle c (between the lines at mic 1,2 and mic 1,3)
% a = 11.5; %distance between mic 1,2
% b = 11;   %distance between mic 1,3
% c = 1.5;  %distance between mic 2,3
% d = 7.5;  %distance between mic 1,4
% e = 17;   %distance between mic 3,4
% 
% %...compute the angle c (between the lines at mic 1,2 and mic 1,3)
% ang_c = acos((a^2 + b^2 - c^2)/(2*a*b)); %radians
% 
% %...compute the angle e (between the lines at mic 1,4 and mic 1,3)
% % d = micDists(1,4); %distance between mic 1,4
% % e = micDists(4,3); %distance between mic 4,3
% ang_e = acos((b^2 + d^2 - e^2)/(2*b*d)); %radians
% 
% % Define mic position 1 
% mic1Pos = [0,0]; 
% 
% % Compute position of mic #2 with the following 2 assumptions
% % * it shares the same y coordinate as mic 1
% % * it's to the right of mic 2 on the graph 
% %   You can switch that the 'left' with minimal changes below. 
% mic2Pos(1) = mic1Pos(1) + a ; 
% mic2Pos(2) = mic1Pos(2) ; 
% 
% % Compute position of mic #3 [2]
% mic3Pos(1) = mic1Pos(1,1) + b * cos(ang_c); 
% mic3Pos(2) = mic1Pos(1,1) + b * sin(ang_c); 
% 
% % Compute the position of mic #4 [3]
% mic4Pos(1) = mic1Pos(1,1) + d * cos(ang_c + ang_e); 
% mic4Pos(2) = mic1Pos(1,1) + d * sin(ang_c + ang_e); 
% 
% %rotate positions
% %  ang_r = acos(1/20);
% %   mic1Pos(1)= (mic1Pos(1,1).*cos(ang_r) - (mic1Pos(2).*sin(ang_r);
% %  mic1Pos(2)= (mic1Pos(1).*sin(ang_r) + (mic1Pos(2).*cos(ang_r);
% % 
% % mic2Pos(1)= (mic2Pos(1)*cos(ang_r) - (mic2Pos(2)*sin(ang_r);
% % mic2Pos(2)= (mic2Pos(1)*sin(ang_r) + (mic2Pos(2)*cos(ang_r);
% % 
% % mic3Pos(1)= (mic3Pos(1)*cos(ang_r) - (mic3Pos(2)*sin(ang_r);
% % mic3Pos(2)= (mic3Pos(1)*sin(ang_r) + (mic3Pos(2)*cos(ang_r);
% % 
% % mic4Pos(1)= (mic4Pos(1)*cos(ang_r) - (mic4Pos(2)*sin(ang_r);
% % mic4Pos(2)= (mic4Pos(1)*sin(ang_r) + (mic4Pos(2)*cos(ang_r);
% 
% 
% %plot results on top of previous plot
% plot([mic1Pos(1),mic2Pos(1),mic3Pos(1),mic4Pos(1)], ...
%     [mic1Pos(2),mic2Pos(2),mic3Pos(2),mic4Pos(2)], ...
%     'bx','LineWidth',2,'DisplayName', 'Computed position')
% legend()
% 
% 
% 
% 
% % grid on
% % xlim ([-10 15])
% % ylim ([-1 6])
% %% Notes 
% %[1]Law of cosines:  https://www.mathsisfun.com/algebra/trig-solving-sss-triangles.html
% %[2] the angle needed in the 3rd term is the angle that pivots about mic #1 between the x axis and mic #3
% %[3] the angle needed in the 3rd term is the angle that pivots about mic #1 between the x axis and mic #4