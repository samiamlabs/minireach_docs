Executive state machine
=======================

This chapter present the background and functionalities of the executive state machine made to perform an autonomous translation of a pallet to a given pallet place.

Background
----------
The Executive State machine is built upon python code for state machines called *Smach-state* with ROS actionlib and service functionalities to perform the given tasks. It is built up in three layers. In the first level you can find the *Sleep* state, the *Failure* state and a container. The container is a concurrence container and contains two states: the *Mission* substate machine and the state *Check*. The state *Check* is constructed to be able to interupt the tasks performed in *Mission* and works as a security solution. The state machine *Mission* contains the overriding states *Go_to_pallet*, *Get_pallet*, *Go_to_pallet_place* and *Leave_pallet* which all of them are substate machines with states within them.

	- *Go_to_pallet*: handles functionalities to look up the pallets position, recalculation the position to a spot infront of the pallet and calling the move_base server to move the fork lift to that position.

	- *Get_pallet*: handles functionalities to call a service (pallet_handler) to position the forks under the pallet and lift the pallet to a suitible height.

	- *Go_to_pallet*: has the same functionalities as *Go_to_pallet* but instead of pallets position the forklift will be moved to the pallet place instead.

	- *Leave_pallet*: handles functionalities to call a serivce (deliver_pallet) to position the forks over the pallet place and lower them.
	
.. note::

	Please consult the ros wiki: http://wiki.ros.org/smach, to learn more about smach state.


Tutorial
--------
This is a short tutorial on how to use the Executive state machine

	- Start the gazebo simulation enviroment or the fork lift itself, to start the simulation type
    
	::

		>$ roslaunch minireach_gazebo playground.launch

	- Start the necessary nodes that are used and Rviz by writing the command in a new terminal

	::

		>$ roslaunch minireach_gazebo_demo smach_pallet.launch

	- Open another terminal and start the state machine. The reason to start the state machine in a new terminal is to be able to follow which state that is executed easier
	
	::

		>$ rosrun minireach_executive move_pallet_main.py

	- Publish the wanted pallet and pallet place on the topic *send_mission* by the following command (the ids have to be integer)

	::

		>$ rostopic pub /send_mission minireach_executive/SendMission "mission: 'start'
		pallet: [pallet id]
		pallet_place: [pallet_place id]"

	- You have now sent the mission to get the given pallet and leave it on the pallet place.

.. note::

	The mission can be aborted by publish a stop message at the same topic
	::
	
		>$ rostopic pub /send_mission minireach_executive/SendMission "mission: 'stop'
		pallet: [pallet id]
		pallet_place: [pallet_place id]"
	
	The [pallet id] and [pallet_place id] doesn't matter here, but need to be integer.
	
.. warning::

	Don't forget to abort the publishing message, *ctrl + c* in the terminal. If not the forklift will start a new mission direct after finished the first one.
	
The mission can also be sent from the GUI, see XXXXXXXXXX for more information.


Troubleshooting
---------------

If something goes wrong or the forklift is not capable to prefrom its task the mission will be aborted. Today the state machine will go throw two failure-state. One local failure state for each task and one global failure state that always will be executed. Today nothing happend in the failure state, but it is possible to implement recovery behavior.

The easiest way to troubleshoot is to ready the message printed in the terminals. In the termianl that the state machine is started one ccan see which state that has been executed. It will give a hint there the mission is aborted.

In the terminal there ``smach_pallet.py`` has started


Interpreting errors while executing pallet handling 
---------------------------------------------------

When performing tasks, several errors can occur in the states. This section describes the cause of some of the nontrival arisen errors.

	- *Failed to locate: 'FRAME'*. A transform could not be found between obstacle frame and base footprint. This error might occur when attempting to drive under pallet and using the obstacle frame as reference.
	
	- *Transform Not Found*. This error arises when looking for a transform between pallet station or pallet and the base footprint of the robot. This is used when calculating the distance left to pallet or station.
	
	- *Transform not found to obstacle_0*. This error is related to the reversing after leaving pallet a pallet. The state is listening for the latest published detected obstacle to make sure reversing is safe.

	




