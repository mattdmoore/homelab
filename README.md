# Personal homelab K3s cluster project

This project automatically builds a High Availability (HA) [K3s](https://k3s.io/) cluster on a [Turing Pi 2](https://turingpi.com/product/turing-pi-2/) using [Ansible](https://www.ansible.com/).

Currently a work in progress, so don't expect this to run out of the box. Since this is a personal project, it's heavily configured towards my own hardware and I don't have any plans to change this for the foreseeable future. I'm using this to learn about DevOps, IaaC, etc. -- be careful about taking inspiration from anything you see here.

## Features

### Summary
- Highly available
	- Two-node control plane
	- Replicated MySQL external cluster datastore
- Infrastructure as a Code (IaaC)
	- Ansible automation wherever possible
- Data safety
	- Distributed storage
	- ZFS pools on multiple nodes with scheduled scrubs

#### Automated with Ansible
- [x] [Hardware provisioning](https://github.com/notthebee/infra)
- [x] [SSH hardening](https://github.com/geerlingguy/ansible-role-security)
- [x] [ZFS installation](https://github.com/mrlesmithjr/ansible-zfs) and pool creation (3-wide 4 TB RAIDZ, one pool per master node)
- [x] [HA K3s installation](https://github.com/PyratLabs/ansible-role-k3s)
- [x] [External MySQL cluster datastore](https://github.com/geerlingguy/ansible-role-mysql)
- [x] Kube-vip virtual cluster IP (based on work by [Techno Tim](https://github.com/techno-tim/k3s-ansible))
- [ ] Longhorn storage manager deployment

#### Manually configured (to automate)
- [x] Zigbee2MQTT (Docker)
- [x] HomeAssistant (Docker)
- [x] Cloudflare Tunnelling

#### Roadmap
- [ ] Self-hosted services (NextCloud, Jellyfin, etc.)
- [ ] VPN with WireGuard and Mullvad
- [ ] Automated certificate management
- [ ] Automated CI/CD

## Hardware list

- Turing Pi 2
	- node-1: Raspberry Pi CM4 (Lite, 8 GB RAM, WLAN)
	- node-2: Raspberry Pi CM4 (Lite, 8 GB RAM)
	- node-3: Nvidia Jetson TX2 NX
	- node-4: Raspberry Pi CM4 (Lite, 4 GB RAM)
- External node(s)
	- node-5: ZimaBoard 832
- Upgrade roadmap
	- Turing RK1 32 GB; nodes 1 & 2 (pre-ordered)
	- Nvidia Jetson Orin Nano; node 3 (when JetPack 4.6 obsoleted)
	- Raspberry Pi CM5(?); node 4 (if compatible)
	- [PiKVM x650](https://geekworm.com/products/pikvm-x650)

- Storage
	- HDD: 
		- 6 x 4 TB Seagate Ironwolf NAS
	- SSD: 
		- 4 x 500 GB NVMe (Crucial P3, Kingston NV2)
		- 1 x 960 GB 2.5" SATA (Kingston SA400S37)
	- MicroSD:
			- 3 x SanDisk 64 GB Extreme PRO
- Power supply:
	- be quiet! Pure Power 11 400W
- Case
	- Fractal Design Node 304 - White
- Peripherals
	- SONOFF Zigbee 3.0 USB Dongle Plus
	- 2 x mPCIe 4 Port SATA Controller (Kalea Informatique)