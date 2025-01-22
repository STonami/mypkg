find_package(ament_cmake REQUIRED)
find_package(rclpy REQUIRED)

install(
  PROGRAMS
    scripts/battery_status_publisher.py
    scripts/listener.py
  DESTINATION lib/${PROJECT_NAME}
)


ament_package()

