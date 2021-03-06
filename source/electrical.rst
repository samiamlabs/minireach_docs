Electrical Overview
-------------------

Communication Overview
++++++++++++++++++++++

Internally, MiniReach has a number of circuit boards,
communication buses, and other components which
handle power distribution and motion control. The system
comprises among other things:

 * The main robot computer (Nuvo-5095GC), running ROS, is responsible for perception
   and high level control of the robot.
 * Ethernet interfaces used to communicate with the scanning laser range
   finders in the front and back of the robot and the wire encoder for the forks (height).
 * An Orbbec Astra 3D camera connected by USB.
 * A digital servo for tilting the camera connected to the computer by USB-serial port.
 * An Arduino connected by USB the computer.
   It is hooked up to an encoder that outputs ticks from the drive wheel rotation,
   relay modules that allow control of fork and reach motors and a relay
   connected in series with the ICH "truck controller" power input.


.. figure:: _static/communications.png
   :width: 80%
   :align: center
   :figclass: align-centered


.. _powerdistribution:

Power Distribution
++++++++++++++++++

The truck has a 25.9V lithium-ion battery in the base. (see
:ref:`charging`).

.. figure:: _static/electrical.png
   :width: 80%
   :align: center
   :figclass: align-centered


.. _power_disconnect:

Power Disconnect Switch
+++++++++++++++++++++++

The power disconnect is on the right side of the battery. This switch
cuts the power between the battery and all systems on the robot.

.. figure:: _static/power_switch_arrow.png
   :width: 80%
   :align: center
   :figclass: align-centered

Emergency Stop
++++++++++++++

The runstop is used to stop all operation of the base. When the runstop is pressed, the drivers will not be able to communicate with the motor or servo controller boards, and thus the wheel angle and other data will not update in RVIZ.

.. figure:: _static/emergency_stop.jpg
   :width: 80%
   :align: center
   :figclass: align-centered
.. _access_panel:

Arduino
++++++++++++++++
 TODO

Arduino:

RX0:
TX1:
D2: Vit 		INTERRUPT_WHEEL_ENCODER
D3: Ljusblå	INTERRUPT_WHEEL_ENCODER
D4:
D5:
D6:
D7:
D8:
D9:
D10: Lila	LIFT_UP_DOWN
D11: Blå	REACH_IN_OUT
D12: Gul	LIFT_ON_OFF
D13: Grön	REACH_ON_OFF
D14: Lila	TCS
D15: Blå	Okänd, Till Relä
D16: Gul	Oanvänd
D17: Grön	Oanvänd

Reachkortet (?):
IN1 Grön  - Från D13
IN2 Gul   - Från D12
IN3 Blå   - Från D11
IN4 Lila  - Från D10
