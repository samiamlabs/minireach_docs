Computer Overview and Configuration
===================================

Minireach has two internal computers which run a
Long Term Support (LTS) release of Ubuntu (14.04) and an LTS release of
ROS (Indigo). These releases are intended to give long-term stability to
the system.

.. embed-user-accounts-start

Default User Account
--------------------

Each robot ships with a default user account, with username `ubuntu` and
password `ubuntu`. It is recommended to change the password when
setting up the robot.

Creating User Accounts
----------------------

It is recommended that each user create their own account on the robot, especially
when developing from source. To create an account on the robot, ssh into the
robot as the `ubuntu` user, and run the following commands:

::

    >$ sudo adduser USERNAME
    >$ sudo usermod -G adm,cdrom,sudo,dip,plugdev,lpadmin,sambashare USERNAME

.. embed-user-accounts-end

Networking
----------

The robot currently has its own router with both Ethernet and Wi-Fi.
The Jetson TX1 and raspberry pi have static IP adresses assigned based on
their respective MAC addresses by the DHCP server on the router.

The static IPs are:
 - raspberry pi: 192.168.1.119
 - Jetson TX1: 192.168.1.207

.. note::

    This is subject to change as we may elect to move the router of the robot in order
    to facilitate multi-robot setups.

.. warning::

    Never drive the robot with an Ethernet cable attached.

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

Roscore runs on the raspberry pi and this means that the upstart scripts on
the Jetson won't work if they both boot when the battery swith is pulled, 
(the Jetson boots faster than the pi). We get around this by triggering the Jetsons 
Boot sequence using a relay connected to the raspberry pi.


Log Files
---------

A number of log files are created on the robot. The most recent logs related to robot_upstart
services can be viewed using: sudo tail /var/log/upstart/minireach.log -n 30

Speakers and Audio
------------------

The Jetson TX1 in the MiniReach is connected to a USB audio device.

While the device enumerates as a standard Linux audio device, we recommend
using the `sound_play ROS package <http://wiki.ros.org/sound_play>`_ to
access the speakers. 

We currenty have some issues getting ``sound_play`` to automatically start as
an robot_upstart service when the robot starts.
This is because it does not have the correct group-level access
to the audio system. If using the speakers directly through a Linux
interface, be sure to add your user to the ``audio`` group in order
to actually access the speakers. If you start node manually by
typing `rosrun sound_play soundplay_node.py` into a ssh-session on the Jetson,
the sound should start working.

While the ``sound_play`` ROS interface allows users to set an audio
level, the audio level set is a percentage of the audio level set
for Linux. To adjust the Linux audio level, use the following command
and follow the on-screen instructions:

::

    >$ sudo su ubuntu -c "alsamixer -c 1"
