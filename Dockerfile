FROM debian:wheezy

# Install prerequisites
RUN apt-get update
RUN apt-get -y install g++ make libssl-dev libminiupnpc-dev libnatpmp-dev iptables

# Add snow user
RUN useradd -s /bin/bash -m snow

# Add source
ADD src /home/snow/src
ADD known_peers /home/snow/
RUN chown -R snow /home/snow

# Compile & install snowd
USER snow
WORKDIR /home/snow/src
RUN make -j
USER root
RUN make install

# Compile & install mktun
USER snow
RUN gcc mktun.c -o mktun
USER root
RUN cp mktun /usr/local/bin/

# Adjust owner for snow directories
RUN chown -R snow /etc/snow /var/lib/snow

# Setup authbind for snowd's privileged port
RUN apt-get -y install authbind
RUN touch /etc/authbind/byport/8 && chown snow /etc/authbind/byport/8 && chmod u+x /etc/authbind/byport/8

# Adjust nsswitch config
RUN sed -i "s/^hosts.\+$/hosts: files snow dns/" /etc/nsswitch.conf

# Add run script
WORKDIR /home/snow
ADD docker/setup_and_run /usr/local/bin/setup_and_run
CMD setup_and_run
