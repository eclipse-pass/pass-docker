FROM fcrepoapix/apix-karaf:4.1.2

ENV CAMEL_VERSION=2.19.2 \
    ACTIVEMQ_VERSION=5.15.3 \
    FCREPO_TOOLBOX_VERSION=4.7.2 \
    FUSEKI_HOST=fuseki \
    FCREPO_HOST=fcrepo \
    FCREPO_PORT=8080 \
    FCREPO_CONTEXT_PATH=/fcrepo \
    REINDEXING_PORT=9090

RUN bin/start && \
    bin/client -r 10 -d 5  "feature:repo-add mvn:org.apache.camel.karaf/apache-camel/${CAMEL_VERSION}/xml/features" && \
    bin/client -r 10 -d 5  "feature:repo-add mvn:org.apache.activemq/activemq-karaf/${ACTIVEMQ_VERSION}/xml/features" && \
    bin/client -r 10 -d 5  "feature:repo-add mvn:org.fcrepo.camel/toolbox-features/${FCREPO_TOOLBOX_VERSION}/xml/features" && \
    bin/client -r 10 -d 5  "feature:install camel" && \
    bin/client -r 10 -d 5  "feature:install activemq-camel" && \
    bin/client -r 10 -d 5  "feature:install fcrepo-service-activemq" && \
    bin/client -r 10 -d 5  "feature:install fcrepo-indexing-triplestore" && \
    bin/client -r 10 -d 5  "feature:install fcrepo-reindexing" && \
    bin/stop && \
    rm -rf instances/* && \
    rm -rf /build/repository/*

ENV JAVA_DEBUG_PORT=${DEBUG_PORT} \
    FCREPO_BASEURI=http://${FCREPO_HOST}:${FCREPO_PORT}${FCREPO_CONTEXT_PATH}/rest
    
# Copy Karaf feature configuration files into the image
COPY cfg/* etc/

COPY entrypoint.sh /entrypoint.sh

RUN chmod 700 /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]

# Launch Karaf with no console
CMD [ "server" ]