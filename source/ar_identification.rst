Tutorial: AR positioning
========================

Once you have the 3D camera running, you can start looking for pallets and 
pallet stations. These should be identified by a unique AR tag. 

Which AR tags that are used are defined in the file ar_ids.yaml in the minireach_world_state/Data map. The maximum and minimum value is set for both pallet ids and station ids.

The ohter files in minireach_world_state/Data, pallets.yaml and stations.yaml, contains the positions of the AR tags to the corresponding object. The positions are automatically updated whenever the 3D camera sees the AR tag and published to a topic called XXXX