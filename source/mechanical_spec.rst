Mechanical Overview
-------------------

Do not operate MiniReach before reviewing the mechanical
information listed below.

Environmental
+++++++++++++

The MiniReach Research Edition Robots are indoor laboratory
robots. Operating outside this type of environment could cause
damage to the MiniReach robots, and injury or death to
operators.

Drive Surface
'''''''''''''
 - The drive surface of the robot must be capable of supporting the
   entire weight of MiniReach, about 180 kgs plus the weight of the 
   payload. If the surface is too soft, MiniReach can get stuck and fail to drive. 
   A commercial carpet, tile or cement floor is recommended.
 
 - MiniReach's ground clearence is only [1.5cm], so make sure the surface is 
   flat enough.

Incline Surface
'''''''''''''''
 - MiniReach can be used with ramps, which are at no
   more than a [1/12] slope. Ramps that are steeper than a [1/12] slope
   are unsafe and may be a tipping hazard.

Water
'''''
 - MiniReach has not been tested for any type of contact with water
   or any other liquid. Under no circumstances should MiniReach
   come in contact with water from rain, mist, ground water (puddles)
   and any other liquid. Water contact can cause damage to the electrical
   circuitry and the mechanism.

Temperature and Humidity 
''''''''''''''''''''''''
 - MiniReach is designed to run in environments between 15C and 35C.
 - Keep MiniReach away from open flames and other heat sources.

Forces and Torques 
++++++++++++++++++ 

NOTE: SOFTWARE/FIRMWARE LIMITS NOT YET IMPLEMENTED

Joint position, velocity, and force limits are implemented in the
MiniReach URDF file as well as in firmware. Firmware implements
additional power limits. These joint limits control the range of
travel of the mechanism and the allowable velocity to prevent
over-travel. These limits are enforced by the controller, and are
designed to prevent poorly commanded control efforts from damaging the
robot or harming operators.

The limits below are from the MiniReach URDF files. If a
velocity or torque limit is not specified, no value is enforced.

======================== ========== ============ =====
Joint                    Velocity   Torque/Force Power
======================== ========== ============ =====
wheel_drive_joint        TBD        TBD          TBD
wheel_steer_joint        TBD        TBD          TBD
fork_joint               TBD        TBD          TBD
reach_joint              0.012m/s   TBD          TBD
camera_joint             TBD        TBD          TBD
======================== ========== ============ =====

Joint Limits and Types
++++++++++++++++++++++

The position limits for MiniReach are specified below. These
"hard limits" are the maximum travel for the mechanism.

======================== ========== =========== ==========
Joint                    Type       Limit (+)   Limit (-)
======================== ========== =========== ========== 
fork_joint               prismatic   1000mm     0mm
reach_joint              prismatic   [400mm]    0mm
wheel_steer_joint        revolute    180°       180°
camera_joint             revolute    [45°]      [45°]
======================== ========== =========== ==========

