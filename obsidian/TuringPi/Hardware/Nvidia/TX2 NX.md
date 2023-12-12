## TX2 NX
### Flashing JetPack 4.6.3
Discord user cyliew#7861 wrote an extensive [[Flashing Guide|guide]] on how to flash JetPack OS to the TX2, but there are still a few wrinkles in this process left to figure out.
#### Issue #1: Jetson modules cannot put their USB port into host mode
> DhanOS (Daniel Kukiela): 
> While the USB port can be used in the host mode, and this works with CM4, for example, the Jetson modules indeed cannot put their USB port into the host mode.

This prevents using a keyboard to input commands via the switchable USB 2.0 port; the only solution is to use an mPCIe to USB adapter. Serial port connection might be possible, but none of my attempts have been successful and others have reported similar difficulties.

#### Issue #2: Jetson modules require a USB A-to-A connection, and the Turing Pi USB port can be inconsistent when flashing to Node 1
> DhanOS (Daniel Kukiela): 
> A few things to consider:
	> - If you have issues, avoid node 1 - it's known to have issues with flashing on some of the boards so it's good to take it out of the equation
	> - For Node 1 and Node 2, if you inserted a Mini PCIe card, try to remove it for flashing
	> - A sequence to put the module into the recovery mode is: turn off the node, set this node into the device mode, turn on the node (you must power on the node after you put it into the client mode)
	> - A-to-C cables rarely work. Very rarely. Ideally you need an A-to-A cable
	> - If you still want to try A-to-C cable and you have some USB hubs, try them. If you have a USB port in your monitor and monitor is connected to the PC via USB, that'd count as a hub

This could cause problems when attempting to use a screen to make initial OS setup easier, since HDMI output is only available over Node 1. It may require experimenting with a few different cables to find a configuration that allows both user interaction and flashing over USB from a connected device.