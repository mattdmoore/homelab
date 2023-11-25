## Flashing Ubuntu Server 22.04 LTS to MicroSD Card
1. Install [Raspberry Pi Imager](https://www.raspberrypi.com/software/)
2. Choose OS > Other general-purpose OS > Ubuntu > Ubuntu Server 22.04.3 LTS (64-bit)
3. Select MicroSD card as target
4. Edit settings:
	General:
		Set hostname: node-#.local
		Set username and password: matt (any password)
		Uncheck configure wireless LAN
		Set locale
	Services:
		Set Enable SSH; allow public-key authentication only
		Copy & paste output from `cat ~/.ssh/turing.pub` 
	Options:
		Uncheck enable telemetry 
5. Write image to MicroSD card
6. When finished, eject card and insert into CM4 carrier board
7. Check SSH key access is correctly configured with `ssh matt@node-#`