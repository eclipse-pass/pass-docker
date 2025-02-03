#! /bin/sh

set -e

CERT_DNAME=$1
CERT_EXT=$2

CERT_EXT_ARG=""

if [ -n "$CERT_EXT" ];then
  CERT_EXT_ARG="-ext ${CERT_EXT}"
fi

rm -f /cert-gen-output/*

PASS_BASE=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c15)
KEY_PW="${PASS_BASE}keypw"
STORE_PW="${PASS_BASE}localstorepw"
P12STORE_PW="${PASS_BASE}pkcs12pw"

keytool -genkeypair -alias localtest -keyalg RSA -dname $CERT_DNAME -keystore /cert-gen-output/localtest.jks \
  -keypass $KEY_PW -storepass $STORE_PW $CERT_EXT_ARG
keytool -importkeystore -srckeystore /cert-gen-output/localtest.jks -srcstorepass $STORE_PW \
  -srckeypass $KEY_PW -srcalias localtest -destalias localtest \
  -destkeystore /cert-gen-output/localtest.p12 -deststoretype PKCS12 -deststorepass $P12STORE_PW \
  -destkeypass $P12STORE_PW
openssl pkcs12 -in /cert-gen-output/localtest.p12 -passin "pass:${P12STORE_PW}" -nodes -nocerts -out /cert-gen-output/private_key.pem
openssl rsa -in /cert-gen-output/private_key.pem -out /cert-gen-output/private_key.pem
openssl pkcs12 -in /cert-gen-output/localtest.p12 -passin "pass:${P12STORE_PW}" -nokeys -out /cert-gen-output/cert.pem
openssl x509 -in /cert-gen-output/cert.pem -out /cert-gen-output/cert.pem
echo "$STORE_PW" > /cert-gen-output/secret.prop