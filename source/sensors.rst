Sensor Overview
---------------

Base Laser
++++++++++

MiniReach has a Hokuyo URG-04LX-UG01 scanning range finder. The
laser has a range of 5.6m, 240° field of view, 10Hz update rate
and angular resolution of 0.36°. The laser publishes distance
to the **scan** topic.

IMU
+++

NOTE: NOT IMPLEMENTED

MiniReach has a 6-axis inertial measurement unit (IMU) called ?(MPU9250) 
in the base. See :ref:`imu_api` for details on the ROS API.

3D Camera
+++++++++++

MiniReach has a ZED stereo camera (alternatively Orbbec Astra) in the fork direction. This
camera is best calibrated in the 0.7-20m range (0.4-8m for Astra). See :ref:`camera_api`
for details on the ROS API.
