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
.. note:: During mapping only stationary objects should be in the mapping area, thus pallets and other objects needs to be moved away. This is because objects seen during the mapping mode is considered as obstacles. 

When call /to_mapping the service shuts down amcl and starts catrographer. 
When cartographer starts the global origo of the map sets to the current position. In order to avoid faulty transformations the files containing the saved AR tags are cleaned when calling upon this service. However the AR tags seen during the mapping is saved with the new map used in the transformation.

/to_positioning
---------------
The service /to_positioning saves the current map and the current pose of the forklift. 
It shuts down the node cartographer and starts amcl with the new map and the current pose as input arguments. 
