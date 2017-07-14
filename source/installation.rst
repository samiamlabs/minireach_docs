Installing Truck Simulator
==========================

You will need an installation of ROS Indigo for the following instructions
to work. You can find a guide for installing it  
`here <http://wiki.ros.org/indigo/Installation/Ubuntu>`_.

Install wstool and rosdep. ::

  sudo apt-get update
  sudo apt-get install -y python-wstool python-rosdep ninja-build

Create a new workspace in 'catkin_ws'. ::

  cd ~
  mkdir catkin_ws
  cd catkin_ws
  wstool init src

Merge the minireach.rosinstall file and fetch code for dependencies. ::

  wstool merge -t src https://github.com/samiamlabs/minireach_install/raw/master/minireach.rosinstall
  wstool update -t src

Install deb dependencies. ::

  sudo rosdep init
  rosdep update
  rosdep install --from-paths src --ignore-src --rosdistro=${ROS_DISTRO} -y -r

Source ROS if you have not already sourced the main ROS environment: ::

  echo "source /opt/ros/indigo/setup.bash" >> ~/.bashrc
  source ~/.bashrc

Build ::

  catkin_make_isolated --use-ninja
  source devel_isolated/setup.bash

Test ::

  rospack profile
  roslaunch minireach_gazebo monosim.launch
