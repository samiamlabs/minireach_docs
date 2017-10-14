Demo: Control the truck using a game-pad
========================================

.. note::
    Prerequisites -- The following is required to run this demo.

    * A truck which is charged
    * A computer which you can remote desktop into the truck with
    * A gamepad with it's dongle connected to the usb port on the truck

      * At the moment only the xbox gamepad is working

Start the truck
---------------

To start the truck, follow these steps.

 #. Start the truck by pulling the red switch on the battery upwards.
 #. Start the computer on the truck by pressing the small gray button on the lower left backside of the computer.

Since all the drivers are launched automatically, you should now be able to control the truck using the game-pad. The left bumper is a dead man grip (button 10 in the "Tutorial: Robot Teleop" section), which has to be pressed to control the truck. When pressed the truck is steered with the left stick. More information about controlling the truck using the game-pad is found in "Tutorial: Robot Teleop" section.

.. Note::
    The joystick is capable of controlling the movement of the robot base. (fork, reach and 3D camera control are currently disabled because they are position controlled).


Troubleshooting
---------------

If the truck does not react to the game controller, you might have to turn the driving wheel, i.e. change it's direction by hand. This is due to a bug from the manufacturer of the steering servo.

If the truck still does not respond to the controller, you might have to relaunch the drivers. Do this by following the steps below.

Login to the truck
^^^^^^^^^^^^^^^^^^

 #. Make sure that the truck and the computer is connected to the same WiFi router.
 #. Launch NoMachine, on the Ubuntu computer it should be available in the upper right corner on the screen.
 #. Choose the truck you want to login to.
 
.. Note::
    If it says connection refused you will have to restart the NoMachine server.

    #. ssh in on the truck
 
       #. Open a new terminal on your computer
       #. Type ``ssh toyota@minireachX``, where X is the truck you want to use.

    #. Type ``sudo /etc/init.d/nxserver restart``

       #. It will ask for the password which is ``minireach``


Restart bringup
^^^^^^^^^^^^^^^

 #. Open a terminal inside the remote desktop
 #. Stop the drivers ``sudo service minireach stop``
 #. Restart the drivers ``roslaunch minireach_bringup bringup.launch``

Now you should be able to control the truck using the game-pad. 
