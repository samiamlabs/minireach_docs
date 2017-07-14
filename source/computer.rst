Truck Computer Overview and Configuration
===================================

The truck has an industrial computer which runs a
Long Term Support (LTS) release of Ubuntu (14.04) and an LTS release of
ROS (Indigo). These releases are intended to give long-term stability to
the system.

Networking
----------

The truck has a USB wireless network card, and is assigned a static IP based
on MAC address by the DHCP server in the router.

Connecting the Robots Wireless Network
------------------------------------------

The ssid for the network is `minireach_network` (alternatively `minireach_network_5G`)
and the password is `minireach`.

Clock Synchronization
---------------------

It is recommended to install the chrony NTP client on both robots and desktops
in order to keep their time synchronized. To install chrony on Ubuntu:

::

    > sudo apt-get update
    > sudo apt-get install chrony

.. _upstart_services:

Upstart Services
----------------

Minireach uses robot_upstart to start and manage various services on the robot.

Upstart service can be restart with the `service` command. For instance, to
restart the robot drivers:

::

    >sudo service minireach stop
    >sudo service minireach start


Log Files
---------

A number of log files are created on the robot. The most recent logs related to robot_upstart
services can be viewed using: sudo tail /var/log/upstart/minireach.log -n 30
