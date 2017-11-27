Drive Wheel Offset
===========================

The drive wheel on the real forklift has a small axial offset from the steer servo rotational axis, which gives the forkift a different behavior. When modelling this offset, a parameter has been introduced to make adjustments of this measure easy to achieve. This parameter is defined in a file called minireach.xacro in the minireach_description package located in the minireach repository. 

::

<property name="drive_wheel_offset"	value="-0.0037" />

::

The value of the offset was determined from drawings and CAD files of the original wheel to be -3.7 mm with the minus sign indicating the direction of the offset. 
