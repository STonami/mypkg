find_package(ament_cmake REQUIRED)
find_package(rclpy REQUIRED)

install(
    PROGRAMS
    scripts/status_publisher.py  # 実行可能スクリプトのパス
    DESTINATION lib/${PROJECT_NAME}
)

ament_package()

