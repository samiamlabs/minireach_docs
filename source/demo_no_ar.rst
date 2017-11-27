.. _demo_no_ar:

Demo: Handle pallets without AR-codes
========================================

.. note::
    Prerequisites -- The following is required to run this demo.

    * A truck which is charged
    * A computer which you can remote desktop into the truck with
    * A gamepad with it's dongle connected to the usb port on the truck

      * At the moment only the xbox gamepad is working

    * A router that has been setup in such a way that the trucks and laptops can connect automatically when powered up
      
      * This must be done before leaving Toyota premises

Start the truck
---------------

To start the truck, follow these steps.

 #. Start the truck by pulling the red switch on the battery upwards.
 #. Start the computer on the truck by pressing the small gray button on the lower left backside of the computer.

Now verify that everything has launched properly by trying to move the truck around by using the gamepad.

.. note::
    All images in this tutorial are from the tutorial, but it will look almost exactly the same for real trucks.

Troubleshooting
---------------

If the truck does not respond to the controller, you might have to relaunch the drivers. Do this by following the steps below.

If the truck still does not react to the game controller, you might have to tilt the truck and to turn the driving wheel (the big wheel under the truck) sideways, i.e. change it's direction by hand. Then the drivers should communicate correctly. This is due to a bug from the manufacturer of the steering servo.


1). Login to the truck
^^^^^^^^^^^^^^^^^^

 #. Launch NoMachine, on the Ubuntu laptop it should be available in the upper right corner on the screen.
 #. Choose the truck you want to login to.
 
.. Note::
    If it says connection refused you will have to restart the NoMachine server.

    #. ssh in on the truck
 
       #. Open a new terminal on your laptop
       #. Type ``ssh toyota@minireach<truck_nr>``, where truck_nr = [1 or 2] is the truck you want to use.

    #. Type ``sudo /etc/init.d/nxserver restart``

       #. It will ask for the password which is ``minireach``


2). Restart bringup
^^^^^^^^^^^^^^^
 
 #. Open a terminal inside the remote desktop
 #. Stop the drivers ``sudo service minireach stop``
 #. Restart the drivers ``roslaunch minireach_bringup bringup.launch``

Now you should be able to control the truck using the game-pad. 
