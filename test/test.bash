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

# tmux セッション名の設定
SESSION_NAME="battery_monitor_session"
tmux new-session -d -s $SESSION_NAME "ros2 run mypkg battery_status_publisher > $HOME/tmp/battery_status.log 2>&1"

# ノードが起動するまで待機
sleep 5

# バッテリーステータスを取得
ros2 topic echo /battery/percents --once
ros2 topic echo /battery/percents -n 1 > /tmp/battery_status_output.log

# 結果の表示
cat /tmp/battery_status_output.log

if grep -q 'Battery' /tmp/battery_status_output.log;then
    echo "Test passed."
else
    echo "Test failed."
    exit 1
fi
