#!/bin/bash
# SPDX-FileCopyrightText: 2025 Tonami Seki
# SPDX-License-Identifier: BSD-3-Clause

dir=~ 
[ "$1" != "" ] && dir="$1"

cd $dir/ros2_ws

colcon build

source $dir/ros2_ws/install/setup.bash

timeout 60 ros2 run mypkg battery_status_publisher > /tmp/battery.log 2>&1

if grep -q 'Published:' /tmp/battery.log; then
    echo "Test passed"
    exit 0
else
    echo "Test failed"
    exit 1
fi

