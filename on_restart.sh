#! /bin/bash
# Declaring bash location
# Have four startups
# 2 flask, 2 watcher

#
##
### For cleaning out and making a fresh instanc of the render services
##
#

# If the Azure File Share mount directory doesn't exist, connect it
echo Full render restart service

if [[ ! -d /mnt/csae48d5df47deax41bcxbaa/ ]]; then
	sudo mkdir /mnt/csae48d5df47deax41bcxbaa
	if [ ! -d "/etc/smbcredentials" ]; then
		sudo mkdir /etc/smbcredentials
	fi
	if [ ! -f "/etc/smbcredentials/sherpaproddiag.cred" ]; then
    		sudo bash -c 'echo "username=sherpaproddiag" >> /etc/smbcredentials/sherpaproddiag.cred'
    		sudo bash -c 'echo "password=mbhAka91nwyTOGWvhKurOlonVC9AMUXX+XDIqpx+qloXf70I9lFchkJhTo0Fib7rVBCNLM/4wu8hr6aTmx23GA==" >> /etc/smbcredentials/sherpaproddiag.cred'
	fi
	sudo chmod 600 /etc/smbcredentials/sherpaproddiag.cred

	sudo bash -c 'echo "//sherpaproddiag.file.core.windows.net/sherpadrive /mnt/csae48d5df47deax41bcxbaa cifs nofail,vers=3.0,credentials=/etc/smbcredentials/sherpaproddiag.cred,dir_mode=0777,file_mode=0777,serverino" >> /etc/fstab'
	sudo mount -t cifs //sherpaproddiag.file.core.windows.net/sherpadrive /mnt/csae48d5df47deax41bcxbaa -o vers=3.0,credentials=/etc/smbcredentials/sherpaproddiag.cred,dir_mode=0777,file_mode=0777,serverino	
fi



# Killin screen application if it exists
sudo pkill python3
sudo pkill screen

# render watcher
screen -dmS render-watcher
screen -S render-watcher -p 0 -X stuff 'cd render-folder-watcher\n'
screen -S render-watcher -p 0 -X stuff 'python3 watcher_full.py\n'

