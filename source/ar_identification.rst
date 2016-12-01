Tutorial: AR-marker identification, positioning and broadcasting
================================================================

Saving and loading AR-markers
-----------------------------

Once the 3D camera is running, the robot can start looking for both pallets and pallet stations in the world in use.
Each object is identified by a unique AR-marker, situated on the front of the pallet or at the station location.
The markers are so called objects of type AlvarMarker which contain an ID and position in the world, among other information. 
These AlvarMarker objects are then in turn stored within a AlvarMarkers() object which then is broadcasted for other nodes to use.

Two files are used to keep track on the different AR-markers' IDs and positions. 
The files are called ``pallets.yaml`` and ``stations.yaml``, located in the folder ``minireach/minireach_world_state/data``. 
Valid AR-marker ID boundaries are held and defined in the file ``ar_ids.yaml``, located in the directory mentioned above. 
The boundaries are simply maximum and minimum value of the IDs for both pallets and pallet stations. 
These preset boundaries can manually be changed at any time to suit the desired IDs of the user.

When an AR-marker is discovered it is compared to the current AR-markers in the files.
If the marker is found in the file, the position of the marker is updated, and if not found the marker is added to the suitable corresponding file.
The AR-markers which have been seen once can be driven to without them being within line of sight.

AR-broadcaster
--------------

The node which offer these functionalities is called ``/ar_broadcaster``, located in ``minireach/minireach_world_state/nodes/ar_broadcaster.py``. The node is run with:

::

	>$ roslaunch minireach_world_state ar_broadcaster.launch

When the node is active, it broadcasts pallets in ``pallets.yaml`` on the topic ``pallet_ar_markers`` and pallet stations in ``stations.yaml`` on the topic ``station_ar_markers``.
Both topics are broadcasted at the frequency 10 Hz. The node also has two services to ease the removal of AR-markers from the save files. The first service erase one specified AR-marker, which either can be a pallet or a pallet station. 
This is desired when a marker has been completely removed or when it has been moved far from its previous position. The service is called ``remove_marker`` and is called using:

::

	>$ rosservice call /remove_marker <id>

The second service clears all known AR-markers from both files, why no id needs to be specified. This can be desireable when there is some kind of faulty regarding the AR-markers, which cannot be solved any other way.
The service is called ``clear_all_markers`` and is called using:

::

	>$ rosservice call /clear_all_markers




