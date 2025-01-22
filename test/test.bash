#!/bin/bash

# パッケージのビルド
colcon build --packages-select mypkg
source install/setup.bash

# ノードをバックグラウンドで起動
ros2 run mypkg battery_status_publisher &
PUBLISHER_PID=$!

# スクリプト終了時にプロセスを停止
trap "kill $PUBLISHER_PID; exit 1" SIGINT SIGTERM EXIT

echo "Waiting for topics to publish data..."
for i in {1..10}; do
    # トピックデータを確認する
    if ros2 topic echo /battery/percent --once &>/dev/null && \
       ros2 topic echo /battery/power_plugged --once &>/dev/null; then
        echo "Topics are publishing data."
        kill $PUBLISHER_PID
        exit 0
    fi
    sleep 2
done

# データが取得できない場合
echo "Topics are not publishing data. Exiting test."
kill $PUBLISHER_PID
exit 1

