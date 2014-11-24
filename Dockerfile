FROM progrium/busybox

MAINTAINER marko.celan@gmail.com

RUN /usr/bin/opkg-install procps \
	collectd \
	collectd-mod-conntrack \
	collectd-mod-cpu \
	collectd-mod-df \
	collectd-mod-load \
	collectd-mod-memory \
	collectd-mod-network \
	collectd-mod-disk \
	collectd-mod-interface \
	collectd-mod-wireless

RUN /bin/echo -e '\n<Plugin network>\n\tServer "%PLACEHOLDER_HOST%" "%PLACEHOLDER_PORT%"\n</Plugin>\n' >> /etc/collectd.conf

ENTRYPOINT [ "/bin/sh", "-c", "sed -i \"s|%PLACEHOLDER_HOST%|${COLLECTD_PORT_25826_UDP_ADDR}|\" /etc/collectd.conf   &&   sed -i \"s|%PLACEHOLDER_PORT%|${COLLECTD_PORT_25826_UDP_PORT}|\" /etc/collectd.conf   &&   sed -i \"s|Interval.*|Interval ${COLLECTD_INTERVAL:-10}|\" /etc/collectd.conf  &&   /usr/sbin/collectd -C /etc/collectd.conf -f " ]
