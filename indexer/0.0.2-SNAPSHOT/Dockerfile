FROM openjdk:8-jre-alpine

ENV PI_VERSION=0.0.2 \
    PI_LOG_LEVEL=${PI_LOG_LEVEL:-info}

WORKDIR /app

RUN apk add --no-cache ca-certificates wget gettext curl && \
    wget https://github.com/OA-PASS/pass-indexer/releases/download/${PI_VERSION}/pass-indexer-cli-${PI_VERSION}-SNAPSHOT-shaded.jar && \
    rm -rf /var/cache/apk/

CMD java -Dorg.slf4j.simpleLogger.defaultLogLevel=${PI_LOG_LEVEL} -jar pass-indexer-cli-${PI_VERSION}-SNAPSHOT-shaded.jar
