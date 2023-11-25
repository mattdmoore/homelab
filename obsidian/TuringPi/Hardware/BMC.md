### Resources
[Github](https://github.com/turing-machines/BMC-Firmware)
[Docs](https://docs.turingpi.com/docs/turing-pi2-bmc-intro-specs)

## Flashing BMC Firmware Image to  MicroSD Card
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
## Enabling SSH Keys
Perform the following steps on client machine: 
1. Generate SSH key pair
	`ssh-keygen -p -f ~/.ssh/turing`
2. Copy public key to BMC
	`ssh-copy-id -i ~/.ssh/turing.pub root@turingpi` 
3. Check that the BMC access via SSH key is possible
	`ssh -i ~/.ssh/turing root@turingpi`
4. Set as default identity key
	`nano ~/.ssh/config` and add line `IdentityFile ~/.ssh/turing`
	Now, `ssh root@turingpi` should be sufficient
1. Change permissions 
	`chmod 0600 ~/.ssh/*`

Then, SSH into Turing Pi BMC and disable password authentication
1.  `nano /etc/ssh/sshd_config` 
2. Change `#PasswordAuthentication yes` to `PasswordAuthentication no`
	Important: Remember to un-comment the line by deleting the `#` at the beginning
3. (Possibly unnecessary): Add `ChallengeResponseAuthentication no`