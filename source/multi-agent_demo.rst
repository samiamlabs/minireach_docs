Tutorial: Multiple trucks
======================

The goal of this tutorial twofold:
  * To esablish a connection between multiple real trucks where information can be exchanged.
  * TODO
This example uses a computer as a central hub which two trucks connects to.

First power-up the two trucks and their industrial computers along with the computer which will act as a central hub.
You can use `NoMachine <https://www.nomachine.com/>`_ to connect to the trucks as described in TODO: ADD LINK TO SAMUELS DEMO

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

TODO: Insert title
---------------------
This subsection will describe how to start and run the multi-ROS master application Random Walk.
This app is divided into two parts.
Random Walk Mapping creates a map of its environment where it can drive around.
Random Walk AMCL receives the map from Random Walk Mapping and tries to position itself in it.

The apps are started with rocon_remocon described in TODO: ADD LINK TO SAMUELS DEMO
asd
