FROM maven:3.6.3-openjdk-11-slim as builder
ARG OPENID_GIT_URL
ARG OPENID_GIT_TAG

# the server app requires redir to run
RUN apt-get update && apt-get install -y redir python3 python3-pip git
RUN pip3 install httpx
RUN git clone -b ${OPENID_GIT_TAG} ${OPENID_GIT_URL} ./conformance-suite
ADD . ./conformance-suite/
EXPOSE 8080
EXPOSE 9090
CMD [ "sh", "./conformance-suite/server-entrypoint.sh" ]
