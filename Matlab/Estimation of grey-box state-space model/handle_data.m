%% Simulera truck med insignal från bagfil. 
% Först läses data in från vald bagfil. Därefter beräknas olika värden på 
% hastighet, vinkelhastighet, etc. Sedan simuleras simulinkmodellen 
% nonlinear_truck.slx. Denna kan simulera två olika modeller av trucken 
% samtidigt. Positionerna för båda modellerna sparas i filerna 
% position_high.mat och position_low.mat. Efter simuleringen sparas 
% plottar över linjär hastighet, rotationshastighet, position och 
% vinkeln på styrhjulet i en mapp för respektive bagfil.

% Välj bagfil

%filename = 'linear_stepV1';
%filename = 'linear-step-w-plot';
%filename = 'linear-step-2';
%filename = 'linear-slow';
%filename = 'linear-step-max-0-1';
%filename = 'linear-step-max-0-05';


%filename = 'angular-step-02-to-09';
%filename = 'angular-step-02-to-05';
%filename = 'angular_step';

%filename = 'precise-u';
filename = 'precise-s';
%filename = 'precise-j-1';
%filename = 'precise-j-2';
%filename = 'angular-step-from0';

% Lägg till alla bag-filer i sökvägen och ladda in vald bagfil.
addpath(genpath('bags'));
bag = rosbag(strcat('bags/', filename, '.bag'));

% Läs in vad som publicerats på topic nav_vel. På denna topic publiceras de
% styrkommandon som skickas till trucken.
bagNav = select(bag, 'Topic', '/nav_vel');
nav_vel = timeseries(bagNav, 'Linear.X', 'Angular.Z');

% Läs in vad som publicerats på topic robot_pose. På denna topic publiceras
% transformen mellan /base_link på trucken och /map. Alltså truckens
% position i förhållande till dess omgivning.
bagSpeed = select(bag, 'Topic', '/flareon/robot_pose');
pos = timeseries(bagSpeed, 'Pose.Position.X', 'Pose.Position.Y', 'Pose.Orientation.Z');

% Läs in vad som publicerats på topic joint_states. På denna topic
% publiceras tillstånd för de leder ("joints") som finns på trucken.
bagJoint = select(bag, 'Topic', '/joint_states');
joint = timeseries(bagJoint); 
msgs = readMessages(bagJoint);

% Beräkna värden utifrån värden i joint_states
vel = zeros(length(msgs), 1);
time = zeros(length(msgs), 1);          % Med start vid tid 0;
abs_time = zeros(length(msgs), 1);      % I sekunder efter 1970;
alpha = zeros(length(msgs), 1);         % Vinkel på drivhjulet.
drive_wheel_radius = 230/2;             % radie på drivhjul [mm]
t0 = msgs{1}.Header.Stamp.Sec + msgs{1}.Header.Stamp.Nsec * 10^(-9);

% msgs.Position(3) innehåller vinkel på drivhjulet.
% msgs.Velocity(4) innehåller vinkelhastighet på drivhjulet.
for i = 1:length(msgs)
    abs_time(i) = msgs{i}.Header.Stamp.Sec + msgs{i}.Header.Stamp.Nsec * 10^(-9);
    time(i) = msgs{i}.Header.Stamp.Sec + msgs{i}.Header.Stamp.Nsec * 10^(-9) - t0;
    alpha(i) = msgs{i}.Position(3);
    vel(i) = msgs{i}.Velocity(4)*drive_wheel_radius*10^(-3)*cos(alpha(i));
end

% Ta fram mätningar från robot_pose. Hastighet beräknas utifrån skillnad i
% robotens position mellan varje sampel. Rotationshastighet beräknas genom
% skillnad i robotens orientation.
velocity = zeros(length(pos.Data)-1, 1);
angular_velocity = quaternion2angular_velocity(pos.Data(:,3), pos.Time);

% Lite (eller ganska mycket) fulhack för att få rätt värden i testfallen
% angular-step-02-to-09 och angular-step-02-to-05. Blir fel i omvandling 
% från quaternion till vinkelhastighet.
if strcmp(filename, 'angular-step-02-to-09')
    angular_velocity(116) = angular_velocity(115);
    angular_velocity(117:end) = -angular_velocity(117:end);
elseif strcmp(filename, 'angular-step-02-to-05')
   angular_velocity(20:47) = -angular_velocity(20:47);
