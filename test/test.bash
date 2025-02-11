#!/bin/bash -xv
# SPDX-FileCopyrightText: 2025 Tonami Seki
# SPDX-License-Identifier: BSD-3-Clause

# 使用するディレクトリを設定
dir=~
[ "$1" != "" ] && dir="$1"

# ROS 2 ワークスペースに移動してビルド
cd $dir/ros2_ws

colcon build

source $dir/.bashrc
source $dir/ros2_ws/install/setup.bash

# ノードをバックグラウンドで実行
timeout 60 ros2 launch mypkg talk_listen.launch.py > /tmp/battery_status.log 2>&1 &

# ログの内容を検証
if grep -E 'Battery:' /tmp/battery_status_test.log; then
    echo "Test Passed: Battery status messages detected."
    exit 0
else
    echo "Test Failed: No valid battery status messages detected."
    exit 1
fi

