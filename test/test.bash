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

# ノードの実行
source $dir/.bashrc
ros2 run mypkg battery_status_publisher &
PUBLISHER_PID=$!

# トピックの準備を確認
echo "Waiting for topics to be available..."
for i in {1..10}; do
    if ros2 topic list | grep -q "/battery/percent" && ros2 topic list | grep -q "/battery/power_plugged"; then
        echo "Topics are now available."
        break
    fi
    sleep 2
done

# トピックが準備されなければエラーを返す
if ! ros2 topic list | grep -q "/battery/percent" || ! ros2 topic list | grep -q "/battery/power_plugged"; then
    echo "Topics are not available. Exiting test."
    kill $PUBLISHER_PID
    exit 1
fi

# トピックの購読とログ保存
timeout 20 bash -c "ros2 topic echo /battery/percent" > /tmp/battery_percent.log &
timeout 20 bash -c "ros2 topic echo /battery/power_plugged" > /tmp/battery_power_plugged.log &

# 十分な時間を待つ
sleep 20

# ノードの停止
kill $PUBLISHER_PID

# ログ内容の表示と検証
echo "Battery Percent Log:"
cat /tmp/battery_percent.log
echo "Battery Power Plugged Log:"
cat /tmp/battery_power_plugged.log

if grep -q 'data:' /tmp/battery_percent.log && grep -q 'data:' /tmp/battery_power_plugged.log; then
    echo "Battery status messages found in logs"
    exit 0
else
    echo "Battery status messages not found in logs"
    exit 1
fi

