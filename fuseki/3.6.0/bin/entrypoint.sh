#!/bin/ash

# handle port
sed -ie "s:<Connector port=\"8080\":<Connector port=\"${FUSEKI_PORT}\":" conf/server.xml

# handle debugging

if [ -n "${DEBUG_PORT}" ] ;
then
  OPTS="${OPTS} `echo ${DEBUG_ARG} | envsubst`"
fi

TYPES="text/trig; charset=utf-8,text/turtle; charset=utf-8,application/json; charset=utf-8,application/ld+json; charset=utf-8,application/sparql-results+json; charset=utf-8,application/sparql-results+xml; charset=utf-8,text/csv; charset=utf-8,text/tab-separated-values; charset=utf-8"

OPTS="${OPTS} -Dresponse.substitute.types.dev=\"${TYPES}\" -Dresponse.substitute.types.pass=\"${TYPES}\""

CATALINA_OPTS="${OPTS}" catalina.sh run
