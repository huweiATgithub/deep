# deep

To run, use 

docker run --gpus all --mount src=/data,target=/data,type=bind -p 8888:8888 -p 6006:6006 -d --name ml notanordinary/huwei --NotebookApp.password=sha1:379d431d4559:b3171db6ac420a5558b31facb381b37f30a96a86

chang the password to password you preferred

After initializing container, one can set, crontab -e,
@reboot /bin/bash ./deep/startDocker.sh
so that container will be started with boot.


