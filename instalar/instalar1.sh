
cd ~/config
docker volume create portainer_data &&
docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v /home/ginio/config/portainer:/data portainer/portainer-ce &&
docker run -d --name=plex -e TZ=Europe/Madrid -v /home/ginio/config/Plex:/config -v /home/ginio/config/Plex/transcode:/transcode -v /home/ginio/config/Plex/deb:/deb -v /home/ginio/config/Plex/dvr:/dvr -v /media/ginio/SSD:/media:ro --network=host --restart unless-stopped plexinc/pms-docker:plexpass &&
docker run -d --name=heimdall -e PUID=1000 -e PGID=1000 -e TZ=Europe/Madrid -p 90:80 -p 543:443 -v /home/ginio/config/heimdall:/config --restart unless-stopped lscr.io/linuxserver/heimdall:latest &&
docker run -d --name=duckdns -e PUID=1000 -e PGID=1000 -e TZ=Europe/Madrid -e SUBDOMAINS=hignio -e TOKEN=e6129474-1f95-4e64-a261-9f564b4dc456 -e LOG_FILE=false -v /home/ginio/config/duckdns:/config --restart unless-stopped lscr.io/linuxserver/duckdns:latest &&

sudo chmod -R +x /home/ginio/scripts/ &&
#pa q no faiga falta entrar en la carpeta scrip pa ejecutalos /a�adir
echo "#mis scripts" >> ~/.bashrc &&
echo 'export PATH="/home/ginio/scripts:$PATH"' >> ~/.bashrc &&
#to los docker
cd /home/ginio/compose/nginx &&
docker-compose up -d &&
#cd /home/ginio/compose/jandroplextraktsync &&
#docker-compose up -d &&
#cd /home/ginio/compose/plextraktsynctemporizador
#docker-compose up -d
cd /home/ginio/compose/webgrab
docker-compose up -d
cd /home/ginio/compose/wireguard
docker-compose up -d

cd /me/ginio
#crontab
echo -e '(crontab -l && echo "#40 3,9,15,21 * * * sh /home/ginio/scripts/copia.sh &") | crontab -'  >> pruebacrontab.sh &&
echo -e '(crontab -l && echo "#15 2,14 * * * /home/ginio/scripts/webgrab.sh") | crontab -'  >> pruebacrontab.sh &&
echo -e '(crontab -l && echo "#30 3 * * * reboot") | crontab -'  >> pruebasucrontab.sh &&
sh pruebacrontab.sh && sudo sh pruebasucrontab.sh &&
rm pruebacrontab.sh && rm pruebasucrontab.sh 
