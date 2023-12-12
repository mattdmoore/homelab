[Ansible docs](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html)
## Nested groups 
The `hosts` file follows the basic structure copied from [`k3s-ansible`](https://github.com/k3s-io/k3s-ansible). The `turing_pi` parent group contains the entire cluster, with child groups `server` and `agent` designating the control plane and worker nodes for k3s[1].
### Server
Nodes 1 and 2 are configured as control planes with their own separate ZFS pools for better system redundancy. For testing, they currently use CM4s (8GB & 4GB), but will replace with 32GB RK1s when available.
### Agent
Node 3 contains an NVidia TX2 NX (needs re-flashing), and external Node 5 is an 8GB ZimaBoard with x86 CPU architecture for any applications that won't run on ARM chips. The 8GB CM4 will migrate to Node 4 when RK1s arrive.
### Notes
[1] Could be beneficial to separate nodes physically connected to the Turing Pi from external nodes (i.e., ZimaBoard), but may end up with redundant groupings if nodes are also eventually grouped by CPU architecture.