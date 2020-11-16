FROM docker/compose:latest
ADD test-runner-entrypoint.sh .
RUN apk add --update --upgrade --no-cache  curl
CMD [ "sh", "./test-runner-entrypoint.sh" ]