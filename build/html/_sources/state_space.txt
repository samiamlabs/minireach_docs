Component: State space model 
======================

Overview
------------------------
Generating a state space representation using a 'black box model' with MATLAB includes the following steps

* Recording step-responses with rosbag
* Generating the model with MATLAB

  * prepare input and output data from rosbag files
  * estimate a model using MATLAB application Sytem Identification Toolbox
  
For the MATLAB code to work, the following applications are required:

* `Robotics System Toolbox <https://se.mathworks.com/products/robotics.html>`_
* `System Identification Toolbox <https://se.mathworks.com/products/sysid.html>`_

Documentation for ``rosbag`` can be found at: http://wiki.ros.org/rosbag

Files neccesary to generate the model
------------------------

The matlab_ss folder contains all neccessary files and includes the following::

  minireach_docs/
  └── matlab_ss
      ├── handle_data.m
      ├── h2h.m
      ├── v2v.m
      ├── quaternion2angular_velocity.m
      └── nonlinear_truck.slx
      
================================= ============================================================================
File                              Description
================================= ============================================================================
handle_data.m                     Run simulation of nonlinear_truck and plot various results.
h2h.m                             Load a linear-step rosbag file and generate state space matrices for the linear part.
v2v.m                             Load a angular-step rosbag file and generate state space matrices for the angular part.
quaternion2angular_velocity.mat   Handles conversion between quaternions and angular velocity.
nonlinear_truck.slx               Simulink model of the discrete nonlinear truck. The 'discrete_truck' within the simulink model handles the final discrete state space matrix. 
================================= ============================================================================

Black box model outline
------------------------
This 'black box' approach uses System Identification Toolbox to estimate a state space model with just input and output data. 
The important data will be recorded in files using ``rosbag`` and MATLAB will in trun require Robotics System Toolbox to read these files.  

Recording data with rosbag
------------------------
Before recording any data for use in this code, it is recommended to prepare suitable step-responses in linear velocity as well as angular velocity in test cases to run on the truck.

ROS-topics to record:

* nav_vel - control signals / input to the truck
* robot_pose - position in x, y and z (quaternion)
* joint_states - includes velocity and angle of the steer wheel

Depending on which live truck will used, the name preceding the robot_pose topic will vary. Using the flareon truck will result in the following command:

::

   rosbag record /nav_vel /flareon/robot_pose /joint_states
   
Suggestions for extensions
------------------------
* Expand on the extra MATLAB-file: v2h.m containing work on the impact of angular velocity on linear velocity.
* Further look into approximations of the position model and possibly linearization of this model.
