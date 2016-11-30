Executive state machine
=======================

This chapter present the background and functionalities of the executive state machine made to perform an autonomous translation of a pallet to a given pallet place.

Background
----------
The Executive State machine is built upon python code for state machines with ROS actionlib and service functionalities to perform the given tasks. It is built up in three layers. In the first level you can find the sleep state, the failure state and a container. The container is a concurrence container and contains two states: the mission substate machine and the state check. The state check is constructed to be able to interupt the tasks performed in mission and works as a security solution. The state machine Mission contains the overriding states *Go to Pallet*, *Get Pallet*, *Go to Pallet Place* and *Leave Pallet* which all of them are substate machines with states within them.

Go to Pallet handles functionalities to get the information of what pallet to get, looking up it's position, recalculation the position to a spot infront of the pallet and calling the move_base server to move the fork lift to that position. 

Get Pallet handles functionalities to call a service (pallet_handler) to position the forks below the pallet and lift the pallet to a suitible height.

Go to Pallet Place XXX

Leave Pallet handles functionalities to call a serivce (deliver_pallet) to position the forks over the pallet place and lower them.


Tutorial
--------
This is a short tutorial on how to use the Executive state machine

    -Start the gazebo simulation enviroment or the fork lift itself
    -Start the state machine, other nodes that are used and Rviz by writing the command

::

>$ roslaunch minireach_gazebo smach_pallet.launch



    -Publish the wanted pallet and pallet place on the topic send_mission by the following command

::

>$ rostopic pub /send_mission minireach_executive

    and then tab to recive

::
>$ pallet:0 pallet place:0

    you can alter the pallet and pallet place by changing the numbers

    -You have now sent the mission to get the given pallet and leave it on the pallet place




