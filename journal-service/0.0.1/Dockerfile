FROM openjdk:8-jdk-alpine

ENV JS_VERSION=0.0.1
ENV JS_MAX_ATTEMPTS=20

WORKDIR /app

ADD wait_and_start.sh /app

RUN apk add --no-cache ca-certificates wget gettext curl && \
    wget https://github.com/OA-PASS/pass-journal-service/releases/download/${JS_VERSION}/pass-journal-service-${JS_VERSION}.jar && \
    echo "787b2fcd86f686d54cc849e6599a7ee03b023afe *pass-journal-service-${JS_VERSION}.jar" \
            | sha1sum -c -  && \
    rm -rf /var/cache/apk/ && \
    chmod 700 wait_and_start.sh

CMD ./wait_and_start.sh pass-journal-service-${JS_VERSION}.jar
