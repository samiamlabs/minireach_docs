Error messages while running
=======================

When performing tasks, several errors can occur in one or more of the subtasks. This section describes the cause of the arisen errors.

Errors 
----------
	-

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




