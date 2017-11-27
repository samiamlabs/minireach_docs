Drive Wheel Offset
===========================

The drive wheel on the real forklift has a small axial offset from the steer servo rotational axis, which gives the forkift a different behavior. When modelling this offset, a parameter has been introduced to make adjustments of this measure easy to achieve. This parameter is defined in a file called minireach.xacro in the minireach_description package located in the minireach repository. 

::

> <property name="drive_wheel_offset"	value="-0.0037" />
>
