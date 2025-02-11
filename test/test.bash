#!/bin/bash
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

ros2 run mypkg battery_status_publisher > /tmp/battery_status.log &

sleep 5

# ノードをバックグラウンドで実行
timeout 10 ros2 topic echo /battery/percents > /tmp/battery_status_test.log

ros2 topic list

# ログの内容を検証
if ros2 topic list | grep -q "battery"; then
    echo "Test passed."
    exit 0
else
    echo "Test failed."
    exit 1
fi

