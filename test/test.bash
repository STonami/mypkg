#!/bin/bash

# ROS 2 ワークスペースに移動
cd ~/ros2_ws

# パッケージをビルド
colcon build

# 環境設定
source install/setup.bash

# battery_status_publisher ノードを開始
echo "Starting battery_status_publisher node..."
ros2 run mypkg battery_status_publisher &

# バックグラウンドプロセスの PID を保存
NODE_PID=$!

# ノードが完全に立ち上がるのを少し待機
sleep 2

# 開始メッセージをパブリッシュ
echo "Publishing start message..."
ros2 topic pub --once /start_time std_msgs/String "data: 'start'"

# 10 秒間待機している間にバッテリー情報がパブリッシュされる
echo "Waiting for 10 seconds..."
sleep 10

# 停止メッセージをパブリッシュ
echo "Publishing stop message..."
ros2 topic pub --once /stop_time std_msgs/String "data: 'stop'"

# 終了メッセージ
echo "Test completed!"


