FROM tomcat:8.5.29-jre8-alpine

ENV FUSEKI_VERSION=3.6.0 \
FUSEKI_BASE=/shared/fuseki-data \
DEBUG_PORT=5009 \
SLF4J_VERSION=1.7.25 \
PASS_PUBLIC_PROTO=https \
PASS_PUBLIC_HOST=pass

EXPOSE 8080
EXPOSE ${DEBUG_PORT}

COPY bin/* /bin/

RUN export FUSEKI_DIST=${FUSEKI_VERSION}/jena-fuseki-war-${FUSEKI_VERSION}.war      && \
    wget -O ${CATALINA_HOME}/webapps/fuseki.war \
    http://central.maven.org/maven2/org/apache/jena/jena-fuseki-war/${FUSEKI_DIST} && \
    ${CATALINA_HOME}/bin/catalina.sh start && \
    wget -O ${CATALINA_HOME}/lib/slf4j-api-${SLF4J_VERSION}.jar \
    http://central.maven.org/maven2/org/slf4j/slf4j-api/${SLF4J_VERSION}/slf4j-api-${SLF4J_VERSION}.jar && \
    wget -O ${CATALINA_HOME}/lib/slf4j-jdk14-${SLF4J_VERSION}.jar \
    http://central.maven.org/maven2/org/slf4j/slf4j-jdk14/${SLF4J_VERSION}/slf4j-jdk14-${SLF4J_VERSION}.jar && \
    wget -O ${CATALINA_HOME}/lib/jsonld-addon-filters-0.0.3-SNAPSHOT-shaded.jar \
        https://github.com/DataConservancy/fcrepo-jsonld/releases/download/0.0.3-SNAPSHOT/jsonld-addon-filters-0.0.3-SNAPSHOT-shaded.jar && \
    mkdir -p ${FUSEKI_BASE}/service-index_data && \
    mkdir -p ${FUSEKI_BASE}/fcrepo-triple-index_data && \
    # gettext provides envsubst used in entrypoint
    apk --no-cache add --update gettext && \
    apk --no-cache add --update curl && \
    /bin/wait_for_tomcat.sh && \
    ${CATALINA_HOME}/bin/catalina.sh stop && \
    rm -rf ${CATALINA_HOME}/webapps/fuseki.war && \ 
    rm -rf ${FUSEKI_BASE}/* && \
    mkdir -p ${FUSEKI_BASE}/configuration

COPY shiro.ini ${FUSEKI_BASE}
COPY service-index.ttl ${FUSEKI_BASE}/configuration/
COPY web.xml ${CATALINA_HOME}/webapps/fuseki/WEB-INF/

RUN chmod 700 /bin/entrypoint.sh

ENTRYPOINT [ "/bin/entrypoint.sh" ]
