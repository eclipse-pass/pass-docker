#! /bin/sh
echo "IDP_HOST: $IDP_HOST"
echo "SP_LOGIN: $SP_LOGIN"
echo "Updating metadata files..."
sed -i "s#https://pass.local#$IDP_HOST#g" /opt/shibboleth-idp/metadata/idp-metadata.xml
sed -i "s#SP_LOGIN#$SP_LOGIN#g" /opt/shibboleth-idp/metadata/sp-metadata.xml
sed -i "s#https://pass.local#$IDP_HOST#g" /opt/shibboleth-idp/conf/cas-protocol.xml
sed -i "s#https://pass.local#$IDP_HOST#g" /opt/shibboleth-idp/conf/idp.properties

echo "Starting Jetty"
/usr/local/bin/run-jetty.sh
