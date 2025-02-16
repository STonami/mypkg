#!/bin/bash
# SPDX-FileCopyrightText: 2025 Tonami Seki
# SPDX-License-Identifier: BSD-3-Clause

# デフォルトのディレクトリ設定
dir=~
[ "$1" != "" ] && dir="$1"

# ROS 2 ワークスペースへ移動
cd $dir/ros2_ws || { echo "Failed to change directory"; exit 1; }

# ビルドと環境設定
colcon build || { echo "Build failed"; exit 1; }
source $dir/.bashrc


# ノードが起動するまで待機
sleep 5

timeout 20 ros2 run mypkg battery_status_publisher

# バッテリーステータスを取得
ros2 topic echo /battery/percents -n 1
ros2 topic echo /battery/percents --once > /tmp/battery_status_output.log

# 結果の表示
cat /tmp/battery_status_output.log

if grep -q 'Battery' /tmp/battery_status_output.log;then
    echo "Test passed."
else
    echo "Test failed."
    exit 1
fi
