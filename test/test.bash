#!/bin/bash
# SPDX-FileCopyrightText: 2025 Tonami Seki
# SPDX-License-Identifier: BSD-3-Clause

dir=~
[ "$1" != "" ] && dir="$1"

cd $dir/ros2_ws

colcon build

source $dir/ros2_ws/install/setup.bash

timeout 60 ros2 launch mypkg talk_listen.launch.py > /tmp/powerwatch.log

if grep -q 'battery_status_listener' /tmp/powerwatch.log; then
    echo "Test passed: Listener found in the log."
    exit 0
else
    echo "Test failed: Listener not found in the log."
    exit 1
fi
