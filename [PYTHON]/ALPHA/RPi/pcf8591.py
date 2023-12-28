import smbus
import time

address = 0x48
A0 = 0x40
value = 0

bus = smbus.SMBus(1)

while True:
    bus.write_byte_data(address,A0,value)
    value = bus.read_byte(address)
    value +- 1
    if value == 265:
        value = 0
    print("AOUT:%3d" %value)
    time.sleep(0.1)
