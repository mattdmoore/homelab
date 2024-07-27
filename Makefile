.PHONY: ansible-requirements

ansible-requirements:
	ansible-galaxy install -r requirements.yml

