FROM ubuntu:18.04
ARG TAG=samba-4.9.2

RUN \
  DEBIAN_FRONTEND=noninteractive apt-get -y update && \
  DEBIAN_FRONTEND=noninteractive apt-get -y install apt-utils && \
  DEBIAN_FRONTEND=noninteractive apt-get -y upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get -y install avahi-daemon libldap-2.4-2 libavahi-client3 libavahi-common3 liblmdb0 libjansson4 python-gpg libarchive13 && \
  DEBIAN_FRONTEND=noninteractive apt-get -y install git python3 build-essential pkg-config python-dev libavahi-common-dev libavahi-client-dev libgnutls28-dev docbook-xml docbook-xsl xsltproc libacl1-dev libldap2-dev libpam0g-dev liblmdb-dev libjansson-dev libgpgme-dev libarchive-dev && \
  git clone https://github.com/samba-team/samba.git && \
  cd samba && \
  git checkout -q $TAG && \
  ./configure --enable-fhs --prefix=/usr --sysconfdir=/etc --localstatedir=/var && \
  make && \
  make install && \
  cd .. && \
  rm -rf samba && \
  DEBIAN_FRONTEND=noninteractive apt-get -y purge git python3 build-essential pkg-config python-dev libavahi-common-dev libavahi-client-dev libgnutls28-dev docbook-xml docbook-xsl xsltproc libacl1-dev libldap2-dev libpam0g-dev liblmdb-dev libjansson-dev libgpgme-dev libarchive-dev && \
  DEBIAN_FRONTEND=noninteractive apt-get -y autoremove && \
  DEBIAN_FRONTEND=noninteractive apt-get -y clean
COPY init.sh /usr/bin/init.sh
RUN chmod 777 /usr/bin/init.sh

CMD ["/usr/bin/init.sh"]
