Change mode
===========

When running the state machine with the launch command

::

	>$ roslaunch minireach_gazebo smach_pallet.launch

a stationary map is automatically loaded. 

If this map needs to be altered the state machine also provides services to simplify the transition between the modes positioning with amcl and mapping with cartographer. The services are called upon by using the following commands:

::

	>$ rosservice call /to_mapping 
	and 
	>$ rosservice call /to_positioning 

/to_mapping 
------------

shuts down amcl
opens cartographer

	- sets the global origo for the map 


/to_positioning
---------------
saves the map
saves the current position 
closed down cartographer
opens up minireach_nav
loads map

	- with current position
