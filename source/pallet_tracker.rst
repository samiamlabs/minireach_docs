Component: Pallet tracker
======================

Overview
------------------------
The pallet tracker is using Visual Servoing platform (ViSP) 3.0.0 to track a pallet.

Documentation for the ViSP project can be found here:  https://visp.inria.fr/

Documentation for the ViSP ROS package can be found here: http://wiki.ros.org/visp_tracker

The tracking of a pallet is mainly divided into different steps

* Finding the pallet using an initial pose

  * Calulating a score for each track.
  * Choose the best track after a few iterations.

* Tracking the pallet.

Files neccesary for the tracker
------------------------

In the models folder all files neccesary for the tracker are specified::

  models/
  └── euro-pallet-aisles
      ├── euro-pallet-aisles.0.pos
      ├── euro-pallet-aisles.ac
      ├── euro-pallet-aisles.cao
      ├── euro-pallet-aisles.init
      ├── euro-pallet-aisles.ppm
      ├── euro-pallet-aisles-real.jpg
      ├── euro-pallet-aisles-sim.jpg
      └── tracker.yaml

euro-pallet-aisles.0.pos*

Holds the last pose when the tracker did an update. It is written automatically

euro-pallet-aisles.ac

???

euro-pallet-aisles.cao

Holds the 3D model for the object that we want to track.

euro-pallet-aisles.init


euro-pallet-aisles.ppm

euro-pallet-aisles-real.jpg
euro-pallet-aisles-sim.jpg

These are the files that are used for template matching. One file for the simulator and another one for the real truck.
 

Initial pose estimation
------------------------

Tracking using VISP
------------------------

Ranking using template matching
------------------------

Ranking using AdaBoost instead
------------------------

Change model or create your own model
------------------------

If you want to create your own model, you will have to create a new cao file. It is possible to create the model using a CAD application, but for simpler models it might be faster to just draw you model on a paper and enumerate all the corners. Specify each corner's location in 3D space and specify the lines and/or faces of your object, by specifying the indices of the corners that define the line or face.

A file might look like this::

  V1
  # Number of points
  8
  # 3D points (x, y, z)
  -1.0 -1.0 -1.0,
  -1.0 -1.0  1.0,
  -1.0  1.0 -1.0,
  -1.0  1.0  1.0,
   1.0 -1.0 -1.0,
   1.0 -1.0  1.0,
   1.0  1.0 -1.0,
   1.0  1.0  1.0,
  # 3D lines
  0
  # Faces from 3D lines
  0
  # Faces from 3D points, first number is the number of points
  # The rest are the indices
  6
  4 0 4 6 2
  4 0 2 1 3
  4 0 1 5 4
  4 4 5 7 6
  4 2 6 7 3
  4 1 3 7 5
  # 3D cylinders
  0
  # 3D circles
  0

Here you can read more about creating your own models: http://visp-doc.inria.fr/doxygen/visp-daily/tutorial-tracking-mb.html#mb_advanced_cao
  
Known problems and suggested solutions
------------------------
  
Suggestion for extensions
------------------------
