Tutorial: Navigation
====================

Once you have MiniReach running, you can start navigating.
MiniReach ships with configurations for using the
ROS Navigation Stack. A number of tutorials related to navigation
can be found in the documentation on the
`ROS Wiki <http://wiki.ros.org/navigation>`_.

Running Navigation in Gazebo Simulation
---------------------------------------

To run navigation in simulation, launch the navigation launch file
from the ``minireach_nav`` package:

::

	>$ roslaunch minireach_nav minireach_nav.launch

Running Navigation on a Real Robot
----------------------------------

When running navigation on a robot, first you will need to build a map,
See the next section for a how-to. Then you will need to supply the map
to the navigation launch file from the ``minireach_nav`` package:

::

    >$ roslaunch minireach_nav minireach_nav.launch map_file:=/path/to/map.yaml


Building A Map
--------------

The launch file for navigation in Gazebo depends on a pre-built
map of the environment. In order to use navigation in the real world,
you will need to first build a map of your environment:

::

    >$ roslaunch minireach_cartographer cartographer.launch

Once you launch cartographer, you will want to
:doc:`tele-operate the robot </teleop>` the robot around and build
the map, which can be visualized in RVIZ.

.. note:: The cartographer.launch file is not intended to be run at the same time
    as minireach_nav.launch

While driving the robot around, you can view the map in RVIZ.
Once you are happy with the map, you can save the map:

::

    >$ rosrun map_server map_saver -f <map_directory/map_name>

The map saver will create two files in the specified
``map_directory``. The directory must already exist.
The two files are map_name.pgm and map_name.yaml.
The first is the map in a ``.pgm`` image format, and
the second is a YAML file that specifies metadata for the image.
These files can then be served by the map_server:

::

    >$ rosrun map_server map_server <map.yaml>

The minireach_nav.launch file used above launches an istance of map_saver to load the map. 
It takes in the argument 创map_file创 which is the name of the map, the default value is 
创map_demo创.

================= ================================
Argument          Meaning
================= ================================
map_file          YAML file containing map metadata
================= ================================

You can either pass the arguments from the command line, like:

::

    >$ roslaunch minireach_nav minireach_nav.launch map_file:=/path/to/map.yaml

Or create a new launch file in your own package which includes launch
file and passes in arguments:

::

    <launch>
      <include file="$(find minireach_nav)/launch/minireach_nav.launch" >
        <arg name="map_file" value="$(find my_package)/maps/my_map.yaml" />
      </include>
    </launch>

The "keepout" map can be created by copying the YAML file of your saved map,
editing the name of the ``.pgm`` file and then copying the ``.pgm`` file.
You can then open the ``.pgm`` file in an image editor, such as GIMP, and black out areas that you do not want the robot to drive through. This must be done in a separate map that is only used for planning so that the edits do not disturb the functionality of localization (AMCL).  

Sending Waypoints 
-----------------

The easiest way to send a goal to the navigation stack is using RVIZ and the
``2D Nav Goal`` button. See the tutorial on using RVIZ with navigation in the RVIZ
`documentation <http://wiki.ros.org/navigation/Tutorials/Using%20rviz%20with%20the%20Navigation%20Stack>`_

However, you probably want to program your robot. There is a
`tutorial <http://wiki.ros.org/navigation/Tutorials/SendingSimpleGoals>`_
on commanding the robot with C++. For examples in Python, look at the demo.py
code in the ``minireach_gazebo_demo`` package.

Local planner
-----------------
The implemented local planner is an online optimal local trajectory planner which uses
uses a method called TEB (Timed elastic band). It locally optimizes the trajectory of the robot with respect to distance from obstacles, trajectory excecution time while following kinodynamic constraints.
Read the `documentation <http://wiki.ros.org/teb_local_planner>`_ for further information.
The planner consists of several parameters which can be tuned in order to enhance the behaviour of the robot. 

In event of unwanted driving-behaviour from minireach, one solution could be to modify the parameters of the local planner and connected maps.
This is achieved in the config-files at "minireach/minireach_nav/config/minireach_gazebo/base_local_planner_params.yaml".
In order to ease the setup, see the following hints.
     * Problem 1. Minireach is not keeping enough distance towards obstacle.
       Solved by: 
       Increase weight_obstacle. 
       Increase inflation_dist. 
       Increase min_obstacle_dist.
     * Problem 2. Minireach oscilliates when traveling towards a goal.
       Solved by: 
       Decrease weight_viapoint. 
       Increase weight_optimaltime. 
       Decrease inflation_radius.
     * Problem 3. Minireach seems slow and takes to much time to "think".
       Decrease number of iterations; no_inner_iterations, no_outer_iterations.
       Decrease max_global_plan_lookahead_dist.
       Decrease max_vel-parameters and controller_frequency.

