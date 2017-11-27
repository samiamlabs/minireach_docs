Component: Precision control
======================

Overview
------------------------
This page explains how the route planning and route following (precision control) works when
 the truck is driving in fork forward direction.

All source code for both route planning and following can be found in move_precise.py

the move_precise function can be divided into the following parts:
* The route is generated using a bezier curve.
* The route is followed using a PID controller which controls the angular velocity.
* While the linear velocity of the truck is controlled with feedback and feedforward.

For a more detailed analysis of the problem see the technical report from 2017 CDIO project :  https://link to webpage

Problem description
------------------------

If the forklift truck receives a mission it first uses a "long planner" in order to move the truck quickly to an approximate position in front of the pallet ordered for pick up
Thereafter with a objective known we need to position the truck with precision in front of the holes, which is our problem in this case.
The problem is further complicated by the fact that the truck has to drive in fork forward direction since the truck then tend to draw away from its track and  end up with wrong angle.

With the current pallet tracking implementation it is important that the angular velocity is not too high since the images might end up with low resolution, thus loosing track of the pallet.
However one wish from toyota is for the truck to be able to execute 90 degree or even u-turns in tight storages.
With tight storages it is meant storages where the truck lack space to stand straight in front of the pallet before starting the precision control.
A solution for this case requires a new method for pallet tracking. However from a control perspective a solution has been developed for the simulation case.

A robust controller that can handle all types of curves was developed during the cdio2017 however this controller has currently only been trimmed for the simulator and currently doesn't work

File location
------------------------
minireach_apps/minireach_tasks/handle_pallets/move_precise.py

Github branches
------------------------

In the models folder all files necessary for the tracker are specified::

  minireach_apps
      ├── Indigo Roccon   (Best controller for real truck, contains bezier planner and pd-controller for angular velocity, linear velocity is constant)
      ├── reglering2017   (Same as Indigo roccon but with a linear velocity control as well as a PID instead of PD for angular_vel)
      ├── cdio-2017       (Best controller for simulation, Same as reglering2017 but with a modified route planning, where the truck sends a target 15 cm in front of goalpose and corrects the angular error before continuing)
      ├── reglering2017ff (Same as reglering2017 but where a feedforward for the angular velocity has been implemented, it currently needs some more modifications to work)

Configuration
------------------------

=========================== ============================================================================
Parameter                    Description
=========================== ============================================================================
filter_error_T              Constant for low-pass filtering of angular error
filter_derivative_T         Constant for low-pass filtering of derivative of angular error
shape_start                 Determines the shape of the start of the planned curve
shape_target                Determines the shape of the end of the planned curve
linear_error_until_half_cor Determines how big the linear error can be until the correction degree is half of maximum
max_linear_correction_deg   Determines the maximum correction degree in order to decrease linear error where 90 degrees is orthogonal to the path
proportional_c              Proportional part of the PID for angular velocity control
derivative_c                Derivative part of the PID for angular velocity control
integrative_c               Integrative part of the PID for angular velocity control
linear_speed_constraint_c   Linear feedback parameter that punishes the speed if the error in last samples has been big
linear_future_speed_const   Linear feedforward parameter that punishes the speed if the truck has to turn in the future
max_linear_speed            Maximum linear movement speed for the truck
max_angular_speed           Maximum angular movement speed for the truck
max_allowed_angle_error_deg Biggest allowed angular error
=========================== ============================================================================

Route planning
------------------------


.. figure:: _static/tracking_init.png
   :width: 100%
   :align: center
   :figclass: align-centered

After 5 iterations each tracker get a score and the tracker with the highest score gets a point every iteration. After 10 iterations the tracker with most points is choosen. It gets verified for another 5 iterations. If the mean score drops below 90, the choosen tracker is too unsure and all the trackers are reinitialized. Otherwise the initialization phase was successful and the pallet should be continiously tracked.

.. figure:: _static/tracking.png
   :width: 100%
   :align: center
   :figclass: align-centered

Angular controller
------------------------

Linear velocity controller
------------------------
