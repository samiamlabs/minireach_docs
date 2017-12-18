%% Best�m f�rh�llandet mellan �nskad vinkelhastighet och uppm�tt vinkelhastighet.
% Denna sektion anv�nder filer d� testet upprepas tv� g�nger i f�ljd i
% samma bagfil. De filer d� testet bara g�rs en g�ng hanteras i n�sta
% sektion

filename = 'angular-step-from0';
%filename = 'angular-step-from01';
bag = rosbag(strcat('bags/', filename, '.bag'));

% Extrahera skickade k�rkommmandon
bagNav = select(bag, 'Topic', '/nav_vel');
nav_vel = timeseries(bagNav, 'Linear.X', 'Angular.Z');

% Extrahera m�tdata
bagSpeed = select(bag, 'Topic', '/flareon/robot_pose');
pos = timeseries(bagSpeed, 'Pose.Position.X', 'Pose.Position.Y', 'Pose.Orientation.Z');

% Ber�kna vinkelhastighet genom att j�mf�ra skillnad i position fr�n topic
% robot_pose. Robot_pose publicerar rotationen av roboten i quaternioner.
% S� m�ste g�ras om till radianer.
angular_velocity = quaternion2angular_velocity(pos.Data(:,3), pos.Time);

% Koordinera s� att alla tidsvektorer utg�r fr�n samma nolltid
t0 = min([pos.Time(1) nav_vel.Time(1)]);
pos_t = pos.Time(1:end) - t0;

% Omvandla angular_velocity till samplingshastighet 40 Hz eftersom detta �r vad
% regulatorn anv�nder
Ts = 1/40;
resampled_data = resample(timeseries(angular_velocity, pos_t), 0:Ts:pos_t(end));

% Hitta v�rde p� de olika stegen
val_step1 = nav_vel.Data(1,2);
val_step2 = -0.3;
val_step3 = nav_vel.Data(end,2);

% Hitta tidpunkt f�r de olika stegen
t = nav_vel.Time(1)-t0;
t_step1 = nav_vel.Time(find(nav_vel.Data(:,2) == val_step2, 1, 'first')) - t0;
t_step2 = nav_vel.Time(find(nav_vel.Data(:,2) == val_step3, 1, 'first')) - t0;
t_step3 = nav_vel.Time(find(nav_vel.Data( floor(t_step2*40):end,2) == val_step1, 1, 'first') + floor(t_step2*40) ) - t0;
t_step4 = nav_vel.Time(find(nav_vel.Data( floor(t_step3*40):end,2) == val_step2, 1, 'first') + floor(t_step3*40) ) - t0;
t_step5 = nav_vel.Time(find(nav_vel.Data( floor(t_step4*40):end,2) == val_step3, 1, 'first') + floor(t_step4*40) ) - t0;
t_step6 = nav_vel.Time(end) - t0;

% G� igenom insignalen och tilldela r�tt v�rde mellan de olika tidsstegen.
% (Kan s�kert g�ras mycket effektivare)
i = find(resampled_data.Time>t, 1, 'first');
input = zeros(1, length(resampled_data.Time));
while t <= t_step1
   input(i) = val_step1;
   t = t + Ts;
   i = i + 1;
end
while t <= t_step2
   input(i) = val_step2;
   t = t + Ts;
   i = i + 1;
end
while t <= t_step3
   input(i) = val_step3;
   t = t + Ts;
   i = i + 1;
end
while t <= t_step4
   input(i) = val_step1;
   t = t + Ts;
   i = i + 1;
end
while t <= t_step5
   input(i) = val_step2;
   t = t + Ts;
   i = i + 1;
end
while t <= t_step6
   input(i) = val_step3;
   t = t + Ts;
   i = i + 1;
end

input = input';
time = resampled_data.Time;
output = resampled_data.Data;

% Fulhack f�r att hantera fel i omvandling fr�n quaternioner till vinkel i
% olika filer
if strcmp(filename, 'angular-step-from01')
    output(1170:1177) = output(1169);
    output = -abs(output);
elseif strcmp(filename, 'angular-step-from0')
    output(438:444) = output(437);
    output(1270:1276) = output(1269);
    output = -abs(output);  
end

% "Klipp ut" estimation- och verifikationsdata
startE = 10;
endE = 30;
timeE = time(startE/Ts);
inputE = input(startE/Ts:endE/Ts);
outputE = output(startE/Ts:endE/Ts);

plot(time, input, 'linewidth', 2)
hold on
plot(time, output, 'linewidth', 2)
ylim([-1 0.1])
% plot([16.38 16.38], [-0.6 0.1], 'k--')
% plot([16.6 16.6], [-0.6 0.1], 'k--')
% plot([31.33 31.33], [-0.6 0.1], 'k--')
% plot([32.1 32.1], [-0.6 0.1], 'k--')
% ylim([-0.6 0.1])
% xlim([15 34])

