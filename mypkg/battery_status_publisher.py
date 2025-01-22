# SPDX-FileCopyrightText: 2025 Tonami Seki
# SPDX-License-Identifier: BSD-3-Clause

import rclpy
from rclpy.node import Node
from std_msgs.msg import Float32, Bool
import psutil

class BatteryStatusPublisher(Node):
    def __init__(self):
        super().__init__('battery_status_publisher')
        self.battery_percent_publisher = self.create_publisher(Float32, '/battery/percent', 10)
        self.power_plugged_publisher = self.create_publisher(Bool, '/battery/power_plugged', 10)
        self.timer = self.create_timer(2.0, self.publish_battery_status)
        self.get_logger().info("Battery Status Publisher Node started")

    def publish_battery_status(self):
        battery = psutil.sensors_battery()
        if battery:
            # バッテリー残量を配信
            percent_msg = Float32()
            percent_msg.data = battery.percent
            self.battery_percent_publisher.publish(percent_msg)

            # 電源接続状態を配信
            plugged_msg = Bool()
            plugged_msg.data = battery.power_plugged
            self.power_plugged_publisher.publish(plugged_msg)

            self.get_logger().info(f"Published: Battery Percent = {battery.percent}, Power Plugged = {battery.power_plugged}")
        else:
            self.get_logger().warning("Battery information not available")

def main(args=None):
    rclpy.init(args=args)
    node = BatteryStatusPublisher()
    rclpy.spin(node)
    node.destroy_node()
    rclpy.shutdown()

if __name__ == '__main__':
    main()

