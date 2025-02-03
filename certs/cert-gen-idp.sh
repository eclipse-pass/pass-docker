#! /bin/sh

set -e

echo ""
echo "Create idp-encryption cert/key"
./scripts/cert-gen.sh "CN=localhost" "SAN=dns:localhost,uri:https://localhost/idp/shibboleth"
cp /cert-gen-output/cert.pem /idp/credentials/shib-idp/idp-encryption.crt
cp /cert-gen-output/private_key.pem /idp/credentials/shib-idp/idp-encryption.key

echo ""
echo "Create idp-signing cert/key"
./scripts/cert-gen.sh "CN=localhost" "SAN=dns:localhost,uri:https://localhost/idp/shibboleth"
cp /cert-gen-output/cert.pem /idp/credentials/shib-idp/idp-signing.crt
cp /cert-gen-output/private_key.pem /idp/credentials/shib-idp/idp-signing.key
CERT=$(sed -n '/-----BEGIN CERTIFICATE-----/,/-----END CERTIFICATE-----/p' /idp/credentials/shib-idp/idp-signing.crt | sed '1d;$d')
awk -v token="IDP_METADATA_CERT" -v replacement="$CERT" '
{
  if ($0 ~ token) {
    gsub(token, replacement)
    print
  } else {
    print
  }
}
' /idp/config/shib-idp/metadata/template.idp-metadata.xml > /idp/config/shib-idp/metadata/idp-metadata.xml

echo ""
echo "Create tomcat keystore with cert"
./scripts/cert-gen.sh "CN=localhost,OU=SUBJ_OU,O=SUBJ_O,L=SUBJ_CITY,ST=SUBJ_STATE,C=SUBJ_COUNTRY" ""
cp /cert-gen-output/localtest.jks /idp/credentials/tomcat/keystore.jks
cp /idp/config/tomcat/template.server.xml /idp/config/tomcat/server.xml
TC_STORE_PW=`cat /cert-gen-output/secret.prop`
sed -i "s#KEYSTORE_PW#$TC_STORE_PW#g" /idp/config/tomcat/server.xml

echo ""
echo "Create pass-core cert/key"
./scripts/cert-gen.sh "CN=localhost" "SAN=dns:localhost"
cp /cert-gen-output/cert.pem /pass-core/saml2/sp-cert.pem
cp /cert-gen-output/private_key.pem /pass-core/saml2/sp-key.pem
CERT=$(sed -n '/-----BEGIN CERTIFICATE-----/,/-----END CERTIFICATE-----/p' /pass-core/saml2/sp-cert.pem | sed '1d;$d')
awk -v token="SP_METADATA_CERT" -v replacement="$CERT" '
{
  if ($0 ~ token) {
    gsub(token, replacement)
    print
  } else {
    print
  }
}
' /idp/config/shib-idp/metadata/template.sp-metadata.xml > /idp/config/shib-idp/metadata/sp-metadata.xml

echo ""
echo "Create sealer secretkey sealer.jks"
rm -f /cert-gen-output/*
PASS_BASE=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c15)
SEALER_KEY_PW="${PASS_BASE}sealkeypw"
SEALER_STORE_PW="${PASS_BASE}seallocalstorepw"
keytool -genseckey -alias secret1 -keypass $SEALER_KEY_PW -keyalg AES -keysize 256 \
  -keystore /cert-gen-output/sealer.jks -storepass $SEALER_STORE_PW -storetype JCEKS
cp /cert-gen-output/sealer.jks /idp/credentials/shib-idp/sealer.jks
cat > /idp/credentials/shib-idp/sealer.properties << EOF
idp.sealer.storePassword = $SEALER_STORE_PW
idp.sealer.keyPassword = $SEALER_KEY_PW
EOF