FROM unicon/shibboleth-idp@sha256:397941df7098b44c939b6d7e0a94afde627a79c27863e0a99f4ae8d8ec069134

ARG TENANT
ARG IDP_ENV

COPY common/shibboleth-idp/ /opt/shibboleth-idp/
COPY common/shib-jetty-base/ /opt/shib-jetty-base/

COPY ${TENANT}/shibboleth-idp/ /opt/shibboleth-idp/

COPY styling/main.css /opt/shibboleth-idp/webapp/css/main.css
COPY styling/dummylogo.png /opt/shibboleth-idp/webapp/images/dummylogo.png
COPY styling/login.vm /opt/shibboleth-idp/views/login.vm
COPY styling/error.vm /opt/shibboleth-idp/views/error.vm

# Update metadata for deploy target
COPY metadata/*.xml /opt/shibboleth-idp/metadata/

COPY entrypoint.sh .

RUN chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
