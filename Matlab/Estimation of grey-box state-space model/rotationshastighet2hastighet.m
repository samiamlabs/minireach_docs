%% Bestäm förhållandet mellan önskad vinkelhastighet och uppmätt hastighet.

% Ladda in önskad bagfil
%filename = 'angular-step-02-to-09';
%filename = 'precise-j-1';
filename = 'precise-s';
%filename = 'angular-step-02-to-05';
bag = rosbag(strcat('bags/', filename, '.bag'));


% Extrahera data
bagNav = select(bag, 'Topic', '/nav_vel');
nav_vel = timeseries(bagNav, 'Linear.X', 'Angular.Z');
bagSpeed = select(bag, 'Topic', '/flareon/robot_pose');
pos = timeseries(bagSpeed, 'Pose.Position.X', 'Pose.Position.Y', 'Pose.Orientation.Z');
bagJoint = select(bag, 'Topic', '/joint_states');
msgs = readMessages(bagJoint);


r = 230/2;  % radie på drivhjulet [mm]
t0 = min([(msgs{1}.Header.Stamp.Sec+msgs{1}.Header.Stamp.Nsec * 10^(-9)) nav_vel.Time(1)]);

% Beräkna hastighet utifrån data i joint_states
vel = zeros(length(msgs), 1);
time = zeros(length(msgs), 1);
for i = 1:length(msgs)
    time(i) = msgs{i}.Header.Stamp.Sec + msgs{i}.Header.Stamp.Nsec * 10^(-9) - t0;
    vel(i) = msgs{i}.Velocity(4)*r*10^(-3)*cos(msgs{i}.Position(3));
end

Ts = 1/40;
nav_t = nav_vel.Time - t0;
t = time(1):Ts:time(end);
resampled_vel = resample(timeseries(vel, time), t);
t = nav_t(1):Ts:nav_t(end);
resampled_nav = resample(timeseries(nav_vel.Data, nav_t), t);

e1 = tsdata.event('start of nav_vel messages relative to joint_state', nav_t(1));
e2 = tsdata.event('end of nav_vel messages relative to joint_state', nav_t(end));
resampled_vel_compensated = gettsafteratevent(resampled_vel, e1);
resampled_vel_compensated = gettsbeforeatevent(resampled_vel_compensated, e2);

% Dra bort påverkan från linjär hastighet
h2h = load('h2h');
sys = ss(h2h.Ah2h, h2h.Bh2h, h2h.Ch2h, h2h.Dh2h, Ts);
x0 = zeros(5,1);
influence_from_linear = lsim(sys, resampled_nav.Data(:,1), t, x0, 'zoh');

inp = resampled_nav.Data(:,2);
output = resampled_vel_compensated.Data - influence_from_linear;

%% Plotta estimeringsdata

input = inp;
input_dot = zeros(length(input), 1);
for i = 10:length(t)-9
    input_dot(i) = mean(diff(input(i-9:i+9)));
end
input = abs(input_dot);
output = abs(output);
%plot(nav_t(1:end), 1/fs*abs(input_dot), 'linewidth', 2)
plot(t, 10*input, 'linewidth', 2)
hold on;
plot(t, output, 'linewidth', 2);
%plot(resampled_vel_compensated.Time , resampled_vel_compensated.Data, 'linewidth', 2);
%plot(resampled_vel_compensated.Time , influence_from_linear, 'linewidth', 2);
%plot(nav_t, nav_vel.Data(:,1), 'linewidth', 2)

%ylim( [ min( [input' output' nav_vel.Data(:,2)' ] ) - 0.05
        %max( [input' output' nav_vel.Data(:,2)' ] ) + 0.05]);
        
hLegend = legend({'Önskad Rotationshastighet', 'Rotationshastighetens påverkan på hastigheten'},'Location','northeast','FontSize',12);
hXLabel = xlabel('Tid [s]');

set( gca                       , ...
    'FontName'   , 'Helvetica' );
set([hLegend, gca]             , ...
    'FontSize'   , 8           );
set(hXLabel  , ...
    'FontSize'   , 10          );

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
print(strcat('plots/', filename, '/r2h_', filename), '-dpng')
%close


%% Ladda in från Systemidentification
Ar2h = ss2.A;
Br2h = ss2.B;
Cr2h = ss2.C;
Dr2h = ss2.D;
save('r2h', 'Ar2h', 'Br2h', 'Cr2h', 'Dr2h');





