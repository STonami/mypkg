#!/bin/bash
# SPDX-FileCopyrightText: 2025 Tonami Seki
# SPDX-License-Identifier: BSD-3-Clause

# ROS 2 ワークスペースのディレクトリ
dir=~
[ "$1" != "" ] && dir="$1"

source $dir/.bashrc

if [ -d "$dir/ros2_ws" ]; then
    cd $dir/ros2_ws
else
    echo "Directory $dir/ros2_ws does not exist."
    exit 1
fi

colcon build

# ノードの実行とログの保存
timeout 20 bash -c "source $dir/.bashrc && ros2 run mypkg battery_status_publisher" &

# トピックの購読結果をログに保存
timeout 20 bash -c "ros2 topic echo /battery/percent" > /tmp/battery_percent.log &
timeout 20 bash -c "ros2 topic echo /battery/power_plugged" > /tmp/battery_power_plugged.log &

sleep 20

# ログ内容の表示と確認
echo "Battery Percent Log:"
cat /tmp/battery_percent.log
echo "Battery Power Plugged Log:"
cat /tmp/battery_power_plugged.log

# 検証
if grep -q 'data:' /tmp/battery_percent.log && grep -q 'data:' /tmp/battery_power_plugged.log; then
    echo "Battery status messages found in logs"
    exit 0
else
    echo "Battery status messages not found in logs"
    exit 1
fi

