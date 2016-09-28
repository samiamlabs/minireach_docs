Tutorial: Robot Teleop
======================

Using the Robot Joystick
------------------------
.. embed-pt

MiniReach ships with a robot joystick.
Whenever the robot drivers are running, so is joystick teleop.
The joystick is capable of controlling the movement of the robot
base, fork, reach and 3D camera.

.. figure:: _static/joystick_numbered.png
   :width: 100%
   :align: center
   :figclass: align-centered

.. figure:: _static/joystick_numbered2.png
   :width: 100%
   :align: center
   :figclass: align-centered

======== =================================
Button # Function (details below)
======== =================================
 0       Not used 
 1       Control robot movement 
 2       Control fork up/down
 3       Not used
 4       Not used
 5       Not used
 6       Not used
 7       Not used
 8       Control reach in
 9       Control reach out
 10      Primary deadman
 11      Secondary deadman
 12      Not used
 13      Log in to truck
 14      Not used
 15      Toggle parking break
 16      Pair/unpair with robot
======== =================================

To pair the controller with the robot, press the middle button (16) once
the robot has powered on. The big LED on the controller will turn a solid 
blue when successful.
To unpair, hold the button for 10 s. The blue LED indicator on the back will turn off.

To toggle parking break, press the "Toggle parking break" button (button 15 above).

To drive the robot base, hold the primary deadman button (button 10
above) and use the left joystick.

To move the fork up and down, hold the secondary deadman button (button 11 above) and use the right joystick.

.. warning::

    Whenever driving the robot, always lower the fork to avoid damaging objects and people

To control the 3D camera, release the secondary
deadman (button 11). The right joystick now controls camera tilt.


Moving the Base with your Keyboard
----------------------------------

.. note::

   You will need a computer with ROS installed to properly
   communicate with the robot. Please consult the `ROS Wiki <http://wiki.ros.org/indigo/Installation>`_
   for more information. We strongly suggest an Ubuntu machine
   with ROS Indigo installed.

To teleoperate the robot base in simulation, we recommend
using the ``teleop_twist_keyboard.py`` script from
`teleop_twist_keyboard <http://wiki.ros.org/teleop_twist_keyboard>`_
package.

::

  >$ export ROS_MASTER_URI=http://<robot_name_or_ip>:11311
  >$ rosrun teleop_twist_keyboard teleop_twist_keyboard.py


Software Runstop
----------------

NOTE: SOFTWARE RUNSTOP IS NOT NOT YET IMPLEMENTED

In addition to the runstop button at the back (non fork) side of the robot, similar software
functionality is also available, allowing for button presses on the
PS3 controller or a program to disable the breakers.

Using Software Runstop
~~~~~~~~~~~~~~~~~~~~~~

To activate the software runstop, publish True to the /enable_software_runstop
topic.

Alternately, with the teleop runstop enabled, pressing both of the right
trigger buttons (buttons 9 and 11) will activate the software runstop.
The software_runstop.py script in fetch_bringup can be modified to change
the button(s) for the software runstop.

Once activated, the software runstop can be deactivated by (1) toggling the
hardware runstop, or (2) disabling the software runstop by passing False to
the /enable_software_runstop topic.

