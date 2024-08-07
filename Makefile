.PHONY: ansible-requirements, provision

ansible-requirements:
	ansible-galaxy install -r requirements.yml

provision:
	ansible-playbook playbooks/provision.yml

build-cluster:
	ansible-playbook playbooks/k3s.yml

kube-vip:
	ansible-playbook playbooks/kube-vip.yml
