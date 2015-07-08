#!/bin/bash

# chfn workaround - Known issue within Dockers
ln -s -f /bin/true /usr/bin/chfn

apt-get -q update
apt-get install -qy gdebi-core wget

#download and install hdhomerun dvr engine
wget -q "http://download.silicondust.com/hdhomerun/hdhomerun_record_linux" -O /tmp/hdhomerun/hdhomerun_record_linux
chmod +x /tmp/hdhomerun/hdhomerun_record_linux
/tmp/hdhomerun/hdhomerun_record_linux


# Add hdhomerun dvr to runit
mkdir -p /etc/service/hdhomerun_record
cat <<'EOT' > /etc/service/hdhomerun_record/run
#!/bin/bash
umask 000
# Fix permission if user is 999
if [ -d /config/Library ]; then
	if [ "$(stat -c "%u" /config/Library/)" -eq "999" ]; then
		echo "Fixing HDHOMERUN Library permissions"
		chown -R 99:100 /hdhomerun
		chmod -R 777 /hdhomerun
	fi
fi
exec /usr/bin/hdhomerun_record start
EOT
chmod +x /etc/service/hdhomerun_record/run
