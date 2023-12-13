## Enabling SSH Keys
This explanation is written for enabling SSH key access on the Turing Pi BMC, but the same steps can be applied exactly the same to any other device in the cluster.

Perform the following steps on client machine: 
1. Generate SSH key pair
	`ssh-keygen -p -f ~/.ssh/turing`
2. Copy public key to BMC
	`ssh-copy-id -i ~/.ssh/turing.pub root@turingpi` 
3. Check that the BMC access via SSH key is possible
	`ssh -i ~/.ssh/turing root@turingpi`
4. Set as default identity key
	`nano ~/.ssh/config` and add line `IdentityFile ~/.ssh/turing`
	Now, `ssh root@turingpi` should be sufficient to gain access
5. Change permissions 
	`chmod 0600 ~/.ssh/*`

### Hardening Access
TODO: break down SSH hardening steps from Jeff Geerling's security Ansible role, explain how to manually apply to BMC (where Python is not installed, so no automatic Ansible configuration is possible).