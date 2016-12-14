#!/bin/sh
# author: joda
openssl=/usr/bin/openssl
certdir=/usr/local/etc/certs

mkdir -p $certdir ; chmod 700 $certdir

HOSTNAME=$1
PORT=$2

if [ ! -f $openssl ]; then
  echo "ERROR: Can't find $openssl. openssl-util installed?" >&2
fi

echo -n | $openssl s_client -connect ${HOSTNAME}:$PORT > /tmp/${HOSTNAME}.crt.txt
cat /tmp/${HOSTNAME}.crt.txt | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > /tmp/${HOSTNAME}.crt

CERTDA=$(date +%Y%m%d-%s)
mv /tmp/${HOSTNAME}.crt $certdir/${HOSTNAME}.${CERTDA}.pem
mv /tmp/${HOSTNAME}.crt.txt $certdir/${HOSTNAME}.${CERTDA}.pem.txt
c_rehash $certdir/
#${HOSTNAME}.${CERTDA}.pem

#echo "CREATING NEW ROOT CA FOR ${HOSTNAME}.${CERTDA}.pem"
#ISSUER=$(openssl x509 -in $certdir/${HOSTNAME}.${CERTDA}.pem -issuer -noout | sed 's/issuer= //')
##/CN=LinkNet Root CA/emailAddress=ca@link-net.org/O=LinkNet IRC Network
## if [ ! -e ~/.certs/${HOSTNAME}.${CERTDA}-ca.pem ] ;then
##openssl req -config req.conf -new -x509 -newkey rsa:2048 -nodes -keyout ~/.keys/${HOSTNAME}.${CERTDA}-ca.key -days 2828 -out \
##~/.certs/${HOSTNAME}.${CERTDA}-ca.pem -subj "/CN=LinkNet Root CA/O=LinkNet IRC Network"
#openssl req -config req.conf -new -x509 -newkey rsa:2048 -nodes -keyout ~/.keys/${HOSTNAME}.${CERTDA}-ca.key -days 2828 -out \
#~/.certs/${HOSTNAME}.${CERTDA}-ca.pem -subj "${ISSUER}"
#c_rehash ~/.certs/
##${HOSTNAME}.${CERTDA}-ca.pem
#
#echo "SIGNING ${HOSTNAME}.${CERTDA}.pem WITH ${HOSTNAME}.${CERTDA}-ca.pem"
#openssl x509 -sha256 -in $certdir/${HOSTNAME}.${CERTDA}.pem -days 2828 -CA ~/.certs/${HOSTNAME}.${CERTDA}-ca.pem \
#-CAkey ~/.keys/${HOSTNAME}.${CERTDA}-ca.key -out ${certdir}/${HOSTNAME}.${CERTDA}-sig.pem -set_serial 88
#c_rehash ${certdir}/
##${HOSTNAME}.${CERTDA}-sig.pem

#error 7 at 0 depth lookup:certificate signature failure
#125171987109528:error:0407006A:rsa routines:RSA_padding_check_PKCS1_type_1:block type is not 01:/var/tmp/portage/dev-libs/libressl-2.4.1/work/libressl-2.4.1/crypto/rsa/rsa_pk1.c:105:
#125171987109528:error:04067072:rsa routines:RSA_EAY_PUBLIC_DECRYPT:padding check failed:/var/tmp/portage/dev-libs/libressl-2.4.1/work/libressl-2.4.1/crypto/rsa/rsa_eay.c:708:
#125171987109528:error:0D0C5006:asn1 encoding routines:ASN1_item_verify:EVP lib:/var/tmp/portage/dev-libs/libressl-2.4.1/work/libressl-2.4.1/crypto/asn1/a_verify.c:161:

# create symbolic link from hash, can be done with c_rehash instead
#echo -n "  generating hash: "
#HASH=`$openssl x509 -hash -noout -in /tmp/${HOSTNAME}.crt`
#echo "$HASH"
#cd $certdir
#ln -sf ${HOSTNAME}.crt.${CERTDA} ${HASH}.0
#cd -
