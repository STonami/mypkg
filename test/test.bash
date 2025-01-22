#!/bin/bash
# SPDX-FileCopyrightText: 2025 Tonami Seki
# SPDX-License-Identifier: BSD-3-Clause

dir=~
[ "$1" != "" ] && dir="$1"

cd $dir/ros2_ws

# パッケージのビルド
colcon build --packages-select mypkg
if [ $? -ne 0 ]; then
    echo "Build failed"
    exit 1
fi

source install/setup.bash

# バッテリーパブリッシャーノードの起動
ros2 run mypkg battery_status_publisher > /tmp/mypkg.log 2>&1 &
PUBLISHER_PID=$!

# 起動が安定するまで待機
sleep 5

# トピックを確認 (明示的にデータの内容を取得)
PERCENT=$(ros2 topic echo /battery/percent --once 2>/dev/null | grep "data" | awk '{print $2}')
PLUGGED=$(ros2 topic echo /battery/power_plugged --once 2>/dev/null | grep "data" | awk '{print $2}')

# ノードを停止
kill $PUBLISHER_PID

# トピックのデータ検証
if [[ "$PERCENT" =~ ^[0-9]+(\.[0-9]+)?$ ]] && [[ "$PLUGGED" =~ ^(true|false)$ ]]; then
    echo "Test passed!"
    exit 0
else
    echo "Test failed"
    echo "Percent: $PERCENT"
    echo "Plugged: $PLUGGED"
    exit 1
fi

