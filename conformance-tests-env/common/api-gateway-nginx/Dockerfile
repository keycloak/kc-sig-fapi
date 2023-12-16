FROM openresty/openresty:alpine-fat

RUN /usr/local/openresty/luajit/bin/luarocks install lua-resty-openidc \
  && /usr/local/openresty/luajit/bin/luarocks install lua-resty-jit-uuid

COPY *.template /usr/local/openresty/nginx/conf/
COPY *.lua /usr/local/openresty/

COPY entrypoint.sh /usr/local/sbin/

EXPOSE 443

ENTRYPOINT ["entrypoint.sh"]
CMD []
