# Jetson TX2 NX Module - Flashing, Booting from NVME and more

I would like to share the process of how I managed to flash a Jetson TX2 NX Module using the Turing Pi 2 cluster board.  
The process described below failed when the module was located in slot 1, but it worked perfect in Slot 2.

**Introduction**

You need a host computer with Ubuntu 18.04.6 LTS operating system to build the image. I am not using any VM technology, just Ubuntu installed on a computer. It might also work with a Live Boot USB but I haven't tested that myself.

The latest Linux version which supports the Jetson TX2 NX Module is Jetson Linux R32.7.3 (included as part of JetPack 4.6.3)  
The download links used in the instructions below are copied from this web page: [https://developer.nvidia.com/embedded/linux-tegra-r3273](https://developer.nvidia.com/embedded/linux-tegra-r3273)

I also upgraded the BMC firmware using this repository from Daniel Kukiela [https://github.com/daniel-kukiela/turing-pi-2-community-edition-firmware](https://github.com/daniel-kukiela/turing-pi-2-community-edition-firmware). This will define a static MAC address for your Turing Pi 2 clusterboard. On the initial firmware version the MAC address kept changing after each restart, leading to a different IP address assigned by the network router (DHCP).

The 16 GB of eMMC storage on the Jetson TX2 NX module is not large enough to install all the Jetson Software. I had already bought 4 Intel P670 NVME 500GB drives myself a few months ago for about EUR 37 per piece. These are QLC based SSD drives, which were much cheaper at that time compared to TLC based SSD drives. QLC drives are fine for use cases where you only need to write a few times but read a lot, like for AI and Analytics. But the last few weeks the prices of TLC based SSD drives have dropped significantly, so there is no price benefit to choose for TLC based SSD drives anymore. If I had to buy new drives today, I would get the Samsung Evo 980 instead (about EUR 35 for the 500GB version at the time of writing, April 30th 2023). TLC drives are in general more performant, durable and reliable when compared to QLC drives. There is little value to buy the really fast NVME drives for the Jetson TX2 NX as the specifications indicate a maximum transfer speed of 2 GB/s.

I initially tried to flash the image directly to the NVME drive, but that didn't work out for me. So as a workaround I first flashed the on-board eMMC storage of the module and cloned it to the NVME drive afterwards.

**Step 1. Building the System Image on the host computer**

Open a System Terminal on your host computer and create a project folder for the image build in your home directory:

```bash
mkdir -p projects/nvidia/tx2-nx 
cd projects/nvidia/tx2-nx
```

Download Driver Package (BSP):

```bash
wget https://developer.nvidia.com/downloads/remksjetpack-463r32releasev73t186jetsonlinur3273aarch64tbz2
```

Download Sample Root File System

```bash
wget https://developer.nvidia.com/downloads/remeleasev73t186tegralinusample-root-filesystemr3273aarch64tbz2
```

Unpack Driver Package (BSP):

```bash
tar -xvf remksjetpack-463r32releasev73t186jetsonlinur3273aarch64tbz2
```

Unpack the Sample Root File System

```bash
cd Linux_for_Tegra/rootfs/
sudo tar -xpvf ../../remeleasev73t186tegralinusample-root-filesystemr3273aarch64tbz2
```

Apply Jetson-specific binaries to the image file

```bash
cd .. 
sudo ./apply_binaries.sh
```

Skipping oem-config by creating a default user and accepting the license. Replace the &lt;username&gt;, &lt;password&gt; and &lt;hostname&gt; values with your own values. This will ensure that your module will startup headless without the need to walk through the setup wizard for which you need a display and keyboard.

```bash
cd tools
sudo ./l4t_create_default_user.sh -u <username> -p <password> -n <hostname> --accept-license
```

Connect your Host Computer to the Turing Pi 2 Cluster board via an USB 2.0 cable. You need to plug it in the Vertical USB port next to the HDMI port on the Turing Pi 2 Cluster board.

Now force the Jetson TX2 NX module into Recovery Mode ( Assuming that the Jetson TX2 NX module is inserted in Slot 2).

Use the Turing Pi 2 web panel to force the device in Node 2 into Forced Recovery Mode:  
\- turn the Node 2 power off \[ Power Tab\]  
\- set Node 2 into the device mode \[ USB Tab\]  
\- turn the Node 2 power on \[Power Tab\]

Flash the Jetson TX2 NX Module

```bash
cd ..
sudo ./flash.sh jetson-xavier-nx-devkit-tx2-nx mmcblk0p1
```

When the flashing has been completed the final two lines will appear:

> \*\*\* The target t186ref has been flashed successfully. \*\*\*  
> Reset the board to boot from internal eMMC.

Now use the Turing Pi 2 web panel to turn the Node 2 off and on again:

\- turn the Node 2 power off \[ Power Tab\]  
\- turn the Node 2 power on \[Power Tab\]

Open the web interface of your network router and lookup the DHCP ip address assigned to the Jetson TX2 NX Module once the boot process has been completed.

**Step 2. Prepare the NVME drive**

Open a secure shell session and login to the Jetson TX2 NX Module:

```bash
ssh <username>@<ip-address>
```

All commands below need to be executed within the SSH session on the Jetson TX2 NX Module.

Prepare the NVME drive:

```bash
sudo parted /dev/nvme0n1
```

This will open the parted (drive partition) application in your session, now type the following commands to partition the NVME drive. I am using 80% of the drive for the root partition here, this will leave some space when you need some space for other purposes later on, like e.g. swap space:

```bash
mklabel gpt
unit s
mkpart primary ext4 0% 80%
quit
```

Now create an Ext4 filesystem on the partition:

```bash
sudo mkfs.ext4 /dev/nvme0n1p1
```

Reboot the Jetson TX2 NX module

```bash
sudo reboot now
```

**Step 3. Clone the Root File System from the eMMC storage to the NVME drive**

Open a secure shell session and login to the Jetson TX2 NX Module:

```bash
ssh <username>@<ip-address>
```

Create a project directory and execute the instructions from Jetson Hacks ( [https://jetsonhacks.com/2020/05/29/jetson-xavier-nx-run-from-ssd/](https://jetsonhacks.com/2020/05/29/jetson-xavier-nx-run-from-ssd/)):

```bash
mkdir projects
cd projects
git clone https://github.com/jetsonhacks/rootOnNVMe
cd rootOnNVMe
./copy-rootfs-ssd.sh
./setup-service.sh
```

Reboot the Jetson TX2 NX module

```bash
sudo reboot now
```

**Step 4. Install additional software**

Open a secure shell session and login to the Jetson TX2 NX Module:

```bash
ssh <username>@<ip-address>
```

Your Jetson TX2 NX should now boot from the NVME drive. You can validate that after the reboot with the following command:

```bash
df -h
```

You should then see that the root directory is mounted on the NVME drive, one of the lines should display something like this:

> /dev/nvme0n1p1 375G 5.3G 351G 2% /

Install Jetson Stats, Nmon, Nano, Apt-Utils and Nvidia Jetpack:

```bash
sudo apt update
sudo apt -y upgrade
sudo apt -y install python3-pip apt-utils nmon nano
sudo apt -y install nvidia-jetpack
sudo pip3 install -U jetson-stats
```

Enable Automatic Fan Control:

```bash
sudo apt install python3-dev
cd ~/projects
git clone https://github.com/Pyrestone/jetson-fan-ctl.git
cd jetson-fan-ctl/
sudo ./install.sh
```

Set the performance to maximum and remove clock restrictions limiting the processors:

```
sudo nvpmodel -m 0
cd /usr/bin
sudo ./jetson_clocks
```

Build OpenCV 4.5.2 with CUDA 10.2 Support:

```bash
cd ~/projects
git clone https://github.com/mdegans/nano_build_opencv.git
cd nano_build_opencv
```

Now change line 110 in build\_opencv.sh (else it will lead to the error nvcc fatal : Unsupported gpu architecture 'compute\_87', see also https://developer.nvidia.com/cuda-gpus)  
From <span class="pl-s"> -D CUDA\_ARCH\_BIN=5.3,6.2,7.2,8.7</span>  
To <span class="pl-s"> -D CUDA\_ARCH\_BIN=6.2</span>

```bash
./build_opencv.sh 4.6.0
```

This last build will take a long time, but once this step is completed you will have a complete set of software on your Jetson TX2 NX to start experimenting and developing.

**Step 5. Have Fun!**