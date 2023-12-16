FROM haproxy:1.9.8

ADD *.cfg /tmp/

# Switch the lines to use loadbalancer listening on two ports of single host.
RUN /bin/sh -c "cp /tmp/haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg"
# RUN /bin/sh -c "cp /tmp/haproxy_two-frontends.cfg /usr/local/etc/haproxy/haproxy.cfg"