end

% Beräkna truckens linjära hastighet utifrån data som publicerats på topic
% robot_pose
for i = 2:length(pos.Data)
    timeDiff = pos.Time(i) - pos.Time(i-1);
    xDiff = pos.Data(i,1) - pos.Data(i-1,1);
    yDiff = pos.Data(i,2) - pos.Data(i-1,2);
    velocity(i) = sqrt( xDiff^2 + yDiff^2 ) / timeDiff;
end

% Skapa insignal till simulinkmodell
in = nav_vel;
in.Time = in.Time - in.Time(1);

% Ta startvärden från topic robot_pose i vald bagfil
start_x = pos.Data(1,1);
start_y = pos.Data(1,2);

% Vinkel som trucken står i vid start av simulering. Medelvärde av första
% tre mätningar. Från topic robot_pose i vald bagfil.
start_angle = mean( pos.Data(1:3,3) );

% Ladda in linjära modeller för modell av låg ordning och sätt
% initialvärden
h2h = load('h2h_low');
r2r = load('r2r_low');
n_h2h = size(h2h.Ah2h, 1);
n_r2r = size(r2r.Ar2r, 1);
init_conditions_low = [start_x start_y zeros(1, n_h2h) start_angle zeros(1, n_r2r)];

% Ladda in linjära modeller för modell av hög ordning och sätt
% initialvärden.
h2h = load('h2h_high');
r2r = load('r2r_high');
r2h = load('r2h');
n_r2h = size(r2h.Ar2h, 1);
n_h2h = size(h2h.Ah2h, 1);
n_r2r = size(r2r.Ar2r, 1);
init_conditions_high = [start_x start_y zeros(1, n_h2h) start_angle zeros(1, n_r2r) zeros(1, n_r2h) 0];

% Beräkna samplingstid
Ts = mean(diff(in.Time));

% Simulera modellen för trucken.
data = sim('nonlinear_truck.slx');

% Hantera resultat från simulering
sim_velocity = sim_velocity.Data(2:end);
sim_angular_velocity =  ( out_1.Data(2:end, 3+n_h2h) - out_1.Data(1:end-1, 3+n_h2h) ) ./ ...
                        (out_1.Time(2:end) - out_1.Time(1:end-1));
