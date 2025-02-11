# SPDX-FileCopyrightText: 2025 Tonami Seki
# SPDX-License-Identifier: BSD-3-Clause

import rclpy
from rclpy.node import Node
from std_msgs.msg import String

class BatteryStatusListener(Node):
    def __init__(self):
        super().__init__('battery_status_listener')
        self.subscription = self.create_subscription(
            String,
            'battery_status',
            self.listener_callback,
            10
        )

    def listener_callback(self, msg):
        self.get_logger().info(f'Received message: {msg.data}')

def main():
    rclpy.init()
    node = BatteryStatusListener()
    rclpy.spin(node)
