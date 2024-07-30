.PHONY: ansible-requirements, provision

ansible-requirements:
	ansible-galaxy install -r requirements.yml

provision:
	ansible-playbook playbooks/provision.yml
