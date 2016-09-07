API Overview
============

One of the ways in which we have tried to create a good experience for 
new developers is by using standard ROS interfaces. This means that code you
might have written for other robots in the past should be easily portable
to your new robot.

Whenever possible, we have conformed to the
`ROS Enhancement Proposals (REPs) <http://www.ros.org/reps/rep-0000.html>`_.
These documents provide the foundation of standard ROS interfaces. 

In addition to REP-compatible interfaces, we have adopted a number of the community-accepted
standard interfaces, such as those provided by the
`control_msgs <http://wiki.ros.org/control_msgs>`_ package.


Fork and Reach
--------------

The fork and reach of the robot are controlled by an interface defined in
`robot_mechanism_controllers/JointPositionController <http://wiki.ros.org/robot_mechanism_controllers/JointPositionController>`_

Publishing a float to the /minireach/fork_position_controller/command topic will make the controller try to move the fork to a hight over the ground defined by the value of that float in meters.

The reach joint can be controlled in a similar manner by publishing to /minireach/reach_position_controller/command.


Only one controller is allowed to control a joint at a time.

.. _base_api:

Base Interface
--------------
Support for mobile bases is quite standard and robust in ROS, however it is one
of the older interfaces. As such, it is one of the few interfaces which is not
action-based.

The mobile base subscribes to `base_controller/command`, and accepts a
`geometry_msgs/Twist <http://docs.ros.org/api/geometry_msgs/html/msg/Twist.html>`_
message.

Only two fields are used in the message:

 * ``linear.x`` specifies the robot's forward velocity
 * ``angular.z`` specifies the robot's turning velocity

User applications will typically not connect directly to `base_controller/command`,
but rather to `cmd_vel`. A multiplexer is always running between `teleop_vel`
and `cmd_vel`. Whenever the deadman on the robot controller is held, `teleop_vel`
will override `cmd_vel`. The advantage of having your application publish to `cmd_vel`
rather than directly to `base_controller/command` is that you can override bad
commands by simply pressing the deadman on the robot controller.

NOTE: SPEED REDUCTION IN BASE CONTROLLER IS NOT YET IMPLEMENTED

The base controller implements a speed reduction when in the proximity of
obstacles. This will not entirely stop the robot if it is about to hit something,
but will prevent full speed collisions.

.. _head_api:

3D Camera Tilt Interface
------------------------

NOTE: TILTABLE 3D CAMERA WILL BE ADDED TO SIMULATION AND REAL ROBOT SOON

The 3D camera in the fork facing direction on the robot is controlled by an 
interface defined in `robot_mechanism_controllers/JointPositionController <http://wiki.ros.org/robot_mechanism_controllers/JointPositionController>`_

Publishing a float to the /minireach/camera_tilt_controller/command topic will make the controller try to move the camera tilt axis to the angle defined by the value of that float in radians.

.. _camera_api:

3D Camera Interface
-------------------

We have been avaluating two different 3D cameras for the MiniReach, the ZED stereo camera and the structured light based (kinect like) Orbbec Astra.

The following infromation is for the Orbbec Astra.

The fork facing camera exposes several topics of interest:

 * `camera/depth_registered/points` is a `sensor_msgs/PointCloud2 <http://docs.ros.org/api/sensor_msgs/html/msg/PointCloud2.html>`_
   which has both 3d and color data. It is published at VGA resolution (640x480)
   at 30Hz.
 * `head_camera/depth_downsampled/points` is a `sensor_msgs/PointCloud2 <http://docs.ros.org/api/sensor_msgs/html/msg/PointCloud2.html>`_
   which has only 3d data. It is published at QQVGA (160x120) resolution at
   30Hz and is intended primarily for use in navigation/moveit for obstacle
   avoidance. (implemented for the Astra?)
 * `head_camera/depth/image_raw` is a `sensor_msgs/Image <http://docs.ros.org/api/sensor_msgs/html/msg/Image.html>`_.
   This is unit16 depth image (2D) in mm . It is published at VGA resolution (640x480)
   at 30Hz.
 * `head_camera/depth/image` is a `sensor_msgs/Image <http://docs.ros.org/api/sensor_msgs/html/msg/Image.html>`_.
   This is float depth image (2D) in m. It is published at VGA resolution (640x480)
   at 30Hz.
 * `head_camera/rgb/image_raw` is a `sensor_msgs/Image <http://docs.ros.org/api/sensor_msgs/html/msg/Image.html>`_.
   This is just the 2d color data. It is published at VGA resolution (640x480)
   at 10Hz.

.. _laser_api:

Laser Interface
---------------

`scan` is a `sensor_msgs/LaserScan <http://docs.ros.org/api/sensor_msgs/html/msg/LaserScan.html>`_
message published at 10Hz.

.. _imu_api:

IMU Interface
-------------

NOTE: THE ROBOT CURRENTLY HAS NO IMU BUT ONE MAY BE ADDED SOON

`imu` is a `sensor_msgs/Imu <http://docs.ros.org/api/sensor_msgs/html/msg/Imu.html>`_
message published at ?(100Hz). This message contains the linear acceleration and
rotational velocities as measured by the IMU located in the base of the robot.

