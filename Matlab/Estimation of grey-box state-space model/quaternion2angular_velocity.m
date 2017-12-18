function [angular_velocity] = quaternion2angular_velocity(quat, time)

angles = 2*asin(quat);
angular_velocity = zeros(length(quat), 1);
for i = 2:length(angles)
    timeDiff = time(i) - time(i-1);
    d1 = angles(i);
    d2 = angles(i-1);
    
    % Båda vinklarna är antingen positiva eller negativa
    if d1 >= 0 && d2 >=0 || d1 <= 0 && d2 <= 0
        angular_velocity(i) = (d1-d2) / timeDiff;
        
    % Går från positivt till negativt
    elseif d1 <= 0 && d2 >= 0
        
        % Runt 0 (typ 0.1 -> -0.1)
        if d1 >= -pi/2 && d2 <= pi/2
            angular_velocity(i) = (d1-d2) / timeDiff;
            
        % Runt pi (typ 3.10 -> -3.11)
        else
            angular_velocity(i) = (2*pi+d1-d2) / timeDiff; 
        end
        
    % Går från negativit till positivt
    else 
        % Runt 0 (typ -0.1 -> 0.1)
        if d1 <= pi/2 && d2 >= -pi/2
            angular_velocity(i) = (d1-d2) / timeDiff;
            
        % Runt pi (typ -3.10 -> 3.11)
        else
            angular_velocity(i) = (2*pi-d1+d2) / timeDiff; 
        end 
    end
end
angular_velocity(1) = angular_velocity(2);


end