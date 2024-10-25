FROM docker:27.3.1-dind-alpine3.20
ADD test-runner-entrypoint.sh .
RUN apk add --update --upgrade --no-cache  curl
CMD [ "sh", "./test-runner-entrypoint.sh" ]