hLegend = legend({'�nskad Hastighet', 'Uppm�tt'},'Location','best'); 

hXLabel = xlabel('Tid [s]');
hYLabel = ylabel('Rotationshastighet [rad/s]');

set( gca                       , ...
    'FontName'   , 'Helvetica' );
set([hLegend, gca]             , ...
    'FontSize'   , 16           );
set([hXLabel, hYLabel]  , ...
    'FontSize'   , 16          );

set(gca, ...
  'Box'         , 'off'     , ...
  'TickDir'     , 'out'     , ...
  'TickLength'  , [.02 .02] , ...
  'XMinorTick'  , 'on'      , ...
  'YMinorTick'  , 'on'      , ...
  'YGrid'       , 'off'      , ...
  'XColor'      , theme_colour, ...
  'YColor'      , theme_colour, ...
  'LineWidth'   , 1         );

set(gcf, 'PaperPositionMode', 'auto');
%print(strcat('plots/', filename, '/r2r_', filename), '-dpng')

%% Skapa verificationsdata till ident. Ladda in en annan bag f�rst. Exakt
% samma procedur som d� verifikationsdata skapas med skillnaden att data
% sparas i input1 och output1 ist�llet f�r input och output.

filename = 'angular-step-02-to-05';
%filename = 'angular-step-02-to-09';
bag = rosbag(strcat('bags/', filename, '.bag'));

% Extrahera skickade k�rkommmandon
bagNav = select(bag, 'Topic', '/nav_vel');
nav_vel = timeseries(bagNav, 'Linear.X', 'Angular.Z');

bagSpeed = select(bag, 'Topic', '/flareon/robot_pose');
pos = timeseries(bagSpeed, 'Pose.Position.X', 'Pose.Position.Y', 'Pose.Orientation.Z');


% Ber�kna vinkelhastighet genom att j�mf�ra skillnad i position fr�n topic
% robot_pose. Robot_pose publicerar rotationen av roboten i quaternioner.
% S� m�ste g�ras om till radianer.
angular_velocity = quaternion2angular_velocity(pos.Data(:,3), pos.Time);

% Koordinera s� att alla tidsvektorer utg�r fr�n samma nolltid
t0 = min([pos.Time(1) nav_vel.Time(1)]);
pos_t = pos.Time - t0;
nav_t = nav_vel.Time - t0;

% Omvandla angular_velocity till samplingshastighet 40 Hz eftersom detta �r vad
% regulatorn anv�nder
Ts = 1/40;
resampled_data = resample(timeseries(angular_velocity, pos_t), 0:Ts:pos_t(end));

% Hitta v�rde p� de olika stegen
val_step1 = nav_vel.Data(1,2);
val_step2 = nav_vel.Data(end,2);

% Hitta tidpunkt f�r de olika stegen
t = nav_vel.Time(1)-t0;
t_step2 = nav_vel.Time(find(nav_vel.Data(:,2) == val_step2, 1, 'first')) - t0;
t_step3 = nav_vel.Time(end) - t0;

% S�tt insignal till r�tt v�rde. Mellan f�rsta och andra steget ska
% insignalen ha v�rdet av steg 1 = val_step1 och efter det andra
% steget innan slutet av signalen ska det ha v�rdet av det andra steget =
% val_step2.
i = find(resampled_data.Time>t, 1, 'first');
input1 = zeros(1, length(resampled_data.Time));
while t <= t_step2
   input1(i) = val_step1;
   t = t + Ts;
   i = i + 1;
end
while t <= t_step3
   input1(i) = val_step2;
   t = t + Ts;
   i = i + 1;
end

input1 = input1';
time = resampled_data.Time;
output1 = resampled_data.Data;

% Fulhack f�r att hantera fel i omvandling fr�n quaternioner till vinkel
if strcmp(filename, 'angular-step-02-to-09')
    output1(458:464) = output1(457);
    output1(465:end) = -output1(465:end);
elseif strcmp(filename, 'angular-step-02-to-05')
    output1(76:187) = -output1(76:187);
end

% "Klipp bort" b�rjan p� data
time_lim = 5.45;
time = time(time_lim*40:end);
input1 = input1(time_lim*40:end);
output1 = output1(time_lim*40:end);

plot(time, input1, time, output1)
    
%% Ladda in fr�n Systemidentification
Ar2r = ss1.A;
Br2r = ss1.B;
Cr2r = ss1.C;
Dr2r = ss1.D;
save('r2r_low', 'Ar2r', 'Br2r', 'Cr2r', 'Dr2r');



