Tutorial: Gazebo Simulation
===========================

MiniReach has a simulated counterpart using the
`Gazebo Simulator <http://gazebosim.org>`_.

Installation
------------

Before installing the simulation environment, make sure your desktop
is setup with a standard installation of
`ROS Indigo on Ubuntu 14.04 <http://wiki.ros.org/indigo/Installation/Ubuntu>`_.
Once your APT repositories are configured, you can install the simulator:

NOTE: NOT YET IMPLEMENTED

::

    >$ sudo apt-get update
    >$ sudo apt-get install ros-indigo-minireach-gazebo-demo

.. warning::

    Never run the simulator on the robot. Simulation requires that
    the ROS parameter use_sim_time be set to true, which will cause
    the robot drivers to stop working correctly. In addition, be sure
    to never start the simulator in a terminal that has the ROS_MASTER_URI
    set to your robot for the same reasons.

Starting the Simulator
----------------------

NOTE: NOT YET IMPLEMENTED

The ``minireach_gazebo`` and ``minireach_gazebo_demo`` packages provide the Gazebo
environment for MiniReach. ``minireach_gazebo`` includes several launch files:

 * simulation.launch spawns a robot in an empty world.
 * playground.launch spawns a robot inside a lab-like test environment.
   This environment has some pallets that may be picked up
   and manipulated. It also has a pre-made map which can be used to
   test out robot navigation.

To start the simplest environment:

::

    >$ roslaunch minireach_gazebo simulation.launch

NOTE: WRONG PICTURE

.. figure:: _static/gazebo.png
   :width: 100%
   :align: center
   :figclass: align-centered


Visualizing with RVIZ
---------------------

Even though Gazebo has a graphical visualization, RVIZ is still the preferred
tool for interacting with your robot.


.. include:: visualization.rst
   :start-after: embed-rviz-start
   :end-before: embed-rviz-end

.. _mm_demo:

Running the Mobile Manipulation Demo
------------------------------------

NOTE: NOT YET IMPLEMENTED

There is a fully integrated demo showing navigation and perception 
working together on the robot in simulation. To run the
demo, start Gazebo simulator with the playground:

::

    >$ roslaunch minireach_gazebo playground.launch

Wait until the simulator is fully running and then run the demo
launch file:

::

    >$ roslaunch minireach_gazebo_demo demo.launch

This will start:

 * minireach_nav.launch - this is the navigation stack with a pre-built map of
   the environment.
 * minireach_ar_track.launch - this launches an ar-tag tracker using the 3D camera
   in the fork facing direction on the robot.
 * demo.py - this our specific demo which navigates the robot from the
   starting pose in Gazebo to a pallet (tracked using an ar-tag) picks it up
   and puts it down at a predefined pose in the map. 

Simulation vs. Real Robots
--------------------------
The simulated robot may not be identical to the real robot. In fact, the
real robot is likely quite a bit better behaved.
