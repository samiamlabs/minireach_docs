Care And Feeding
================

.. _charging:

Charging
--------

The robot is charged by connecting a lab voltage supply set to 28.5V and limited to 10A.

.. warning::

   When the lab supply is connected to the battery, there mey be a spark even if
   the supply is turned off because of the output capacitor on the supply.

.. _updating:

Updating Your Robot
-------------------

NOTE: THE MINIREACH PACKAGES ARE NOT YET UPLOADED TO OSRF SO THE FOLLOWING WILL NOT WORK

Your robot has been pre-configured with ROS Indigo and the appropriate
APT repositories from which to fetch package updates.
Upgrading to the latest packages is as easy as:

::

   sudo apt-get update
   sudo apt-get install --only-upgrade ros-indigo-* f.*-system-config
   sudo service minireach stop
   sudo service minireach start

.. warning::

    Using 'apt-get upgrade' and 'apt-get dist-upgrade' could cause critical
    software, such as the kernel, to change. We can not guarantee your robot
    will function after making such a change. We recommend against using these commands unless you understand and accept the risks.

Cleaning Your Robot
-------------------

To clean fingerprints, dirt, and smudges from the cab or base, 
[use a clean soft cloth and isopropyl alcohol].

To clean the sensor optics of MiniReach use the lens cloth. 
Lens tissues or cotton swabs are also good
options for cleaning the optics of the robot.

.. warning::

    Do not use window cleaner, acetone, or abrasive cloths on the sensor
    lenses as this may cause damage to the lens.

