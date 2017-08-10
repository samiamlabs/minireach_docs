Tutorial: Multiple trucks
======================

The goal of this tutorial is to establish a connection between multiple real trucks where information can be exchanged.
This example uses a computer as a central hub which two trucks connects to.

First power-up the two trucks and their industrial computers along with the computer which will act as a central hub.
You can use `NoMachine <https://www.nomachine.com/>`_ to connect to the trucks as described in TODO: ADD LINK TO SAMUELS DEMO

Once the remote desktop has been established the next step is to connect the trucks and central computer to eachother.
This is done via a ros package called `rocon_gateway <http://wiki.ros.org/action/fullsearch/rocon_gateway?action=fullsearch&context=180&value=linkto%3A%22rocon_gateway%22>`_.
