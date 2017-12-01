Component: Robot Description
============================

Overview
--------

The model used in the simulation environment is defined according to the URDF (Unified Robot Description Format) standard. The files defining the model (having .xacro and .gazebo file extensions) are located in the ``minireach_description`` package in the main ``minireach`` repository.

The main file for the robot model is called ``minireach.xacro``. In this file, certain parameters are defined and sub-model files are called. The major sub-assemblies of the model (cab, drive wheel, stand, ...) are defined in separate sub-models, located in the ``urdf/assemblies`` folder.


Drive Wheel Offset
------------------

The drive wheel on the physical forklift has a small axial offset from the steer servo rotational axis, which gives the forklift a certain behavior. When modeling this offset, a parameter has been introduced to make adjustments of this measure easy to achieve. This parameter is defined in the main file ``minireach.xacro``::

<property name="drive_wheel_offset"	value="-0.0037" />


The value of the offset was determined from drawings and CAD files of the original wheel to be -3.7 mm with the minus sign indicating the direction of the offset.

Control of Modeled Actuators
----------------------------

In the robot model, certain elements called transmissions are used to define a connection between an actuator and a modeled joint. For these transmissions, joint command interfaces are specified (Position, Velocity or Effort Joint Interface). For example, the wheel_steer_joint transmission (the steer servo) is of the Position Joint Interface type. For this specific interface type, it turned out that it is of ABSOLUTE IMPORTANCE to specify PID parameters for the controller of the interface to make the simulation wok in the desired way. This is done in the ``minireach_control.yaml`` file in the ``minireach_control`` package in the main ``minireach`` repository. Make sure this file contains a ``gazebo_ros_control`` section with PID gains for the joint in question::

  gazebo_ros_control:
    pid_gains:
      wheel_steer_joint: {p: 200.0, i: 0, d: 0}

.. NOTE:: If these parameters are not specified, the simulation will not take the physics into account while moving the actuator. In the case of the implementation of the drive wheel offset, the drive wheel servo would spin around without taking the contact between the wheel and the underlying surface into account.

Future work
-----------

  * Both the model and the controllers (in the ``minireach_control`` package) contains a lot of different limit values, for e.g. positions, speeds and accelerations. When implementing the drive wheel offset, it was found that the maximum rotational speed of the steer servo was significantly too low. Hence, this maximum speed value was then corrected. Though, the question is: how precise is the rest of the limit values of the model? This is something that should be investigated to make the simulated model behave more like the physical forklift. 
