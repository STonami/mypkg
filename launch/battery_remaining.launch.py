# SPDX-FileCopyrightText: 2025 Tonami Seki
# SPDX-License-Identifier: BSD-3-Clause

import launch
import launch_ros.actions


def generate_launch_description():
    # バッテリー情報をパブリッシュするノード
    battery_node = launch_ros.actions.Node(
        package='mypkg',           # パッケージ名
        executable='battery_node', # 実行ファイル名（battery_node.py）
        output='screen'            # ログを端末に出力
    )

    # リスナーノード（トピックを購読するための例）
    listener_node = launch_ros.actions.Node(
        package='mypkg',
        executable='listener',
        output='screen'
    )

    # LaunchDescriptionで複数ノードをまとめて起動
    return launch.LaunchDescription([
        battery_node,
        listener_node
    ])

