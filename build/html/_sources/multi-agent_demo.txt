Tutorial: Multiple trucks
======================

The goal of this tutorial is twofold:
  * To establish a connection between multiple real trucks where information can be exchanged.
  * Describe how to use the multi-truck simulator

This example uses a computer as a central hub which two trucks connects to.

First power-up the two trucks and their industrial computers along with the computer which will act as a central hub.
You can use `NoMachine <https://www.nomachine.com/>`_ to connect to the trucks as described in :ref:`Running demo on real trucks`.

Using rocon_gateway
----------------------

Once the remote desktop connection has been established the next step is to connect the trucks and central computer to each other.
This is done via a ros package called `rocon_gateway <http://wiki.ros.org/action/fullsearch/rocon_gateway?action=fullsearch&context=180&value=linkto%3A%22rocon_gateway%22>`_.
The gateway nodes should already be running on the trucks.
To start the node on the central computer enter the following command in a terminal.
(Note: Make sure that the terminal started is on the correct computer as it is easy to mix them up when dealing with remote desktops)::

  roslaunch minireach_concert concert.launch

Once this node is running you should be able to see detections of other concert nodes in the terminal.
The nodes has been properly connected if they have the state 'available'.
The following is an example of a successful connection::
  Conductor : concert client transition [joining -> available][espeon]
  Conductor : concert client transition [joining -> available][flareon]

In case of all trucks not connecting successfully the gateways should be stopped on all computers and thereafter restarted.
The following command restarts the processes on the trucks. Note that the processes should be stopped on all machines before starting them again::
  sudo service minireach stop
  roslaunch minireach\_bringup bringup.launch

Lastly, once the gateway nodes are running on the trucks, start the hub on the central computer as described before.
This process might have to be repeated if the desirable state of the nodes are not reached.

Application: Random Walk
---------------------
This subsection will describe how to start and run the multi-ROS master application Random Walk.
This app is divided into two parts.
Random Walk Mapping creates a map of its environment where it can drive around.
Random Walk AMCL (Automatic Monte Carlo Localization) receives the map from Random Walk Mapping and tries to position itself in it.

The apps are started with rocon_remocon described in :ref:`Using rocon_remocon` and is done after the rocon_gateway connection has been established.
After the apps are launched each truck will have its own rviz window representing how it views its surrounding.
A good idea to do next could be to drive around with the mapping truck to get a map of the surrounding environment.
The truck with AMLC running will have to get an initial estimate of its position.
This is done with the "Pose Estimate" button in rviz.
Note that this is a click and drag action.

After the truck has been properly initiated both trucks can be given waypoints to drive to with the "publish point" button in rviz.
If a truck running AMCL's actual and estimated position would diverge the button "Estimate 2D pose" could be used at any time to relocate its position estimation.

Troubleshooting
---------------------
This subsection will describe how to fix different errors that may occur.

If a node does not start, the easiest way to fix this is to restart the system.
Another way to fix the problem is shown below.
For example, lets say that a truck does not show up in the other trucks map (RVIz).
The reason behind this could be that the node named: Truck_state_broadcaster did not start.
The way to check if the node has started is to use the command::
  rosnode list | grep truck_state_broadcaster

Then control that the node named truck_state_broadcaster exists in the list.
If not, try to run it with::
  rosrun minireach_tasks truck_state_broadcaster __ns:="namespace"

Then you can use the commands flip and pull to connect the gateways and force the data to be sent.
Write the following commands into the terminal::
  rosrun rocon_gateway flip
  rosrun rocon_gateway pull

The flip command, makes the gateway send the data of a certain topic and the pull retrieves data from a topic sent from another rosmaster.

Read more in the tutorials of `rocon_gateway <http://wiki.ros.org/action/fullsearch/rocon_gateway?action=fullsearch&context=180&value=linkto%3A%22rocon_gateway%22>`_.

If the gateways will not connect.
Open .bashrc and check the the following settings are correct::
  export ROS_MASTER_URI=http://"IP"::11311
  export ROS_HOSTNAME="IP"
  export ROS_IP="IP"

  export MINIREACH_SIMULATION=false
  export MINIREACH_DISABLE_ZERO_CONF=false

Multi-truck Simulator
---------------------
This subsection will describe how to run the simulator for 2 trucks (the number of trucks is possible to change).

First control the settings in bashrc.
The following settings should be set::
  export ROS_MASTER_URI=http://localhost::11311
  export ROS_HOSTNAME=localhost
  export ROS_IP=localhost

  export MINIREACH_SIMULATION=false
  export MINIREACH_DISABLE_ZERO_CONF=false

Then restart the terminal.
Start the simulation by using the following commands (You will need different terminals)::
  roslaunch minireach_gazebo multisim.launch
  rosrun concert_service_random_walk temp_start.py
  rocon_launch minireach_rviz random_walk.concert

It will open a solution with different rosmasters in each terminal. This makes it possible to simulate the real environment.

TROUBLESHOOTING

If no maps exists in either truck, then most likely the temp_start command did not work properly.
Run following command in a terminal::
  roslaunch concert_service_random_walk start_rapps.launch
