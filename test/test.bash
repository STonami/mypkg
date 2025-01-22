#!/bin/bash
# SPDX-FileCopyrightText: 2025 Tonami Seki
# SPDX-License-Identifier: BSD-3-Clause

# Default directory
dir=~
[ "$1" != "" ] && dir="$1"

# Move to ROS 2 workspace directory
cd $dir/ros2_ws || { echo "Directory not found: $dir/ros2_ws"; exit 1; }

# Build the workspace
colcon build || { echo "Build failed."; exit 1; }

# Source the setup file
source $dir/ros2_ws/install/setup.bash

# Start the battery_status_publisher node in the background
ros2 run mypkg battery_status_publisher &
PUBLISHER_PID=$!

# Give the node some time to start
sleep 5

# Subscribe to the topics and capture output
timeout 10 ros2 topic echo /battery/percent > /tmp/battery_percent.log &
SUBSCRIBER_PID1=$!
timeout 10 ros2 topic echo /battery/power_plugged > /tmp/battery_plugged.log &
SUBSCRIBER_PID2=$!

# Wait for the subscribers to finish
wait $SUBSCRIBER_PID1 $SUBSCRIBER_PID2

# Check if the logs contain data
if grep -qE "data: [0-9]+" /tmp/battery_percent.log && grep -qE "data: (true|false)" /tmp/battery_plugged.log; then
    echo "Test passed: Data received on both topics."
    TEST_RESULT=0
else
    echo "Test failed: No data received on one or both topics."
    TEST_RESULT=1
fi

# Clean up
kill $PUBLISHER_PID 2>/dev/null
rm /tmp/battery_percent.log /tmp/battery_plugged.log

exit $TEST_RESULT

