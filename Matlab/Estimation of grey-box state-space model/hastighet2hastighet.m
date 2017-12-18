%% Bestäm förhållandet mellan önskad hastighet och uppmätt hastighet. 
% Jämför med stegsvar från test på Toyota - Läs in data

bag = rosbag('bags/linear-step-2.bag');

% Extrahera skickade körkommmandon
bagNav = select(bag, 'Topic', '/nav_vel');
nav_vel = timeseries(bagNav, 'Linear.X', 'Angular.Z');

% Läs in vad som publicerats på topic robot_pose. På denna topic publiceras
% transformen mellan /base_link på trucken och /map. Alltså truckens
% position i förhållande till dess omgivning.
bagSpeed = select(bag, 'Topic', '/flareon/robot_pose');
pos = timeseries(bagSpeed, 'Pose.Position.X', 'Pose.Position.Y', 'Pose.Orientation.Z');

bagJoint = select(bag, 'Topic', '/joint_states');
msgs = readMessages(bagJoint);

vel = zeros(length(msgs), 1);
time = zeros(length(msgs), 1);
abs_time = zeros(length(msgs), 1);

r = 230/2;  % radie på drivhjulet [mm]
t0 = msgs{1}.Header.Stamp.Sec + msgs{1}.Header.Stamp.Nsec * 10^(-9);

% msgs.Position(3) innehåller vinkel på drivhjulet.
% msgs.Velocity(4) innehåller vinkelhastighet på drivhjulet.
for i = 1:length(msgs)
    abs_time(i) = msgs{i}.Header.Stamp.Sec + msgs{i}.Header.Stamp.Nsec * 10^(-9);
    time(i) = msgs{i}.Header.Stamp.Sec + msgs{i}.Header.Stamp.Nsec * 10^(-9) - t0;
    vel(i) = msgs{i}.Velocity(4)*r*10^(-3)*cos(msgs{i}.Position(3));
end

Ts = 1/40;
% Omvandla vel till samplingshastighet 40 Hz eftersom detta är vad
% regulatorn använder

resampled_data = resample(timeseries(vel, time), 0:Ts:time(end));

nav_t = nav_vel.Time - nav_vel.Time(1);
val_step1 = nav_vel.Data(1,1);
val_step2 = nav_vel.Data(end,1);

t_diff = nav_vel.Time(1)-t0;
t_step2 = t_diff + nav_t(find(nav_vel.Data(:,1) == val_step2, 1, 'first'));
t_step3 = t_diff + nav_t(end);

t = t_diff;
i = find(resampled_data.Time>=t, 1, 'first');
input = zeros(1, length(resampled_data.Time));
while t <= t_step2
   input(i) = val_step1;
   t = t + Ts;
   i = i + 1;
end
while t <= t_step3
   input(i) = val_step2;
   t = t + Ts;
   i = i + 1;
end

start = 1;
endE = 14;
input = input(start/Ts:endE/Ts)';
time = resampled_data.Time(start/Ts:endE/Ts);
output = resampled_data.Data(start/Ts:endE/Ts);

velocity = zeros(length(pos.Data), 1);
pos_t = pos.Time(1:end) - min([pos.Time(1) nav_vel.Time(1) abs_time(1)]);

for i = 2:length(pos.Data)
    timeDiff = pos.Time(i) - pos.Time(i-1);
    xDiff = pos.Data(i,1) - pos.Data(i-1,1);
    yDiff = pos.Data(i,2) - pos.Data(i-1,2);
    velocity(i) = sqrt( xDiff^2 + yDiff^2 ) / timeDiff;
end
velocity(1) = velocity(2);

%% Plotta estimeringsdata

plot(time, input, 'linewidth', 2)
hold on;
plot(time, output, 'linewidth', 2);
%plot(pos_t, -velocity, 'linewidth', 2);

legend({'Sent commando', 'Measured from drive wheel angular velocity', 'Measured from position difference'},'Location','southwest','FontSize',12)
    
%% Ladda in verificationsdata

bag = rosbag('bags/linear-step-w-plot.bag');

% Extrahera skickade körkommmandon
bagNav = select(bag, 'Topic', '/nav_vel');
nav_vel = timeseries(bagNav, 'Linear.X', 'Angular.Z');

bagJoint = select(bag, 'Topic', '/joint_states');
joint = timeseries(bagJoint); 
msgs = readMessages(bagJoint);

vel = zeros(length(msgs), 1);
time = zeros(length(msgs), 1);

r = 230/2;  % radie på drivhjulet [mm]
t0 = msgs{1}.Header.Stamp.Sec + msgs{1}.Header.Stamp.Nsec * 10^(-9);

% msgs.Position(3) innehåller vinkel på drivhjulet.
% msgs.Velocity(4) innehåller vinkelhastighet på drivhjulet.
for i = 1:length(msgs)
    time(i) = msgs{i}.Header.Stamp.Sec + msgs{i}.Header.Stamp.Nsec * 10^(-9) - t0;
    vel(i) = msgs{i}.Velocity(4)*r*10^(-3)*cos(msgs{i}.Position(3));
end

% Omvandla vel till samplingshastighet 40 Hz eftersom detta är vad
% regulatorn använder
Ts = 1/40;
resampled_data = resample(timeseries(vel, time), 0:Ts:time(end));

nav_t = nav_vel.Time - nav_vel.Time(1);
val_step1 = nav_vel.Data(1,1);
val_step2 = nav_vel.Data(end,1);

t_diff = nav_vel.Time(1)-t0;
t_step2 = t_diff + nav_t(find(nav_vel.Data(:,1) == val_step2, 1, 'first'));
t_step3 = t_diff + nav_t(end);

t = t_diff;
i = find(time>t, 1, 'first');
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

%% Plotta valideringsdata

plot(time, input1, 'linewidth', 2)
hold on;
plot(time, output1, 'linewidth', 2);

legend({'Sent commando', 'Real'},'Location','northeast','FontSize',12)

% ylim( [ min( [input1 output1 nav_vel.Data(:,2)' ] ) - 0.05
%         max( [input1 output1 nav_vel.Data(:,2)' ] ) + 0.05]);

%% Manuellt framtestad modell

tau_x = 0.27;
k_x = 0.9;
numT = k_x;
denT = [tau_x 1];
G1 = tf(numT, denT);
Delay = 0.5;

s = tf('s');
sys = exp(-Delay*s);    
sysx = pade(sys,2); 
G = sysx*G1;

[ Ah2h, Bh2h, Ch2h, Dh2h ] = tf2ss(G.num{1}, G.den{1});
save('h2h', 'Ah2h', 'Bh2h', 'Ch2h', 'Dh2h');

%% Ladda in från Systemidentification
Ah2h = ss3.A;
Bh2h = ss3.B;
Ch2h = ss3.C;
Dh2h = ss3.D;
save('h2h_low', 'Ah2h', 'Bh2h', 'Ch2h', 'Dh2h');


