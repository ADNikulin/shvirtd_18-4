#!/bin/bash

if ! command -v docker &> /dev/null
then
   #!/bin/bash

	# Add Docker's official GPG key:
	sudo apt-get update &&
	sudo apt-get install ca-certificates curl gnupg -y &&
	sudo install -m 0755 -d /etc/apt/keyrings &&
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg &&
	sudo chmod a+r /etc/apt/keyrings/docker.gpg &&

	# Add the repository to Apt sources:
	echo \
	"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
	$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
	sudo tee /etc/apt/sources.list.d/docker.list > /dev/null &&
	sudo apt-get update &&
	sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin &&
fi

if [ ! -d "/opt/shvirtd-example-python" ] ; then
    sudo git clone https://github.com/ADNikulin/shvirtd_18-4.git /opt/shvirtd-example-python
else
    cd /opt/shvirtd-example-python
    sudo git pull
fi

cd /opt/shvirtd-example-python

sudo docker-compose -f compose.yaml up -d