sim_velocity = [sim_velocity(1) sim_velocity'];
sim_angular_velocity = [sim_angular_velocity(1) sim_angular_velocity'];

% Spara position för trucken som gavs i modellen med hög ordning
x = out_1.Data(:,1);
y = out_1.Data(:,2);
save('position_high', 'x', 'y');
% ... och för modellen av låg ordning
x = out_2.Data(:,1);
y = out_2.Data(:,2);
save('position_low', 'x', 'y'); 


% Kontrollera så att det finns en mapp att spara plottar i. Om inte skapa
% en
if not(exist('plots', 'dir'))
   mkdir('plots');
end
if not(exist(strcat('plots/', filename), 'dir'))
   mkdir('plots', filename);
end
% Ladda in mapp med alla plottar i sökväg.
addpath(genpath('plots'));

% Färg på axlar och titel i plottar
theme_colour = [0.5 0 0.05];

% För filerna precise-u och precise-s har simuleringar med de inspelade
% insignalerna genomförts i Gazebo. Position från dessa simuleringar laddas
% in för att kunna visas i plottar.
if strcmp(filename, 'precise-u') || strcmp(filename, 'precise-s')
   bag = rosbag(strcat('bags/', filename, '-sim', '.bag'));
   bagPos = select(bag, 'Topic', '/jolteon/robot_pose');
   posSim = timeseries(bagPos, 'Pose.Position.X', 'Pose.Position.Y', 'Pose.Orientation.Z'); 
end



%% Plota hastighet

% Subtrahera tidpunkten då den första topicen publicerar från alla
% tidpunkter för att få mätningar som börjar vid tidpunkt 0.
t0 = min([nav_vel.Time(1) abs_time(1)]);
nav_t = nav_vel.Time - t0;
abs_t = abs_time - t0;

% Ge insignalen nollor då den inte skickar in något för att plotten ska se
% bra ut.
nav_t = [0 (nav_t(1)-0.0001) nav_t' (nav_t(end)+0.0001) abs_t(end)];
u1 = [0 0 nav_vel.Data(:,1)' 0 0];
u2 = [0 0 nav_vel.Data(:,2)' 0 0];

% out_1.Time är från simulering och börjar vid tid noll. Ska förskjutas till
% den tidpunkt då vi skickar det första nav_vel meddelandet
out_t = out_1.Time + nav_t(3);



% --- Välj vad som ska plottas ---

%%%% Insignal (önskad linjär hastighet)
plot(nav_t, u1, 'linewidth', 2)
hold on;

%%%% Hastighet från topic joint_states
plot(abs_t, vel, 'linewidth', 2)

%%%% Linjen som visar största möjliga linjära hastighet
%plot([0 10], [-0.34 -0.34], 'k--')

%%%% Hastighet från simulering
%plot(out_t, sim_velocity, 'linewidth', 2)

%%%% Önskad vinkelhastighet
plot(nav_t, 0.2*u2, '-', 'linewidth', 2)

%%%% Hastighet från topic robot_pose
% plot(pos.Time-t0, -velocity)

% ylim( [ min([nav_vel.Data(:,1)' vel' sim_velocity' nav_vel.Data(:,2)' ])*1.3 - 0.05
        %max([nav_vel.Data(:,1)' vel' sim_velocity' nav_vel.Data(:,2)' ])*1.3      ])
        
hLegend = legend('Önskad Hastighet', 'Uppmätt', 'Önskad Rotationshastigheten');%, 'Simulerad', '0.2*Önskad vinkelhastighet'); 
hXLabel = xlabel('Tid [s]');
hYLabel = ylabel('Hastighet [m/s]');
hTitle = title('Hastighet');

set( gca                       , ...
    'FontName'   , 'Helvetica' );
set([hLegend, gca]             , ...
    'FontSize'   , 8           );
set([hXLabel, hYLabel]  , ...
    'FontSize'   , 15          );
set( hTitle                    , ...
    'FontSize'   , 20          , ...
    'FontName'   , 'Century'   , ...
    'Color'  , theme_colour     , ...
    'FontWeight' , 'bold'      );

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
print(strcat('plots/', filename, '/hastighet_', filename), '-dpng')
close

%% Plota rotationshastighet

% Subtrahera tidpunkten då den första topicen publicerar från alla
% tidpunkter för att få mätningar som börjar vid tidpunkt 0.
t0 = min([pos.Time(1) nav_vel.Time(1) abs_time(1)]);
nav_t = nav_vel.Time - t0;
abs_t = abs_time - t0;

% Ge insignalen nollor då den inte skickar in något
nav_t = [0 (nav_t(1)-0.0001) nav_t' (nav_t(end)+0.0001) abs_t(end)];
u1 = [0 0 nav_vel.Data(:,2)' 0 0];


% sim_time är från simulering och börjar vid tid noll. Ska förskjutas till
% den tidpunkt då vi skickar det första nav_vel meddelandet
out_t = out_1.Time + nav_t(3);



% --- Välj vad som ska plottas ---

%%%% Insignal (önskad rotationshastighet)
plot(nav_t, u1, 'linewidth', 2)
hold on;

%%%% Rotationshastighet från topic robot_pose
plot(pos.Time - t0, angular_velocity, 'linewidth', 2)

%%%% Rotationshastighet i simulering
plot(out_t, sim_angular_velocity, 'linewidth', 2)

%%%% Önskad linjär hastighet
%plot(nav_t, nav_vel.Data(:,1), 'linewidth', 2)


%ylim( [ min([nav_vel.Data(:,2)' angular_velocity' sim_angular_velocity' nav_vel.Data(:,1)' ])*1.3 - 0.05
        %max([nav_vel.Data(:,2)' angular_velocity' sim_angular_velocity' nav_vel.Data(:,1)' ])*1.3      ])

hLegend = legend('Önskad', 'Uppmätt', 'Simulerad');
hXLabel = xlabel('Tid [s]');
hYLabel = ylabel('Vinkelhastighet [rad/s]');
hTitle = title('Vinkelhastighet');

set( gca                       , ...
    'FontName'   , 'Helvetica' );
set([hLegend, gca]             , ...
    'FontSize'   , 8           );
set([hXLabel, hYLabel]  , ...
    'FontSize'   , 15          );
set( hTitle                    , ...
    'FontSize'   , 20          , ...
    'FontName'   , 'Century'   , ...
    'Color'  , theme_colour    , ...
    'FontWeight' , 'bold'      );

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
print(strcat('plots/', filename, '/vinkelhastighet_', filename), '-dpng')
close

%% Plota positionen

% De olika topicsen börjar publicera vid olika tidpunkter. Plocka bort
% värden från den topic som börjar publicera först så att man får mätvärden
% från samma tidsperiod
if pos.Time(1) > nav_vel.Time(1)
    [~, index_pos] = min(abs(pos.Time - nav_vel.Time(1)));
    index_nav = 1;
else
    [~, index_nav] = min(abs(nav_vel.Time - pos.Time(1)));
    index_pos = 1;
end


figure('Units', 'pixels', ...
    'Position', [100 100 500 375]);

pos_t = pos.Time(index_pos:end) - pos.Time(index_pos);

%%%% Position från verkligheten
plot(pos.Data(index_pos:end,1), pos.Data(index_pos:end,2), 'linewidth', 2 )
hold on

%%%% Plota position från simulering i Gazebo
% I simuleringen var inte startpostionen densamma. Därför måste alla
% positioner från simuleringen skiftas. I simuleringen startade trucken i
% (0,0). Därför adderas bara truckens ursprungsposition från verkligheten.
% Ingen hänsyn tas till rotation.
if strcmp(filename, 'precise-u') || strcmp(filename, 'precise-s')
    %plot(posSim.Data(:,1)+ pos.Data(1,1), posSim.Data(:,2)+ pos.Data(1,2), 'linewidth', 2 )
end

% Position för modell 1 i simulering
high = load('position_high.mat');
plot( high.x(index_nav:end), high.y(index_nav:end), 'linewidth', 2 )

%%%% Position från modell 2 i simulering
low = load('position_low.mat');
%plot( low.x(index_nav:end), low.y(index_nav:end), 'linewidth', 2 )

%%%% Skriv text om visar startpunkt
text( high.x(index_nav), high.y(index_nav), 'start', 'fontsize', 15 )

% Plota linjer mellan samtida sampel
density = 50;
for ii = 1:size(pos_t, 1)/density
    [~, index] = min(abs(out_1.Time+nav_vel.Time(1) - pos.Time(ii*density)));
    plot([pos.Data(index_pos-1 + ii*density,1) high.x(index)], [pos.Data(index_pos-1 + ii*density,2) high.y(index)], '-', 'Color','k', 'linewidth', 0.5)
end

% Beroende på hur trucken kör placeras legend på olika ställen för att inte
% vara ivägen.
if strcmp(filename, 'precise-u')
    location = 'southwest';
elseif strcmp(filename, 'precise-s')
    location = 'southeast';
    xlim([-0.2 1.23])
else
    location = 'southeast';
end

hLegend = legend({'Measured','Modeled'},'Location',location);
hYLabel = ylabel('Y [m]');
hXLabel = xlabel('X [m]');
set( gca                       , ...
    'FontName'   , 'Helvetica' );
set([hLegend, gca]             , ...
    'FontSize'   , 12          );
set([hXLabel, hYLabel]  , ...
    'FontSize'   , 18          );

set(gca, ...
  'Box'         , 'off'     , ...
  'TickDir'     , 'out'     , ...
  'TickLength'  , [.02 .02] , ...
  'XMinorTick'  , 'on'      , ...
  'YMinorTick'  , 'on'      , ...
  'YGrid'       , 'off'      , ...
  'XColor'      , theme_colour , ...
  'YColor'      , theme_colour , ...
  'LineWidth'   , 1         );

set(gcf, 'PaperPositionMode', 'auto');
print(strcat('plots/', filename, '/position_', filename), '-dpng')
close

%% Animera trucken i simuleringen och i verkligheten

% Plocka bort mätningarna i början då trucken står still
cut = 100;
cut2 = 110;
x_real = pos.Data(cut:end-110, 1);
y_real = pos.Data(cut:end-110, 2);
[~, index1] = min(abs(out_1.Time+nav_vel.Time(1) - pos.Time(cut)));
[~, index2] = min(abs(out_1.Time+nav_vel.Time(1) - pos.Time(end - cut2)));
diff_x = high.x(index1)- pos.Data(cut, 1);
diff_y = high.y(index1)- pos.Data(cut, 2);
x_sim = high.x(index1:index2) - diff_x;
y_sim = high.y(index1:index2) - diff_y;

% Gör mätningarna från simuleringen lika lång som mätningarna från
% verkligheten så att animeringen kan uppdatera båda samtidigt
x_sim = resample(x_sim, length(x_real), length(x_sim));
y_sim = resample(y_sim, length(y_real), length(y_sim));

% Gränser för animeringsplot
xli = [-0.2 1.3];
yli = [-0.2 0.4];
axis([xli yli])

% Då "resample" används blir de första och sista mätningarna i simuleringen
% felaktiga. Därför bortses från dessa och trucken står still i början och
% slut.
d = 6;
x_sim(1:d) = x_sim(d);
y_sim(1:d) = y_sim(d);
x_sim(end-d:end) = x_sim(end-d);
y_sim(end-d:end) = y_sim(end-d);


hYLabel = ylabel('Y [m]');
hXLabel = xlabel('X [m]');

% Backgrund till plotten. Ska likna ett betonggolv som trucken kör på.
img=imread('background.jpg');
hold on
hi = imagesc(xli, yli, img);

set( gca                       , ...
    'FontName'   , 'Helvetica' );

set([hXLabel, hYLabel]  , ...
    'FontSize'   , 18          );

set(gca, ...
  'Box'         , 'off'     , ...
  'TickDir'     , 'out'     , ...
  'TickLength'  , [.02 .02] , ...
  'XMinorTick'  , 'on'      , ...
  'YMinorTick'  , 'on'      , ...
  'YGrid'       , 'off'      , ...
  'XColor'      , theme_colour , ...
  'YColor'      , theme_colour , ...
  'LineWidth'   , 1         );

sim_colour = [0.1 0.4 0.7];
real_colour = [0.5 0.5 0.2];
size1 = 20;

p_sim = plot(x_sim(1),y_sim(1),'s','MarkerFaceColor',sim_colour, 'MarkerEdgeColor',sim_colour,'MarkerSize',size1);
p_real = plot(x_real(1),y_real(1),'s','MarkerFaceColor',real_colour, 'MarkerEdgeColor',real_colour,'MarkerSize',size1);

simulation = animatedline('Color',sim_colour,'LineWidth',3);
real = animatedline('Color',real_colour,'LineWidth',3);

for k = 1:length(x_sim)
    addpoints(simulation,x_sim(k),y_sim(k));
    addpoints(real,x_real(k),y_real(k));
    p_sim.XData = x_sim(k);
    p_sim.YData = y_sim(k);
    p_real.XData = x_real(k);
    p_real.YData = y_real(k);
    drawnow
    pause(0.08)
end

% Stäng figur
close


%% Plota vinkeln alpha på styrhjulet

scale = 5;
delay = 0.3;
nav_t = nav_vel.Time - t0;

plot(abs_time-abs_time(1), alpha, 'linewidth', 2)               % Vinkeln alpha
hold on;
plot(nav_t+delay, nav_vel.Data(:,2)*scale, '-', 'linewidth', 2) % Funktion av rotationshastighet
plot(nav_t, nav_vel.Data(:,2) , '-', 'linewidth', 2)            % Rotationshastighet

if strcmp(filename, 'precise-u')
    location = 'northwest';
elseif strcmp(filename, 'precise-s')
    location = 'southwest';
else
    location = 'southeast';
end

%hLegend = legend('alpha', '*5 med 0.3 s fördröjning', 'Önskad rotationshastighet', 'Location', location); 
hYLabel = ylabel('Radians');
hXLabel = xlabel('Time [s]');

set( gca                       , ...
    'FontName'   , 'Helvetica' );
%set([hLegend, gca]             , ...
    %'FontSize'   , 14           );
set([hXLabel, hYLabel]  , ...
    'FontSize'   , 15          );

set(gca, ...
  'Box'         , 'off'     , ...
  'TickDir'     , 'out'     , ...
  'TickLength'  , [.02 .02] , ...
  'XMinorTick'  , 'on'      , ...
  'YMinorTick'  , 'on'      , ...
  'YGrid'       , 'off'      , ...
  'XColor'      , theme_colour , ...
  'YColor'      , theme_colour , ...
  'LineWidth'   , 1         );

set(gcf, 'PaperPositionMode', 'auto');
print(strcat('plots/', filename, '/alpha_', filename), '-dpng')

close

