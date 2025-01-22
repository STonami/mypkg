from setuptools import setup
import os
from glob import glob

package_name = 'mypkg'

setup(
    name=package_name,
    version='0.0.0',
    packages=[package_name],
    py_modules=[],
    data_files=[
        ('share/ament_index/resource_index/packages',
         ['resource/' + package_name]),
        ('share/' + package_name, ['package.xml']),
        ('share/' + package_name + '/launch', glob('launch/*.launch.py'))
    ],
    install_requires=['setuptools'],
    zip_safe=True,
    maintainer='gano',
    maintainer_email='dounanguan@gmail.com',
    description='Description of mypkg',
    license='BSD-3-Clause',
    tests_require=['pytest'],
    entry_points={
    'console_scripts': [
        'battery_status_publisher = mypkg.battery_status_publisher:main',
    ],
},

)

