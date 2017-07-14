Tutorial: Gazebo Simulation
===========================

MiniReach has a simulated counterpart using the
`Gazebo Simulator <http://gazebosim.org>`_.

Starting the Simulator
----------------------

The ``minireach_simulator`` "stack" (a stack is a collection of ROS packages) provide the Gazebo
environment for the truck. The ``minireach_gazebo`` pakckage includes

 * `monosim.launch`:  spawns a truck in a miniature warehouse with bootstrap software
 * `multisim.launch`: spawns multiple trucks in a miniature warehouse, each with bootstrap software running in a separate "ros master" for each truck
 * `simulation.launch`: spawns a truck in a miniature warehose without bootstrap software

To start one simulated truck, use the following terminal command: ::

  roslaunch minireach_gazebo monosim.launch

.. figure:: _static/start.png
   :width: 100%
   :align: center
   :figclass: align-centered


The gazebo client will start and you should se something like the miniature warehouse 
in the image below on your screen:

.. figure:: _static/gazebo.png
   :width: 100%
   :align: center
   :figclass: align-centered



To start multiple simulated trucks, use this terminal command:



::

    roslaunch minireach_gazebo multisim.launch
    gzclient


Simulation vs. Real Robots
--------------------------
The simulated robot may not be identical to the real truck. The sensors on the real truck can be badly calibrated and things like steer servo velocity are not identical.
