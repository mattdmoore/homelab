### Resources
[Github](https://github.com/turing-machines/BMC-Firmware)
[Docs](https://docs.turingpi.com/docs/turing-pi2-bmc-intro-specs)

## Flashing BMC Firmware Image to  MicroSD Card
This step should only be necessary once, when upgrading firmware from v1.x to v.2 -- subsequent updates can be done OTA using the web terminal.
1. [Download image](https://github.com/turing-machines/BMC-Firmware/suites/18382034790/artifacts/1064830863)
2. Diskdump to SD card
	Replace `if=` target with firmware .img file and `of=` target with the MicroSD card device obtained from `sudo fdisk -l`
	`dd if=tp2-firmware-sdcard-v2.0.0-RC3-4-gd7bb01cc.img of=/dev/sda status=progress`
3. Insert MicroSD card into Turing Pi rear slot
4. Reset Turing Pi
5. Wait until LEDs on LAN ports start to blink
6. Press KEY_1 three times
	LEDs will flash from left to right during flashing; wait until they start to blink twice
7. Remove MicroSD card and reset Turing Pi
### Connecting to Serial Interface via UART
[Docs](https://docs.turingpi.com/docs/turing-pi2-specs-and-io-ports#uart)
>  DhanOS (Daniel Kukiela):
>  Also keep in mind, that this UART interface (UART0) is actually connected to the BMC where you can connect to the node UARTs using:
>  `microcom -s 115200 /dev/ttyS1`
>  UARTs: 
>```
Node 1: /dev/ttyS2 
Node 2: /dev/ttyS1 
Node 3: /dev/ttyS4 
Node 4: /dev/ttyS5 
>``` 
>Additionally, CM4 only has a single UART interface which means GPIO14/15 (and UART headers (for nodes 2-4) on the edge of the board) won't work with it. GPIO14/15 and UART headers are connected to UART1 for the modules that contain it (like Nvidia Jetson)