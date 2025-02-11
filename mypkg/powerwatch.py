# SPDX-FileCopyrightText: 2025 Tonami Seki
# SPDX-License-Identifier: BSD-3-Clause

import rclpy
from rclpy.node import Node
from std_msgs.msg import String
import psutil
from datetime import datetime

class PowerWatch(Node):
    def __init__(self):
        super().__init__('powerwatch')
        self.publisher = self.create_publisher(String, 'battery_status', 10)
        self.timer = self.create_timer(1.0, self.publish_battery_status)

    def publish_battery_status(self):
        battery = psutil.sensors_battery()
        current_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

        if battery:
            status = "Charging" if battery.power_plugged else "Discharging"
            message = f"Battery: {battery.percent:.1f}%, Status: {status}, Time: {current_time}"
        else:
            message = f"No battery info available, Time: {current_time}"

        self.publisher.publish(String(data=message))

def main(args=None):
    rclpy.init(args=args)
    power_watch = PowerWatch()
    rclpy.spin(power_watch)
    power_watch.destroy_node()
    rclpy.shutdown()

if __name__ == '__main__':
    main()
