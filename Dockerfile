FROM registry.fedoraproject.org/fedora:latest
RUN dnf install -y transmission-daemon openvpn
RUN dnf upgrade -y
COPY client.up /etc/openvpn/client.up
COPY start-me-up /usr/local/bin/start-me-up
RUN chmod a+x /usr/local/bin/start-me-up
VOLUME /transmission
VOLUME /etc/openvpn/client
VOLUME /var/log
EXPOSE 9091/tcp
ENTRYPOINT /usr/local/bin/start-me-up
