#SPDX-FileCopyrightText: 2025 Tonami Seki
# SPDX-License-Identifier: BSD-3-Clause

import rclpy
from rclpy.node import Node
from std_msgs.msg import Float32, Bool

class BatteryStatusPublisher(Node):
    def __init__(self):
        super().__init__('battery_status_publisher')
        self.publisher_percent = self.create_publisher(Float32, '/battery/percent', 10)
        self.publisher_power_plugged = self.create_publisher(Bool, '/battery/power_plugged', 10)
        self.timer = self.create_timer(2.0, self.publish_status)
        self.get_logger().info('Battery Status Publisher Node started')

    def publish_status(self):
        percent_msg = Float32(data=96.68)
        power_plugged_msg = Bool(data=True)
        self.publisher_percent.publish(percent_msg)
        self.publisher_power_plugged.publish(power_plugged_msg)
        self.get_logger().info(f'Published: Battery Percent = {percent_msg.data}, Power Plugged = {power_plugged_msg.data}')

def main(args=None):
    rclpy.init(args=args)
    node = BatteryStatusPublisher()

    try:
        rclpy.spin(node)
    except rclpy.executors.ExternalShutdownException:
        node.get_logger().warn("External shutdown detected. Exiting node.")
    finally:
        node.destroy_node()
        rclpy.shutdown()

if __name__ == '__main__':
    main()
