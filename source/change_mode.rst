Change mode
===========

When running the state machine with the launch command

::

	>$ roslaunch minireach_gazebo smach_pallet.launch

a stationary map is automatically loaded. 

If this map needs to be altered the state machine also provides services to simplify the transition between the modes positioning with amcl and mapping with cartographer. The services are called upon by using the following commands:

::

	>$ rosservice call /to_mapping 
	>$ rosservice call /to_positioning 

/to_mapping 
------------
To_mapping shuts down amcl and starts catrographer. 
When cartographer starts the global origo of the map sets to the current position. In order to avoid faulty transformations the saved AR tags files are cleaned when calling upon this service. However the AR tags seen during the mapping is saved with the new map used in the transformation.

/to_positioning
---------------
The service to_positioning saves the current map and the current pose of the forklift. 
It shuts down the node cartographer and starts amcl with the new map and the current pose as input arguments. 