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

# ノードをバックグラウンドで実行
ros2 run mypkg battery_status_publisher > /tmp/battery_status.log 2>&1 &
NODE_PID=$!

# ノードがデータをパブリッシュするのを待つ
sleep 5

# トピックからメッセージを購読
timeout 100 ros2 topic echo /battery/percents > /tmp/battery_status_test.log

# ノードを停止
kill $NODE_PID

# ログの内容を検証
grep -E 'Battery:' /tmp/battery_status_test.log

# テスト結果の判定
if [ $? -eq 0 ]; then
    echo "Test Passed: Battery status messages detected."
    exit 0
else
    echo "Test Failed: No valid battery status messages detected."
    exit 1
fi

