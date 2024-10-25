#FROM haproxy:1.9.8
FROM haproxy:3.0.5-alpine

COPY --chown=haproxy:haproxy haproxy.cfg /tmp/haproxy.cfg
COPY --chown=haproxy:haproxy haproxy_two-frontends.cfg /tmp/haproxy_two-frontends.cfg

USER root

# Switch the lines to use loadbalancer listening on two ports of single host.
RUN /bin/sh -c "cp /tmp/haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg"
# RUN /bin/sh -c "cp /tmp/haproxy_two-frontends.cfg /usr/local/etc/haproxy/haproxy.cfg"

USER haproxy

